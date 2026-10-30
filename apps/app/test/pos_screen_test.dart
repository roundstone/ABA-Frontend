import 'package:app/features/merchant/application/merchant_providers.dart';
import 'package:app/features/merchant/presentation/pos_screen.dart';
import 'package:app/features/merchant/presentation/widgets/pos_category_filter_bar.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const List<ShopCategory> testSubcategories = [
    ShopCategory(id: '3', name: 'Shoes', slug: 'shoes', parentId: '14'),
    ShopCategory(
      id: '2',
      name: 'Bags and Accessories',
      slug: 'bags-accessories',
      parentId: '14',
    ),
  ];

  const List<ShopCategory> testCategories = [
    ShopCategory(
      id: '14',
      name: 'Clothing',
      slug: 'clothing',
      children: testSubcategories,
    ),
    ShopCategory(
      id: '13',
      name: 'Electronics',
      slug: 'electronics',
      children: [
        ShopCategory(
          id: '1',
          name: 'Mobile Phones',
          slug: 'mobile-phones',
          parentId: '13',
        ),
      ],
    ),
  ];

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        merchantCategoriesProvider.overrideWith(
          (ref) => Future.value(testCategories),
        ),
        merchantSubcategoriesProvider.overrideWith(
          (ref, categoryId) => Future.value(testSubcategories),
        ),
      ],
      child: const MaterialApp(
        home: POSScreen(),
      ),
    );
  }

  testWidgets('POSScreen renders Register Counter and categories bar from API',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Register Counter 1'), findsOneWidget);
    expect(find.byType(PosCategoryFilterBar), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Clothing'), findsOneWidget);
    expect(find.text('Electronics'), findsOneWidget);
  });

  testWidgets(
      'Tapping Clothing reveals subcategories and allows subcategory filtering',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Subcategories shouldn't be visible before category is selected
    expect(find.text('All in Clothing'), findsNothing);
    expect(find.text('Shoes'), findsNothing);

    // Tap 'Clothing' category chip
    await tester.tap(find.text('Clothing'));
    await tester.pumpAndSettle();

    // Subcategories should now be visible
    expect(find.text('All in Clothing'), findsOneWidget);
    expect(find.text('Shoes'), findsOneWidget);
    expect(find.text('Bags and Accessories'), findsOneWidget);

    // Tap 'Shoes' subcategory chip
    await tester.tap(find.text('Shoes'));
    await tester.pumpAndSettle();

    // Tap 'All in Clothing' chip resets subcategory
    await tester.tap(find.text('All in Clothing'));
    await tester.pumpAndSettle();

    // Tap 'All' main category chip clears category and subcategories
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();

    expect(find.text('All in Clothing'), findsNothing);
  });
}

