import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/cart/data/cart_mock_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';

void main() {
  group('CartMockRepository Tests', () {
    late CartMockRepository repository;
    late Product testProduct;

    setUp(() {
      repository = CartMockRepository();

      testProduct = const Product(
        id: 'p1',
        name: 'Test Product',
        slug: 'test-product',
        price: 10000,
        category: 'Test',
        brand: 'Test Brand',
        rating: 4.5,
        reviewCount: 10,
        stock: 5,
        images: ['https://example.com/image.jpg'],
        description: 'Test product description',
        tags: ['test'],
      );
    });

    test('addToCart adds item to cart', () async {
      final item = await repository.addToCart(testProduct, quantity: 2);

      expect(item.product.id, equals(testProduct.id));
      expect(item.quantity, equals(2));
    });

    test('addToCart updates quantity for existing item', () async {
      // Add item first
      await repository.addToCart(testProduct, quantity: 2);

      // Add more quantity
      final item = await repository.addToCart(testProduct, quantity: 3);

      expect(item.quantity, equals(5));
    });

    test('updateQuantity updates item quantity', () async {
      // Add item first
      await repository.addToCart(testProduct, quantity: 2);

      // Update quantity
      await repository.updateQuantity(testProduct.id, 5);

      final items = await repository.getCartItems();
      expect(items.first.quantity, equals(5));
    });

    test('updateQuantity removes item when quantity is 0', () async {
      // Add item first
      await repository.addToCart(testProduct, quantity: 2);

      // Update quantity to 0 (should remove item)
      await repository.updateQuantity(testProduct.id, 0);

      final items = await repository.getCartItems();
      expect(items.isEmpty, isTrue);
    });

    test('removeFromCart removes item from cart', () async {
      // Add item first
      await repository.addToCart(testProduct, quantity: 2);

      // Remove item
      await repository.removeFromCart(testProduct.id);

      final items = await repository.getCartItems();
      expect(items.isEmpty, isTrue);
    });

    test('clearCart clears all items', () async {
      // Add items
      await repository.addToCart(testProduct, quantity: 2);
      await repository.addToCart(testProduct, quantity: 1);

      // Clear cart
      await repository.clearCart();

      final items = await repository.getCartItems();
      expect(items.isEmpty, isTrue);
    });

    test('getCartSummary returns correct cart data', () async {
      // Add items
      await repository.addToCart(testProduct, quantity: 2);

      final cart = await repository.getCartSummary();

      expect(cart.items.length, equals(1));
      expect(cart.items.first.quantity, equals(2));
      expect(cart.itemCount, equals(2));
    });
  });
}