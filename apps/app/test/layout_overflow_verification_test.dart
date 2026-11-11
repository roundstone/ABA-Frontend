import 'package:app/features/cart/domain/entities/cart_entities.dart';
import 'package:app/features/checkout/domain/checkout_entities.dart';
import 'package:app/features/checkout/presentation/widgets/checkout_referral_section.dart';
import 'package:app/features/checkout/presentation/widgets/checkout_summary_card.dart';
import 'package:app/features/customer/presentation/widgets/referral_activation_payment_views.dart';
import 'package:app/features/shop/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Layout Overflow Protection Tests (Mobile 360px & 375px)', () {
    testWidgets('ReferralPaymentStepView renders without overflow on 360px and 375px widths', (tester) async {
      for (final width in [360.0, 375.0]) {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: ReferralPaymentStepView(
                    isProcessing: false,
                    onPay: () {},
                    onBack: () {},
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Step 2 of 2: Activation Fee'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('CheckoutReferralSection renders without overflow on 360px screen with applied referral', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const applied = ReferralCandidate(
        id: '638',
        customerId: 638,
        userId: 945,
        name: 'Very Long Customer Full Name With Extra Words',
        moniker: '@customer.with.very.long.moniker',
        code: 'CUSTOMER-638-033F5078',
        imageUrl: '',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: CheckoutReferralSection(
                appliedReferral: applied,
                searchQuery: '',
                searchResults: const [],
                isSearching: false,
                onQueryChanged: (_) {},
                onApplyCandidate: (_) {},
                onRemove: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Referral applied'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('CheckoutSummaryCard renders cleanly without overflow on 360px screen', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const dummyProduct = Product(
        id: '1',
        name: 'Handcrafted Aba Leather Shoes Premium Edition',
        slug: 'handcrafted-aba-leather-shoes',
        price: 25000,
        category: 'Footwear',
        brand: 'Aba Brand',
        rating: 4.5,
        reviewCount: 10,
        stock: 5,
        images: [],
      );

      const cart = Cart(
        items: [CartItem(product: dummyProduct, quantity: 2)],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: CheckoutSummaryCard(cart: cart),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Grand Total'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
