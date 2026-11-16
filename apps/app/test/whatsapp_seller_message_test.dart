import 'package:app/core/widgets/app_widgets.dart';
import 'package:app/features/shop/application/shop_providers.dart';
import 'package:app/features/shop/data/shop_mock_repository.dart';
import 'package:app/features/shop/presentation/widgets/about_seller_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WhatsApp Seller Messaging', () {
    test('getWhatsAppLink formats local Nigerian number to 234', () {
      final url = getWhatsAppLink('0803 123 4567', 'Aba Leather');
      expect(
        url,
        'https://wa.me/2348031234567?text=Hello%20Aba%20Leather%2C%20I\'m%20interested%20in%20your%20products',
      );
    });

    test('getWhatsAppLink preserves 234 prefix from +234 number', () {
      final url = getWhatsAppLink('+234-805-987-6543', 'Ariaria Shoes');
      expect(
        url,
        startsWith('https://wa.me/2348059876543?text='),
      );
    });

    testWidgets('launchWhatsAppChat shows info snackbar when phone is empty', (
      tester,
    ) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await launchWhatsAppChat(
                    context,
                    phoneNumber: '',
                    sellerName: 'Test Store',
                  );
                },
                child: const Text('Tap'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
      expect(
        find.text('Seller WhatsApp contact is not available.'),
        findsOneWidget,
      );
    });

    testWidgets('AboutSellerTab triggers onMessageSeller when tapped', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shopRepositoryProvider.overrideWithValue(ShopMockRepository()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AboutSellerTab(
                  merchantName: 'Aba Leather Works',
                  productId: '1',
                  merchantId: '10',
                  onMessageSeller: () => tapped = true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Message seller'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
