// Domain entities for Merchant Order Management.

enum MerchantOrderStatus {
  pending('Pending'),
  processing('Processing'),
  ready('Ready'),
  completed('Completed'),
  cancelled('Cancelled');

  const MerchantOrderStatus(this.label);
  final String label;

  static MerchantOrderStatus fromString(String? value) {
    if (value == null) return MerchantOrderStatus.pending;
    final normalized = value.toLowerCase().trim();
    if (normalized == 'processing') return MerchantOrderStatus.processing;
    if (normalized == 'ready') return MerchantOrderStatus.ready;
    if (normalized == 'completed') return MerchantOrderStatus.completed;
    if (normalized == 'cancelled') return MerchantOrderStatus.cancelled;
    return MerchantOrderStatus.pending;
  }
}

enum MerchantPaymentStatus {
  paid('Paid'),
  unpaid('Unpaid'),
  partiallyPaid('Partially Paid'),
  refunded('Refunded');

  const MerchantPaymentStatus(this.label);
  final String label;

  static MerchantPaymentStatus fromString(String? value) {
    if (value == null) return MerchantPaymentStatus.unpaid;
    final normalized = value.toLowerCase().trim();
    if (normalized == 'paid') return MerchantPaymentStatus.paid;
    if (normalized == 'partially_paid' || normalized == 'partially paid') {
      return MerchantPaymentStatus.partiallyPaid;
    }
    if (normalized == 'refunded') return MerchantPaymentStatus.refunded;
    return MerchantPaymentStatus.unpaid;
  }
}

enum OrderChannel {
  pos('POS / Walk-in'),
  storefront('Storefront'),
  portal('Customer Portal');

  const OrderChannel(this.label);
  final String label;
}

class MerchantOrderItem {
  const MerchantOrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.price,
    required this.quantity,
    this.imageUrl = '',
  });

  final String id;
  final String productId;
  final String productName;
  final String sku;
  final double price;
  final int quantity;
  final String imageUrl;

  double get total => price * quantity;
}

class MerchantOrder {
  const MerchantOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    this.isWalkIn = false,
    required this.channel,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.items,
    required this.subtotal,
    this.deliveryFee = 0,
    this.discount = 0,
    required this.total,
    required this.createdAt,
    this.shippingAddress,
    this.notes,
  });

  final String id;
  final String customerName;
  final String customerPhone;
  final bool isWalkIn;
  final OrderChannel channel;
  final MerchantOrderStatus status;
  final MerchantPaymentStatus paymentStatus;
  final String paymentMethod;
  final List<MerchantOrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final DateTime createdAt;
  final String? shippingAddress;
  final String? notes;

  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  MerchantOrder copyWith({
    MerchantOrderStatus? status,
    MerchantPaymentStatus? paymentStatus,
    String? notes,
  }) {
    return MerchantOrder(
      id: id,
      customerName: customerName,
      customerPhone: customerPhone,
      isWalkIn: isWalkIn,
      channel: channel,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      createdAt: createdAt,
      shippingAddress: shippingAddress,
      notes: notes ?? this.notes,
    );
  }
}
