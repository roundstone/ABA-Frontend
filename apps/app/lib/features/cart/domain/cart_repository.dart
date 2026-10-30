import 'package:app/features/shop/domain/shop_entities.dart';

abstract class CartRepository {
  /// Fetches cart from GET /api/v1/cart/mobile-app
  Future<Cart> getCart();

  /// Fetches current user's cart summary from GET /api/v1/cart/mobile-app/me
  Future<Cart> getMyCart();

  /// Checks inventory availability from GET /api/v1/cart/mobile-app/availability
  Future<CartAvailabilityResult> checkAvailability();

  /// Adds a variant to cart via POST /api/v1/cart/mobile-app/items
  /// Request body: { "productVariantId": 42, "quantity": 2 }
  Future<CartItem> addItem({
    required int productVariantId,
    required int quantity,
    Product? product,
  });

  /// Updates quantity via PATCH /api/v1/cart/mobile-app/items/{itemId}
  /// Request body: { "quantity": 3 }
  Future<CartItem> updateItemQuantity({
    required String itemId,
    required int quantity,
  });

  /// Removes an item via DELETE /api/v1/cart/mobile-app/items/{itemId}
  Future<void> removeItem(String itemId);

  /// Clears the mobile app cart via DELETE /api/v1/cart/mobile-app
  Future<void> clearCart();

  // ── Backward-compatible legacy interface ──────────────────────────────
  Future<List<CartItem>> getCartItems();
  Future<CartItem> addToCart(Product product, {int quantity = 1, int? variantId});
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> removeFromCart(String productId);
  Future<Cart> getCartSummary();
}
