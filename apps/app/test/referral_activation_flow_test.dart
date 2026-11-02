import 'package:app/features/customer/application/referral_activation_provider.dart';
import 'package:app/features/customer/domain/referral_activation_model.dart';
import 'package:app/features/customer/presentation/widgets/referral_activation_card.dart';
import 'package:app/features/customer/presentation/widgets/referral_active_code_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReferralActivationModel Tests', () {
    test('initial model has no code and hasCode is false', () {
      const model = ReferralActivationState(
        referralCode: null,
        status: ReferralActivationStatus.inactive,
        feeAmountNaira: 5000,
        isKycCompleted: false,
        isFeePaid: false,
      );

      expect(model.hasCode, isFalse);
      expect(model.referralCode, isNull);
      expect(model.id, isNull);
      expect(model.isActive, isFalse);
    });

    test('model with generated code hasCode is true', () {
      const model = ReferralActivationState(
        id: 224,
        referralCode: 'CUSTOMER-4-C701F16C',
        isActive: true,
        status: ReferralActivationStatus.active,
        feeAmountNaira: 5000,
        isKycCompleted: true,
        isFeePaid: true,
      );

      expect(model.hasCode, isTrue);
      expect(model.referralCode, equals('CUSTOMER-4-C701F16C'));
      expect(model.id, equals(224));
      expect(model.isActive, isTrue);
    });
  });

  group('ReferralActivationCard Widget Tests', () {
    testWidgets('renders generate referral code CTA when user has no referral code', (tester) async {
      final notifier = _MockReferralNotifier(
        const ReferralActivationState(
          referralCode: null,
          id: null,
          isActive: false,
          status: ReferralActivationStatus.inactive,
          feeAmountNaira: 5000,
          isKycCompleted: false,
          isFeePaid: false,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralActivationProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ReferralActivationCard(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('COMMISSION INACTIVE'), findsOneWidget);
      expect(find.text('Generate Referral Code'), findsOneWidget);
      expect(find.byType(ReferralActiveCodeView), findsNothing);
    });

    testWidgets('renders active code banner and code view when user already has code', (tester) async {
      final notifier = _MockReferralNotifier(
        const ReferralActivationState(
          referralCode: 'CUSTOMER-4-C701F16C',
          id: 224,
          isActive: true,
          status: ReferralActivationStatus.active,
          feeAmountNaira: 5000,
          isKycCompleted: true,
          isFeePaid: true,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralActivationProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ReferralActivationCard(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('CUSTOMER-4-C701F16C'), findsOneWidget);
      expect(find.text('Commission Earning Active'), findsOneWidget);
      expect(find.byType(ReferralActiveCodeView), findsOneWidget);
    });

    testWidgets('tapping Generate Referral Code triggers generateReferralCode', (tester) async {
      final notifier = _MockReferralNotifier(
        const ReferralActivationState(
          referralCode: null,
          id: null,
          isActive: false,
          status: ReferralActivationStatus.inactive,
          feeAmountNaira: 5000,
          isKycCompleted: false,
          isFeePaid: false,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralActivationProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ReferralActivationCard(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final generateButton = find.text('Generate Referral Code');
      expect(generateButton, findsOneWidget);

      await tester.tap(generateButton);
      await tester.pumpAndSettle();

      expect(notifier.generateCalled, isTrue);
      expect(find.text('CUSTOMER-4-C701F16C'), findsOneWidget);
      expect(find.byType(ReferralActiveCodeView), findsOneWidget);
    });
  });
}

class _MockReferralNotifier extends StateNotifier<ReferralActivationState>
    implements ReferralActivationNotifier {
  _MockReferralNotifier(super.initial);

  bool generateCalled = false;

  @override
  Future<void> fetchMyReferralCode() async {}

  @override
  Future<String?> generateReferralCode() async {
    generateCalled = true;
    state = state.copyWith(
      id: 224,
      referralCode: 'CUSTOMER-4-C701F16C',
      isActive: true,
      status: ReferralActivationStatus.active,
      isKycCompleted: true,
      isFeePaid: true,
    );
    return 'CUSTOMER-4-C701F16C';
  }

  @override
  Future<bool> payActivationFee() async => true;

  @override
  Future<void> submitKyc({
    required String ninNumber,
    required String idType,
    required String idDocumentName,
    required String proofOfAddressName,
  }) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
