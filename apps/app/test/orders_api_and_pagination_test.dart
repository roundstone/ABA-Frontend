import 'package:app/core/config/app_config.dart';
import 'package:app/features/account/application/orders_providers.dart';
import 'package:app/features/account/data/orders_api.dart';
import 'package:app/features/account/domain/customer_order.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomerOrder Domain Model Parsing', () {
    test('parses new backend order schema with items status, failure reasons, and delivery method', () {
      final backendJson = {
        "id": 1811,
        "customer_id": 4,
        "delivery_address_id": 106,
        "delivery_method": "standard",
        "order_number": "ORD-1793458691802-863YFRV2",
        "total_amount": "25300.00",
        "status": "pending",
        "cancellation_reason": null,
        "deliveryAddress": {
          "id": 106,
          "name": "Office/Work",
          "street": "nexus road",
          "city": "Aba",
          "state": "Abia",
          "zip": "450001"
        },
        "payments": [
          {
            "id": 1813,
            "order_id": 1811,
            "reference": "PSK-54fc7825b5f546a2b407860ea7d627c7",
            "amount": "25300.00",
            "currency": "NGN",
            "status": "pending",
            "payment_method": "card_or_bank",
            "failure_reason": null
          },
          {
            "id": 1807,
            "order_id": 1811,
            "reference": "PSK-failed-ref",
            "amount": "25300.00",
            "currency": "NGN",
            "status": "failed",
            "payment_method": "card_or_bank",
            "failure_reason": "Paystack is not configured"
          }
        ],
        "items": [
          {
            "id": 310,
            "order_id": 1811,
            "quantity": 1,
            "unit_price": "12700.00",
            "total_price": "12700.00",
            "status": "pending",
            "productVariant": {
              "id": 4,
              "name": "Demo Product 2 - Black",
              "sku": "DEMO-SKU-002-B",
              "attributes": {"color": "Black", "size": "42"},
              "product": {
                "id": 3,
                "name": "Demo Product 2",
                "images": [
                  {"url": "https://example.com/demo.jpg"}
                ]
              }
            }
          }
        ],
        "createdAt": "2026-10-31T14:58:11.849Z"
      };

      final order = CustomerOrder.fromJson(backendJson);
      expect(order.id, '1811');
      expect(order.orderNumber, 'ORD-1793458691802-863YFRV2');
      expect(order.status, OrderStatus.pending);
      expect(order.deliveryMethod, 'standard');
      expect(order.cancellationReason, isNull);
      expect(order.total, 2530000);
      expect(order.isUnpaid, isTrue);
      expect(order.canBeCancelled, isTrue);
      expect(order.shippingAddress.label, 'Office/Work');
      expect(order.payments.length, 2);
      expect(order.payments[1].failureReason, 'Paystack is not configured');

      expect(order.items.length, 1);
      final item = order.items.first;
      expect(item.status, 'pending');
      expect(item.sku, 'DEMO-SKU-002-B');
      expect(item.attributes?['color'], 'Black');
    });

    test('parses cancelled order correctly', () {
      final cancelledJson = {
        "id": "1806",
        "order_number": "ORD-CANCELLED",
        "status": "cancelled",
        "cancellation_reason": "Customer changed mind",
        "total_amount": "15000.00",
        "items": [],
        "deliveryAddress": {"name": "Home", "street": "Main St"}
      };

      final order = CustomerOrder.fromJson(cancelledJson);
      expect(order.status, OrderStatus.cancelled);
      expect(order.isCancelled, isTrue);
      expect(order.isUnpaid, isFalse);
      expect(order.canBeCancelled, isFalse);
      expect(order.cancellationReason, 'Customer changed mind');
    });

    test('parses all updated order statuses correctly', () {
      expect(OrderStatus.fromString('pending'), OrderStatus.pending);
      expect(OrderStatus.fromString('complete'), OrderStatus.complete);
      expect(
        OrderStatus.fromString('shipped_or_ready_for_pickup'),
        OrderStatus.shippedOrReadyForPickup,
      );
      expect(OrderStatus.fromString('cancelled'), OrderStatus.cancelled);
      expect(
        OrderStatus.fromString('refund_requested'),
        OrderStatus.refundRequested,
      );
    });
  });

  group('OrdersApi Integration', () {
    test('mock mode cancelOrder updates order status and cancellation reason', () async {
      AppConfig.isMockMode = true;
      final api = OrdersApi();

      final cancelled = await api.cancelOrder(
        orderId: '1811',
        cancellationReason: 'Found better price elsewhere',
      );

      expect(cancelled.status, OrderStatus.cancelled);
      expect(cancelled.cancellationReason, 'Found better price elsewhere');
      expect(cancelled.isCancelled, isTrue);
    });

    test('mock mode pagination and date range filtering works', () async {
      AppConfig.isMockMode = true;
      final api = OrdersApi();

      final res1 = await api.getOrders(page: 1, limit: 1);
      expect(res1.orders.length, 1);
      expect(res1.currentPage, 1);
      expect(res1.hasNext, isTrue);

      final filteredDate = await api.getOrders(
        startDate: '2026-10-01',
        endDate: '2026-10-31',
      );
      expect(filteredDate.orders.isNotEmpty, isTrue);
    });

    test('live Dio call sends cancel payload with reason and orderId', () async {
      AppConfig.isMockMode = false;
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, contains('/api/v1/orders/mobile-app/cancel'));
            expect(options.method, 'POST');
            final data = options.data as Map;
            expect(data['cancellation_reason'], 'Changed mind');
            expect(data['order_id'], 1811);

            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  "success": true,
                  "statusCode": 200,
                  "data": {
                    "id": 1811,
                    "order_number": "ORD-1811",
                    "status": "cancelled",
                    "cancellation_reason": "Changed mind",
                    "total_amount": "25300.00",
                    "items": []
                  }
                },
              ),
            );
          },
        ),
      );

      final api = OrdersApi(dio);
      final res = await api.cancelOrder(
        orderId: '1811',
        cancellationReason: 'Changed mind',
      );

      expect(res.status, OrderStatus.cancelled);
      expect(res.cancellationReason, 'Changed mind');
    });
  });

  group('CustomerOrdersNotifier Pagination & Date Filters', () {
    test('filters by date range and clears filters', () async {
      AppConfig.isMockMode = true;
      final api = OrdersApi();
      final notifier = CustomerOrdersNotifier(api);

      await Future.delayed(const Duration(milliseconds: 350));
      expect(notifier.state.orders.isNotEmpty, isTrue);

      notifier.setDateRange(DateTime(2026, 1, 1), DateTime(2026, 1, 2));
      await Future.delayed(const Duration(milliseconds: 350));
      expect(notifier.state.hasActiveFilters, isTrue);

      notifier.clearDateRange();
      await Future.delayed(const Duration(milliseconds: 350));
      expect(notifier.state.startDate, isNull);
      expect(notifier.state.endDate, isNull);
    });
  });
}
