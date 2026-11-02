class ShippingAddress {
  final String fullName;
  final String street;
  final String city;
  final String zipCode;
  final String phone;
  final String state;
  final String? label;

  ShippingAddress({
    required this.fullName,
    required this.street,
    required this.city,
    required this.zipCode,
    required this.phone,
    this.state = '',
    this.label,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: (json['recipient_name'] ??
              json['recipientName'] ??
              json['fullName'] ??
              json['name'] ??
              'Customer') as String,
      street: (json['street'] ?? '') as String,
      city: (json['city'] ?? '') as String,
      zipCode: (json['zip'] ?? json['zipCode'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      state: (json['state'] ?? '') as String,
      label: json['name'] as String?,
    );
  }
}

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String? variantName;
  final String? sku;
  final Map<String, dynamic>? attributes;
  final String status;
  final String? imageUrl;
  final int price;
  final int quantity;
  final int? totalPrice;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.variantName,
    this.sku,
    this.attributes,
    this.status = 'pending',
    this.imageUrl,
    required this.price,
    required this.quantity,
    this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final pv = json['productVariant'] as Map<String, dynamic>?;
    final product = pv?['product'] as Map<String, dynamic>?;

    String name = json['productName'] as String? ?? '';
    if (name.isEmpty && product != null) {
      name = product['name'] as String? ?? '';
    }
    if (name.isEmpty && pv != null) {
      name = pv['name'] as String? ?? '';
    }
    if (name.isEmpty) name = 'Product Item';

    String? img;
    if (product != null &&
        product['images'] is List &&
        (product['images'] as List).isNotEmpty) {
      final firstImg = (product['images'] as List).first;
      if (firstImg is Map) {
        img = firstImg['url'] as String?;
      } else if (firstImg is String) {
        img = firstImg;
      }
    }
    img ??= json['imageUrl'] as String?;

    int parsedPrice = 0;
    if (json['unit_price'] != null) {
      final d = double.tryParse(json['unit_price'].toString()) ?? 0.0;
      parsedPrice = (d * 100).round();
    } else if (json['price'] != null) {
      if (json['price'] is int) {
        parsedPrice = json['price'] as int;
      } else {
        final d = double.tryParse(json['price'].toString()) ?? 0.0;
        parsedPrice = (d * 100).round();
      }
    }

    int? parsedTotal;
    if (json['total_price'] != null) {
      final d = double.tryParse(json['total_price'].toString()) ?? 0.0;
      parsedTotal = (d * 100).round();
    }

    final rawAttrs = pv?['attributes'];
    Map<String, dynamic>? attrs;
    if (rawAttrs is Map<String, dynamic>) {
      attrs = rawAttrs;
    } else if (rawAttrs is Map) {
      attrs = rawAttrs.map((k, v) => MapEntry(k.toString(), v));
    }

    return OrderItem(
      id: json['id']?.toString() ?? '',
      productId: product?['id']?.toString() ??
          pv?['product_id']?.toString() ??
          json['productId']?.toString() ??
          '',
      productName: name,
      variantName: pv?['name'] as String?,
      sku: pv?['sku']?.toString(),
      attributes: attrs,
      status: (json['status']?.toString() ?? 'pending').toLowerCase(),
      imageUrl: img,
      price: parsedPrice,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      totalPrice: parsedTotal,
    );
  }
}

class CustomerOrderPayment {
  final String id;
  final String? reference;
  final int amount;
  final String currency;
  final String status;
  final String? paymentMethod;
  final String? failureReason;
  final DateTime? paidAt;
  final DateTime? createdAt;

  CustomerOrderPayment({
    required this.id,
    this.reference,
    required this.amount,
    required this.currency,
    required this.status,
    this.paymentMethod,
    this.failureReason,
    this.paidAt,
    this.createdAt,
  });

  factory CustomerOrderPayment.fromJson(Map<String, dynamic> json) {
    int parsedAmount = 0;
    if (json['amount'] != null) {
      if (json['amount'] is int) {
        parsedAmount = json['amount'] as int;
      } else {
        final d = double.tryParse(json['amount'].toString()) ?? 0.0;
        parsedAmount = (d * 100).round();
      }
    }

    return CustomerOrderPayment(
      id: json['id']?.toString() ?? '',
      reference: json['reference'] as String?,
      amount: parsedAmount,
      currency: json['currency']?.toString() ?? 'NGN',
      status: json['status']?.toString() ?? 'pending',
      paymentMethod: json['payment_method']?.toString(),
      failureReason: json['failure_reason']?.toString(),
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
