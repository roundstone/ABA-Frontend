import 'package:app/features/checkout/domain/checkout_entities.dart';

class DeliveryAddress {
  const DeliveryAddress({
    required this.id,
    required this.customerId,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    this.phone = '',
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String customerId;
  final String name;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String phone;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: (json['id'] ?? '').toString(),
      customerId: (json['customer_id'] ?? json['customerId'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      street: (json['street'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      zip: (json['zip'] ?? json['zipCode'] ?? '').toString(),
      phone: (json['phone'] ?? json['contact_phone'] ?? json['mobile'] ?? '').toString(),
      isDefault: json['is_default'] == true || json['isDefault'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : (json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
              : DateTime.now()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : (json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      if (phone.isNotEmpty) 'phone': phone,
      'is_default': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  DeliveryAddress copyWith({
    String? id,
    String? customerId,
    String? name,
    String? street,
    String? city,
    String? state,
    String? zip,
    String? phone,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  CheckoutAddress toCheckoutAddress() {
    return CheckoutAddress(
      id: id,
      label: name,
      fullName: '',
      street: street,
      city: city,
      state: state,
      zipCode: zip,
      phone: phone,
      isDefault: isDefault,
    );
  }
}