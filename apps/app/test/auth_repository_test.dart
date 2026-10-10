import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/auth/data/auth_mock_repository.dart';
import 'package:app/features/auth/application/auth_notifier.dart';
import 'package:app/features/auth/presentation/splash_screen.dart';
import 'package:app/features/auth/presentation/role_selection_screen.dart';

void main() {
  group('AuthMockRepository Tests', () {
    late AuthMockRepository repository;

    setUp(() {
      repository = AuthMockRepository();
    });

    test('loginCustomer succeeds with demo customer', () async {
      final user = await repository.loginCustomer(
        identifier: 'jane.doe@example.com',
        password: 'password123',
      );

      expect(user.isCustomer, isTrue);
      expect(user.isMerchant, isFalse);
      expect(user.name, equals('Jane Doe'));
      expect(user.email, equals('jane.doe@example.com'));
      expect(user.role, equals(UserRole.customer));
    });

    test('loginCustomer rejects short password', () async {
      expect(
        () => repository.loginCustomer(
          identifier: 'jane.doe@example.com',
          password: '12',
        ),
        throwsException,
      );
    });

    test('registerCustomer creates new customer account', () async {
      final user = await repository.registerCustomer(
        const CustomerRegistrationParams(
          fullName: 'Chisom Obi',
          email: 'chisom@example.com',
          phone: '+2348011223344',
          password: 'securePass123',
          referralCode: 'REF-JANE100',
        ),
      );

      expect(user.name, equals('Chisom Obi'));
      expect(user.email, equals('chisom@example.com'));
      expect(user.role, equals(UserRole.customer));
      expect(user.referralCode, startsWith('REF-CHI'));
    });

    test('loginMerchant returns merchant user with businessName', () async {
      final user = await repository.loginMerchant(
        identifier: 'emeka@abaleather.com',
        password: 'password123',
      );

      expect(user.isMerchant, isTrue);
      expect(user.role, equals(UserRole.merchant));
      expect(user.businessName, equals('Enyimba Leather Works'));
      expect(user.merchantId, equals('mer-1'));
    });

    test('onboardMerchant creates merchant account with details', () async {
      final user = await repository.onboardMerchant(
        const MerchantOnboardingParams(
          businessName: 'Ariaria Weaving Hub',
          businessType: 'Textiles',
          ownerName: 'Uche Okafor',
          phone: '+2348055667788',
          email: 'uche@ariaria.ng',
          address: '40 Faulks Road',
          city: 'Aba',
          state: 'Abia',
          bankName: 'Access Bank',
          accountNumber: '0987654321',
        ),
      );

      expect(user.isMerchant, isTrue);
      expect(user.businessName, equals('Ariaria Weaving Hub'));
      expect(user.role, equals(UserRole.merchant));
    });

    test('logout clears current stored user', () async {
      await repository.loginCustomer(
        identifier: 'jane.doe@example.com',
        password: 'password123',
      );
      expect(await repository.getStoredUser(), isNotNull);

      await repository.logout();
      expect(await repository.getStoredUser(), isNull);
    });
  });

  group('AuthNotifier Tests', () {
    late AuthNotifier notifier;
    late AuthMockRepository repository;

    setUp(() {
      repository = AuthMockRepository();
      notifier = AuthNotifier(repository: repository);
    });

    test('loginCustomer sets customer state correctly', () async {
      final ok = await notifier.loginCustomer(
        identifier: 'jane.doe@example.com',
        password: 'password123',
      );

      expect(ok, isTrue);
      expect(notifier.state.isAuthenticated, isTrue);
      expect(notifier.state.isMerchant, isFalse);
      expect(notifier.state.role, equals(UserRole.customer));
    });

    test('loginMerchant sets merchant state correctly', () async {
      final ok = await notifier.loginMerchant(
        identifier: 'emeka@abaleather.com',
        password: 'password123',
      );

      expect(ok, isTrue);
      expect(notifier.state.isAuthenticated, isTrue);
      expect(notifier.state.isMerchant, isTrue);
      expect(notifier.state.role, equals(UserRole.merchant));
    });

    test('logout resets auth state to unauthenticated', () async {
      await notifier.loginCustomer(
        identifier: 'jane.doe@example.com',
        password: 'password123',
      );
      expect(notifier.state.isAuthenticated, isTrue);

      await notifier.logout();
      expect(notifier.state.isAuthenticated, isFalse);
      expect(notifier.state.user, isNull);
    });
  });

  group('Auth Presentation Widget Tests', () {
    testWidgets('SplashScreen renders MLM merchant marketplace highlights',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SplashScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('BUY NIGERIA'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('RoleSelectionScreen renders Customer and Merchant cards',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RoleSelectionScreen(),
          ),
        ),
      );

      expect(find.text('Welcome to Buy Nigeria'), findsOneWidget);
      expect(find.text('Shop, Save & Earn'), findsOneWidget);
      expect(find.text('Sell, Scale & POS'), findsOneWidget);
    });
  });
}
