import 'package:app/features/shop/domain/product.dart';
import 'package:app/features/wishlist/application/wishlist_providers.dart';
import 'package:app/features/wishlist/data/wishlist_mock_repository.dart';
import 'package:app/features/wishlist/data/wishlist_remote_repository.dart';
import 'package:app/features/wishlist/domain/wishlist_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WishlistItem JSON Parsing Tests', () {
    test('parses WishlistItem from POST creation response', () {
      final json = {
        "id": 1,
        "customer_id": 4,
        "wishlistable_type": "product",
        "wishlistable_id": 42,
        "createdAt": "2026-11-02T12:19:49.139Z",
      };

      final item = WishlistItem.fromJson(json);

      expect(item.id, equals(1));
      expect(item.customerId, equals(4));
      expect(item.wishlistableType, equals('product'));
      expect(item.wishlistableId, equals(42));
      expect(item.createdAt, isNotNull);
      expect(item.product, isNull);
    });

    test('parses WishlistItem from GET response with nested wishlistable', () {
      final json = {
        "id": 1,
        "customer_id": 4,
        "wishlistable_type": "product",
        "wishlistable_id": 42,
        "wishlistable": {
          "id": 42,
          "name": "Demo Product 41",
          "slug": "demo-product-41",
          "base_cost_price": "14100.00",
          "base_selling_price": "16600.00",
          "brand": {"id": 1, "name": "ABA Demo", "slug": "aba-demo"},
          "merchant": {"id": 7, "business_name": "Demo Merchant Store 5"},
          "images": [{"id": 42, "url": "https://example.com/demo41.jpg"}],
        },
        "createdAt": "2026-11-02T12:19:49.139Z",
      };

      final item = WishlistItem.fromJson(json);

      expect(item.id, equals(1));
      expect(item.product, isNotNull);
      expect(item.product!.name, equals('Demo Product 41'));
      expect(item.product!.price, equals(16600.0));
      expect(item.product!.brand, equals('ABA Demo'));
    });
  });

  group('WishlistRemoteRepository Tests', () {
    late Dio dio;
    late WishlistMockRepository fallback;
    late WishlistRemoteRepository remoteRepo;

    setUp(() {
      dio = Dio();
      fallback = WishlistMockRepository();
      remoteRepo = WishlistRemoteRepository(dio, fallback);
    });

    test('getWishlist calls GET endpoint and parses items', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('/wishlists/mobile-app') &&
                options.method == 'GET') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    "success": true,
                    "statusCode": 200,
                    "message": "Request completed successfully",
                    "data": {
                      "data": [
                        {
                          "id": 1,
                          "customer_id": 4,
                          "wishlistable_type": "product",
                          "wishlistable_id": 42,
                          "wishlistable": {
                            "id": 42,
                            "name": "Demo Product 41",
                            "slug": "demo-41",
                            "base_selling_price": "16600.00",
                          },
                          "createdAt": "2026-11-02T12:19:49.139Z",
                        }
                      ],
                      "meta": {"total": 1, "page": 1, "limit": 10},
                    },
                  },
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      final res = await remoteRepo.getWishlist(page: 1, limit: 10);
      expect(res.items.length, equals(1));
      expect(res.items.first.wishlistableId, equals(42));
      expect(res.items.first.product?.name, equals('Demo Product 41'));
    });

    test('addToWishlist calls POST endpoint with correct payload', () async {
      dynamic capturedData;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('/wishlists/mobile-app') &&
                options.method == 'POST') {
              capturedData = options.data;
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    "success": true,
                    "statusCode": 201,
                    "message": "Request completed successfully",
                    "data": {
                      "id": 99,
                      "customer_id": 4,
                      "wishlistable_type": "product",
                      "wishlistable_id": 42,
                      "createdAt": "2026-11-02T12:19:49.139Z",
                    },
                  },
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      final created = await remoteRepo.addToWishlist(wishlistableId: 42);
      expect(capturedData['wishlistableType'], equals('product'));
      expect(capturedData['wishlistableId'], equals(42));
      expect(created.id, equals(99));
      expect(created.wishlistableId, equals(42));
    });

    test('removeFromWishlist calls DELETE /wishlists/mobile-app/{id}', () async {
      String? deletedPath;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.method == 'DELETE') {
              deletedPath = options.path;
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {"success": true, "statusCode": 200},
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      await remoteRepo.removeFromWishlist(105);
      expect(deletedPath, contains('/wishlists/mobile-app/105'));
    });
  });

  group('WishlistNotifier Tests', () {
    test('toggleWishlist optimistically adds and removes products', () async {
      final mock = WishlistMockRepository();
      final container = ProviderContainer(
        overrides: [
          wishlistRepositoryProvider.overrideWithValue(mock),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(wishlistNotifierProvider.notifier);
      await notifier.loadInitial();

      const testProduct = Product(
        id: '100',
        name: 'Test Item 100',
        slug: 'test-100',
        price: 5000,
        category: 'Test',
        brand: 'ABA',
        rating: 4.0,
        reviewCount: 1,
        stock: 10,
        images: ['https://example.com/p.jpg'],
      );

      // 1. Initial state (item 100 is not wishlisted)
      expect(
        container.read(isProductInWishlistProvider('100')),
        isFalse,
      );

      // 2. Add to wishlist
      final added = await notifier.toggleWishlist(testProduct);
      expect(added, isTrue);
      expect(
        container.read(isProductInWishlistProvider('100')),
        isTrue,
      );

      // 3. Remove from wishlist
      final removed = await notifier.toggleWishlist(testProduct);
      expect(removed, isFalse);
      expect(
        container.read(isProductInWishlistProvider('100')),
        isFalse,
      );
    });
  });
}
