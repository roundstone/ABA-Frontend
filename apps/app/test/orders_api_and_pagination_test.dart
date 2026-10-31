import 'package:app/core/config/app_config.dart';
import 'package:app/features/account/application/orders_providers.dart';
import 'package:app/features/account/data/orders_api.dart';
import 'package:app/features/account/domain/customer_order.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomerOrder Domain Model Parsing', () {
    test('parses real backend order JSON with string amounts into kobo minor units', () {
      final backendJson = {
        "id": 1811,
        "customer_id": 4,
        "delivery_address_id": 106,
        "order_number": "ORD-1793458691802-863YFRV2",
        "total_amount": "25300.00",
        "currency": "NGN",
        "payment_state": "unpaid",
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
            "payment_method": "card_or_bank"
          }
        ],
        "items": [
          {
            "id": 306,
            "order_id": 1811,
            "quantity": 1,
            "unit_price": "25300.00",
            "total_price": "25300.00",
            "productVariant": {
              "id": 6,
              "name": "Demo Product 3 - Black",
              "product": {
                "id": 4,
                "name": "Demo Product 3",
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
      expect(order.total, 2530000);
      expect(order.isUnpaid, isTrue);
      expect(order.shippingAddress.fullName, 'Office/Work');
      expect(order.payments.length, 1);
      expect(order.items.length, 1);
    });

    test('parses legacy mock JSON with integer kobo amounts correctly', () {
      final mockJson = {
        "id": "ORD-2026-X8F9A",
        "date": "2026-10-01T10:42:00Z",
        "status": "Processing",
        "total": 4670000,
        "paymentMethod": "wallet",
        "shippingAddress": {
          "fullName": "Jane Doe",
          "street": "123 Market Street",
          "city": "Lagos",
          "zipCode": "101241",
          "phone": "+234 801 234 5678"
        },
        "items": [
          {
            "id": "item-1",
            "productId": "prod-1",
            "productName": "Apple Watch",
            "price": 4520000,
            "quantity": 1
          }
        ]
      };

      final order = CustomerOrder.fromJson(mockJson);
      expect(order.id, 'ORD-2026-X8F9A');
      expect(order.total, 4670000);
      expect(order.status, OrderStatus.processing);
    });
  });

  group('OrdersApi Integration', () {
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

    test('live Dio call sends startDate, endDate, and query parameters', () async {
      AppConfig.isMockMode = false;
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, contains('/api/v1/orders/mobile-app'));
            expect(options.queryParameters['page'], 2);
            expect(options.queryParameters['limit'], 5);
            expect(options.queryParameters['startDate'], '2026-10-01');
            expect(options.queryParameters['endDate'], '2026-10-31');

            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  "success": true,
                  "statusCode": 200,
                  "data": {
                    "data": [
                      {
                        "id": 2001,
                        "order_number": "ORD-2001",
                        "total_amount": "15000.00",
                        "createdAt": "2026-10-31T12:00:00.000Z",
                        "items": []
                      }
                    ],
                    "meta": {
                      "totalItems": 1,
                      "totalPages": 1,
                      "currentPage": 1,
                      "nextPageUrl": null
                    }
                  }
                },
              ),
            );
          },
        ),
      );

      final api = OrdersApi(dio);
      final res = await api.getOrders(
        page: 2,
        limit: 5,
        startDate: '2026-10-01',
        endDate: '2026-10-31',
      );

      expect(res.orders.length, 1);
      expect(res.orders.first.orderNumber, 'ORD-2001');
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
