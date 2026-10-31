import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/cart/domain/entities/cart_entities.dart';
import 'package:app/features/shop/domain/shop_entities.dart' show Product, ProductVariant;

void main() {
  group('Cart Entity Tests', () {
    late Product testProduct;
    late CartItem testCartItem;

    setUp(() {
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
      // Test free shipping (subtotal >= 100,000)
      final cart1 = Cart(items: [
        CartItem(product: testProduct, quantity: 10),
      ]);
      expect(cart1.shipping, equals(0.0));

      // Test paid shipping (subtotal < 100,000)
      final cart2 = Cart(items: [
        CartItem(product: testProduct, quantity: 5),
      ]);
      expect(cart2.shipping, equals(2000.0));
    });

    test('Cart calculates tax correctly', () {
      final cart = Cart(items: [
        testCartItem,
      ]);
      expect(cart.tax, equals(1500.0)); // 10000 * 2 * 0.075 = 1500.0
    });

    test('Cart calculates total correctly', () {
      final cart = Cart(items: [
        testCartItem,
      ]);
      expect(cart.total, equals(23500.0)); // 20000 + 2000 + 1500 = 23500.0
    });

    test('Cart calculates item count correctly', () {
      final cart = Cart(items: [
        testCartItem,
        CartItem(product: testProduct, quantity: 3),
      ]);
      expect(cart.itemCount, equals(5));
    });

    test('CartItem.fromJson parses nested productVariant.product accurately without ID collisions', () {
      final backendJson = {
        'id': 3, // CartItem ID in database
        'cart_id': 1,
        'product_variant_id': 6,
        'quantity': 1,
        'productVariant': {
          'id': 6,
          'product_id': 4,
          'name': 'Demo Product 3 - Black',
          'price': '12800.00',
          'product': {
            'id': 4,
            'name': 'Demo Product 3',
            'slug': 'demo-product-3',
            'base_selling_price': '12800.00',
          },
        },
      };

      final item = CartItem.fromJson(backendJson);
      expect(item.id, equals('3'));
      expect(item.product.id, equals('4')); // Must be Product ID 4, not CartItem ID 3 or Variant ID 6
      expect(item.product.name, equals('Demo Product 3'));
      expect(item.effectiveVariantId, equals(6));

      const demoProduct1 = Product(
        id: '2',
        name: 'Demo Product 1',
        slug: 'demo-product-1',
        price: 12600,
        category: 'Clothing',
        brand: 'Brand 1',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        images: [],
      );

      const demoProduct3 = Product(
        id: '4',
        name: 'Demo Product 3',
        slug: 'demo-product-3',
        price: 12800,
        category: 'Electronics',
        brand: 'Brand 1',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        images: [],
      );

      final cart = Cart(items: [item]);
      expect(cart.containsProduct(demoProduct3), isTrue);
      expect(cart.containsProduct(demoProduct1), isFalse);
    });

    test('Cart.addItem does not overwrite or confuse items for different products', () {
      const prod1 = Product(
        id: '2',
        name: 'Demo Product 1',
        slug: 'demo-product-1',
        price: 12600,
        category: 'Clothing',
        brand: 'Brand 1',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        images: [],
      );

      const prod3 = Product(
        id: '4',
        name: 'Demo Product 3',
        slug: 'demo-product-3',
        price: 12800,
        category: 'Electronics',
        brand: 'Brand 1',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        images: [],
      );

      var cart = const Cart();
      cart = cart.addItem(const CartItem(
        id: '1',
        product: prod3,
        productVariantId: 6,
        quantity: 1,
      ));

      expect(cart.containsProduct(prod3), isTrue);
      expect(cart.containsProduct(prod1), isFalse);

      // Now add product 1
      cart = cart.addItem(const CartItem(
        id: '2',
        product: prod1,
        productVariantId: 2,
        quantity: 1,
      ));

      expect(cart.items.length, equals(2));
      expect(cart.containsProduct(prod3), isTrue);
      expect(cart.containsProduct(prod1), isTrue);
    });

    test('Cart.addItem does not confuse items even if both share a placeholder or cart ID', () {
      const prod1 = Product(
        id: '2',
        name: 'Demo Product 1',
        slug: 'demo-product-1',
        price: 12600,
        category: 'Clothing',
        brand: 'Brand 1',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        images: [],
      );

      const prod3 = Product(
        id: '4',
        name: 'Demo Product 3',
        slug: 'demo-product-3',
        price: 12800,
        category: 'Electronics',
        brand: 'Brand 1',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        images: [],
      );

      var cart = const Cart();
      // Suppose both items got cart ID '1' temporarily
      cart = cart.addItem(const CartItem(
        id: '1',
        product: prod1,
        productVariantId: 2,
        quantity: 1,
      ));

      cart = cart.addItem(const CartItem(
        id: '1',
        product: prod3,
        productVariantId: 6,
        quantity: 1,
      ));

      expect(cart.items.length, equals(2));
      expect(cart.containsProduct(prod1), isTrue);
      expect(cart.containsProduct(prod3), isTrue);
    });

    test('effectiveVariantId does not confuse product ID with variant ID', () {
      const prod2 = Product(
        id: '3',
        name: 'Demo Product 2',
        slug: 'demo-product-2',
        price: 12700,
        category: 'Electronics',
        brand: 'Brand 1',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        images: [],
      );

      const demoProduct1 = Product(
        id: '2',
        name: 'Demo Product 1',
        slug: 'demo-product-1',
        price: 12600,
        category: 'Clothing',
        brand: 'Brand 1',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        images: [],
        variants: [
          ProductVariant(id: 2, productId: 2, name: 'Black', sku: 'B', price: 12600),
          ProductVariant(id: 3, productId: 2, name: 'Blue', sku: 'L', price: 13100),
        ],
      );

      // Cart contains Demo Product 2 with no variant set
      const item = CartItem(
        id: 'item-2',
        product: prod2,
        quantity: 1,
      );

      expect(item.effectiveVariantId, isNull);

      const cart = Cart(items: [item]);
      // Demo Product 1 has variant ID 3, but should NOT be indicated as inCart
      expect(cart.containsProduct(demoProduct1), isFalse);
      expect(cart.containsProduct(prod2), isTrue);
    });
  });
}