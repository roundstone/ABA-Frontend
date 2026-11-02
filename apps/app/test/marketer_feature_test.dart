import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/application/auth_notifier.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/marketer/application/marketer_providers.dart';
import 'package:app/features/marketer/presentation/marketer_dashboard_screen.dart';
import 'package:app/features/marketer/presentation/marketer_add_customer_screen.dart';
import 'package:app/features/marketer/presentation/marketer_merchant_profile_screen.dart';
import 'package:app/features/merchants/application/merchant_providers.dart';
import 'package:app/features/merchants/domain/merchant_entities.dart';
import 'package:app/features/wallet/application/wallet_providers.dart';

void main() {
  final testMarketer = AuthUser(
    id: 'MKT-701',
    name: 'Chisom Marketer',
    email: 'm-chisom@gmail.com',
    phone: '+2348011223344',
    role: UserRole.marketer,
    token: 'test-token',
    referralCode: 'REF-CHISOM701',
    merchantId: 'mer-1',
    businessName: 'Enyimba Leather Works',
    walletBalance: 84500.0,
    createdAt: DateTime.now(),
  );

  final testStats = MarketerStats.mock();

  final testMerchant = Merchant(
    id: 'mer-1',
    merchantNo: 'MERCH-001',
    name: 'Enyimba Leather Works',
    legalName: 'Enyimba Leather Crafts Ltd',
    description: 'Premier manufacturer of genuine handcrafted leather shoes in Aba.',
    logoUrl: '',
    bannerImage: '',
    state: 'Abia',
    city: 'Aba',
    address: '14 Faulks Road, Aba',
    ownerName: 'Emeka Nwosu',
    phone: '+2348031234567',
    email: 'contact@enyimbaleather.com',
    isVerified: true,
    productCount: 24,
    rating: 4.8,
    reviewCount: 38,
    onboardedAt: DateTime(2025, 2, 10),
  );

  const testWallet = WalletInfo(
    balance: 84500.0,
    currency: 'NGN',
  );

  group('Marketer Feature Tests', () {
    testWidgets('MarketerDashboardScreen renders header, wallet, actions and stats', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(testMarketer),
            authStateProvider.overrideWith(
              (ref) => _StaticAuthNotifier(
                AuthState(user: testMarketer),
              ),
            ),
            walletInfoProvider.overrideWith((ref) => Future.value(testWallet)),
            walletTransactionsProvider.overrideWith((ref) => Future.value([])),
            marketerStatsProvider.overrideWith((ref) => Future.value(testStats)),
            associatedMerchantProvider.overrideWith((ref) => Future.value(testMerchant)),
          ],
          child: const MaterialApp(home: MarketerDashboardScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Chisom Marketer'), findsOneWidget);
      expect(find.text('Code: REF-CHISOM701'), findsOneWidget);
      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('Add Customer(s)'), findsOneWidget);
      expect(find.text('My Referrals'), findsOneWidget);
      expect(find.text('My Merchant'), findsOneWidget);
      expect(find.text('Performance Overview'), findsOneWidget);
      expect(find.text('Customers Added'), findsOneWidget);
      expect(find.text('Total Commission'), findsOneWidget);
    });

    testWidgets('MarketerAddCustomerScreen renders tabs and referral code banner', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(testMarketer),
          ],
          child: const MaterialApp(home: MarketerAddCustomerScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add Customers'), findsOneWidget);
      expect(find.textContaining('REF-CHISOM701'), findsOneWidget);
      expect(find.text('Single Customer'), findsOneWidget);
      expect(find.text('Multiple Customers'), findsOneWidget);
      expect(find.text('Register Customer'), findsOneWidget);

      // Switch to Multiple Customers tab
      await tester.tap(find.text('Multiple Customers'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Customers to Onboard'), findsOneWidget);
      expect(find.text('Add Another'), findsOneWidget);

      // Scroll down to trigger sticky header
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Sticky header is displayed with 'Add Another' action
      expect(find.text('Add Another'), findsWidgets);
      await tester.tap(find.text('Add Another').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Customers to Onboard (3)'), findsWidgets);
    });

    testWidgets('MarketerMerchantProfileScreen renders partner merchant details', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(testMarketer),
            associatedMerchantProvider.overrideWith((ref) => Future.value(testMerchant)),
            merchantProductsProvider('mer-1').overrideWith(
              (ref) => Future.value([]),
            ),
          ],
          child: const MaterialApp(home: MarketerMerchantProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Associated Merchant'), findsOneWidget);
      expect(find.text('Enyimba Leather Works'), findsWidgets);
      expect(find.text('OFFICIAL MARKETER AFFILIATION'), findsOneWidget);
      expect(find.text('Share Store'), findsOneWidget);
    });

    test('OnboardCustomerInput serializes with marketer referral code', () {
      const input = OnboardCustomerInput(
        fullName: 'Emeka John',
        email: 'emeka@test.com',
        phone: '08099887766',
        password: 'Password@123',
        referralCode: 'REF-CHISOM701',
      );

      final json = input.toJson();
      expect(json['first_name'], 'Emeka');
      expect(json['last_name'], 'John');
      expect(json['email'], 'emeka@test.com');
      expect(json['referralCode'], 'REF-CHISOM701');
    });
  });
}

class _StaticAuthNotifier extends StateNotifier<AuthState>
    implements AuthNotifier {
  _StaticAuthNotifier(super.state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
