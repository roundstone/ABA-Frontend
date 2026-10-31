import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../../shop/application/shop_providers.dart';
import '../../shop/domain/shop_entities.dart';
import 'cart_providers.dart';

const _kCartKey = 'aba_cart_v1';

/// Cart state notifier with remote API synchronization and local cache.
class CartNotifier extends AsyncNotifier<Cart> {
  static const _sep = '|';

  @override
  Future<Cart> build() async {
    final repo = ref.read(cartRepositoryProvider);
    final prefs = ref.read(sharedPreferencesProvider);

    // 1. Try fetching live cart from API
    try {
      final remoteCart = await repo.getCart();
      _persist(remoteCart);
      return remoteCart;
    } catch (e) {
      AppLogger.w('CartNotifier.build: remote cart fetch failed ($e), checking local cache');
    }

    // 2. Fallback to locally cached cart in SharedPreferences
    final raw = prefs?.getStringList(_kCartKey);
    if (raw == null || raw.isEmpty) return const Cart();

    try {
      final catalogue = await ref.read(shopCatalogueProvider.future);
      final productMap = {for (final p in catalogue.products) p.id: p};

      final items = <CartItem>[];
      for (final entry in raw) {
        final parts = entry.split(_sep);
        if (parts.length < 2) continue;
        final productId = parts[0];
        final qty = int.tryParse(parts[1]) ?? 1;
        final color = parts.length > 2 && parts[2].isNotEmpty ? parts[2] : null;
        final size = parts.length > 3 && parts[3].isNotEmpty ? parts[3] : null;
        final itemId = parts.length > 4 && parts[4].isNotEmpty ? parts[4] : null;
        final varId = parts.length > 5 ? int.tryParse(parts[5]) : null;

        final product = productMap[productId] ??
            Product(
              id: productId,
              name: 'Product $productId',
              slug: 'product-$productId',
              price: 15000.0,
              category: 'General',
              brand: 'Aba Craft',
              rating: 4.8,
              reviewCount: 5,
              stock: 20,
              images: const [],
            );

        items.add(
          CartItem(
            id: itemId,
            product: product,
            quantity: qty,
            productVariantId: varId,
            selectedColor: color,
            selectedSize: size,
          ),
        );
      }
      return Cart(items: items);
    } catch (_) {
      return const Cart();
    }
  }

  Future<void> _persist(Cart cart) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (prefs == null) return;
    final encoded = cart.items.map((i) => [
      i.product.id, '${i.quantity}', i.selectedColor ?? '',
      i.selectedSize ?? '', i.id ?? '', '${i.effectiveVariantId ?? ''}',
    ].join(_sep)).toList();
    await prefs.setStringList(_kCartKey, encoded);
  }

  int _resolveVariantId(Product product, {String? color, String? size, int? variantId}) {
    if (variantId != null && variantId > 0) return variantId;
    if (product.variants.isNotEmpty) {
      if (color != null || size != null) {
        return product.variants.firstWhere(
          (v) => (color == null || v.color?.toLowerCase() == color.toLowerCase()) &&
              (size == null || v.size?.toLowerCase() == size.toLowerCase()),
          orElse: () => product.variants.first,
        ).id;
      }
      return product.variants.first.id;
    }
    return int.tryParse(product.id) ?? 1;
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

    final vId = _resolveVariantId(
      effectiveProduct,
      color: color,
      size: size,
      variantId: variantId,
    );

    // Optimistically update cart state immediately
    final optItem = CartItem(
      product: effectiveProduct,
      quantity: quantity,
      productVariantId: vId,
      selectedColor: color,
      selectedSize: size,
    );
    final optimisticCart = current.addItem(optItem);
    state = AsyncValue.data(optimisticCart);

    // Call POST /api/v1/cart/mobile-app/items
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
    await _persist(const Cart());
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
