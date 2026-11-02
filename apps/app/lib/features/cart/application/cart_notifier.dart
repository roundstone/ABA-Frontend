import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/auth_entities.dart';
import '../../shop/application/shop_providers.dart';
import '../../shop/domain/shop_entities.dart';
import 'cart_cache_helper.dart';
import 'cart_providers.dart';

/// Cart state notifier with remote API synchronization and user-scoped local cache.
class CartNotifier extends AsyncNotifier<Cart> {
  @override
  Future<Cart> build() async {
    ref.listen<AuthUser?>(currentUserProvider, (previous, next) {
      if (previous?.id != next?.id) {
        state = const AsyncValue.data(Cart());
        if (previous != null) {
          ref
              .read(cartMockRepositoryProvider)
              .clearForUser(previous.id.toString());
        }
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

    // Clean up any legacy global un-scoped cart cache
    if (prefs?.containsKey(CartCacheHelper.legacyKey) ?? false) {
      await prefs?.remove(CartCacheHelper.legacyKey);
    }

    // Unauthenticated/logged-out state has an empty cart
    if (userId == null) {
      return const Cart();
    }

    final userCartKey = CartCacheHelper.keyForUser(userId);

    // 1. Try fetching live cart from API for this user
    try {
      final remoteCart = await repo.getCart();
      await _persistForUser(remoteCart, userCartKey);
      return remoteCart;
    } catch (e) {
      AppLogger.w(
        'CartNotifier.build: remote cart fetch failed ($e), checking user cache',
      );
    }

    // 2. Fallback to locally cached cart for THIS USER ONLY in SharedPreferences
    final raw = prefs?.getStringList(userCartKey);
    if (raw == null || raw.isEmpty) return const Cart();

    try {
      final catalogue = await ref.read(shopCatalogueProvider.future);
      final productMap = {for (final p in catalogue.products) p.id: p};
      final items = CartCacheHelper.decode(raw, productMap);
      return Cart(items: items);
    } catch (_) {
      return const Cart();
    }
  }

  Future<void> _persist(Cart cart) async {
    final user = ref.read(currentUserProvider);
    final userId = user?.id.toString();
    if (userId == null) return;
    await _persistForUser(cart, CartCacheHelper.keyForUser(userId));
  }

  Future<void> _persistForUser(Cart cart, String key) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (prefs == null) return;
    final encoded = CartCacheHelper.encode(cart);
    await prefs.setStringList(key, encoded);
  }

  Future<void> addToCart(
    Product product, {
    int quantity = 1,
    String? color,
    String? size,
    int? variantId,
  }) async {
    final current = state.valueOrNull ?? const Cart();

    var effectiveProduct = product;
    if (effectiveProduct.variants.isEmpty && variantId == null) {
      try {
        final repo = ref.read(shopRepositoryProvider);
        final full = await repo.fetchProductById(product.id);
        if (full != null && full.variants.isNotEmpty) {
          effectiveProduct = full;
        }
      } catch (_) {}
    }

    final vId = CartCacheHelper.resolveVariantId(
      effectiveProduct,
      color: color,
      size: size,
      variantId: variantId,
    );

    final optItem = CartItem(
      product: effectiveProduct,
      quantity: quantity,
      productVariantId: vId,
      selectedColor: color,
      selectedSize: size,
    );
    final optimisticCart = current.addItem(optItem);
    state = AsyncValue.data(optimisticCart);

    try {
      final repo = ref.read(cartRepositoryProvider);
      final created = await repo.addItem(
        productVariantId: vId,
        quantity: quantity,
        product: effectiveProduct,
      );
      if (created.id != null) {
        final synced = optimisticCart.items.map((i) {
          if (i.product.id == effectiveProduct.id &&
              (i.effectiveVariantId == vId || i.effectiveVariantId == null)) {
            return i.copyWith(id: created.id, productVariantId: vId);
          }
          return i;
        }).toList();
        final finalCart = Cart(id: optimisticCart.id, items: synced);
        state = AsyncValue.data(finalCart);
        await _persist(finalCart);
        return;
      }
    } catch (e) {
      AppLogger.w('CartNotifier.addToCart remote failed: $e');
    }
    await _persist(optimisticCart);
  }

  Future<void> removeFromCart(String productIdOrItemId) async {
    final current = state.valueOrNull ?? const Cart();
    final item = current.items.where(
      (i) =>
          i.id == productIdOrItemId ||
          i.product.id == productIdOrItemId ||
          i.effectiveId == productIdOrItemId,
    ).firstOrNull;

    final targetId = item?.id ?? productIdOrItemId;
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.removeItem(targetId);
    } catch (e) {
      AppLogger.w('CartNotifier.removeFromCart remote failed: $e');
    }

    final next = current.removeItem(productIdOrItemId);
    state = AsyncValue.data(next);
    await _persist(next);
  }

  Future<void> updateQuantity(String productIdOrItemId, int quantity) async {
    if (quantity <= 0) {
      return removeFromCart(productIdOrItemId);
    }

    final current = state.valueOrNull ?? const Cart();
    final item = current.items.where(
      (i) =>
          i.id == productIdOrItemId ||
          i.product.id == productIdOrItemId ||
          i.effectiveId == productIdOrItemId,
    ).firstOrNull;

    final targetId = item?.id ?? productIdOrItemId;
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.updateItemQuantity(itemId: targetId, quantity: quantity);
    } catch (e) {
      AppLogger.w('CartNotifier.updateQuantity remote failed: $e');
    }

    final next = current.updateQuantity(productIdOrItemId, quantity);
    state = AsyncValue.data(next);
    await _persist(next);
  }

  Future<void> clearCart() async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.clearCart();
    } catch (e) {
      AppLogger.w('CartNotifier.clearCart remote failed: $e');
    }
    state = const AsyncValue.data(Cart());
    final user = ref.read(currentUserProvider);
    final userId = user?.id.toString();
    if (userId != null) {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs?.remove(CartCacheHelper.keyForUser(userId));
    }
  }

  Future<CartAvailabilityResult> checkAvailability() async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      return await repo.checkAvailability();
    } catch (e) {
      AppLogger.w('CartNotifier.checkAvailability failed: $e');
      return const CartAvailabilityResult(isAvailable: true);
    }
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, Cart>(
  CartNotifier.new,
);
