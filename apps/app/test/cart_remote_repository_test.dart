import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/cart/data/cart_remote_repository.dart';
import 'package:app/features/cart/data/cart_mock_repository.dart';

void main() {
  group('CartRemoteRepository Tests', () {
    late Dio dio;
    late CartMockRepository mockRepo;
    late CartRemoteRepository repository;
    RequestOptions? lastRequest;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.aba.com'));
      mockRepo = CartMockRepository();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            lastRequest = options;
            if (options.path.contains('/availability')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'statusCode': 200,
                    'message': 'Request completed successfully',
                    'data': {
                      'cart_id': 1,
                      'is_available': true,
                      'items': [
                        {
                          'cart_item_id': 7,
                          'product_variant_id': 2,
                          'requested_quantity': 1,
                          'available_quantity': 22,
                          'is_available': true,
                        },
                        {
                          'cart_item_id': 8,
                          'product_variant_id': 4,
                          'requested_quantity': 1,
                          'available_quantity': 24,
                          'is_available': true,
                        },
                      ],
                    },
                    'timestamp': '2026-10-31T07:31:32.881Z',
                  },
                ),
              );
            }

            if (options.method == 'PATCH' || (options.method == 'POST' && options.path.contains('/items'))) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'data': {
                      'id': 10,
                      'product_variant_id': 42,
                      'quantity': 3,
                      'price': 5000,
                      'product': {
                        'id': 42,
                        'name': 'Test Remote Item',
                        'slug': 'test-remote-item',
                        'price': 5000,
                        'stock': 15,
                      },
                    },
                  },
                ),
              );
            }

            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'data': {
                    'id': 1,
                    'items': [
                      {
                        'id': 10,
                        'product_variant_id': 42,
                        'quantity': 2,
                        'price': 5000,
                        'product': {
                          'id': 42,
                          'name': 'Test Remote Item',
                          'slug': 'test-remote-item',
                          'price': 5000,
                          'stock': 15,
                        },
                      }
                    ],
                    'total': 10000,
                  },
                },
              ),
            );
          },
        ),
      );

      repository = CartRemoteRepository(dio: dio, mockFallback: mockRepo);
    });

    test('getCart calls GET /api/v1/cart/mobile-app', () async {
      final cart = await repository.getCart();
      expect(lastRequest?.method, equals('GET'));
      expect(lastRequest?.path, equals('/api/v1/cart/mobile-app'));
      expect(cart.items.length, equals(1));
    });

    test('getMyCart calls GET /api/v1/cart/mobile-app/me', () async {
      final cart = await repository.getMyCart();
      expect(lastRequest?.method, equals('GET'));
      expect(lastRequest?.path, equals('/api/v1/cart/mobile-app/me'));
      expect(cart.items.length, equals(1));
    });

    test('checkAvailability calls GET /api/v1/cart/mobile-app/availability', () async {
      final res = await repository.checkAvailability();
      expect(lastRequest?.method, equals('GET'));
      expect(lastRequest?.path, equals('/api/v1/cart/mobile-app/availability'));
      expect(res.isAvailable, isTrue);
      expect(res.cartId, equals(1));
      expect(res.items.length, equals(2));
      expect(res.items[0].cartItemId, equals(7));
      expect(res.items[0].productVariantId, equals(2));
      expect(res.items[0].requestedQuantity, equals(1));
      expect(res.items[0].availableQuantity, equals(22));
      expect(res.items[0].isAvailable, isTrue);
      expect(res.items[1].cartItemId, equals(8));
      expect(res.items[1].productVariantId, equals(4));
      expect(res.items[1].availableQuantity, equals(24));
      expect(res.items[1].isAvailable, isTrue);
      expect(res.unavailableVariantIds, isEmpty);
    });

    test('addItem calls POST /api/v1/cart/mobile-app/items with productVariantId', () async {
      final item = await repository.addItem(productVariantId: 42, quantity: 2);
      expect(lastRequest?.method, equals('POST'));
      expect(lastRequest?.path, equals('/api/v1/cart/mobile-app/items'));
      expect(lastRequest?.data, equals({'productVariantId': 42, 'quantity': 2}));
      expect(item.id, equals('10'));
      expect(item.productVariantId, equals(42));
    });

    test('updateItemQuantity calls PATCH /api/v1/cart/mobile-app/items/{itemId}', () async {
      final item = await repository.updateItemQuantity(itemId: '10', quantity: 3);
      expect(lastRequest?.method, equals('PATCH'));
      expect(lastRequest?.path, equals('/api/v1/cart/mobile-app/items/10'));
      expect(lastRequest?.data, equals({'quantity': 3}));
      expect(item.quantity, equals(3));
    });

    test('removeItem calls DELETE /api/v1/cart/mobile-app/items/{itemId}', () async {
      await repository.removeItem('10');
      expect(lastRequest?.method, equals('DELETE'));
      expect(lastRequest?.path, equals('/api/v1/cart/mobile-app/items/10'));
    });

    test('clearCart calls DELETE /api/v1/cart/mobile-app', () async {
      await repository.clearCart();
      expect(lastRequest?.method, equals('DELETE'));
      expect(lastRequest?.path, equals('/api/v1/cart/mobile-app'));
    });
  });
}
