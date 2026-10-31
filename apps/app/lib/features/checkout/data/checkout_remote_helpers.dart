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
      orderJson['status']?.toString() ?? 'pending',
    );

    final safeTotal = (orderJson['total'] as num?)?.toInt() ??
        (orderJson['total_amount'] as num?)?.toInt() ??
        (orderJson['totalAmount'] as num?)?.toInt() ??
        cart.total.toInt();

    final safeOrder = CustomerOrder(
      id: ordId,
      date: safeDate,
      status: safeStatus,
      total: safeTotal,
      paymentMethod: paymentType.name,
      shippingAddress: ShippingAddress(
        fullName: address.fullName,
        street: address.street,
        city: address.city,
        zipCode: address.zipCode,
        phone: address.phone,
      ),
      items: cart.items
          .map((i) => OrderItem(
                id: i.effectiveId,
                productId: i.product.id,
                productName: i.product.name,
                price: i.product.price.toInt(),
                quantity: i.quantity,
              ))
          .toList(),
    );

    return CheckoutOrderResult(
      orderId: ordId,
      status: safeStatus.label,
      totalAmount: safeTotal.toDouble(),
      createdAt: safeDate,
      order: safeOrder,
    );
  }
}

