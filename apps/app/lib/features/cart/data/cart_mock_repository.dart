import 'package:app/features/cart/domain/cart_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';

class CartMockRepository implements CartRepository {
  final List<CartItem> _cartItems = [];

  @override
  Future<Cart> getCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Cart(items: List.from(_cartItems));
  }

  @override
  Future<Cart> getMyCart() => getCart();

  @override
  Future<CartAvailabilityResult> checkAvailability() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final unavail = <int>[];
    for (final item in _cartItems) {
      if (item.product.stock < item.quantity) {
        if (item.effectiveVariantId != null) {
          unavail.add(item.effectiveVariantId!);
        }
      }
    }
    return CartAvailabilityResult(
      isAvailable: unavail.isEmpty,
      message: unavail.isEmpty ? 'All items in stock' : 'Some items are unavailable',
      unavailableVariantIds: unavail,
    );
  }

  @override
  Future<CartItem> addItem({
    required int productVariantId,
    required int quantity,
    Product? product,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final existingIndex = _cartItems.indexWhere(
      (item) =>
          item.productVariantId == productVariantId ||
          (product != null && item.product.id == product.id),
    );

    if (existingIndex >= 0) {
      final updated = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
      _cartItems[existingIndex] = updated;
      return updated;
    }

    final p = product ??
        Product(
          id: 'prod-$productVariantId',
          name: 'Demo Product $productVariantId',
          slug: 'demo-product-$productVariantId',
          price: 25000.0,
          category: 'General',
          brand: 'Aba Craft',
          rating: 4.8,
          reviewCount: 12,
          stock: 20,
          images: const [],
        );

    final newItem = CartItem(
      id: 'item-${DateTime.now().millisecondsSinceEpoch}',
      product: p,
      productVariantId: productVariantId,
      quantity: quantity,
      unitPrice: p.discountedPrice > 0 ? p.discountedPrice : p.price,
    );

    _cartItems.add(newItem);
    return newItem;
  }

  @override
  Future<CartItem> updateItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _cartItems.indexWhere(
      (i) => i.id == itemId || i.effectiveId == itemId,
    );
    if (index >= 0) {
      if (quantity <= 0) {
        final removed = _cartItems.removeAt(index);
        return removed.copyWith(quantity: 0);
      }
      final updated = _cartItems[index].copyWith(quantity: quantity);
      _cartItems[index] = updated;
      return updated;
    }
    throw Exception('Cart item $itemId not found');
  }

  @override
  Future<void> removeItem(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _cartItems.removeWhere(
      (i) => i.id == itemId || i.effectiveId == itemId || i.product.id == itemId,
    );
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cartItems.clear();
  }

  // ── Backward-compatible legacy interface ──────────────────────────────
  @override
  Future<List<CartItem>> getCartItems() async => List.from(_cartItems);

  @override
  Future<CartItem> addToCart(
    Product product, {
    int quantity = 1,
    int? variantId,
  }) {
    final vId = variantId ??
        (product.variants.isNotEmpty ? product.variants.first.id : (int.tryParse(product.id) ?? 1));
    return addItem(
      productVariantId: vId,
      quantity: quantity,
      product: product,
    );
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
    } else {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == productId || item.effectiveId == productId,
      );
      if (index >= 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  Future<void> removeFromCart(String productId) async => removeItem(productId);

  @override
  Future<Cart> getCartSummary() async => Cart(items: List.from(_cartItems));
}
