import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/config/paystack_config.dart';
import 'package:app/features/checkout/data/checkout_remote_repository.dart';
import 'package:app/features/checkout/data/checkout_mock_repository.dart';
import 'package:app/features/checkout/data/paystack_charge_service.dart';
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
      expect(PaystackConfig.calculateFee(10000), greaterThan(0));
    });
  });

  group('PaystackChargeService Direct Charge Tests', () {
    late Dio dio;
    late PaystackChargeService chargeService;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.paystack.co'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/transaction/initialize') {
              return handler.resolve(Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'status': true,
                  'data': {
                    'authorization_url': 'https://checkout.paystack.com/access123',
                    'access_code': 'access123',
                    'reference': 'pstk_init_999',
                  },
                },
              ));
            }
            if (options.path == '/charge') {
              return handler.resolve(Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'status': true,
                  'data': {
                    'status': 'send_otp',
                    'reference': 'pstk_real_ref_999',
                    'display_text': 'Please enter OTP sent to 080***',
                  },
                },
              ));
            }
            if (options.path == '/charge/submit_otp') {
              return handler.resolve(Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'status': true,
                  'data': {'status': 'success', 'reference': 'pstk_real_ref_999'},
                },
              ));
            }
            return handler.next(options);
          },
        ),
      );
      chargeService = PaystackChargeService(dio: dio);
    });

    test('chargeCard sends card details and receives send_otp', () async {
      final res = await chargeService.chargeCard(
        amount: 25000,
        email: 'customer@aba.ng',
        cardNumber: '4084 0840 0840 0840',
        expiry: '12/30',
        cvv: '408',
      );
      expect(res.isOtpRequired, isTrue);
      expect(res.reference, equals('pstk_real_ref_999'));
    });

    test('submitOtp sends OTP and returns success with authentic reference', () async {
      final res = await chargeService.submitOtp(
        reference: 'pstk_real_ref_999',
        otp: '1234',
      );
      expect(res.isSuccess, isTrue);
      expect(res.reference, equals('pstk_real_ref_999'));
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
              return handler.resolve(Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'data': {'status': 'success', 'reference': 'test_ref_123'},
                },
              ));
            }
            if (options.path.contains('/order/mobile-app')) {
              return handler.resolve(Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'success': true,
                  'data': {
                    'id': 1807,
                    'order_number': 'ORD-1793449837461-MFUYZXMU',
                    'total_amount': '25300.00',
                    'status': 'pending',
                  },
                },
              ));
            }
            return handler.next(options);
          },
        ),
      );
      repository = CheckoutRemoteRepository(dio, mockRepo);
    });

    test('verifyPaystackPayment calls backend verify endpoint', () async {
      final verified = await repository.verifyPaystackPayment('test_ref_123');
      expect(verified, isTrue);
      expect(
        recordedRequests.any((r) => r.path.contains('/payments/mobile-app/paystack/test_ref_123/verify')),
        isTrue,
      );
    });

    test('placeOrder calls POST /api/v1/order/mobile-app with deliveryAddressId and items', () async {
      const customer = CheckoutCustomerInfo(
        firstName: 'Chisom',
        lastName: 'Okoro',
        email: 'chisom@example.com',
        phone: '+2348012345678',
      );
      const address = CheckoutAddress(
        id: '106',
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
      const cart = Cart(items: [
        CartItem(
          product: Product(
            id: '4',
            name: 'Demo Product 3',
            slug: 'demo-product-3',
            price: 12800,
            rating: 4.5,
            reviewCount: 10,
            images: [],
            category: 'Clothing',
            brand: 'Aba',
            stock: 20,
          ),
          quantity: 1,
          productVariantId: 6,
        ),
      ]);

      final result = await repository.placeOrder(
        cart: cart,
        customerInfo: customer,
        address: address,
        deliveryMethod: delivery,
        paymentType: CheckoutPaymentType.paystack,
      );

      expect(result.orderId, equals('1807'));
      expect(result.totalAmount, equals(25300.0));
      expect(result.order.total, equals(2530000)); // Stored in kobo

      final orderReq = recordedRequests.firstWhere((r) => r.path.contains('/order/mobile-app'));
      expect(orderReq.method, equals('POST'));
      final body = orderReq.data as Map<String, dynamic>;
      expect(body['deliveryAddressId'], equals(106));
      expect(body['items'][0]['productVariantId'], equals(6));
    });
  });
}
