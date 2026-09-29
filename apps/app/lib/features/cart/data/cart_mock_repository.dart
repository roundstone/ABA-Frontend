
import 'package:app/features/cart/domain/cart_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';

class CartMockRepository implements CartRepository {
  // In-memory cart storage
  final List<CartItem> _cartItems = [];

  @override
  Future<List<CartItem>> getCartItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_cartItems);
  }

  @override
  Future<CartItem> addToCart(Product product, {int quantity = 1}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Update quantity if item already exists
      final updatedItem = _cartItems[existingItemIndex].copyWith(
        quantity: _cartItems[existingItemIndex].quantity + quantity,
      );
      _cartItems[existingItemIndex] = updatedItem;
      return updatedItem;
    } else {
      // Add new item
      final newItem = CartItem(
        product: product,
        quantity: quantity,
      );
      _cartItems.add(newItem);
      return newItem;
    }
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    if (quantity <= 0) {
      _cartItems.removeWhere((item) => item.product.id == productId);
    } else {
      final index = _cartItems.indexWhere((item) => item.product.id == productId);
      if (index >= 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.removeWhere((item) => item.product.id == productId);
  }

  @override
  Future<void> clearCart() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.clear();
  }

  @override
  Future<Cart> getCartSummary() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return Cart(items: _cartItems);
  }
}