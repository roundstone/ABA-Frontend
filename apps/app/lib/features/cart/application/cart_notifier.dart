import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_error.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/auth_entities.dart';
import '../../shop/application/shop_providers.dart';
import '../../shop/domain/shop_entities.dart';
import 'cart_cache_helper.dart';
import 'cart_providers.dart';

/// Cart state notifier with optimistic UI, debounced quantity sync,
/// guest-to-user merge on login, and rollback on backend errors.
class CartNotifier extends AsyncNotifier<Cart> {
  final Map<String, Timer> _qtyTimers = {};
  final Map<String, Cart> _qtyRollbackSnapshots = {};
  String? lastErrorMessage;

  @override
  Future<Cart> build() async {
    ref.onDispose(() {
      for (final t in _qtyTimers.values) { t.cancel(); }
      _qtyTimers.clear();
    });

    ref.listen<AuthUser?>(currentUserProvider, (previous, next) {
      if (previous?.id != next?.id) {
        state = const AsyncValue.data(Cart());
        if (previous != null) ref.read(cartMockRepositoryProvider).clearForUser(previous.id.toString());
      }
      if (next == null) {
        state = const AsyncValue.data(Cart());
        ref.read(cartMockRepositoryProvider).clearAll();
      }
    });

    final user = ref.watch(currentUserProvider);
    final userId = user?.id.toString();
    final repo = ref.read(cartRepositoryProvider);
    final prefs = ref.read(sharedPreferencesProvider);

    if (prefs?.containsKey(CartCacheHelper.legacyKey) ?? false) {
      await prefs?.remove(CartCacheHelper.legacyKey);
    }

    if (userId == null) {
      return _loadCachedCart(CartCacheHelper.keyForUser(null));
    }

    await CartCacheHelper.syncGuestCartOnLogin(prefs, repo);
    try {
      final remoteCart = await repo.getCart();
      await CartCacheHelper.persistCart(prefs, remoteCart, userId);
      return remoteCart;
    } catch (e) {
      AppLogger.w('CartNotifier.build: remote fetch failed ($e), using cache');
      return _loadCachedCart(CartCacheHelper.keyForUser(userId));
    }
  }

  Future<Cart> _loadCachedCart(String key) async {
    final raw = ref.read(sharedPreferencesProvider)?.getStringList(key);
    if (raw == null || raw.isEmpty) return const Cart();
    try {
      final catalogue = await ref.read(shopCatalogueProvider.future);
      final productMap = {for (final p in catalogue.products) p.id: p};
      return Cart(items: CartCacheHelper.decode(raw, productMap));
    } catch (_) {
      return const Cart();
    }
  }

  Future<void> _rollback(Cart previous, Object error) async {
    lastErrorMessage = ApiError.toUserFriendlyMessage(error);
    state = AsyncValue.data(previous);
    await _persist(previous);
  }

  Future<void> _persist(Cart cart) => CartCacheHelper.persistCart(
        ref.read(sharedPreferencesProvider),
        cart,
        ref.read(currentUserProvider)?.id.toString(),
      );

  Future<bool> addToCart(
    Product product, {
    int quantity = 1,
    String? color,
    String? size,
    int? variantId,
    ProductVariant? variant,
    double? unitPrice,
  }) async {
    lastErrorMessage = null;
    var effectiveProduct = product;
    if (effectiveProduct.variants.isEmpty && variantId == null) {
      try {
        final full = await ref.read(shopRepositoryProvider).fetchProductById(product.id);
        if (full != null) effectiveProduct = full;
      } catch (e) {
        AppLogger.w('CartNotifier.addToCart product lookup failed: $e');
      }
    }

    final vId = CartCacheHelper.resolveVariantId(
      effectiveProduct,
      color: color,
      size: size,
      variantId: variantId,
    );
    final resolvedVariant = variant ??
        (effectiveProduct.variants.isNotEmpty
            ? effectiveProduct.variants.firstWhere(
                (v) => v.id == vId,
                orElse: () => effectiveProduct.variants.first,
              )
            : null);
    final previous = state.valueOrNull ?? const Cart();
    if (effectiveProduct.stock > 0) {
      final existingQty = previous.items
          .where((i) =>
              i.product.id == effectiveProduct.id &&
              (i.effectiveVariantId == vId || vId <= 0))
          .fold<int>(0, (sum, i) => sum + i.quantity);
      if (existingQty + quantity > effectiveProduct.stock) {
        lastErrorMessage =
            'Only ${effectiveProduct.stock} item(s) available in stock.';
        return false;
      }
    }
    final optimisticCart = previous.addItem(CartItem(
      product: effectiveProduct,
      quantity: quantity,
      productVariantId: vId,
      variant: resolvedVariant,
      selectedColor: color ?? resolvedVariant?.color,
      selectedSize: size ?? resolvedVariant?.size,
      unitPrice: unitPrice ??
          (resolvedVariant != null && resolvedVariant.price > 0
              ? resolvedVariant.price
              : null),
    ));
    state = AsyncValue.data(optimisticCart);
    await _persist(optimisticCart);
    if (ref.read(currentUserProvider) == null) return true;

    try {
      final created = await ref.read(cartRepositoryProvider).addItem(
            productVariantId: vId, quantity: quantity, product: effectiveProduct);
      final latest = state.valueOrNull ?? optimisticCart;
      if (created.id != null) {
        final syncedItems = latest.items.map((item) =>
            (item.product.id == effectiveProduct.id && item.effectiveVariantId == vId)
                ? item.copyWith(id: created.id, productVariantId: vId)
                : item).toList();
        final syncedCart = Cart(id: latest.id, items: syncedItems);
        state = AsyncValue.data(syncedCart);
        await _persist(syncedCart);
      }
      return true;
    } catch (e) {
      AppLogger.w('CartNotifier.addToCart remote failed, rolling back: $e');
      await _rollback(previous, e);
      return false;
    }
  }

