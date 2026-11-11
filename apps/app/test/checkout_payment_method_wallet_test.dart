import 'package:app/core/network/api_endpoints.dart';
import 'package:app/features/cart/application/cart_notifier.dart';
import 'package:app/features/cart/application/cart_providers.dart';
import 'package:app/features/checkout/data/paystack_gateway_service.dart';
import 'package:app/features/checkout/domain/checkout_entities.dart';
import 'package:app/features/checkout/presentation/widgets/step_payment_method.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:app/features/wallet/application/wallet_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCartNotifier extends CartNotifier {
  _FakeCartNotifier(this._cart);
  final Cart _cart;

  @override
  Future<Cart> build() async => _cart;
}

void main() {
  group('Payment Endpoints and Service paymentMethod tests', () {
    test('api endpoints orderPaymentInitialize points to /orders/{orderId}', () {
      final endpoint = ApiEndpoints.payments.orderPaymentInitialize(1807);
      expect(
        endpoint,
        equals('${ApiEndpoints.apiV1}/payments/mobile-app/orders/1807'),
      );
    });

    test('initializePayment sends paymentMethod: 1 for Paystack', () async {
      final recordedRequests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://test.aba.com'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            recordedRequests.add(options);
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'data': {
                    'authorizationUrl': 'https://checkout.paystack.com/test-123',
                    'reference': 'PSK-test-123',
                  },
                },
              ),
            );
          },
        ),
      );

      final service = PaystackGatewayService(dio);
      final res = await service.initializePayment(
        orderId: 1807,
        amount: 25800.0,
        email: 'customer@aba.ng',
      );

      expect(res.authorizationUrl, equals('https://checkout.paystack.com/test-123'));
      expect(recordedRequests.first.data['paymentMethod'], equals(1));
      expect(recordedRequests.first.path.endsWith('/orders/1807'), isTrue);
    });

    test('initializePayment sends paymentMethod: 2 for Wallet', () async {
      final recordedRequests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://test.aba.com'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            recordedRequests.add(options);
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'data': {
                    'status': 'success',
                    'reference': 'WLT-tx-999',
                  },
                },
              ),
            );
          },
        ),
      );

      final service = PaystackGatewayService(dio);
      final res = await service.initializePayment(
        orderId: 1807,
        amount: 25800.0,
        email: 'customer@aba.ng',
        paymentMethod: 2,
      );

      expect(res.reference, equals('WLT-tx-999'));
      expect(recordedRequests.first.data['paymentMethod'], equals(2));
      expect(recordedRequests.first.path.endsWith('/orders/1807'), isTrue);
    });
  });

  group('StepPaymentMethod Widget Tests', () {
    testWidgets('allows selecting Wallet and Paystack payment methods', (tester) async {
      CheckoutPaymentType selected = CheckoutPaymentType.paystack;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartProvider.overrideWith(
              () => _FakeCartNotifier(const Cart(items: [])),
            ),
            walletInfoProvider.overrideWith(
              (ref) => Future.value(
                const WalletInfo(
                  balance: 50000.0,
                  currency: 'NGN',
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => StepPaymentMethod(
                  selectedType: selected,
                  onSelectType: (type) => setState(() => selected = type),
                  onBack: () {},
                  onContinue: () {},
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Paystack Gateway'), findsOneWidget);
      expect(find.text('BuyNaija Wallet'), findsOneWidget);
      expect(find.textContaining('Available Balance:'), findsOneWidget);
      expect(find.textContaining('50,000.00'), findsOneWidget);

      // Tap Wallet
      await tester.tap(find.text('BuyNaija Wallet'));
      await tester.pumpAndSettle();

      expect(selected, equals(CheckoutPaymentType.wallet));
    });

    testWidgets('shows insufficient balance snackbar and opens FundWalletSheet without route crash', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartProvider.overrideWith(
              () => _FakeCartNotifier(
                const Cart(
                  items: [
                    CartItem(
                      id: 'ci_1',
                      product: Product(
                        id: 'p1',
                        name: 'Shoe',
                        slug: 'shoe',
                        price: 30000,
                        discount: 0,
                        category: 'Footwear',
                        brand: 'Aba',
                        rating: 5,
                        reviewCount: 1,
                        stock: 5,
                        images: [],
                        description: 'Shoes',
                        tags: [],
                      ),
                      quantity: 1,
                    ),
                  ],
                ),
              ),
            ),
            walletInfoProvider.overrideWith(
              (ref) => Future.value(
                const WalletInfo(
                  balance: 5000.0,
                  currency: 'NGN',
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: StepPaymentMethod(
                selectedType: CheckoutPaymentType.wallet,
                onSelectType: (_) {},
                onBack: () {},
                onContinue: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('(Low balance)'), findsOneWidget);

      // Tap Review Order
      await tester.tap(find.text('Review Order'));
      await tester.pumpAndSettle();

      // Verify snackbar is displayed with Fund wallet action
      expect(find.textContaining('Insufficient wallet balance'), findsOneWidget);
      expect(find.text('Fund wallet'), findsOneWidget);

      // Tap Fund wallet
      await tester.tap(find.text('Fund wallet'));
      await tester.pumpAndSettle();

      // Verify FundWalletSheet modal opened without navigator crash
      expect(find.text('Fund Wallet'), findsOneWidget);
    });
  });
}
