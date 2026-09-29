import 'package:flutter_test/flutter_test.dart';
import 'package:aba_project/app/lib/features/cart/domain/entities/cart_entities.dart';
import 'package:aba_project/app/lib/features/shop/domain/entities/shop_entities.dart';

void main() {
  group('Cart Entity Tests', () {
    late Product testProduct;
    late CartItem testCartItem;

    setUp(() {
      testProduct = Product(
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

      testCartItem = CartItem(
        product: testProduct,
        quantity: 2,
      );
    });

    test('CartItem equality works correctly', () {
      final item1 = CartItem(product: testProduct, quantity: 2);
      final item2 = CartItem(product: testProduct, quantity: 2);
      final item3 = CartItem(product: testProduct, quantity: 3);

      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
    });

    test('Cart calculates subtotal correctly', () {
      final cart = Cart(items: [
        testCartItem,
        CartItem(product: testProduct, quantity: 1),
      ]);

      expect(cart.subtotal, equals(30000.0));
    });

    test('Cart calculates shipping correctly', () {
      // Test free shipping
      final cart1 = Cart(items: [
        CartItem(product: testProduct, quantity: 10),
      ]);
      expect(cart1.shipping, equals(0.0));

      // Test paid shipping
      final cart2 = Cart(items: [
        CartItem(product: testProduct, quantity: 5),
      ]);
      expect(cart2.shipping, equals(2000.0));
    });

    test('Cart calculates tax correctly', () {
      final cart = Cart(items: [
        testCartItem,
      ]);
      expect(cart.tax, equals(750.0)); // 10000 * 2 * 0.075
    });

    test('Cart calculates total correctly', () {
      final cart = Cart(items: [
        testCartItem,
      ]);
      expect(cart.total, equals(22750.0)); // 20000 + 2000 + 750
    });

    test('Cart calculates item count correctly', () {
      final cart = Cart(items: [
        testCartItem,
        CartItem(product: testProduct, quantity: 3),
      ]);
      expect(cart.itemCount, equals(5));
    });
  });
}