import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/config/paystack_config.dart';
import 'package:app/features/checkout/data/checkout_remote_repository.dart';
import 'package:app/features/checkout/data/checkout_mock_repository.dart';
import 'package:app/features/checkout/domain/checkout_entities.dart';
import 'package:app/features/shop/domain/shop_entities.dart';

void main() {
  group('Paystack Configuration Tests', () {
    test('Paystack public and secret keys are correctly configured', () {
      expect(PaystackConfig.publicKey, equals('pk_test_a3c52ce327f5f3e830c62d7d2209ca361833dbb9'));
      expect(PaystackConfig.secretKey, equals('sk_test_5bc54e726c9ac247f8b16e85f39d20b20a528052'));
      expect(PaystackConfig.currency, equals('NGN'));
    });

    test('calculateFee computes standard fee', () {
      final fee = PaystackConfig.calculateFee(10000);
      expect(fee, greaterThan(0));
    });
  });

  group('Checkout Remote Repository & Paystack Flow Tests', () {
    late Dio dio;
    late CheckoutMockRepository mockRepo;
    late CheckoutRemoteRepository repository;
    final recordedRequests = <RequestOptions>[];

    setUp(() {
      recordedRequests.clear();
      dio = Dio(BaseOptions(baseUrl: 'https://test.aba.com'));
      mockRepo = CheckoutMockRepository();

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            recordedRequests.add(options);
            if (options.path.contains('/payments/mobile-app/paystack/')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'data': {
                      'status': 'success',
                      'reference': 'test_ref_123',
                      'amount': 2500000,
                      'currency': 'NGN',
                    },
                  },
                ),
              );
            }

            if (options.path == '/api/v1/orders/mobile-app') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'success': true,
                    'data': {
                      'id': 'ord-999',
                      'order_number': 'ORD-2026-999',
                      'total_amount': 25000.0,
                      'status': 'confirmed',
                    },
                  },
                ),
              );
            }

            return handler.next(options);
          },
        ),
      );

      repository = CheckoutRemoteRepository(dio, mockRepo);
    });

    test('verifyPaystackPayment calls /api/v1/payments/mobile-app/paystack/{reference}/verify', () async {
      final verified = await repository.verifyPaystackPayment('test_ref_123');
      expect(verified, isTrue);
      expect(
        recordedRequests.any((r) => r.path == '/api/v1/payments/mobile-app/paystack/test_ref_123/verify'),
        isTrue,
      );
    });

    test('placeOrder calls POST /api/v1/orders/mobile-app with payment reference', () async {
      const customer = CheckoutCustomerInfo(
        firstName: 'Chisom',
        lastName: 'Okoro',
        email: 'chisom@example.com',
        phone: '+2348012345678',
      );
      const address = CheckoutAddress(
        id: 'addr-1',
        label: 'Home',
        fullName: 'Chisom Okoro',
        street: '12 Faulks Road',
        city: 'Aba',
        state: 'Abia',
        phone: '+2348012345678',
      );
      const delivery = DeliveryMethod(
        id: 'standard',
        name: 'Standard Delivery',
        duration: '2-3 business days',
        cost: 2000,
      );
      const cart = Cart(items: []);

      final result = await repository.placeOrder(
        cart: cart,
        customerInfo: customer,
        address: address,
        deliveryMethod: delivery,
        paymentType: CheckoutPaymentType.paystack,
        paymentReference: 'test_ref_123',
      );

      expect(result.orderId, equals('ord-999'));
      final orderReq = recordedRequests.firstWhere((r) => r.path == '/api/v1/orders/mobile-app');
      expect(orderReq.method, equals('POST'));
      final body = orderReq.data as Map<String, dynamic>;
      expect(body['payment_reference'], equals('test_ref_123'));
      expect(body['payment_method'], equals('paystack'));
    });
  });
}
