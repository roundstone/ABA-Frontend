import 'customer_order_models.dart';

class OrderInvoice {
  const OrderInvoice({
    required this.id,
    required this.orderId,
    this.customerId,
    this.merchantId,
    required this.invoiceNumber,
    required this.status,
    required this.subtotal,
    required this.discountAmount,
    required this.deliveryAmount,
    required this.taxAmount,
    required this.totalAmount,
    this.currency = 'NGN',
    this.customerName,
    this.customerEmail,
    this.deliveryAddress,
    this.storageKey,
    this.issuedAt,
    this.dueAt,
    this.items = const [],
  });

  final int id;
  final int orderId;
  final int? customerId;
  final int? merchantId;
  final String invoiceNumber;
  final String status;
  final double subtotal;
  final double discountAmount;
  final double deliveryAmount;
  final double taxAmount;
  final double totalAmount;
  final String currency;
  final String? customerName;
  final String? customerEmail;
  final ShippingAddress? deliveryAddress;
  final String? storageKey;
  final DateTime? issuedAt;
  final DateTime? dueAt;
  final List<OrderItem> items;

  factory OrderInvoice.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final custSnap = data['customer_snapshot'] is Map
        ? Map<String, dynamic>.from(data['customer_snapshot'] as Map)
        : null;

    final addrMap = custSnap?['deliveryAddress'] is Map
        ? Map<String, dynamic>.from(custSnap!['deliveryAddress'] as Map)
        : null;

    final itemsList = data['items'] is List ? data['items'] as List : const [];

    return OrderInvoice(
      id: (data['id'] as num?)?.toInt() ?? 0,
      orderId: (data['order_id'] as num?)?.toInt() ?? 0,
      customerId: (data['customer_id'] as num?)?.toInt(),
      merchantId: (data['merchant_id'] as num?)?.toInt(),
      invoiceNumber: (data['invoice_number'] ?? '').toString(),
      status: (data['status'] ?? 'issued').toString(),
      subtotal: double.tryParse(data['subtotal']?.toString() ?? '0') ?? 0.0,
      discountAmount:
          double.tryParse(data['discount_amount']?.toString() ?? '0') ?? 0.0,
      deliveryAmount:
          double.tryParse(data['delivery_amount']?.toString() ?? '0') ?? 0.0,
      taxAmount:
          double.tryParse(data['tax_amount']?.toString() ?? '0') ?? 0.0,
      totalAmount:
          double.tryParse(data['total_amount']?.toString() ?? '0') ?? 0.0,
      currency: (data['currency'] ?? 'NGN').toString(),
      customerName: custSnap?['name']?.toString(),
      customerEmail: custSnap?['email']?.toString(),
      deliveryAddress:
          addrMap != null ? ShippingAddress.fromJson(addrMap) : null,
      storageKey: data['storage_key']?.toString(),
      issuedAt: data['issued_at'] != null
          ? DateTime.tryParse(data['issued_at'].toString())
          : null,
      dueAt: data['due_at'] != null
          ? DateTime.tryParse(data['due_at'].toString())
          : null,
      items: itemsList
          .whereType<Map>()
          .map((i) => OrderItem.fromJson(Map<String, dynamic>.from(i)))
          .toList(),
    );
  }
}

