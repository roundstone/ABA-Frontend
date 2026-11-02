import 'package:app/features/cart/application/cart_notifier.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:app/features/shop/presentation/widgets/home_cart_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCartNotifier extends CartNotifier {
  _FakeCartNotifier(this._cart);
  final Cart _cart;

  @override
  Future<Cart> build() async => _cart;
}

void main() {
  const testProduct = Product(
    id: 'p1',
    name: 'Test Shoes',
    slug: 'test-shoes',
    price: 15000,
    category: 'Footwear',
    brand: 'Aba Craft',
    rating: 4.8,
    reviewCount: 12,
    stock: 10,
    images: ['https://example.com/test.jpg'],
    description: 'Shoes',
    tags: ['shoes'],
  );

  testWidgets(
      'HomeCartFloatingButton is hidden when cart is empty',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cartProvider.overrideWith(
            () => _FakeCartNotifier(const Cart(items: [])),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            floatingActionButton: HomeCartFloatingButton(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('HomeCartFloatingButton shows badge count when cart has items',
      (tester) async {
    const cartWithItems = Cart(
      items: [
        CartItem(
          product: testProduct,
          quantity: 4,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cartProvider.overrideWith(
            () => _FakeCartNotifier(cartWithItems),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            floatingActionButton: HomeCartFloatingButton(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });
}
