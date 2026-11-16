import 'package:app/features/cart/application/cart_notifier.dart';
import 'package:app/features/cart/application/cart_providers.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:app/features/shop/presentation/widgets/product_card.dart';
import 'package:app/features/wishlist/domain/wishlist_item.dart';
import 'package:app/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const outOfStockProduct = Product(
    id: '10',
    name: 'Sold Out Shoes',
    slug: 'sold-out-shoes',
    price: 15000,
    category: 'Shoes',
    brand: 'ABA',
    rating: 4.5,
    reviewCount: 4,
    stock: 0,
    images: [],
  );

  group('Out of stock Add-to-Cart disabled state', () {
    testWidgets('ProductCard grid and list disable add to cart when stock == 0', (tester) async {
      final cartNotifier = _FakeCartNotifier();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [cartProvider.overrideWith(() => cartNotifier)],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 300,
                      child: ProductCard(product: outOfStockProduct, listMode: false),
                    ),
                    ProductCard(product: outOfStockProduct, listMode: true),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Out of stock'), findsOneWidget);
      await tester.tap(find.byTooltip('Out of stock'));
      await tester.tap(find.text('Out of stock'));
      await tester.pump();

      expect(cartNotifier.addCalled, isFalse);
    });

    testWidgets('WishlistItemCard disables add to cart button when stock == 0', (tester) async {
      final cartNotifier = _FakeCartNotifier();
      final item = WishlistItem(
        id: 1,
        customerId: 10,
        wishlistableType: 'product',
        wishlistableId: 10,
        createdAt: DateTime(2026),
        product: outOfStockProduct,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [cartProvider.overrideWith(() => cartNotifier)],
          child: MaterialApp(
            home: Scaffold(body: WishlistItemCard(item: item)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final btn = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('Out of stock'),
          matching: find.byType(IconButton),
        ),
      );
      expect(btn.onPressed, isNull);
    });
  });
}

class _FakeCartNotifier extends CartNotifier {
  bool addCalled = false;

  @override
  Future<Cart> build() async => const Cart();

  @override
  Future<bool> addToCart(
    Product product, {
    int quantity = 1,
    String? color,
    String? size,
    int? variantId,
  }) async {
    addCalled = true;
    return true;
  }
}