  Future<bool> removeFromCart(String productIdOrItemId) async {
    lastErrorMessage = null;
    _qtyTimers.remove(productIdOrItemId)?.cancel();
    _qtyRollbackSnapshots.remove(productIdOrItemId);

    final previous = state.valueOrNull ?? const Cart();
    final item = _findItem(previous, productIdOrItemId);
    final next = previous.removeItem(productIdOrItemId);
    state = AsyncValue.data(next);
    await _persist(next);

    if (ref.read(currentUserProvider) == null) return true;

    try {
      final repo = ref.read(cartRepositoryProvider);
      final targetId = await CartCacheHelper.resolveServerItemId(repo, item);
      if (targetId != null && targetId.isNotEmpty) await repo.removeItem(targetId);
      return true;
    } catch (e) {
      AppLogger.w('CartNotifier.removeFromCart remote failed, rolling back: $e');
      await _rollback(previous, e);
      return false;
    }
  }

  Future<void> updateQuantity(String productIdOrItemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productIdOrItemId);
      return;
    }
    lastErrorMessage = null;
    final current = state.valueOrNull ?? const Cart();
    final item = _findItem(current, productIdOrItemId);
    if (item == null) return;
    if (item.product.stock > 0 && quantity > item.product.stock) {
      lastErrorMessage =
          'Only ${item.product.stock} item(s) available in stock.';
      return;
    }

    _qtyRollbackSnapshots.putIfAbsent(productIdOrItemId, () => current);
    final next = current.updateQuantity(productIdOrItemId, quantity);
    state = AsyncValue.data(next);
    await _persist(next);

    if (ref.read(currentUserProvider) == null) {
      _qtyRollbackSnapshots.remove(productIdOrItemId);
      return;
    }

    _qtyTimers.remove(productIdOrItemId)?.cancel();
    _qtyTimers[productIdOrItemId] = Timer(const Duration(milliseconds: 350), () async {
      final rollbackCart = _qtyRollbackSnapshots.remove(productIdOrItemId);
      try {
        final repo = ref.read(cartRepositoryProvider);
        final targetId = await CartCacheHelper.resolveServerItemId(repo, item);
        if (targetId == null || targetId.isEmpty) return;
        await repo.updateItemQuantity(itemId: targetId, quantity: quantity);
      } catch (e) {
        AppLogger.w('CartNotifier.updateQuantity remote failed, rolling back: $e');
        if (rollbackCart != null) await _rollback(rollbackCart, e);
      }
    });
  }

  Future<void> _resetTimersAndCache(String? userId) async {
    for (final t in _qtyTimers.values) { t.cancel(); }
    _qtyTimers.clear();
    _qtyRollbackSnapshots.clear();
    state = const AsyncValue.data(Cart());
    await ref.read(sharedPreferencesProvider)?.remove(CartCacheHelper.keyForUser(userId));
  }

  /// Syncs local cart with the backend after checkout payment succeeds
  /// (backend clears the cart on payment; fetches latest state as source of truth).
  Future<void> syncAfterPayment() async {
    final user = ref.read(currentUserProvider);
    await _resetTimersAndCache(user?.id.toString());
    if (user == null) return;
    try {
      final remoteCart = await ref.read(cartRepositoryProvider).getCart();
      state = AsyncValue.data(remoteCart);
      await _persist(remoteCart);
    } catch (e) {
      AppLogger.w('CartNotifier.syncAfterPayment fetch failed: $e');
    }
  }

  Future<void> clearCart() async {
    lastErrorMessage = null;
    final previous = state.valueOrNull ?? const Cart();
    final user = ref.read(currentUserProvider);
    await _resetTimersAndCache(user?.id.toString());
    if (user == null) return;

    try {
      await ref.read(cartRepositoryProvider).clearCart();
    } catch (e) {
      AppLogger.w('CartNotifier.clearCart remote failed, rolling back: $e');
      await _rollback(previous, e);
      rethrow;
    }
  }

  Future<CartAvailabilityResult> checkAvailability() async {
    try { return await ref.read(cartRepositoryProvider).checkAvailability(); }
    catch (e) { AppLogger.w('CartNotifier.checkAvailability failed: $e'); return const CartAvailabilityResult(isAvailable: true); }
  }

  CartItem? _findItem(Cart cart, String id) =>
      cart.items.where((i) => i.id == id || i.product.id == id || i.effectiveId == id).firstOrNull;
}

final cartProvider = AsyncNotifierProvider<CartNotifier, Cart>(CartNotifier.new);
