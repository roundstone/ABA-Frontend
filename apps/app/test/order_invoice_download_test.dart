import 'dart:convert';
import 'dart:io';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/features/account/application/invoice_service.dart';
import 'package:app/features/account/domain/customer_order.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testOrder = CustomerOrder(
    id: '1811',
    orderNumber: 'ORD-1793458691802-863YFRV2',
    date: DateTime(2026, 10, 31),
    status: OrderStatus.pending,
    paymentMethod: 'card_or_bank',
    total: 2530000,
    items: const [],
    shippingAddress: ShippingAddress(
      fullName: 'John Doe',
      street: 'nexus road',
      city: 'Aba',
      state: 'Abia',
      zipCode: '450001',
      phone: '+234 801 234 5678',
    ),
  );

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return Directory.systemTemp.path;
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      (MethodCall methodCall) async {
        return 'success';
      },
    );
  });

  group('Invoice Endpoint & Service Tests', () {
    test('ApiEndpoints.invoices constructs correct view and download URLs', () {
      expect(
        ApiEndpoints.invoices.byOrderId('1814'),
        equals('/api/v1/invoices/orders/1814'),
      );
      expect(
        ApiEndpoints.invoices.downloadByOrderId('1814'),
        equals('/api/v1/invoices/orders/1814/download'),
      );
      expect(
        ApiEndpoints.orders.invoice('1811'),
        equals('/api/v1/invoices/orders/1811/download'),
      );
    });

    test('InvoiceService.fetchOrderInvoice parses backend invoice JSON', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/invoices/orders/1814')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'statusCode': 200,
                    'message': 'Request completed successfully',
                    'data': {
                      'id': 1,
                      'order_id': 1814,
                      'customer_id': 4,
                      'merchant_id': null,
                      'invoice_number': 'INV-1814-1793838157748',
                      'status': 'issued',
                      'subtotal': '0.00',
                      'discount_amount': '0.00',
                      'delivery_amount': '0.00',
                      'tax_amount': '0.00',
                      'total_amount': '26900.00',
                      'currency': 'NGN',
                      'customer_snapshot': {
                        'name': 'Bro David Enabs',
                        'email': 'c-davidenabs@gmail.com',
                        'deliveryAddress': {
                          'id': 106,
                          'zip': '450001',
                          'city': 'Aba',
                          'name': 'Office/Work',
                          'state': 'Abia',
                          'street': 'nexus road',
                        }
                      },
                      'issued_at': '2026-11-05T00:22:37.748Z',
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

      final inv = await InvoiceService.fetchOrderInvoice('1814', dioClient: dio);
      expect(inv.id, 1);
      expect(inv.orderId, 1814);
      expect(inv.invoiceNumber, 'INV-1814-1793838157748');
      expect(inv.status, 'issued');
      expect(inv.totalAmount, 26900.0);
      expect(inv.customerName, 'Bro David Enabs');
      expect(inv.customerEmail, 'c-davidenabs@gmail.com');
      expect(inv.deliveryAddress?.city, 'Aba');
    });

    testWidgets('InvoiceService queries download endpoint and handles direct binary bytes', (tester) async {
      final dio = Dio();
      bool endpointCalled = false;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/invoices/orders/1811/download')) {
              endpointCalled = true;
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: utf8.encode('%PDF-1.4 test invoice content %%EOF'),
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => InvoiceService.downloadAndShareInvoice(
                  context,
                  testOrder,
                  dioClient: dio,
                ),
                child: const Text('Download Invoice'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Download Invoice'));
      await tester.pumpAndSettle();

      expect(endpointCalled, isTrue);
    });

    testWidgets('InvoiceService handles JSON wrapper with download URL', (tester) async {
      final dio = Dio();
      bool invoiceEndpointCalled = false;
      bool downloadUrlCalled = false;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/invoices/orders/1811/download')) {
              invoiceEndpointCalled = true;
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: utf8.encode(jsonEncode({
                    'success': true,
                    'statusCode': 200,
                    'data': {
                      'url': 'https://aba-storage.ng/invoices/ord-1811.pdf',
                    },
                  })),
                ),
              );
            }
            if (options.path == 'https://aba-storage.ng/invoices/ord-1811.pdf') {
              downloadUrlCalled = true;
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: utf8.encode('%PDF-1.4 remote downloaded bytes %%EOF'),
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => InvoiceService.downloadAndShareInvoice(
                  context,
                  testOrder,
                  dioClient: dio,
                ),
                child: const Text('Download Invoice'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Download Invoice'));
      await tester.pumpAndSettle();

      expect(invoiceEndpointCalled, isTrue);
      expect(downloadUrlCalled, isTrue);
    });
  });
}
