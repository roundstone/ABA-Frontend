import 'package:app/core/config/app_config.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/features/account/application/orders_providers.dart';
import 'package:app/features/account/data/orders_api.dart';
import 'package:app/features/account/domain/customer_order.dart';
import 'package:app/features/account/presentation/widgets/order_detail_payment_section.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final pendingOrder = CustomerOrder(
    id: '1811',
    orderNumber: 'ORD-1793458691802-863YFRV2',
    date: DateTime(2026, 10, 31, 14, 58),
    status: OrderStatus.pending,
    total: 2530000,
    paymentMethod: 'card_or_bank',
    shippingAddress: ShippingAddress(
      fullName: 'Customer Name',
      street: 'nexus road',
      city: 'Aba',
      state: 'Abia',
      zipCode: '450001',
      phone: '+234 801 234 5678',
    ),
    items: const [],
    payments: [
      CustomerOrderPayment(
        id: '1813',
        reference: 'PSK-pending-123',
        amount: 2530000,
        currency: 'NGN',
        status: 'pending',
        paymentMethod: 'card_or_bank',
        createdAt: DateTime(2026, 10, 31, 14, 58),
      ),
      CustomerOrderPayment(
        id: '1807',
        reference: 'PSK-failed-456',
        amount: 2530000,
        currency: 'NGN',
        status: 'failed',
        paymentMethod: 'card_or_bank',
        createdAt: DateTime(2026, 10, 31, 14, 00),
      ),
    ],
  );

  final paidOrder = CustomerOrder(
    id: '1812',
    orderNumber: 'ORD-PAID-001',
    date: DateTime(2026, 10, 31, 14, 58),
    status: OrderStatus.processing,
    total: 2530000,
    paymentMethod: 'card_or_bank',
    shippingAddress: ShippingAddress(
      fullName: 'Customer Name',
      street: 'nexus road',
      city: 'Aba',
      state: 'Abia',
      zipCode: '450001',
      phone: '+234 801 234 5678',
    ),
    items: const [],
    payments: [
      CustomerOrderPayment(
        id: '1815',
        reference: 'PSK-success-789',
        amount: 2530000,
        currency: 'NGN',
        status: 'success',
        paymentMethod: 'card_or_bank',
        paidAt: DateTime(2026, 10, 31, 15, 00),
      ),
    ],
  );

  group('Order Payment Verify Button Tests', () {
    testWidgets('Verify button appears when order is unpaid and payment is pending', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OrderDetailPaymentSection(order: pendingOrder),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify button should appear for pending reference
      expect(find.byKey(const ValueKey('verify_payment_button_PSK-pending-123')), findsOneWidget);

      // Verify button should NOT appear for failed payment attempt
      expect(find.byKey(const ValueKey('verify_payment_button_PSK-failed-456')), findsNothing);
    });

    testWidgets('Verify button does NOT appear when order is paid', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OrderDetailPaymentSection(order: paidOrder),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify button must not appear for paid order or successful payment
      expect(find.text('Verify'), findsNothing);
      expect(find.byKey(const ValueKey('verify_payment_button_PSK-success-789')), findsNothing);
      expect(find.byKey(const ValueKey('header_verify_payment_button')), findsNothing);
    });

    testWidgets('Tapping Verify button triggers payment verify endpoint and recalls order details', (tester) async {
      bool verifyEndpointCalled = false;
      bool orderDetailsRecalled = false;

      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('/payments/mobile-app/paystack/PSK-pending-123/verify')) {
              verifyEndpointCalled = true;
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'statusCode': 200,
                    'data': {'status': 'success'},
                  },
                ),
              );
            }
            if (options.path.endsWith('/orders/mobile-app/1811')) {
              orderDetailsRecalled = true;
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'statusCode': 200,
                    'data': {
                      'id': 1811,
                      'order_number': 'ORD-1793458691802-863YFRV2',
                      'status': 'confirmed',
                      'total_amount': '25300.00',
                      'payments': [
                        {
                          'id': 1813,
                          'reference': 'PSK-pending-123',
                          'amount': '25300.00',
                          'status': 'success',
                          'paid_at': '2026-10-31T15:00:00.000Z',
                        }
                      ],
                      'items': [],
                    },
                  },
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      final customOrdersApi = OrdersApi(dio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ordersApiProvider.overrideWithValue(customOrdersApi),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      // Actively watch order details to confirm invalidation recalls endpoint
                      ref.watch(customerOrderByIdProvider(pendingOrder.id));
                      return const SizedBox.shrink();
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: OrderDetailPaymentSection(order: pendingOrder),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final verifyBtn = find.byKey(const ValueKey('verify_payment_button_PSK-pending-123'));
      expect(verifyBtn, findsOneWidget);

      await tester.tap(verifyBtn);
      await tester.pumpAndSettle();

      expect(verifyEndpointCalled, isTrue);
      expect(orderDetailsRecalled, isTrue);
      expect(find.text('Payment verified successfully! Updating order...'), findsOneWidget);
    });

    test('OrdersApi.verifyPayment constructs correct URL and parses success', () async {
      AppConfig.isMockMode = false;
      final dio = Dio();
      String? capturedPath;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedPath = options.path;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'statusCode': 200,
                  'data': {'status': 'success'},
                },
              ),
            );
          },
        ),
      );

      final api = OrdersApi(dio);
      final result = await api.verifyPayment('PSK-test-ref-001');

      expect(result, isTrue);
      expect(capturedPath, equals(ApiEndpoints.payments.paystackVerify('PSK-test-ref-001')));
    });
  });
}
