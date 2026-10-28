import 'package:app/core/network/list_query_params.dart';
import 'package:app/features/shop/domain/product.dart';
import 'package:app/features/shop/domain/product_variant.dart';
import 'package:app/features/shop/domain/shop_category.dart';
import 'package:app/features/shop/presentation/widgets/category_chip_bar.dart';
import 'package:app/features/shop/presentation/widgets/category_tree_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sampleBackendPayload = {
    'id': 14,
    'name': 'Clothing',
    'slug': 'clothing',
    'description': 'Apparel, footwear, bags and accessories.',
    'is_active': true,
    'subcategories': [
      {
        'id': 2,
        'category_id': 14,
        'name': 'Bags and Accessories',
        'slug': 'bags-accessories',
        'description': 'Bags, belts, jewellery and fashion accessories.',
        'is_active': true,
        'productCount': 0,
      },
      {
        'id': 6,
        'category_id': 14,
        'name': "Men's Clothing",
        'slug': 'mens-clothing',
        'description': 'Clothing and apparel for men.',
        'is_active': true,
        'productCount': 20,
      },
    ],
    'productCount': 20,
  };

  group('Subcategories Model Tests', () {
    test('parses nested subcategories from backend payload correctly', () {
      final category = ShopCategory.fromJson(sampleBackendPayload);

      expect(category.id, '14');
      expect(category.name, 'Clothing');
      expect(category.hasChildren, true);
      expect(category.children.length, 2);

      final mensClothing = category.children[1];
      expect(mensClothing.id, '6');
      expect(mensClothing.name, "Men's Clothing");
      expect(mensClothing.parentId, '14');
      expect(mensClothing.productCount, 20);
      expect(mensClothing.hasChildren, false);

      expect(category.matches('clothing'), true);
      expect(mensClothing.matches('mens-clothing'), true);
      expect(mensClothing.matches("Men's Clothing"), true);
    });
  });

  group('CategoryChipBar Subcategories Tests', () {
    testWidgets('expands subcategories row when category is tapped',
        (tester) async {
      final category = ShopCategory.fromJson(sampleBackendPayload);
      String? selectedCategory;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChipBar(
              categories: [category],
              selected: selectedCategory,
              onSelect: (cat) => selectedCategory = cat,
            ),
          ),
        ),
      );

      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text("Men's Clothing (20)"), findsNothing);

      // Tap on Clothing to select and expand
      await tester.tap(find.text('Clothing'));
      await tester.pumpAndSettle();

      expect(selectedCategory, 'Clothing');
      expect(find.text('All in Clothing'), findsOneWidget);
      expect(find.text("Men's Clothing (20)"), findsOneWidget);

      // Tap on Men's Clothing subcategory
      await tester.tap(find.text("Men's Clothing (20)"));
      await tester.pumpAndSettle();

      expect(selectedCategory, "Men's Clothing");
    });

    testWidgets('auto-expands and highlights parent when subcategory is active',
        (tester) async {
      final category = ShopCategory.fromJson(sampleBackendPayload);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChipBar(
              categories: [category],
              selected: "Men's Clothing",
              onSelect: (_) {},
            ),
          ),
        ),
      );

      // Subcategories row should be auto-expanded because child is selected
      expect(find.text('All in Clothing'), findsOneWidget);
      expect(find.text("Men's Clothing (20)"), findsOneWidget);
    });
  });

  group('CategoryTreeWidget Subcategories Tests', () {
    testWidgets('auto-expands node if child slug is in selectedSlugs',
        (tester) async {
      final category = ShopCategory.fromJson(sampleBackendPayload);
      String? toggledSlug;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTreeWidget(
              categories: [category],
              selectedSlugs: const ['mens-clothing'],
              onToggle: (slug) => toggledSlug = slug,
              isDark: false,
            ),
          ),
        ),
      );

      // Men's clothing should be visible immediately because parent auto-expanded
      expect(find.text("Men's Clothing"), findsOneWidget);

      await tester.tap(find.text("Men's Clothing"));
      expect(toggledSlug, 'mens-clothing');
    });
  });

  group('Product and QueryParams SubcategoryId Tests', () {
    test('Product parses subcategoryId and subcategoryObj correctly', () {
      final product = Product.fromJson({
        'id': '101',
        'name': "Men's Casual Shirt",
        'slug': 'mens-casual-shirt',
        'price': 25000,
        'category_id': 14,
        'subcategory_id': 6,
        'subcategory': {
          'id': 6,
          'name': "Men's Clothing",
          'slug': 'mens-clothing',
        },
      });

      expect(product.id, '101');
      expect(product.categoryId, 14);
      expect(product.subcategoryId, 6);
      expect(product.subcategoryObj?.name, "Men's Clothing");
    });

    test('ListQueryParams serializes subcategoryId into query map', () {
      const params = ListQueryParams(
        categoryId: 14,
        subcategoryId: 6,
      );

      final map = params.toMap();
      expect(map['categoryId'], 14);
      expect(map['subcategoryId'], 6);

      final fromMap = ListQueryParams.fromJson(map);
      expect(fromMap.categoryId, 14);
      expect(fromMap.subcategoryId, 6);
    });

    test('ProductVariantMatching finds matching variant by attribute', () {
      final variants = [
        const ProductVariant(
          id: 1,
          productId: 101,
          name: 'Blue / L',
          sku: 'SHIRT-BLU-L',
          price: 26000,
          attributes: {'color': 'Blue', 'size': 'L'},
        ),
        const ProductVariant(
          id: 2,
          productId: 101,
          name: 'Red / M',
          sku: 'SHIRT-RED-M',
          price: 25000,
          attributes: {'color': 'Red', 'size': 'M'},
        ),
      ];

      final match = variants.findMatching(color: 'Blue', size: 'L');
      expect(match?.id, 1);
      expect(match?.sku, 'SHIRT-BLU-L');

      final colorMatch = variants.findMatching(color: 'Red');
      expect(colorMatch?.id, 2);
    });

    test('Product parses full ERP staging payload correctly', () {
      final payload = {
        "id": 5, "category_id": 14, "subcategory_id": 6,
        "name": "Demo Product 1", "slug": "demo-product-1",
        "brand_id": 1, "is_active": true,
        "base_cost_price": "10100.00", "base_selling_price": "12600.00",
        "merchant_id": 6,
        "category": {"id": 14, "name": "Clothing", "slug": "clothing"},
        "subcategory": {"id": 6, "category_id": 14, "name": "Men's Clothing", "slug": "mens-clothing"},
        "variants": [
          {"id": 5, "product_id": 5, "merchant_id": 6, "name": "Demo 1 Black", "sku": "D1-B", "price": "12600.00", "attributes": {"color": "Black"}},
          {"id": 6, "product_id": 5, "merchant_id": 6, "name": "Demo 1 Blue", "sku": "D1-L", "price": "13100.00", "attributes": {"color": "Blue"}}
        ],
        "images": [{"id": 8, "url": "https://aba-erp.s3/media/demo-1.jpg", "original_name": "demo.jpg"}],
      };

      final product = Product.fromJson(payload);
      expect(product.id, '5');
      expect(product.name, 'Demo Product 1');
      expect(product.price, 12600.00);
      expect(product.baseCostPrice, 10100.00);
      expect(product.categoryId, 14);
      expect(product.subcategoryId, 6);
      expect(product.merchantId, 6);
      expect(product.category, 'Clothing');
      expect(product.subcategoryObj?.name, "Men's Clothing");
      expect(product.variants.length, 2);
      expect(product.variants[0].merchantId, 6);
      expect(product.colors, containsAll(['Black', 'Blue']));
      expect(product.imageUrl, 'https://aba-erp.s3/media/demo-1.jpg');
    });
  });
}
