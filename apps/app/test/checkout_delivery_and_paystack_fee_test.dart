import 'package:app/features/checkout/data/checkout_mock_repository.dart';
import 'package:app/features/checkout/domain/checkout_entities.dart';
import 'package:app/features/checkout/presentation/widgets/step_payment_method.dart';
import 'package:app/features/wallet/application/wallet_providers.dart';
import 'package:app/features/wallet/domain/wallet_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Delivery Fee & Paystack Charges Indicator', () {
    test('delivery methods list 1500 Standard and 3000 Express with 1500 temp flat fee', () async {
      final methods = await CheckoutMockRepository().getDeliveryMethods();
      final standard = methods.firstWhere((m) => m.name == 'Standard Delivery');
      final express = methods.firstWhere((m) => m.name == 'Express Delivery');

      expect(standard.cost, 1500.0);
      expect(express.cost, 3000.0);
      expect(CheckoutDeliveryPricing.effectiveFee(standard), 1500.0);
      expect(CheckoutDeliveryPricing.effectiveFee(express), 1500.0);
    });

    testWidgets('StepPaymentMethod displays Paystack gateway charges indicator', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            walletInfoProvider.overrideWith(
              (_) async => const WalletInfo(balance: 20000, currency: 'NGN'),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: StepPaymentMethod(
                  selectedType: CheckoutPaymentType.paystack,
                  onSelectType: (_) {},
                  onBack: () {},
                  onContinue: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Debit card, Bank Transfer, USSD • Paystack charges apply'),
        findsOneWidget,
      );
      expect(
        find.text('Paystack gateway processing charges apply to the payable amount.'),
        findsOneWidget,
      );
    });
  });
}
