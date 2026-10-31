import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/checkout/application/payment_gateway_registry.dart';
import 'package:app/features/checkout/data/paystack_gateway_service.dart';
import 'package:app/features/checkout/domain/payment_gateway.dart';

void main() {
  group('Decoupled Payment Gateway Domain Tests', () {
    test('GatewayPaymentInitResult parses backend initialize response', () {
      final backendJson = {
        'success': true,
        'statusCode': 201,
        'message': 'Request completed successfully',
        'data': {
          'payment': {
            'id': 1809,
            'order_id': 1807,
            'payment_gateway_id': 1,
            'reference': 'PSK-e56c369088fd4d81b4c6c23c217ed771',
            'gateway_transaction_id': null,
            'amount': '12800.00',
            'currency': 'NGN',
            'status': 'pending',
            'payment_method': 'card_or_bank',
            'paid_at': null,
            'metadata': null,
            'failure_reason': null,
            'createdAt': '2026-10-31T14:00:05.043Z',
            'updatedAt': '2026-10-31T14:00:05.043Z',
          },
          'authorizationUrl': 'https://checkout.paystack.com/5miqttewz4xfsor',
          'reference': 'PSK-e56c369088fd4d81b4c6c23c217ed771',
        },
        'timestamp': '2026-10-31T14:00:08.120Z',
      };

      final result = GatewayPaymentInitResult.fromJson(backendJson);
      expect(
        result.authorizationUrl,
        equals('https://checkout.paystack.com/5miqttewz4xfsor'),
      );
      expect(result.reference, equals('PSK-e56c369088fd4d81b4c6c23c217ed771'));
      expect(result.orderId, equals(1807));
      expect(result.amount, equals(12800.0));
      expect(result.paymentId, equals(1809));
      expect(result.status, equals('pending'));
      expect(result.currency, equals('NGN'));
    });
  });

  group('PaystackGatewayService Tests', () {
    late Dio dio;
    late PaystackGatewayService service;
    final recordedRequests = <RequestOptions>[];

    setUp(() {
      recordedRequests.clear();
      dio = Dio(BaseOptions(baseUrl: 'https://test.aba.com'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            recordedRequests.add(options);
            if (options.path.contains('/orders/1807/paystack/initialize')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'success': true,
                    'statusCode': 201,
                    'data': {
                      'payment': {
                        'id': 1809,
                        'order_id': 1807,
                        'reference': 'PSK-e56c369088fd4d81b4c6c23c217ed771',
                        'amount': '12800.00',
                      },
                      'authorizationUrl':
                          'https://checkout.paystack.com/5miqttewz4xfsor',
                      'reference': 'PSK-e56c369088fd4d81b4c6c23c217ed771',
                    },
                  },
                ),
              );
            }

            if (options.path.contains('/payments/mobile-app/paystack/')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'data': {
                      'status': 'success',
                      'reference': 'PSK-e56c369088fd4d81b4c6c23c217ed771',
                    },
                  },
                ),
              );
            }

            return handler.next(options);
          },
        ),
      );
      service = PaystackGatewayService(dio);
    });

    test('initializePayment calls backend order initialize endpoint', () async {
      final res = await service.initializePayment(
        orderId: 1807,
        amount: 12800.0,
        email: 'customer@aba.ng',
      );

      expect(
        res.authorizationUrl,
        equals('https://checkout.paystack.com/5miqttewz4xfsor'),
      );
      expect(res.reference, equals('PSK-e56c369088fd4d81b4c6c23c217ed771'));
      expect(
        recordedRequests.any(
          (r) =>
              r.method == 'POST' &&
              r.path.endsWith('/orders/1807/paystack/initialize'),
        ),
        isTrue,
      );
    });

    test('verifyPayment calls backend paystack verify endpoint', () async {
      final ok = await service.verifyPayment(
        'PSK-e56c369088fd4d81b4c6c23c217ed771',
      );
      expect(ok, isTrue);
      expect(
        recordedRequests.any(
          (r) =>
              r.path.contains('/payments/mobile-app/paystack/') &&
              r.path.endsWith('/verify'),
        ),
        isTrue,
      );
    });
  });

  group('PaymentGatewayRegistry Tests', () {
    test('retrieves registered gateway and rejects unsupported', () {
      final dio = Dio();
      final paystack = PaystackGatewayService(dio);
      final registry = PaymentGatewayRegistry({
        PaymentGatewayType.paystack: paystack,
      });

      expect(registry.isSupported(PaymentGatewayType.paystack), isTrue);
      expect(
        registry.getGateway(PaymentGatewayType.paystack),
        same(paystack),
      );
      expect(registry.isSupported(PaymentGatewayType.flutterwave), isFalse);
      expect(
        () => registry.getGateway(PaymentGatewayType.flutterwave),
        throwsUnsupportedError,
      );
    });
  });
}

