import 'package:app/features/customer/application/referrals_network_providers.dart';
import 'package:app/features/customer/presentation/marketer_profile_screen.dart';
import 'package:app/features/customer/presentation/widgets/network_member_tile.dart';
import 'package:app/features/customer/presentation/widgets/network_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkTreeWidget Tests', () {
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

    testWidgets('renders Downline Network by default with tree view and depth chips', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralDownlineProvider(1).overrideWith((ref) => Future.value(testDownline)),
            referralUplineProvider(1).overrideWith((ref) => Future.value(testUpline)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: NetworkTreeWidget(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(NetworkTreeWidget), findsOneWidget);
      expect(find.text('Downline Network'), findsOneWidget);
      expect(find.text('Upline Mentors'), findsOneWidget);
      expect(find.text('Level 1'), findsWidgets);
      expect(find.text('Level 2'), findsOneWidget);
      expect(find.text('Level 3'), findsOneWidget);

      // In tree view, tree node is rendered with root and member
      expect(find.byType(TreeNodeWidget), findsWidgets);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('toggling list view displays member tiles and switching to Upline displays mentor', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralDownlineProvider(1).overrideWith((ref) => Future.value(testDownline)),
            referralUplineProvider(1).overrideWith((ref) => Future.value(testUpline)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: NetworkTreeWidget(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap view mode toggle button to switch to List View
      await tester.tap(find.byTooltip('Switch to List View'));
      await tester.pumpAndSettle();

      // List view displays member tile
      expect(find.byType(NetworkMemberTile), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('@john.doe'), findsOneWidget);

      // Tap 'Upline Mentors' tab
      await tester.tap(find.text('Upline Mentors'));
      await tester.pumpAndSettle();

      expect(find.byType(NetworkMemberTile), findsOneWidget);
      expect(find.text('Chioma Mentor'), findsOneWidget);
      expect(find.text('@mentor.chioma'), findsOneWidget);
    });

    testWidgets('renders MarketerProfileScreen with NetworkTreeWidget in Network Visualisation', (tester) async {
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
      expect(find.text('Network Visualisation'), findsOneWidget);
      expect(find.byType(NetworkTreeWidget), findsOneWidget);
      expect(find.text('Downline Network'), findsOneWidget);
      expect(find.text('Upline Mentors'), findsOneWidget);
    });
  });
}

