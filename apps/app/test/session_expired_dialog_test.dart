import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/auth/presentation/widgets/session_expired_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SessionExpiredDialog Widget Tests', () {
    testWidgets('renders dialog for customer role with correct text and action',
        (tester) async {
      bool confirmTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showSessionExpiredDialog(
                      context: context,
                      role: UserRole.customer,
                      onConfirmLogin: () async {
                        confirmTriggered = true;
                      },
                    );
                  },
                  child: const Text('Trigger Dialog'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Trigger Dialog'));
      await tester.pumpAndSettle();

      // Verify UI elements
      expect(find.text('Session Expired'), findsOneWidget);
      expect(find.text('Customer Account'), findsOneWidget);
      expect(
        find.textContaining('Please log in again to continue shopping'),
        findsOneWidget,
      );
      expect(find.text('Log In'), findsOneWidget);

      // Tap action button
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(confirmTriggered, isTrue);
      // Dialog should be dismissed
      expect(find.text('Session Expired'), findsNothing);
    });

    testWidgets('renders dialog for merchant role with merchant portal text',
        (tester) async {
      bool confirmTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showSessionExpiredDialog(
                      context: context,
                      role: UserRole.merchant,
                      onConfirmLogin: () async {
                        confirmTriggered = true;
                      },
                    );
                  },
                  child: const Text('Trigger Dialog'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Trigger Dialog'));
      await tester.pumpAndSettle();

      // Verify UI elements
      expect(find.text('Session Expired'), findsOneWidget);
      expect(find.text('Merchant Account'), findsOneWidget);
      expect(
        find.textContaining('access your merchant portal, manage orders'),
        findsOneWidget,
      );
      expect(find.text('Log In as Merchant'), findsOneWidget);

      // Tap action button
      await tester.tap(find.text('Log In as Merchant'));
      await tester.pumpAndSettle();

      expect(confirmTriggered, isTrue);
      expect(find.text('Session Expired'), findsNothing);
    });
  });
}
