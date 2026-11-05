import '../../account/domain/customer_order.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/checkout_entities.dart';

/// Helper parsers for [CheckoutRemoteRepository].
class CheckoutRemoteHelpers {
  CheckoutRemoteHelpers._();

  static CheckoutOrderResult parseOrderResult({
    required Map<String, dynamic> unwrapped,
    required Cart cart,
    required CheckoutAddress address,
    required CheckoutPaymentType paymentType,
  }) {
    final orderJson = unwrapped['order'] is Map<String, dynamic>
        ? unwrapped['order'] as Map<String, dynamic>
        : unwrapped;

    final ordId = unwrapped['orderId']?.toString() ??
        orderJson['id']?.toString() ??
        orderJson['order_number']?.toString() ??
        'ORD-${DateTime.now().millisecondsSinceEpoch % 100000}';

    final safeDate = DateTime.tryParse(orderJson['date']?.toString() ??
            orderJson['createdAt']?.toString() ??
            orderJson['created_at']?.toString() ??
            '') ??
        DateTime.now();

    final safeStatus = OrderStatus.fromString(
      orderJson['payment_state']?.toString() ??
          orderJson['status']?.toString() ??
          'pending',
    );

    final rawTotal = orderJson['total'] ??
        orderJson['total_amount'] ??
        orderJson['totalAmount'];

    // Backend returns '25300.00' in Naira.
    // CustomerOrder.total stores integer minor units (kobo, per Doc 1 §16),
    // which gets formatted by dividing by 100 in the UI.
    final double totalNaira = rawTotal is num
        ? rawTotal.toDouble()
        : (double.tryParse(rawTotal?.toString() ?? '') ?? cart.total);

    final int safeTotalKobo = (totalNaira * 100).round();

    final safeOrder = CustomerOrder(
      id: ordId,
      orderNumber: orderJson['order_number']?.toString() ?? ordId,
      date: safeDate,
      status: safeStatus,
      paymentState: orderJson['payment_state']?.toString() ?? 'paid',
      total: safeTotalKobo,
      paymentMethod: paymentType.name,
      shippingAddress: ShippingAddress(
        fullName: address.fullName,
        street: address.street,
        city: address.city,
        state: address.state,
        zipCode: address.zipCode,
        phone: address.phone,
      ),
      items: cart.items
          .map((i) => OrderItem(
                id: i.effectiveId,
                productId: i.product.id,
                productName: i.product.name,
                price: (i.product.price * 100).round(),
                quantity: i.quantity,
              ))
          .toList(),
    );

    return CheckoutOrderResult(
      orderId: ordId,
      status: safeStatus.label,
      totalAmount: totalNaira,
      createdAt: safeDate,
      order: safeOrder,
    );
  }
}

