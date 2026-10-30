import 'package:app/core/network/api_endpoints.dart';
import 'package:app/features/merchant/application/merchant_products_notifier.dart';
import 'package:app/features/merchant/data/merchant_mock_repository.dart';
import 'package:app/features/merchant/data/merchant_remote_repository.dart';
import 'package:app/features/merchant/domain/merchant_product_entities.dart';
import 'package:app/features/merchant/presentation/widgets/merchant_product_taxonomy_fields.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MerchantProduct Payload Requirements Tests', () {
    test('toCreatePayload outputs exact backend specification', () {
      final product = MerchantProduct(
        id: '42',
        name: 'iPhone 17 Pro',
        sku: 'ABA-IPH-17',
        category: 'Electronics',
        categoryId: 3,
        subcategoryId: 8,
        brandId: 1,
        description: 'Flagship smartphone with a titanium finish.',
        price: 3500.00,
        costPrice: 2500.00,
        baseUnitOfMeasurement: 'piece',
        type: 1,
        reorderLevel: 10,
        reorderQuantity: 25,
        status: MerchantProductStatus.active,
        productImages: const ['https://images.unsplash.com/photo-iphone'],
        stock: 50,
        updatedAt: DateTime.now(),
      );

      final payload = product.toCreatePayload();

      expect(payload['categoryId'], equals(3));
      expect(payload['subcategoryId'], equals(8));
      expect(payload['name'], equals('iPhone 17 Pro'));
      expect(payload['description'], equals('Flagship smartphone with a titanium finish.'));
      expect(payload['brandId'], equals(1));
      expect(payload['baseCostPrice'], equals('2500.00'));
      expect(payload['baseSellingPrice'], equals('3500.00'));
      expect(payload['baseUnitOfMeasurement'], equals('piece'));
      expect(payload['type'], equals(1));
      expect(payload['reorderLevel'], equals(10));
      expect(payload['reorderQuantity'], equals(25));
      expect(payload['isActive'], isTrue);
      expect(payload['productImages'], equals(['https://images.unsplash.com/photo-iphone']));
    });

    test('fromJson parses backend product JSON properly', () {
      final json = {
        'id': 93,
        'name': 'Demo Product 89',
        'slug': 'demo-product-89',
        'categoryId': 3,
        'subcategoryId': 8,
        'brandId': 1,
        'category': {'id': 3, 'name': 'Electronics'},
        'brand': {'id': 1, 'name': 'Apple'},
        'baseCostPrice': '2500.00',
        'baseSellingPrice': '3500.00',
        'baseUnitOfMeasurement': 'piece',
        'type': 1,
        'reorderLevel': 10,
        'reorderQuantity': 25,
        'isActive': true,
        'productImages': ['https://images.unsplash.com/photo-1'],
        'stock': 15,
      };

      final product = MerchantProduct.fromJson(json);

      expect(product.id, equals('93'));
      expect(product.name, equals('Demo Product 89'));
      expect(product.categoryId, equals(3));
      expect(product.subcategoryId, equals(8));
      expect(product.brandId, equals(1));
      expect(product.category, equals('Electronics'));
      expect(product.costPrice, equals(2500.0));
      expect(product.price, equals(3500.0));
      expect(product.baseUnitOfMeasurement, equals('piece'));
      expect(product.type, equals(1));
      expect(product.reorderLevel, equals(10));
      expect(product.reorderQuantity, equals(25));
      expect(product.isActive, isTrue);
      expect(product.imageUrl, equals('https://images.unsplash.com/photo-1'));
    });
  });

  group('MerchantRemoteRepository & MockRepository CRUD Tests', () {
    test('Mock repository add, update, delete works correctly', () async {
      final mock = MerchantMockRepository();
      final initial = await mock.getProducts('mer-1');
      final initialCount = initial.length;

      final newProduct = MerchantProduct(
        id: 'new-101',
        name: 'Brand New Shoes',
        sku: 'ABA-NEW-01',
        category: 'Shoes',
        price: 20000.0,
        costPrice: 12000.0,
        stock: 10,
        updatedAt: DateTime.now(),
      );

      final added = await mock.addProduct('mer-1', newProduct);
      expect(added.id, equals('new-101'));

      final afterAdd = await mock.getProducts('mer-1');
      expect(afterAdd.length, equals(initialCount + 1));

      final updated = await mock.updateProduct('mer-1', added.copyWith(name: 'Updated Shoes'));
      expect(updated.name, equals('Updated Shoes'));

      await mock.deleteProduct('mer-1', 'new-101');
      final afterDelete = await mock.getProducts('mer-1');
      expect(afterDelete.any((p) => p.id == 'new-101'), isFalse);
    });

    test('Remote repository sends correct payloads and routes', () async {
      final dio = Dio();
      final requests = <RequestOptions>[];

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            if (options.path == ApiEndpoints.products.base && options.method == 'POST') {
              handler.resolve(Response(
                requestOptions: options,
                data: {
                  'success': true,
                  'statusCode': 201,
                  'data': {
                    'id': 199,
                    ...options.data as Map<String, dynamic>,
                  },
                },
              ));
            } else if (options.path == ApiEndpoints.products.byId('199') && options.method == 'DELETE') {
              handler.resolve(Response(
                requestOptions: options,
                data: {'success': true, 'statusCode': 200, 'message': 'Product deleted'},
              ));
            } else {
              handler.resolve(Response(
                requestOptions: options,
                data: {'success': true, 'statusCode': 200, 'data': []},
              ));
            }
          },
        ),
      );

      final repo = MerchantRemoteRepository(dio: dio);

      final created = await repo.addProduct(
        'mer-1',
        MerchantProduct(
          id: 'temp',
          name: 'iPhone 17 Pro',
          sku: 'ABA-01',
          category: 'Phones',
          categoryId: 3,
          subcategoryId: 8,
          brandId: 1,
          price: 3500.0,
          costPrice: 2500.0,
          stock: 10,
          updatedAt: DateTime.now(),
        ),
      );

      expect(created.id, equals('199'));
      expect(requests.first.path, equals(ApiEndpoints.products.base));
      expect(requests.first.method, equals('POST'));
      expect((requests.first.data as Map)['name'], equals('iPhone 17 Pro'));

      await repo.deleteProduct('mer-1', '199');
      expect(requests.last.path, equals(ApiEndpoints.products.byId('199')));
      expect(requests.last.method, equals('DELETE'));
    });

    test('MerchantProductsNotifier add, update, delete operations update state', () async {
      final mock = MerchantMockRepository();
      final notifier = MerchantProductsNotifier(repository: mock, merchantId: 'mer-1');

      await Future.delayed(const Duration(milliseconds: 300));
      expect(notifier.state.products.isNotEmpty, isTrue);

      final p = MerchantProduct(
        id: 'test-item-1',
        name: 'Notifier Product',
        sku: 'NOTIF-01',
        category: 'Test',
        price: 15000.0,
        costPrice: 9000.0,
        stock: 5,
        updatedAt: DateTime.now(),
      );

      final addOk = await notifier.addProduct(p);
      expect(addOk, isTrue);
      expect(notifier.state.products.any((x) => x.id == 'test-item-1'), isTrue);

      final editOk = await notifier.updateProduct(p.copyWith(name: 'Renamed Product'));
      expect(editOk, isTrue);
      expect(notifier.state.products.firstWhere((x) => x.id == 'test-item-1').name, equals('Renamed Product'));

      final delOk = await notifier.deleteProduct('test-item-1');
      expect(delOk, isTrue);
      expect(notifier.state.products.any((x) => x.id == 'test-item-1'), isFalse);
    });

    testWidgets('MerchantProductTaxonomyFields renders without dropdown assertion error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MerchantProductTaxonomyFields(
              selectedCategoryId: null,
              selectedSubcategoryId: null,
              selectedBrandId: null,
              productType: 1,
              categories: const [
                ShopCategory(id: 'cat_fashion', name: 'Fashion & Apparel', slug: 'fashion'),
                ShopCategory(id: 'cat_accessories', name: 'Accessories', slug: 'accessories'),
                ShopCategory(id: '3', name: 'Electronics', slug: 'electronics'),
              ],
              subcategories: const [
                ShopCategory(id: 'cat_clothes', name: 'Clothes', slug: 'fashion/clothes'),
                ShopCategory(id: 'cat_shoes', name: 'Shoes', slug: 'fashion/shoes'),
              ],
              brands: const [
                Brand(id: 1, name: 'Apple', slug: 'apple'),
                Brand(id: 2, name: 'Samsung', slug: 'samsung'),
              ],
              onCategoryChanged: (_) {},
              onSubcategoryChanged: (_) {},
              onBrandChanged: (_) {},
              onTypeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('No Category'), findsOneWidget);
      expect(find.text('No Subcategory'), findsOneWidget);
      expect(find.text('Generic / None'), findsOneWidget);
    });
  });
}

