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
    status: OrderStatus.processing,
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
    test('ApiEndpoints.orders.invoice constructs correct mobile app URL', () {
      final endpoint = ApiEndpoints.orders.invoice('1811');
      expect(endpoint, equals('/api/v1/orders/mobile-app/1811/invoice'));
    });

    testWidgets('InvoiceService queries endpoint and handles direct binary bytes', (tester) async {
      final dio = Dio();
      bool endpointCalled = false;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/orders/mobile-app/1811/invoice')) {
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
            if (options.path.endsWith('/orders/mobile-app/1811/invoice')) {
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
