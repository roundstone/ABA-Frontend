import 'package:app/core/widgets/app_empty_state.dart';
import 'package:app/features/cart/application/cart_notifier.dart';
import 'package:app/features/cart/application/cart_providers.dart';
import 'package:app/features/checkout/application/checkout_providers.dart';
import 'package:app/features/checkout/application/payment_gateway_registry.dart';
import 'package:app/features/checkout/data/checkout_mock_repository.dart';
import 'package:app/features/checkout/domain/checkout_entities.dart';
import 'package:app/features/checkout/domain/payment_gateway.dart';
import 'package:app/features/checkout/presentation/checkout_order_handler.dart';
import 'package:app/features/checkout/presentation/checkout_screen.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestCartNotifier extends CartNotifier {
  _TestCartNotifier(this._initialCart);
  Cart _initialCart;

  @override
  Future<Cart> build() async => _initialCart;

  @override
  Future<void> clearCart() async {
    _initialCart = const Cart();
    state = const AsyncValue.data(Cart());
  }
}

class _MockPaymentGatewayService implements PaymentGatewayService {
  _MockPaymentGatewayService({this.shouldWalletPass = true});

  final bool shouldWalletPass;

  @override
  PaymentGatewayType get type => PaymentGatewayType.paystack;

  @override
  Future<GatewayPaymentInitResult> initializePayment({
    required dynamic orderId,
    required double amount,
    required String email,
    int? paymentMethod,
    Map<String, dynamic>? extra,
  }) async {
    if (paymentMethod == 2 && !shouldWalletPass) {
      throw Exception('Insufficient wallet balance');
    }
    return const GatewayPaymentInitResult(
      authorizationUrl: 'https://checkout.paystack.com/test-mock',
      reference: 'PSK-test-ref-123',
    );
  }

  @override
  Future<bool> verifyPayment(String reference) async => true;
}

const _dummyProduct = Product(
  id: 'prod-01',
  name: 'Aba Leather Shoes',
  slug: 'aba-leather-shoes',
  price: 15000.0,
  brand: 'Aba',
  category: 'Shoes',
  rating: 4.5,
  reviewCount: 10,
  stock: 5,
  images: ['https://example.com/shoe.jpg'],
);

const _dummyAddress = CheckoutAddress(
  id: 'addr-01', label: 'Home', fullName: 'John Okafor',
  street: '12 Faulks Road', city: 'Aba', state: 'Abia', phone: '+2348012345678',
);

const _dummyMethod = DeliveryMethod(
  id: 'dm_standard', name: 'Standard Delivery', duration: '2-4 days', cost: 1500,
);

const _dummyCart = Cart(
  items: [CartItem(product: _dummyProduct, quantity: 2)],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Cart Clearing Timing on Checkout & Payment', () {
    late CheckoutMockRepository mockRepo;

    setUp(() {
      mockRepo = CheckoutMockRepository();
    });

    test('submitOrder does not clear cart when clearCartOnSuccess is false', () async {
      final cartNotifier = _TestCartNotifier(_dummyCart);
      final container = ProviderContainer(
        overrides: [
          checkoutRepositoryProvider.overrideWithValue(mockRepo),
          cartProvider.overrideWith(() => cartNotifier),
        ],
      );
      addTearDown(container.dispose);
      container.listen(checkoutProvider, (_, __) {});

      final notifier = container.read(checkoutProvider.notifier);
      await pumpEventQueue();
      notifier.selectAddress(_dummyAddress);
      notifier.selectDeliveryMethod(_dummyMethod);

      // Submit order with standard checkout policy (clearCartOnSuccess: false)
      final res = await notifier.submitOrder(
        _dummyCart,
        clearCartOnSuccess: false,
      );

      expect(res, isNotNull);
      final cartAfter = container.read(cartProvider).valueOrNull;
      expect(cartAfter, isNotNull);
      expect(cartAfter!.isEmpty, isFalse);
      expect(cartAfter.items.length, equals(1));
    });

    test('submitOrder clears cart when clearCartOnSuccess is explicitly true', () async {
      final cartNotifier = _TestCartNotifier(_dummyCart);
      final container = ProviderContainer(
        overrides: [
          checkoutRepositoryProvider.overrideWithValue(mockRepo),
          cartProvider.overrideWith(() => cartNotifier),
        ],
      );
      addTearDown(container.dispose);
      container.listen(checkoutProvider, (_, __) {});

      final notifier = container.read(checkoutProvider.notifier);
      await pumpEventQueue();
      notifier.selectAddress(_dummyAddress);
      notifier.selectDeliveryMethod(_dummyMethod);

      final res = await notifier.submitOrder(
        _dummyCart,
        clearCartOnSuccess: true,
      );

      expect(res, isNotNull);
      final cartAfter = container.read(cartProvider).valueOrNull;
      expect(cartAfter, isNotNull);
      expect(cartAfter!.isEmpty, isTrue);
    });

    testWidgets('Wallet payment failure leaves cart intact with items', (tester) async {
      final cartNotifier = _TestCartNotifier(_dummyCart);
      final mockGateway = _MockPaymentGatewayService(shouldWalletPass: false);

      final container = ProviderContainer(
        overrides: [
          checkoutRepositoryProvider.overrideWithValue(mockRepo),
          cartProvider.overrideWith(() => cartNotifier),
          paymentGatewayRegistryProvider.overrideWith((ref) {
            return PaymentGatewayRegistry({
              PaymentGatewayType.paystack: mockGateway,
            });
          }),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(checkoutProvider);
                  return ElevatedButton(
                    onPressed: () async {
                      final notifier = ref.read(checkoutProvider.notifier);
                      notifier.selectAddress(_dummyAddress);
                      notifier.selectDeliveryMethod(_dummyMethod);
                      notifier.selectPaymentType(CheckoutPaymentType.wallet);

                      await CheckoutOrderHandler.handlePlaceOrder(
                        context: context,
                        ref: ref,
                        checkoutState: state,
                        notifier: notifier,
                        cart: _dummyCart,
                      );
                    },
                    child: const Text('Pay Wallet'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pay Wallet'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));

      final cartAfter = container.read(cartProvider).valueOrNull;
      expect(cartAfter, isNotNull);
      expect(cartAfter!.isEmpty, isFalse, reason: 'Cart must NOT be cleared when wallet payment fails');
      expect(cartAfter.items.length, equals(1));
    });

    testWidgets('CheckoutScreen renders LoadingState and never flashes AppEmptyState when createdOrderResult != null', (tester) async {
      final cartNotifier = _TestCartNotifier(const Cart());
      final container = ProviderContainer(
        overrides: [
          checkoutRepositoryProvider.overrideWithValue(mockRepo),
          cartProvider.overrideWith(() => cartNotifier),
        ],
      );
      addTearDown(container.dispose);
      container.listen(checkoutProvider, (_, __) {});

      final notifier = container.read(checkoutProvider.notifier);
      notifier.selectAddress(_dummyAddress);
      notifier.selectDeliveryMethod(_dummyMethod);

      CheckoutOrderResult? orderRes;
      notifier.submitOrder(_dummyCart, clearCartOnSuccess: false).then((res) => orderRes = res);
      await tester.pump(const Duration(seconds: 2));
      expect(orderRes, isNotNull);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CheckoutScreen(directCart: Cart()),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AppEmptyState), findsNothing, reason: 'Must not flash AppEmptyState while order is created');
      expect(find.text('Finalizing order…'), findsOneWidget);
    });
  });
}
