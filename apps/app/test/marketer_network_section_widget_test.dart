import 'package:app/features/customer/application/referrals_network_providers.dart';
import 'package:app/features/customer/presentation/marketer_profile_screen.dart';
import 'package:app/features/customer/presentation/widgets/marketer_network_section.dart';
import 'package:app/features/customer/presentation/widgets/network_member_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarketerNetworkSection Widget Tests', () {
    final testDownline = [
      const ReferralNetworkMember(
        id: 12,
        referrerUserId: 8,
        referredUserId: 21,
        level: 1,
        userId: 21,
        username: 'john.doe',
        user: ReferralNetworkUser(
          id: 21,
          firstName: 'John',
          lastName: 'Doe',
          username: 'john.doe',
        ),
      ),
    ];

    final testUpline = [
      const ReferralNetworkMember(
        id: 11,
        referrerUserId: 5,
        referredUserId: 8,
        level: 1,
        userId: 5,
        username: 'mentor.chioma',
        user: ReferralNetworkUser(
          id: 5,
          firstName: 'Chioma',
          lastName: 'Mentor',
          username: 'mentor.chioma',
        ),
      ),
    ];

    testWidgets('renders Downline Network by default with member tiles and depth chips', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralDownlineProvider(1).overrideWith((ref) => Future.value(testDownline)),
            referralUplineProvider(1).overrideWith((ref) => Future.value(testUpline)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: MarketerNetworkSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Referral Network Explorer'), findsOneWidget);
      expect(find.text('Downline Network'), findsOneWidget);
      expect(find.text('Upline Mentors'), findsOneWidget);
      expect(find.text('Level 1'), findsWidgets);
      expect(find.text('Level 2'), findsOneWidget);
      expect(find.text('Level 3'), findsOneWidget);
      expect(find.byType(NetworkMemberTile), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('@john.doe'), findsOneWidget);
    });

    testWidgets('switching to Upline Mentors updates view and displays mentor tile', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralDownlineProvider(1).overrideWith((ref) => Future.value(testDownline)),
            referralUplineProvider(1).overrideWith((ref) => Future.value(testUpline)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: MarketerNetworkSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap 'Upline Mentors' tab
      await tester.tap(find.text('Upline Mentors'));
      await tester.pumpAndSettle();

      expect(find.byType(NetworkMemberTile), findsOneWidget);
      expect(find.text('Chioma Mentor'), findsOneWidget);
      expect(find.text('@mentor.chioma'), findsOneWidget);
    });

    testWidgets('renders MarketerProfileScreen including network explorer section', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralDownlineProvider(1).overrideWith((ref) => Future.value(testDownline)),
            referralUplineProvider(1).overrideWith((ref) => Future.value(testUpline)),
          ],
          child: const MaterialApp(
            home: MarketerProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Marketer Profile'), findsOneWidget);
      expect(find.byType(MarketerNetworkSection), findsOneWidget);
      expect(find.text('Referral Network Explorer'), findsOneWidget);
    });
  });
}

