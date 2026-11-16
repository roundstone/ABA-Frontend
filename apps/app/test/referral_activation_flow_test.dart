import 'package:app/features/customer/application/referral_activation_provider.dart';
import 'package:app/features/customer/data/kyc_service.dart';
import 'package:app/features/customer/domain/kyc_models.dart';
import 'package:app/features/customer/domain/referral_activation_model.dart';
import 'package:app/features/customer/presentation/widgets/referral_activation_card.dart';
import 'package:app/features/wallet/application/wallet_providers.dart';
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
    testWidgets('renders activation CTA when KYC is not approved and fee is unpaid', (tester) async {
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
            optionalKycProfileProvider.overrideWith((_) async => null),
            shoppingCreditsProvider.overrideWith(
              (_) async => const ShoppingCreditInfo(balance: 0.0, isActivated: false),
            ),
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
      expect(find.text('Activate Earning (KYC & ₦5,000 Fee)'), findsOneWidget);
      expect(find.text('View KYC Profile'), findsOneWidget);
    });

    testWidgets('renders Commission Earning Active when KYC is approved and fee is paid', (tester) async {
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
            optionalKycProfileProvider.overrideWith(
              (_) async => const KycProfile(id: 1, userId: 10, status: 3),
            ),
            shoppingCreditsProvider.overrideWith(
              (_) async => const ShoppingCreditInfo(balance: 5000.0, isActivated: true),
            ),
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

      expect(find.text('Commission Earning Active'), findsOneWidget);
      expect(find.text('VERIFIED'), findsOneWidget);
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
    String? dateOfBirth,
    String? nationality,
    String? residentialAddress,
    String? city,
    String? stateName,
    String? lga,
    List<KycUploadDocument>? uploadDocuments,
  }) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
