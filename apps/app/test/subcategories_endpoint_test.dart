import 'package:app/core/network/list_query_params.dart';
import 'package:app/features/shop/data/shop_mock_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product Subcategories Endpoint Tests', () {
    final sampleSubcategoryJson = {
      "id": 2,
      "category_id": 14,
      "name": "Bags and Accessories",
      "slug": "bags-accessories",
      "description": "Bags, belts, jewellery and fashion accessories.",
      "is_active": true,
      "category": {
        "id": 14,
        "name": "Clothing",
        "slug": "clothing",
        "description": "Apparel, footwear, bags and accessories.",
        "is_active": true,
        "createdAt": "2026-10-25T19:09:01.366Z",
        "updatedAt": "2026-10-25T19:09:01.366Z",
        "deletedAt": null
      },
      "createdAt": "2026-10-25T19:09:01.366Z",
      "updatedAt": "2026-10-25T19:09:01.366Z",
      "deletedAt": null,
      "productCount": 0
    };

    final sampleActiveSubcategoryJson = {
      "id": 6,
      "category_id": 14,
      "name": "Men's Clothing",
      "slug": "mens-clothing",
      "description": "Clothing and apparel for men.",
      "is_active": true,
      "category": {
        "id": 14,
        "name": "Clothing",
        "slug": "clothing",
        "description": "Apparel, footwear, bags and accessories.",
        "is_active": true,
      },
      "createdAt": "2026-10-25T19:09:01.366Z",
      "updatedAt": "2026-10-25T19:09:01.366Z",
      "productCount": 20
    };

    test('ShopCategory correctly parses subcategory payload with parent category', () {
      final sub = ShopCategory.fromJson(sampleSubcategoryJson);

      expect(sub.id, '2');
      expect(sub.name, 'Bags and Accessories');
      expect(sub.slug, 'bags-accessories');
      expect(sub.parentId, '14');
      expect(sub.isActive, isTrue);
      expect(sub.productCount, 0);
      expect(sub.parentCategory?.id, '14');
      expect(sub.parentCategory?.name, 'Clothing');
    });

    test('ShopCategory correctly parses productCount > 0', () {
      final sub = ShopCategory.fromJson(sampleActiveSubcategoryJson);

      expect(sub.id, '6');
      expect(sub.name, "Men's Clothing");
      expect(sub.parentId, '14');
      expect(sub.productCount, 20);
      expect(sub.parentCategory?.name, 'Clothing');
    });

    test('ShopMockRepository.fetchSubcategories handles params & categoryId filtering', () async {
      final repo = ShopMockRepository();

      final allSubcategories = await repo.fetchSubcategories(
        params: const ListQueryParams(includeCounts: true),
      );
      expect(allSubcategories, isNotEmpty);

      final filteredByParent = await repo.fetchSubcategories(
        params: const ListQueryParams(categoryId: 1, includeCounts: true),
      );
      for (final s in filteredByParent) {
        expect(s.parentId, '1');
      }
    });

    test('ShopMockRepository.fetchSubcategoryById returns matching subcategory', () async {
      final repo = ShopMockRepository();
      final all = await repo.fetchSubcategories();
      if (all.isNotEmpty) {
        final target = all.first;
        final fetched = await repo.fetchSubcategoryById(target.id);
        expect(fetched?.id, target.id);
        expect(fetched?.name, target.name);

        final fetchedBySlug = await repo.fetchSubcategoryById(target.slug);
        expect(fetchedBySlug?.id, target.id);
      }
    });

    test('ProductVariant parses variant endpoint payload with parent product', () {
      final variantJson = {
        "id": 9,
        "product_id": 7,
        "merchant_id": 8,
        "name": "Demo Product 3 - Black",
        "sku": "DEMO-SKU-003-B",
        "barcode": null,
        "price": "12800.00",
        "cost_price": "10300.00",
        "variant_cost_price": "10300.00",
        "variant_selling_price": "12800.00",
        "weight": null,
        "attributes": {
          "color": "Black"
        },
        "is_active": true,
        "product": {
          "id": 7,
          "category_id": 13,
          "subcategory_id": 1,
          "name": "Demo Product 3",
          "slug": "demo-product-3",
          "description": "Demo product used for ERP staging demonstrations.",
          "brand_id": 1,
          "is_active": true,
          "base_cost_price": "10300.00",
          "base_selling_price": "12800.00",
          "base_unit_of_measurement": "piece",
          "type": 1,
          "reorder_level": 5,
          "reorder_quantity": 20
        }
      };

      final variant = ProductVariant.fromJson(variantJson);
      expect(variant.id, 9);
      expect(variant.productId, 7);
      expect(variant.merchantId, 8);
      expect(variant.name, 'Demo Product 3 - Black');
      expect(variant.sku, 'DEMO-SKU-003-B');
      expect(variant.price, 12800.0);
      expect(variant.color, 'Black');
      expect(variant.product, isNotNull);
      expect(variant.product?.id, '7');
      expect(variant.product?.name, 'Demo Product 3');
      expect(variant.product?.categoryId, 13);
      expect(variant.product?.subcategoryId, 1);
    });

    test('ShopMockRepository.fetchProductVariantById returns variant', () async {
      final repo = ShopMockRepository();
      final variant = await repo.fetchProductVariantById('9');
      expect(variant, isNotNull);
      expect(variant?.id, 9);
      expect(variant?.product, isNotNull);
    });
  });
}
