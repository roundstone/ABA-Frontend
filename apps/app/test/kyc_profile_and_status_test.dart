import 'package:app/features/auth/application/auth_notifier.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/customer/application/referral_activation_provider.dart';
import 'package:app/features/customer/domain/kyc_models.dart';
import 'package:app/features/customer/domain/referral_activation_model.dart';
import 'package:app/features/customer/presentation/kyc_profile_screen.dart';
import 'package:app/features/customer/presentation/widgets/referral_activation_card.dart';
import 'package:app/features/wallet/application/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sampleApiPayload = {
    'success': true,
    'statusCode': 200,
    'data': {
      'id': 608,
      'user_id': 10,
      'date_of_birth': '2007-01-27',
      'nationality': 'Nigerian',
      'residential_address': '14 Admiralty Way',
      'city': 'Lekki',
      'state': 'Lagos',
      'lga': 'Eti Osa',
      'status': 2,
      'rejection_reason': null,
      'submitted_at': '2026-11-05T01:52:58.606Z',
      'activationPayment': {
        'id': 1821,
        'payment_type': 'kyc_activation',
        'reference': 'KYC-26e52107d40849d6b2ed671cfe76b6fc',
        'amount': '5000.00',
        'currency': 'NGN',
        'status': 'successful',
        'payment_method': 'card',
        'paid_at': '2026-11-05T01:57:12.000Z',
      },
      'documents': [
        {
          'id': 105,
          'kyc_profile_id': 608,
          'document_type': 4,
          'media_id': 172,
          'media': {
            'id': 172,
            'original_name': 'utility_bill.png',
            'mime_type': 'image/png',
            'url': 'https://example.com/utility_bill.png',
          },
        },
      ],
    },
  };

  group('KycProfile JSON Parsing & Status Helpers', () {
    test('parses status, activationPayment, and documents accurately', () {
      final profile = KycProfile.fromJson(sampleApiPayload);
      expect(profile.id, 608);
      expect(profile.status, 2);
      expect(profile.isUnderReview, isTrue);
      expect(profile.isEditable, isFalse);
      expect(profile.statusLabel, 'Under review');
      expect(profile.isActivationPaid, isTrue);
      expect(profile.activationPayment?.reference, 'KYC-26e52107d40849d6b2ed671cfe76b6fc');
      expect(profile.documents.length, 1);
      expect(kycDocumentTypeLabel(profile.documents.first.documentType), 'Proof of address');
    });

    test('handles missing activationPayment and rejected status', () {
      final profile = KycProfile.fromJson({
        'data': {
          'id': 1,
          'user_id': 2,
          'status': 4,
          'rejection_reason': 'Blurry ID image',
          'documents': [],
        },
      });
      expect(profile.isRejected, isTrue);
      expect(profile.isEditable, isTrue);
      expect(profile.isActivationPaid, isFalse);
      expect(profile.rejectionReason, 'Blurry ID image');
    });
  });

  group('KycProfileScreen & ReferralActivationCard Widget Tests', () {
    testWidgets('ReferralActivationCard hides activation CTA when under review', (tester) async {
      final profile = KycProfile.fromJson(sampleApiPayload);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralActivationProvider.overrideWith(
              (_) => _FakeReferralNotifier(
                const ReferralActivationState(
                  referralCode: null,
                  status: ReferralActivationStatus.inactive,
                  feeAmountNaira: 5000,
                  isKycCompleted: false,
                  isFeePaid: false,
                ),
              ),
            ),
            optionalKycProfileProvider.overrideWith((_) async => profile),
            shoppingCreditsProvider.overrideWith(
              (_) async => const ShoppingCreditInfo(balance: 0.0, isActivated: false),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: SingleChildScrollView(child: ReferralActivationCard())),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Requirement: KYC review in progress'), findsOneWidget);
      expect(find.text('View KYC Status'), findsOneWidget);
      expect(find.text('Activate Earning (KYC & ₦5,000 Fee)'), findsNothing);
    });

    testWidgets('KycProfileScreen displays status, paid activationPayment without Pay CTA, and documents', (tester) async {
      final profile = KycProfile.fromJson(sampleApiPayload);
      final authState = AuthState(
        user: AuthUser(
          id: '10',
          name: 'Bro David',
          email: 'c-davidenabs@gmail.com',
          phone: '+2348140000003',
          role: UserRole.customer,
          token: 'token',
          createdAt: DateTime(2026),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((_) => _FakeAuthNotifier(authState)),
            referralActivationProvider.overrideWith(
              (_) => _FakeReferralNotifier(
                const ReferralActivationState(
                  referralCode: null,
                  status: ReferralActivationStatus.inactive,
                  feeAmountNaira: 5000,
                  isKycCompleted: true,
                  isFeePaid: true,
                ),
              ),
            ),
            optionalKycProfileProvider.overrideWith((_) async => profile),
            shoppingCreditsProvider.overrideWith(
              (_) async => const ShoppingCreditInfo(balance: 5000.0, isActivated: true),
            ),
          ],
          child: const MaterialApp(home: KycProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Under review'), findsOneWidget);
      expect(find.text('PAID'), findsOneWidget);
      expect(find.text('Pay ₦5,000 Activation Fee'), findsNothing);
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.text('Proof of address'), findsOneWidget);
      expect(find.text('utility_bill.png'), findsOneWidget);
    });
  });
}

class _FakeAuthNotifier extends StateNotifier<AuthState>
    implements AuthNotifier {
  _FakeAuthNotifier(super.state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReferralNotifier extends StateNotifier<ReferralActivationState>
    implements ReferralActivationNotifier {
  _FakeReferralNotifier(super.state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
