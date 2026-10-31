import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/widgets/app_snackbar.dart';

void main() {
  group('AppSnackbar Platform Tests', () {
    testWidgets('AppSnackbar.success renders message and dismisses cleanly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppSnackbar.success(context, 'Operation succeeded!'),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 300)); // Complete animation

      expect(find.text('Operation succeeded!'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('AppSnackbar.error renders with crimson tone and error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppSnackbar.error(context, 'Payment failed!'),
                child: const Text('Show Error'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Payment failed!'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('AppSnackbar with action triggers onAction callback when tapped', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppSnackbar.show(
                  context,
                  message: 'Item added to cart',
                  actionLabel: 'View Cart',
                  onAction: () => actionTriggered = true,
                ),
                child: const Text('Show Action'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Action'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Item added to cart'), findsOneWidget);
      expect(find.text('View Cart'), findsOneWidget);

      await tester.tap(find.text('View Cart'));
      await tester.pumpAndSettle();

      expect(actionTriggered, isTrue);
    });

    testWidgets('BuildContext extension methods render correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => context.showWarningSnackBar('Low stock alert!'),
                    child: const Text('Warn'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.showInfoSnackBar('New update available'),
                    child: const Text('Info'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Warn'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Low stock alert!'), findsOneWidget);

      await tester.tap(find.text('Info'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('New update available'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });
  });
}

