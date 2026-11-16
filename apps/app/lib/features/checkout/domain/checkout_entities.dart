import '../../account/domain/customer_order.dart';

/// Centralized delivery fee configuration and temporary flat-rate override.
class CheckoutDeliveryPricing {
  CheckoutDeliveryPricing._();

  static const bool enableShipping = true;
  static const double standardDeliveryCost = 1500.0;
  static const double expressDeliveryCost = 3000.0;

  /// Temporary promotional flat delivery fee applied regardless of tier.
  static const bool useTemporaryFlatFee = true;
  static const double temporaryFlatFee = 1500.0;

  static double effectiveFee(DeliveryMethod? method) {
    if (!enableShipping) return 0.0;
    if (useTemporaryFlatFee) return temporaryFlatFee;
    return method?.cost ?? standardDeliveryCost;
  }
}

class CheckoutCustomerInfo {
  const CheckoutCustomerInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  String get fullName => '$firstName $lastName'.trim();

  CheckoutCustomerInfo copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return CheckoutCustomerInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

class CheckoutAddress {
  const CheckoutAddress({
    required this.id,
    required this.label,
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    this.zipCode = '101241',
    required this.phone,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String fullName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String phone;
  final bool isDefault;

  CheckoutAddress copyWith({
    String? id,
    String? label,
    String? fullName,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? phone,
    bool? isDefault,
  }) {
    return CheckoutAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class DeliveryMethod {
  const DeliveryMethod({
    required this.id,
    required this.name,
    required this.duration,
    required this.cost,
  });

  final String id;
  final String name;
  final String duration;
  final double cost;
}

enum CheckoutPaymentType { paystack, card, wallet, bankTransfer }

class ReferralCandidate {
  const ReferralCandidate({
    required this.id,
    required this.name,
    required this.moniker,
    required this.code,
    required this.imageUrl,
    this.customerId,
    this.userId,
    this.username,
  });

  final String id;
  final String name;
  final String moniker;
  final String code;
  final String imageUrl;
  final int? customerId;
  final int? userId;
  final String? username;

  factory ReferralCandidate.fromJson(Map<String, dynamic> json) {
    final customerId = json['customerId'] != null
        ? int.tryParse(json['customerId'].toString())
        : null;
    final userId = json['userId'] != null
        ? int.tryParse(json['userId'].toString())
        : null;
    final rawId = json['id']?.toString() ??
        customerId?.toString() ??
        userId?.toString() ??
        '';
    final name = json['name']?.toString() ?? '';
    final username = json['username']?.toString() ?? '';
    final moniker = json['moniker']?.toString() ??
        (username.isNotEmpty ? '@$username' : '');
    final code = json['referralCode']?.toString() ??
        json['code']?.toString() ??
        '';
    final imageUrl = json['imageUrl']?.toString() ??
        json['avatar']?.toString() ??
        '';

    return ReferralCandidate(
      id: rawId,
      name: name,
      moniker: moniker,
      code: code,
      imageUrl: imageUrl,
      customerId: customerId,
      userId: userId,
      username: username,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'moniker': moniker,
    'code': code,
    'imageUrl': imageUrl,
    if (customerId != null) 'customerId': customerId,
    if (userId != null) 'userId': userId,
    if (username != null) 'username': username,
  };
}

class CheckoutOrderResult {
  const CheckoutOrderResult({
    required this.orderId,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.order,
  });

  final String orderId;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  final CustomerOrder order;
}
