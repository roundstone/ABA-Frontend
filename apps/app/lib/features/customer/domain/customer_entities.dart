// Domain entities — pure Dart, no framework dependencies.
// Mirrors the shapes in: apps/web/src/services/mock/{order,commission,user}.service.ts

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

enum CommissionStatus { pending, approved, paid, reversed }

class CustomerProfile {
  const CustomerProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.referralCode,
    this.avatarUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String referralCode;
  final String? avatarUrl;

  String get fullName => '$firstName $lastName';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
          .toUpperCase();
}

class OrderItem {
  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  double get subtotal => price * quantity;
}

class CustomerOrder {
  const CustomerOrder({
    required this.id,
    required this.customerId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.status,
    required this.createdAt,
    this.shippingAddress,
    this.paymentMethod,
  });

  final String id;
  final String customerId;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String? shippingAddress;
  final String? paymentMethod;
}

class CommissionEntry {
  const CommissionEntry({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.level,
    required this.status,
    required this.createdAt,
    this.purchaserName,
  });

  final String id;
  final String orderId;
  final double amount;
  final int level;
  final CommissionStatus status;
  final DateTime createdAt;
  final String? purchaserName;
}

class DashboardSummary {
  const DashboardSummary({
    required this.profile,
    required this.totalOrderValue,
    required this.totalPoints,
    required this.totalOrders,
    required this.recentOrders,
    required this.totalEarned,
    required this.pendingCommission,
    required this.availableToWithdraw,
  });

  final CustomerProfile profile;
  final double totalOrderValue;
  final int totalPoints;
  final int totalOrders;
  final List<CustomerOrder> recentOrders;
  final double totalEarned;
  final double pendingCommission;
  final double availableToWithdraw;
}
