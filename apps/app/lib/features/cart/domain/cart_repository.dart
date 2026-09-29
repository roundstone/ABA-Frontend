import 'package:app/features/shop/domain/shop_entities.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<CartItem> addToCart(Product product, {int quantity = 1});
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> removeFromCart(String productId);
  Future<void> clearCart();
  Future<Cart> getCartSummary();
}
