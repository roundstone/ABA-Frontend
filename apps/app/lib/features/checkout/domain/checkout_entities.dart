import '../../account/domain/customer_order.dart';

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

enum CheckoutPaymentType { card, wallet, bankTransfer }

class ReferralCandidate {
  const ReferralCandidate({
    required this.id,
    required this.name,
    required this.moniker,
    required this.code,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String moniker;
  final String code;
  final String imageUrl;
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
