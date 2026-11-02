import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/customer/presentation/more_menu_sheet.dart';
import 'package:app/features/merchant/presentation/widgets/merchant_menu_sheet.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/data/auth_mock_repository.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:hugeicons/hugeicons.dart';

void main() {
  group('Menu Sheets Navigation Tests', () {
    testWidgets('Customer more_menu_sheet shows all menu items', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => showMoreMenu(context),
                    child: const Text('Open Customer Menu'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap button to launch customer more menu
      await tester.tap(find.text('Open Customer Menu'));
      await tester.pumpAndSettle();

      // Verify all items are present
      expect(find.text('My Account'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Businesses'), findsOneWidget);
      expect(find.text('Reward Points'), findsOneWidget);
      expect(find.text('Referrals'), findsOneWidget);
      expect(find.text('My Orders'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('Marketer more_menu_sheet shows only the 5 allowed items', (
      tester,
    ) async {
      final container = ProviderContainer();
      container.read(authStateProvider.notifier).state = AuthState(
        user: AuthUser(
          id: 'mkt-1',
          name: 'David Marketer',
          email: 'david@example.com',
          phone: '+2348123456789',
          role: UserRole.marketer,
          referralCode: 'REF-DAVID-01',
          token: 'token-marketer',
          createdAt: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => showMoreMenu(context),
                    child: const Text('Open Marketer Menu'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Marketer Menu'));
      await tester.pumpAndSettle();

      // Only the 5 required items for marketers
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Referrals'), findsOneWidget);
      expect(find.text('Reward Points'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);

      // Customer-only and merchant items must not display for marketers
      expect(find.text('My Account'), findsNothing);
      expect(find.text('Businesses'), findsNothing);
      expect(find.text('Community'), findsNothing);
      expect(find.text('My Orders'), findsNothing);
      expect(find.text('Wishlist'), findsNothing);
      expect(find.text('About Us'), findsNothing);
      expect(find.text('Marketer Hub'), findsNothing);
      expect(find.text('Saved Address'), findsNothing);
      expect(find.text('Merchant Hub'), findsNothing);
    });

    testWidgets('Merchant menu sheet shows all merchant sections and items', (
      tester,
    ) async {
      final container = ProviderContainer();
      container.read(authStateProvider.notifier).state = AuthState(
        user: AuthUser(
          id: 'merch-1',
          name: 'Emeka Anya',
          email: 'emeka@abaleather.com',
          phone: '+2348011223344',
          role: UserRole.merchant,
          businessName: 'Enyimba Shoes',
          referralCode: 'ABA-EMEK-990',
          token: 'token-merchant',
          createdAt: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => showMerchantMenuSheet(context),
                    child: const Text('Open Merchant Menu'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap button to launch merchant menu sheet
      await tester.tap(find.text('Open Merchant Menu'));
      await tester.pumpAndSettle();

      // Verify merchant info and options
      expect(find.text('Enyimba Shoes'), findsOneWidget);
      expect(find.text('Referral Network'), findsOneWidget);
      expect(find.text('Earnings & Commissions'), findsOneWidget);
      expect(find.text('Business Wallet'), findsOneWidget);
      expect(find.text('Account & Store Settings'), findsOneWidget);
      expect(find.text('Notification Preferences'), findsOneWidget);
      expect(find.text('Customer Storefront'), findsOneWidget);
    });

    testWidgets('SafeNavigation canPopSafely and popOrGo behavior', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/detail'),
                  child: const Text('Go Detail'),
                ),
              ),
            ),
            '/detail': (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Detail Screen'),
                leading: IconButton(
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowLeft01,
                    // color: isDark ? Colors.white : AppColors.onBackground,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          },
        ),
      );
      await tester.pumpAndSettle();

      // At root, detail screen is not present
      expect(find.text('Go Detail'), findsOneWidget);
      expect(find.text('Detail Screen'), findsNothing);

      // Push detail screen
      await tester.tap(find.text('Go Detail'));
      await tester.pumpAndSettle();
      expect(find.text('Detail Screen'), findsOneWidget);

      // Pop detail screen back to root
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.text('Detail Screen'), findsNothing);
      expect(find.text('Go Detail'), findsOneWidget);
    });

    testWidgets('Tapping Logout in customer more menu resets auth state to unauthenticated', (tester) async {
      final mockRepo = AuthMockRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      container.read(authStateProvider.notifier).state = AuthState(
        user: AuthUser(
          id: 'cust-1',
          name: 'Ada Obi',
          email: 'ada@example.com',
          phone: '+2348000000001',
          role: UserRole.customer,
          token: 'test-token',
          createdAt: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            routes: {
              '/role-select': (_) => const Scaffold(body: Text('Role Select Screen')),
            },
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => showMoreMenu(context),
                    child: const Text('Open Menu'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      expect(container.read(authStateProvider).isAuthenticated, isTrue);

      await tester.scrollUntilVisible(
        find.text('Logout'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(container.read(authStateProvider).isAuthenticated, isFalse);
      expect(find.text('Role Select Screen'), findsOneWidget);
    });
  });
}
