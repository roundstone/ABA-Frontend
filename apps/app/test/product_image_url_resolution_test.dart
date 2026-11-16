import 'package:app/core/network/api_endpoints.dart';
import 'package:app/core/widgets/app_network_image.dart';
import 'package:app/features/shop/domain/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Relative Product Image URL Resolution', () {
    test('AppNetworkImage.resolveUrl resolves relative /api/v1/media paths', () {
      expect(
        AppNetworkImage.resolveUrl('/api/v1/media/local/708'),
        '${ApiEndpoints.baseUrl}/api/v1/media/local/708',
      );
      expect(
        AppNetworkImage.resolveUrl('https://cdn.example.com/img.jpg'),
        'https://cdn.example.com/img.jpg',
      );
      expect(AppNetworkImage.resolveUrl(''), isNull);
      expect(AppNetworkImage.resolveUrl(null), isNull);
    });

    test('Product.fromJson normalizes relative image URLs in images list', () {
      final product = Product.fromJson({
        'id': 3,
        'name': 'Demo Product 2',
        'slug': 'demo-product-2',
        'base_selling_price': '12700.00',
        'images': [
          {
            'id': 708,
            'url': '/api/v1/media/local/708',
            'original_name': 'shoe-brown-slides.jpeg',
          },
        ],
      });

      expect(
        product.images,
        ['${ApiEndpoints.baseUrl}/api/v1/media/local/708'],
      );
      expect(
        product.imageUrl,
        '${ApiEndpoints.baseUrl}/api/v1/media/local/708',
      );
    });
  });
}
