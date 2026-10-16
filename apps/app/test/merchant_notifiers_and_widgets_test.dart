import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/merchant/application/merchant_dashboard_notifier.dart';
import 'package:app/features/merchant/application/merchant_orders_notifier.dart';
import 'package:app/features/merchant/application/merchant_products_notifier.dart';
import 'package:app/features/merchant/data/merchant_mock_repository.dart';
import 'package:app/features/merchant/domain/merchant_order_entities.dart';
import 'package:app/features/merchant/presentation/merchant_dashboard_screen.dart';
import 'package:app/features/merchant/presentation/merchant_orders_screen.dart';
import 'package:app/features/merchant/presentation/merchant_products_screen.dart';

void main() {
  group('Merchant Notifiers Tests', () {
    late MerchantMockRepository repo;

    setUp(() {
      repo = MerchantMockRepository();
    });

    test('MerchantDashboardNotifier loads metrics successfully', () async {
      final notifier = MerchantDashboardNotifier(
        repository: repo,
        merchantId: 'mer-1',
      );

      // Await initial load
      await Future.delayed(const Duration(milliseconds: 350));
      expect(notifier.state.metrics, isNotNull);
      expect(notifier.state.isLoading, isFalse);
    });

    test('MerchantProductsNotifier filters products', () async {
      final notifier = MerchantProductsNotifier(
        repository: repo,
        merchantId: 'mer-1',
      );

      await Future.delayed(const Duration(milliseconds: 300));
      expect(notifier.state.products.isNotEmpty, isTrue);

      notifier.setSearchQuery('Leather');
      await Future.delayed(const Duration(milliseconds: 300));
      expect(notifier.state.products.every((p) => p.name.contains('Leather')), isTrue);
    });

    test('MerchantOrdersNotifier updates order status', () async {
      final notifier = MerchantOrdersNotifier(
        repository: repo,
        merchantId: 'mer-1',
      );

      await Future.delayed(const Duration(milliseconds: 300));
      final pending = notifier.state.orders.firstWhere((o) => o.status == MerchantOrderStatus.pending);

      final success = await notifier.updateOrderStatus(
        pending.id,
        MerchantOrderStatus.processing,
      );
      expect(success, isTrue);

      final updated = notifier.state.orders.firstWhere((o) => o.id == pending.id);
      expect(updated.status, equals(MerchantOrderStatus.processing));
    });
  });

  group('Merchant Screens Widget Tests', () {
    testWidgets('MerchantDashboardScreen renders KPIs and Quick Actions', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MerchantDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("Today's Sales"), findsOneWidget);
      expect(find.text('Low Stock Alert'), findsOneWidget);
      expect(find.text('POS Register'), findsOneWidget);
      expect(find.text('Add Product'), findsOneWidget);
      expect(find.text('Catalog'), findsOneWidget);
    });

    testWidgets('MerchantDashboardScreen opens MerchantMenuSheet and renders options', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MerchantDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final menuBtn = find.byTooltip('Menu & Settings');
      expect(menuBtn, findsOneWidget);
      await tester.tap(menuBtn);
      await tester.pumpAndSettle();

      expect(find.text('Referral Network'), findsOneWidget);
      expect(find.text('Earnings & Commissions'), findsOneWidget);
      expect(find.text('Business Wallet'), findsOneWidget);
      expect(find.text('Account & Store Settings'), findsOneWidget);

      await tester.drag(find.byType(ListView).last, const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Delete Account'), findsOneWidget);
    });

    testWidgets('MerchantProductsScreen renders products catalog and search', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MerchantProductsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Shop & Products'), findsOneWidget);
      expect(find.text('All'), findsWidgets);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('MerchantOrdersScreen renders order tabs and cards', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MerchantOrdersScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Order Management'), findsOneWidget);
      expect(find.text('Pending'), findsWidgets);
      expect(find.text('Processing'), findsWidgets);
      expect(find.text('Completed'), findsWidgets);
    });
  });
}
