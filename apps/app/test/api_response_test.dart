import 'package:app/core/network/api_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiResponse Tests', () {
    test('parses non-paginated success response correctly', () {
      final json = {
        'success': true,
        'statusCode': 200,
        'message': 'Request completed successfully',
        'data': {
          'id': 'prod-101',
          'name': 'Aba Handmade Leather Shoes',
          'price': 45000,
        },
        'timestamp': '2026-10-21T12:00:00.000Z',
        'path': '/api/v1/products',
      };

      final response = ApiResponse<Map<String, dynamic>>.fromJson(
        json,
        (data) => data as Map<String, dynamic>,
      );

      expect(response.success, isTrue);
      expect(response.statusCode, equals(200));
      expect(response.message, equals('Request completed successfully'));
      expect(response.data['id'], equals('prod-101'));
      expect(response.data['price'], equals(45000));
      expect(response.timestamp, equals('2026-10-21T12:00:00.000Z'));
      expect(response.path, equals('/api/v1/products'));
    });

    test('parses paginated response with meta correctly', () {
      final json = {
        'success': true,
        'statusCode': 200,
        'message': 'Request completed successfully',
        'data': {
          'data': [
            {'id': 'prod-1', 'name': 'Item 1'},
            {'id': 'prod-2', 'name': 'Item 2'},
          ],
          'meta': {
            'totalItems': 20,
            'itemCount': 2,
            'itemsPerPage': 10,
            'totalPages': 2,
            'currentPage': 1,
            'currentPageUrl': 'https://api.buynaija.ng/v1/products?page=1',
            'nextPageUrl': 'https://api.buynaija.ng/v1/products?page=2',
            'previousPageUrl': null,
          },
        },
        'timestamp': '2026-10-22T01:48:07.029Z',
      };

      final response = ApiResponse.fromPaginatedJson<Map<String, dynamic>>(
        json,
        (item) => item as Map<String, dynamic>,
      );

      expect(response.success, isTrue);
      expect(response.statusCode, equals(200));
      expect(response.data.items.length, equals(2));
      expect(response.data.items[0]['id'], equals('prod-1'));

      final meta = response.data.meta;
      expect(meta.totalItems, equals(20));
      expect(meta.itemCount, equals(2));
      expect(meta.itemsPerPage, equals(10));
      expect(meta.totalPages, equals(2));
      expect(meta.currentPage, equals(1));
      expect(meta.hasNextPage, isTrue);
      expect(meta.hasPreviousPage, isFalse);
    });

    test('unwrapMap extracts inner data regardless of envelope wrapping', () {
      // Case 1: Wrapped in ApiResponse
      final wrapped = {
        'success': true,
        'statusCode': 200,
        'data': {
          'access_token': 'test_token',
          'refresh_token': 'test_refresh',
        },
      };
      expect(ApiResponse.unwrapMap(wrapped)['access_token'], equals('test_token'));

      // Case 2: Bare map
      final bare = {
        'access_token': 'bare_token',
      };
      expect(ApiResponse.unwrapMap(bare)['access_token'], equals('bare_token'));
    });

    test('unwrapList handles both direct list and paginated object', () {
      final paginated = {
        'success': true,
        'data': {
          'data': ['itemA', 'itemB'],
          'meta': {'totalItems': 2},
        },
      };
      expect(ApiResponse.unwrapList(paginated), equals(['itemA', 'itemB']));

      final flatList = ['alpha', 'beta'];
      expect(ApiResponse.unwrapList(flatList), equals(['alpha', 'beta']));
    });
  });
}
