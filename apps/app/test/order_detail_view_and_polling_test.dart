import 'package:app/core/config/app_config.dart';
import 'package:app/features/account/application/orders_providers.dart';
import 'package:app/features/account/domain/customer_order.dart';
import 'package:app/features/account/presentation/order_detail_screen.dart';
import 'package:app/features/account/presentation/widgets/order_cancel_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    AppConfig.isMockMode = true;
  });

  final testOrder = CustomerOrder(
    id: '1811',
    orderNumber: 'ORD-1793458691802-863YFRV2',
    date: DateTime(2026, 10, 31, 14, 58),
    status: OrderStatus.pending,
    total: 2530000,
    deliveryMethod: 'standard',
    paymentMethod: 'card_or_bank',
    shippingAddress: ShippingAddress(
      fullName: 'Customer Name',
      street: 'nexus road',
      city: 'Aba',
      state: 'Abia',
      zipCode: '450001',
      phone: '+234 801 234 5678',
      label: 'Office/Work',
    ),
    items: [
      OrderItem(
        id: '310',
        productId: '3',
        productName: 'Demo Product 2 - Black',
        variantName: 'Black / 42',
        sku: 'DEMO-SKU-002-B',
        attributes: {'color': 'Black', 'size': '42'},
        status: 'pending',
        price: 1270000,
        quantity: 1,
        totalPrice: 1270000,
      ),
    ],
    payments: [
      CustomerOrderPayment(
        id: '1813',
        reference: 'PSK-54fc7825b5f546a2b407860ea7d627c7',
        amount: 2530000,
        currency: 'NGN',
        status: 'pending',
        paymentMethod: 'card_or_bank',
        createdAt: DateTime(2026, 10, 31, 14, 58),
      ),
      CustomerOrderPayment(
        id: '1807',
        reference: 'PSK-failed-ref',
        amount: 2530000,
        currency: 'NGN',
        status: 'failed',
        failureReason: 'Paystack is not configured',
        createdAt: DateTime(2026, 10, 31, 15, 24),
      ),
    ],
  );

  testWidgets('OrderDetailScreen renders all detail information and statuses', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          customerOrderByIdProvider('1811').overrideWith(
            (ref) async => testOrder,
          ),
        ],
        child: const MaterialApp(
          home: OrderDetailScreen(orderId: '1811'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify header and order number
    expect(find.text('ORD-1793458691802-863YFRV2'), findsOneWidget);
    expect(find.text('Order Details'), findsOneWidget);

    // Verify address label and street
    expect(find.text('Office/Work'), findsOneWidget);
    expect(find.text('nexus road'), findsOneWidget);
    expect(find.textContaining('Standard Ground Delivery'), findsOneWidget);

    // Verify line item and individual status
    expect(find.text('Demo Product 2 - Black'), findsOneWidget);
    expect(find.text('PENDING'), findsWidgets);
    expect(find.text('SKU: DEMO-SKU-002-B'), findsOneWidget);
    expect(find.text('color: Black • size: 42'), findsOneWidget);

    // Verify payment and failure reason
    expect(find.text('Payment & Transactions'), findsOneWidget);
    expect(find.text('Paystack is not configured'), findsOneWidget);
    expect(find.textContaining('Ref: PSK-54fc7825'), findsOneWidget);

    // Verify transactions are ordered by date descending (15:24 before 14:58)
    final failedPos = tester.getTopLeft(find.text('Paystack is not configured')).dy;
    final pendingPos = tester.getTopLeft(find.textContaining('Ref: PSK-54fc7825')).dy;
    expect(failedPos, lessThan(pendingPos));

    // Verify cancel order button is present
    expect(find.text('Cancel Order'), findsOneWidget);
  });

  testWidgets('Tapping Cancel Order opens OrderCancelDialog', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          customerOrderByIdProvider('1811').overrideWith(
            (ref) async => testOrder,
          ),
        ],
        child: const MaterialApp(
          home: OrderDetailScreen(orderId: '1811'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final cancelBtn = find.text('Cancel Order');
    expect(cancelBtn, findsOneWidget);
    await tester.tap(cancelBtn);
    await tester.pumpAndSettle();

    expect(find.byType(OrderCancelDialog), findsOneWidget);
    expect(find.text('Changed my mind'), findsOneWidget);
    expect(find.text('Keep Order'), findsOneWidget);
    expect(find.text('Confirm Cancel'), findsOneWidget);
  });

  testWidgets('OrderDetailScreen renders cancelled order with reason banner', (tester) async {
    final cancelledOrder = CustomerOrder(
      id: '1806',
      orderNumber: 'ORD-CANCELLED',
      date: DateTime(2026, 10, 29),
      status: OrderStatus.cancelled,
      cancellationReason: 'Customer requested cancellation before dispatch',
      total: 1500000,
      paymentMethod: 'card',
      shippingAddress: ShippingAddress(
        fullName: 'Jane Doe',
        street: 'Main St',
        city: 'Aba',
        zipCode: '450001',
        phone: '123',
      ),
      items: [],
      payments: [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          customerOrderByIdProvider('1806').overrideWith(
            (ref) async => cancelledOrder,
          ),
        ],
        child: const MaterialApp(
          home: OrderDetailScreen(orderId: '1806'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Order Cancelled'), findsWidgets);
    expect(
      find.text('Reason: Customer requested cancellation before dispatch'),
      findsOneWidget,
    );
  });
}
