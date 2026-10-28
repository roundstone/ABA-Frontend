import 'package:app/core/network/api_endpoints.dart';
import 'package:app/features/shop/data/shop_remote_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sampleProductJson = {
    'id': 5,
    'category_id': 5,
    'name': 'Demo Product 1',
    'slug': 'demo-product-1',
    'description': 'Demo product used for ERP staging demonstrations.',
    'brand_id': 1,
    'is_active': true,
    'base_cost_price': '10100.00',
    'base_selling_price': '12600.00',
    'base_unit_of_measurement': 'piece',
    'type': 1,
    'reorder_level': 5,
    'reorder_quantity': 20,
    'vendor_id': 6,
    'category': {
      'id': 5,
      'name': 'Demo Category 1',
      'slug': 'demo-category-1',
      'description': 'Demo catalogue category 1',
      'is_active': true,
      'createdAt': '2026-10-23T08:53:05.363Z',
      'updatedAt': '2026-10-23T08:53:05.363Z',
      'deletedAt': null,
    },
    'variants': [
      {
        'id': 5,
        'product_id': 5,
        'name': 'Demo Product 1 - Black',
        'sku': 'DEMO-SKU-001-B',
        'barcode': null,
        'price': '12600.00',
        'cost_price': '10100.00',
        'variant_cost_price': '10100.00',
        'variant_selling_price': '12600.00',
        'weight': null,
        'attributes': {'color': 'Black'},
        'is_active': true,
        'createdAt': '2026-10-23T08:53:05.363Z',
        'updatedAt': '2026-10-23T08:53:05.363Z',
        'deletedAt': null,
      },
      {
        'id': 6,
        'product_id': 5,
        'name': 'Demo Product 1 - Blue',
        'sku': 'DEMO-SKU-001-L',
        'barcode': null,
        'price': '13100.00',
        'cost_price': '10100.00',
        'variant_cost_price': '10100.00',
        'variant_selling_price': '13100.00',
        'weight': null,
        'attributes': {'color': 'Blue'},
        'is_active': true,
        'createdAt': '2026-10-23T08:53:05.363Z',
        'updatedAt': '2026-10-23T08:53:05.363Z',
        'deletedAt': null,
      }
    ],
    'createdAt': '2026-10-23T08:53:05.363Z',
    'updatedAt': '2026-10-23T08:53:05.363Z',
    'deletedAt': null,
  };

  group('Product and ProductVariant Models', () {
    test('ProductVariant.fromJson parses variant correctly', () {
      final vJson = (sampleProductJson['variants']! as List)[0] as Map<String, dynamic>;
      final variant = ProductVariant.fromJson(vJson);

      expect(variant.id, 5);
      expect(variant.productId, 5);
      expect(variant.name, 'Demo Product 1 - Black');
      expect(variant.sku, 'DEMO-SKU-001-B');
      expect(variant.price, 12600.0);
      expect(variant.costPrice, 10100.0);
      expect(variant.color, 'Black');
      expect(variant.isActive, true);
    });

    test('Product.fromJson parses backend product JSON accurately', () {
      final product = Product.fromJson(sampleProductJson);

      expect(product.id, '5');
      expect(product.name, 'Demo Product 1');
      expect(product.slug, 'demo-product-1');
      expect(product.price, 12600.0);
      expect(product.baseCostPrice, 10100.0);
      expect(product.baseSellingPrice, 12600.0);
      expect(product.category, 'Demo Category 1');
      expect(product.categoryId, 5);
      expect(product.brandId, 1);
      expect(product.vendorId, 6);
      expect(product.variants.length, 2);
      expect(product.colors, containsAll(['Black', 'Blue']));
      expect(product.inStock, true);
      expect(product.imageUrl.isNotEmpty, true);
    });
  });

  group('ShopRemoteRepository fetchProducts Tests', () {
    test('fetchProducts passes all filter parameters to query', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedOptions = options;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'statusCode': 200,
                  'message': 'Request completed successfully',
                  'data': {
                    'data': [sampleProductJson],
                    'meta': {
                      'totalItems': 1,
                      'itemCount': 1,
                      'itemsPerPage': 10,
                      'totalPages': 1,
                      'currentPage': 1,
                    }
                  }
                },
              ),
            );
          },
        ),
      );

      final repo = ShopRemoteRepository(dio: dio);
      final products = await repo.fetchProducts(
        page: 2,
        pageSize: 15,
        search: 'Demo',
        categoryId: 5,
        brandId: 1,
        vendorId: 6,
        minPrice: 5000,
        maxPrice: 20000,
        rating: 4.0,
        sort: SortOrder.priceLow,
      );

      expect(products.length, 1);
      expect(products.first.name, 'Demo Product 1');

      final q = capturedOptions?.queryParameters;
      expect(q?['page'], 2);
      expect(q?['limit'], 15);
      expect(q?['search'], 'Demo');
      expect(q?['categoryId'], 5);
      expect(q?['brandId'], 1);
      expect(q?['vendorId'], 6);
      expect(q?['minPrice'], 5000.0);
      expect(q?['maxPrice'], 20000.0);
      expect(q?['rating'], 4.0);
      expect(q?['orderBy'], 'base_selling_price:ASC');
      expect(q?['isActive'], true);
      expect(q?['includeVariants'], true);
    });

    test('fetchProductById queries product by id with includeVariants', () async {
      final dio = Dio();
      RequestOptions? capturedOptions;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedOptions = options;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'statusCode': 200,
                  'data': sampleProductJson,
                },
              ),
            );
          },
        ),
      );

      final repo = ShopRemoteRepository(dio: dio);
      final product = await repo.fetchProductById('5');

      expect(product, isNotNull);
      expect(product!.id, '5');
      expect(product.variants.length, 2);
      expect(capturedOptions?.path, ApiEndpoints.products.byId('5'));
      expect(capturedOptions?.queryParameters['includeVariants'], true);
    });

    test('fetchProductById handles non-numeric slug safely without 400 error', () async {
      final dio = Dio();
      final repo = ShopRemoteRepository(dio: dio);

      // Should not throw or crash on non-numeric slug
      final product = await repo.fetchProductById('wander-pack-heaven-backpack');
      expect(product, isNotNull);
    });

    test('fetchFeaturedProducts queries storefront endpoint', () async {
      final dio = Dio();
      RequestOptions? captured;
      dio.interceptors.add(InterceptorsWrapper(onRequest: (opt, handler) {
        captured = opt;
        return handler.resolve(Response(requestOptions: opt, statusCode: 200, data: {
          'success': true, 'data': [sampleProductJson],
        }));
      }));
      final list = await ShopRemoteRepository(dio: dio).fetchFeaturedProducts();
      expect(list.length, 1);
      expect(captured?.path, ApiEndpoints.storefront.featuredProducts);
    });

    test('fetchTrendingProducts queries storefront endpoint', () async {
      final dio = Dio();
      RequestOptions? captured;
      dio.interceptors.add(InterceptorsWrapper(onRequest: (opt, handler) {
        captured = opt;
        return handler.resolve(Response(requestOptions: opt, statusCode: 200, data: {
          'success': true, 'data': [sampleProductJson],
        }));
      }));
      final list = await ShopRemoteRepository(dio: dio).fetchTrendingProducts();
      expect(list.length, 1);
      expect(captured?.path, ApiEndpoints.storefront.trendingProducts);
    });
  });
}
