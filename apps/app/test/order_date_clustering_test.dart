import 'package:app/features/account/application/orders_providers.dart';
import 'package:app/features/account/data/orders_api.dart';
import 'package:app/features/account/domain/customer_order.dart';
import 'package:app/features/account/domain/order_date_cluster.dart';
import 'package:app/features/account/presentation/orders_screen.dart';
import 'package:app/features/account/presentation/widgets/order_cluster_card.dart';
import 'package:app/features/account/presentation/widgets/order_cluster_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final novOrder1 = CustomerOrder(
    id: '101',
    orderNumber: 'ORD-NOV-001',
    date: DateTime(2026, 11, 1, 7, 53, 33),
    status: OrderStatus.delivered,
    total: 4067943,
    paymentMethod: 'card_or_bank',
    shippingAddress: ShippingAddress(
      fullName: 'Aba Customer',
      street: '123 Market St',
      city: 'Aba',
      state: 'Abia',
      zipCode: '450001',
      phone: '+234 801 111 2222',
    ),
    items: [
      OrderItem(
        id: 'item_1',
        productId: 'prod_1',
        productName: 'Leather Bag',
        price: 4067943,
        quantity: 1,
      ),
    ],
  );

  final novOrder2 = CustomerOrder(
    id: '102',
    orderNumber: 'ORD-NOV-002',
    date: DateTime(2026, 11, 1, 3, 20, 3),
    status: OrderStatus.pending,
    total: 21716,
    paymentMethod: 'wallet',
    shippingAddress: ShippingAddress(
      fullName: 'Aba Customer',
      street: '123 Market St',
      city: 'Aba',
      state: 'Abia',
      zipCode: '450001',
      phone: '+234 801 111 2222',
    ),
    items: [
      OrderItem(
        id: 'item_2',
        productId: 'prod_2',
        productName: 'SafeBox Interest Item',
        price: 21716,
        quantity: 1,
      ),
    ],
  );

  final octOrder1 = CustomerOrder(
    id: '103',
    orderNumber: 'ORD-OCT-001',
    date: DateTime(2026, 10, 31, 19, 43, 9),
    status: OrderStatus.processing,
    total: 50000,
    paymentMethod: 'card',
    shippingAddress: ShippingAddress(
      fullName: 'Aba Customer',
      street: '123 Market St',
      city: 'Aba',
      state: 'Abia',
      zipCode: '450001',
      phone: '+234 801 111 2222',
    ),
    items: [
      OrderItem(
        id: 'item_3',
        productId: 'prod_3',
        productName: 'Airtime Voucher',
        price: 50000,
        quantity: 1,
      ),
    ],
  );

  group('Order Date Clustering Domain Logic', () {
    test('formatOrderDateOrdinal produces formatted strings with correct suffix', () {
      expect(formatOrderDateOrdinal(DateTime(2026, 11, 1, 7, 53, 33)), equals('Nov 1st, 07:53:33'));
      expect(formatOrderDateOrdinal(DateTime(2026, 10, 2, 12, 0, 0)), equals('Oct 2nd, 12:00:00'));
      expect(formatOrderDateOrdinal(DateTime(2026, 10, 3, 12, 0, 0)), equals('Oct 3rd, 12:00:00'));
      expect(formatOrderDateOrdinal(DateTime(2026, 10, 4, 12, 0, 0)), equals('Oct 4th, 12:00:00'));
      expect(formatOrderDateOrdinal(DateTime(2026, 10, 11, 12, 0, 0)), equals('Oct 11th, 12:00:00'));
      expect(formatOrderDateOrdinal(DateTime(2026, 10, 21, 12, 0, 0)), equals('Oct 21st, 12:00:00'));
      expect(formatOrderDateOrdinal(DateTime(2026, 10, 31, 19, 43, 9)), equals('Oct 31st, 19:43:09'));
    });

    test('clusterOrdersByDate groups orders by month and orders newest first', () {
      final orders = [octOrder1, novOrder2, novOrder1];
      final clusters = clusterOrdersByDate(orders);

      expect(clusters.length, equals(2));
      // First cluster is November (newest)
      expect(clusters[0].monthLabel, equals('Nov'));
      expect(clusters[0].orders.length, equals(2));
      expect(clusters[0].orders.first.orderNumber, equals('ORD-NOV-001'));
      expect(clusters[0].totalAmount, equals(4067943 + 21716));

      // Second cluster is October
      expect(clusters[1].monthLabel, equals('Oct'));
      expect(clusters[1].orders.length, equals(1));
      expect(clusters[1].orders.first.orderNumber, equals('ORD-OCT-001'));
      expect(clusters[1].totalAmount, equals(50000));
    });
  });

  group('Order Cluster UI Widgets', () {
    testWidgets('OrderClusterCard renders month header, count badge, total, and item tiles', (tester) async {
      final cluster = OrderDateCluster(
        key: '2026-11',
        monthLabel: 'Nov',
        yearLabel: '2026',
        date: DateTime(2026, 11, 1),
        orders: [novOrder1, novOrder2],
        totalAmount: 4067943 + 21716,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: OrderClusterCard(cluster: cluster),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header labels
      expect(find.text('Nov'), findsOneWidget);
      expect(find.text('2 Orders'), findsOneWidget);
      expect(find.textContaining('Total ₦'), findsOneWidget);

      // Both orders are displayed
      expect(find.text('Leather Bag'), findsOneWidget);
      expect(find.text('SafeBox Interest Item'), findsOneWidget);
      expect(find.byType(OrderClusterItemTile), findsNWidgets(2));

      // Tap header to collapse
      await tester.tap(find.text('Nov'));
      await tester.pumpAndSettle();

      // Items should now be collapsed
      expect(find.byType(OrderClusterItemTile), findsNothing);

      // Tap header again to expand
      await tester.tap(find.text('Nov'));
      await tester.pumpAndSettle();
      expect(find.byType(OrderClusterItemTile), findsNWidgets(2));
    });

    testWidgets('OrdersScreen displays clustered orders list with search and filters bar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerOrdersNotifierProvider.overrideWith(
              (ref) => _FakeCustomerOrdersNotifier([novOrder1, novOrder2, octOrder1]),
            ),
          ],
          child: const MaterialApp(
            home: OrdersScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check month cluster headers are rendered
      expect(find.text('Nov'), findsOneWidget);
      expect(find.text('Oct'), findsOneWidget);
      expect(find.byType(OrderClusterCard), findsNWidgets(2));
      expect(find.byType(OrderClusterItemTile), findsNWidgets(3));
    });
  });
}

class _FakeOrdersApi extends OrdersApi {
  final List<CustomerOrder> _orders;
  _FakeOrdersApi(this._orders) : super();

  @override
  Future<PaginatedOrdersResult> getOrders({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    String? orderBy = 'createdAt:DESC',
    OrderStatus? status,
  }) async {
    return PaginatedOrdersResult(
      orders: _orders,
      totalItems: _orders.length,
      totalPages: 1,
      currentPage: 1,
      hasNext: false,
    );
  }
}

class _FakeCustomerOrdersNotifier extends CustomerOrdersNotifier {
  _FakeCustomerOrdersNotifier(List<CustomerOrder> initialOrders)
      : super(_FakeOrdersApi(initialOrders)) {
    state = CustomerOrdersState(
      orders: initialOrders,
      currentPage: 1,
      totalPages: 1,
      totalItems: initialOrders.length,
      hasMore: false,
      isLoading: false,
    );
  }
}
