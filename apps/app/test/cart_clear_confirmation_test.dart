import 'package:app/features/cart/domain/entities/cart_entities.dart';
import 'package:app/features/cart/presentation/widgets/cart_order_summary.dart';
import 'package:app/features/shop/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sampleProduct = Product(
    id: '1',
    name: 'Aba Leather Bag',
    slug: 'aba-leather-bag',
    price: 15000,
    category: 'Bags',
    brand: 'Aba Brand',
    rating: 4.5,
    reviewCount: 5,
    stock: 10,
    images: [],
  );

  const sampleCart = Cart(
    items: [CartItem(product: sampleProduct, quantity: 2)],
  );

  testWidgets('Clear cart requires confirmation and cancels safely', (
    tester,
  ) async {
    var cleared = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartOrderSummary(
            cart: sampleCart,
            onCheckout: () {},
            onClear: () => cleared = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Clear cart'));
    await tester.pumpAndSettle();

    expect(find.text('Clear Cart?'), findsOneWidget);
    expect(
      find.text(
        'Remove all 2 items from your cart? This action cannot be undone.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Keep Items'));
    await tester.pumpAndSettle();

    expect(cleared, isFalse);

    await tester.tap(find.byTooltip('Clear cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear Cart'));
    await tester.pumpAndSettle();

    expect(cleared, isTrue);
  });
}
