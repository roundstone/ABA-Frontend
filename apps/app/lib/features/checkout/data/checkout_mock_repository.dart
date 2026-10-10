import 'dart:math';
import '../../account/data/orders_api.dart';
import '../../account/domain/customer_order.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/checkout_entities.dart';
import '../domain/checkout_repository.dart';

class CheckoutMockRepository implements CheckoutRepository {
  static const List<ReferralCandidate> _candidates = [
    ReferralCandidate(
      id: '1',
      name: 'Chisom Nwokwu',
      moniker: '@chisomn',
      code: 'REF-CN2026',
      imageUrl: 'https://i.pravatar.cc/150?u=chisomn',
    ),
    ReferralCandidate(
      id: '2',
      name: 'Aba Merchant Hub',
      moniker: '@abahub',
      code: 'REF-ABA8',
      imageUrl: 'https://i.pravatar.cc/150?u=abahub',
    ),
    ReferralCandidate(
      id: '3',
      name: 'Emeka Onyeka',
      moniker: '@emeka_o',
      code: 'REF-EMK01',
      imageUrl: 'https://i.pravatar.cc/150?u=emeka_o',
    ),
    ReferralCandidate(
      id: '4',
      name: 'Sarah Chidimma',
      moniker: '@sarahc',
      code: 'REF-SC44',
      imageUrl: 'https://i.pravatar.cc/150?u=sarahc',
    ),
    ReferralCandidate(
      id: '5',
      name: 'David Okafor',
      moniker: '@davido',
      code: 'REF-DO99',
      imageUrl: 'https://i.pravatar.cc/150?u=davido',
    ),
  ];

  static final List<CheckoutAddress> _savedAddresses = [
    const CheckoutAddress(
      id: 'addr_1',
      label: 'Home',
      fullName: 'Jane Doe',
      street: '123 Market Street, Victoria Island',
      city: 'Lagos',
      state: 'Lagos',
      zipCode: '101241',
      phone: '+234 801 234 5678',
      isDefault: true,
    ),
    const CheckoutAddress(
      id: 'addr_2',
      label: 'Office / Store',
      fullName: 'Jane Doe',
      street: '45 Faulks Road, Ariaria International Market',
      city: 'Aba',
      state: 'Abia',
      zipCode: '450211',
      phone: '+234 801 234 5678',
      isDefault: false,
    ),
  ];

  static const List<DeliveryMethod> _deliveryMethods = [
    DeliveryMethod(
      id: 'dm_standard',
      name: 'Standard Delivery',
      duration: '3-5 Business Days',
      cost: 2500.0,
    ),
    DeliveryMethod(
      id: 'dm_express',
      name: 'Express Delivery',
      duration: '1-2 Business Days',
      cost: 5000.0,
    ),
  ];

  @override
  Future<List<CheckoutAddress>> getSavedAddresses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_savedAddresses);
  }

  @override
  Future<List<DeliveryMethod>> getDeliveryMethods() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _deliveryMethods;
  }

  @override
  Future<List<ReferralCandidate>> searchReferrals(String query) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final q = query.trim().toLowerCase();
    if (q.length < 2) return [];
    return _candidates.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.moniker.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Future<CheckoutOrderResult> placeOrder({
    required Cart cart,
    required CheckoutCustomerInfo customerInfo,
    required CheckoutAddress address,
    required DeliveryMethod deliveryMethod,
    required CheckoutPaymentType paymentType,
    ReferralCandidate? referral,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final grandTotal = cart.subtotal + deliveryMethod.cost + cart.tax;
    final totalInKobo = (grandTotal * 100).round();

    if (paymentType == CheckoutPaymentType.wallet) {
      const mockWalletBalance = 145000.50;
      if (grandTotal > mockWalletBalance) {
        throw Exception(
          'Insufficient wallet balance. Please fund your wallet or select another payment method.',
        );
      }
    }

    final randSuffix = Random().nextInt(90000) + 10000;
    final orderId = 'ORD-2026-X$randSuffix';

    final orderItems = cart.items.map((item) {
      return OrderItem(
        id: 'item_${item.product.id}',
        productId: item.product.id,
        productName: item.product.name,
        price: (item.product.discountedPrice * 100).round(),
        quantity: item.quantity,
      );
    }).toList();

    final order = CustomerOrder(
      id: orderId,
      date: DateTime.now(),
      status: OrderStatus.processing,
      total: totalInKobo,
      paymentMethod: paymentType.name,
      shippingAddress: ShippingAddress(
        fullName: address.fullName,
        street: address.street,
        city: address.city,
        zipCode: address.zipCode,
        phone: address.phone,
      ),
      items: orderItems,
    );

    // Insert into mock orders map so it immediately appears in account/orders
    mockOrders.insert(0, {
      "id": order.id,
      "date": order.date.toIso8601String(),
      "status": "Processing",
      "total": order.total,
      "paymentMethod": order.paymentMethod,
      "shippingAddress": {
        "fullName": order.shippingAddress.fullName,
        "street": order.shippingAddress.street,
        "city": order.shippingAddress.city,
        "zipCode": order.shippingAddress.zipCode,
        "phone": order.shippingAddress.phone,
      },
      "items": order.items.map((it) => {
        "id": it.id,
        "productId": it.productId,
        "productName": it.productName,
        "price": it.price,
        "quantity": it.quantity,
      }).toList(),
    });

    return CheckoutOrderResult(
      orderId: orderId,
      status: 'Processing',
      totalAmount: grandTotal,
      createdAt: DateTime.now(),
      order: order,
    );
  }
}
