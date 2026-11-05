import 'customer_order_models.dart';
export 'customer_order_models.dart';

enum OrderStatus {
  pending(
    apiValue: 'pending',
    label: 'Pending',
    shortLabel: 'Pending',
  ),
  shippedOrReadyForPickup(
    apiValue: 'shipped_or_ready_for_pickup',
    label: 'Shipped / Ready for Pickup',
    shortLabel: 'Shipped',
  ),
  complete(
    apiValue: 'complete',
    label: 'Complete',
    shortLabel: 'Complete',
  ),
  cancelled(
    apiValue: 'cancelled',
    label: 'Cancelled',
    shortLabel: 'Cancelled',
  ),
  refundRequested(
    apiValue: 'refund_requested',
    label: 'Refund Requested',
    shortLabel: 'Refund Req.',
  );

  const OrderStatus({
    required this.apiValue,
    required this.label,
    required this.shortLabel,
  });

  final String apiValue;
  final String label;
  final String shortLabel;

  factory OrderStatus.fromString(String value) {
    final v = value.toLowerCase().trim();
    if (v == 'complete' || v == 'completed' || v == 'delivered') {
      return OrderStatus.complete;
    }
    if (v == 'shipped_or_ready_for_pickup' ||
        v == 'shipped' ||
        v == 'ready_for_pickup' ||
        v == 'ready') {
      return OrderStatus.shippedOrReadyForPickup;
    }
    if (v == 'refund_requested' || v == 'refunded') {
      return OrderStatus.refundRequested;
    }
    if (v == 'cancelled' || v == 'canceled') {
      return OrderStatus.cancelled;
    }
    if (v == 'pending' ||
        v == 'unpaid' ||
        v == 'processing' ||
        v == 'confirmed') {
      return OrderStatus.pending;
    }
    return OrderStatus.values.firstWhere(
      (e) =>
          e.apiValue == v ||
          e.name.toLowerCase() == v ||
          e.label.toLowerCase() == v,
      orElse: () => OrderStatus.pending,
    );
  }
}

class CustomerOrder {
  final String id;
  final String orderNumber;
  final DateTime date;
  final OrderStatus status;
  final String paymentState;
  final int total;
  final String deliveryMethod;
  final String? cancellationReason;
  final String paymentMethod;
  final ShippingAddress shippingAddress;
  final List<OrderItem> items;
  final List<CustomerOrderPayment> payments;
  final DateTime? updatedAt;

  CustomerOrder({
    required this.id,
    String? orderNumber,
    required this.date,
    required this.status,
    this.paymentState = 'paid',
    required this.total,
    this.deliveryMethod = 'standard',
    this.cancellationReason,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.items,
    this.payments = const [],
    this.updatedAt,
  }) : orderNumber = orderNumber ?? id;

  bool get isPaid => payments.any(
        (p) => p.status.toLowerCase() == 'success' || p.paidAt != null,
      );

  bool get isCancelled => status == OrderStatus.cancelled;

  bool get isRefundRequested => status == OrderStatus.refundRequested;

  bool get isComplete => status == OrderStatus.complete;

  bool get isUnpaid =>
      !isPaid &&
      !isCancelled &&
      !isRefundRequested &&
      !isComplete &&
      (status == OrderStatus.pending || paymentState.toLowerCase() == 'unpaid');

  bool get canBeCancelled =>
      !isCancelled &&
      !isRefundRequested &&
      status != OrderStatus.complete &&
      status != OrderStatus.shippedOrReadyForPickup;

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    int parsedTotal = 0;
    if (json['total_amount'] != null) {
      final d = double.tryParse(json['total_amount'].toString()) ?? 0.0;
      parsedTotal = (d * 100).round();
    } else if (json['total'] != null) {
      if (json['total'] is int) {
        parsedTotal = json['total'] as int;
      } else {
        final d = double.tryParse(json['total'].toString()) ?? 0.0;
        parsedTotal = (d * 100).round();
      }
    }

    DateTime parsedDate;
    if (json['createdAt'] != null) {
      parsedDate =
          DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    } else if (json['date'] != null) {
      parsedDate = DateTime.tryParse(json['date'].toString()) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    DateTime? parsedUpdated;
    if (json['updatedAt'] != null) {
      parsedUpdated = DateTime.tryParse(json['updatedAt'].toString());
    }

    final payState = json['payment_state']?.toString() ?? 'paid';
    final rawStatus = json['status']?.toString();
    OrderStatus parsedStatus;
    if (rawStatus != null && rawStatus.isNotEmpty) {
      parsedStatus = OrderStatus.fromString(rawStatus);
    } else {
      parsedStatus = OrderStatus.pending;
    }

    List<CustomerOrderPayment> parsedPayments = [];
    if (json['payments'] is List) {
      parsedPayments = (json['payments'] as List)
          .whereType<Map<String, dynamic>>()
          .map((p) => CustomerOrderPayment.fromJson(p))
          .toList();
    }

    String method = json['paymentMethod']?.toString() ?? '';
    if (method.isEmpty && parsedPayments.isNotEmpty) {
      method = parsedPayments.first.paymentMethod ?? 'Card';
    }
    if (method.isEmpty) method = 'Paystack';

    final addrJson = (json['deliveryAddress'] ?? json['shippingAddress'])
        as Map<String, dynamic>?;
    final address = addrJson != null
        ? ShippingAddress.fromJson(addrJson)
        : ShippingAddress(
            fullName: '',
            street: '',
            city: '',
            zipCode: '',
            phone: '',
          );

    List<OrderItem> parsedItems = [];
    if (json['items'] is List) {
      parsedItems = (json['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => OrderItem.fromJson(item))
          .toList();
    }

    final cancelReason =
        (json['cancellation_reason'] ?? json['cancellationReason'])?.toString();
    final delivMethod =
        (json['delivery_method'] ?? json['deliveryMethod'])?.toString() ??
            'standard';

    return CustomerOrder(
      id: json['id']?.toString() ?? '',
      orderNumber:
          json['order_number']?.toString() ?? json['id']?.toString() ?? '',
      date: parsedDate,
      status: parsedStatus,
      paymentState: payState,
      total: parsedTotal,
      deliveryMethod: delivMethod,
      cancellationReason: cancelReason,
      paymentMethod: method,
      shippingAddress: address,
      items: parsedItems,
      payments: parsedPayments,
      updatedAt: parsedUpdated,
    );
  }
}

class PaginatedOrdersResult {
  final List<CustomerOrder> orders;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNext;

  const PaginatedOrdersResult({
    required this.orders,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
  });
}
