import 'package:app/features/cart/domain/cart_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';

class CartService {
  final CartRepository _repository;

  CartService(this._repository);

  Future<List<CartItem>> getCartItems() async {
    try {
      return await _repository.getCartItems();
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<CartItem> addToCart(Product product, {int quantity = 1}) async {
    try {
      return await _repository.addToCart(product, quantity: quantity);
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      await _repository.updateQuantity(productId, quantity);
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await _repository.removeFromCart(productId);
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await _repository.clearCart();
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<Cart> getCartSummary() async {
    try {
      return await _repository.getCartSummary();
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }
}
