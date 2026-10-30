import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product shareUrl Tests', () {
    test('uses slug when slug is present', () {
      const product = Product(
        id: '42',
        name: 'Apple Watch Series 9',
        slug: 'apple-watch-series-9',
        price: 450000,
        category: 'Electronics',
        brand: 'Apple',
        rating: 4.8,
        reviewCount: 45,
        stock: 10,
        images: ['https://example.com/watch.jpg'],
      );

      expect(
        product.shareUrl,
        equals('https://abaonline.vercel.app/products/apple-watch-series-9'),
      );
    });

    test('falls back to slugified name when slug is empty', () {
      const product = Product(
        id: '88',
        name: 'Handmade Leather Shoes (Size 43)',
        slug: '',
        price: 35000,
        category: 'Fashion',
        brand: 'Aba Craft',
        rating: 4.5,
        reviewCount: 12,
        stock: 5,
        images: ['https://example.com/shoes.jpg'],
      );

      expect(
        product.shareUrl,
        equals('https://abaonline.vercel.app/products/handmade-leather-shoes-size-43'),
      );
    });

    test('falls back to id when slug and name are both empty', () {
      const product = Product(
        id: '99',
        name: '',
        slug: '',
        price: 10000,
        category: 'General',
        brand: 'Aba',
        rating: 4.0,
        reviewCount: 1,
        stock: 3,
        images: [],
      );

      expect(
        product.shareUrl,
        equals('https://abaonline.vercel.app/products/99'),
      );
    });
  });
}

