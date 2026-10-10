import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/checkout/data/checkout_mock_repository.dart';
import 'package:app/features/checkout/domain/checkout_entities.dart';
import 'package:app/features/shop/domain/shop_entities.dart';

void main() {
  group('CheckoutMockRepository', () {
    late CheckoutMockRepository repo;

    setUp(() {
      repo = CheckoutMockRepository();
    });

    test('getSavedAddresses returns at least one default address', () async {
      final addresses = await repo.getSavedAddresses();
      expect(addresses.isNotEmpty, isTrue);
      expect(addresses.any((a) => a.isDefault), isTrue);
    });

    test('getDeliveryMethods returns standard and express delivery options', () async {
      final methods = await repo.getDeliveryMethods();
      expect(methods.length, greaterThanOrEqualTo(2));
      expect(methods.any((m) => m.id == 'dm_standard'), isTrue);
      expect(methods.any((m) => m.id == 'dm_express'), isTrue);
    });

    test('searchReferrals returns matching candidate for "Chisom" or "REF"', () async {
      final results1 = await repo.searchReferrals('Chisom');
      expect(results1.isNotEmpty, isTrue);
      expect(results1.first.name, contains('Chisom'));

      final results2 = await repo.searchReferrals('REF-ABA8');
      expect(results2.isNotEmpty, isTrue);
      expect(results2.first.code, equals('REF-ABA8'));
    });

    test('placeOrder successfully creates order and returns CheckoutOrderResult', () async {
      const product = Product(
        id: 'test_prod_1',
        name: 'Aba Quality Leather Shoes',
        slug: 'aba-leather-shoes',
        price: 35000.0,
        category: 'Footwear',
        brand: 'Aba Artisans',
        rating: 4.8,
        reviewCount: 12,
        stock: 5,
        images: ['https://example.com/shoe.jpg'],
      );

      const cart = Cart(items: [
        CartItem(product: product, quantity: 1),
      ]);

      const customerInfo = CheckoutCustomerInfo(
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane@example.com',
        phone: '+2348012345678',
      );

      const address = CheckoutAddress(
        id: 'addr_test',
        label: 'Home',
        fullName: 'Jane Doe',
        street: '123 Test St',
        city: 'Lagos',
        state: 'Lagos',
        phone: '+2348012345678',
      );

      const deliveryMethod = DeliveryMethod(
        id: 'dm_standard',
        name: 'Standard Delivery',
        duration: '3-5 Days',
        cost: 2500.0,
      );

      final result = await repo.placeOrder(
        cart: cart,
        customerInfo: customerInfo,
        address: address,
        deliveryMethod: deliveryMethod,
        paymentType: CheckoutPaymentType.card,
      );

      expect(result.orderId, startsWith('ORD-2026-X'));
      expect(result.status, equals('Processing'));
      expect(result.order.items.length, equals(1));
      expect(result.order.shippingAddress.fullName, equals('Jane Doe'));
    });
  });
}
