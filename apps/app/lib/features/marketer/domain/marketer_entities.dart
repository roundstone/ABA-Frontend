class MarketerStats {
  const MarketerStats({
    required this.totalCustomersAdded,
    required this.activeCustomers,
    required this.totalCommissionEarned,
    required this.pendingCommission,
    required this.ordersByReferred,
    required this.salesVolumeGenerated,
  });

  final int totalCustomersAdded;
  final int activeCustomers;
  final double totalCommissionEarned;
  final double pendingCommission;
  final int ordersByReferred;
  final double salesVolumeGenerated;

  factory MarketerStats.empty() => const MarketerStats(
        totalCustomersAdded: 0,
        activeCustomers: 0,
        totalCommissionEarned: 0,
        pendingCommission: 0,
        ordersByReferred: 0,
        salesVolumeGenerated: 0,
      );

  factory MarketerStats.mock() => const MarketerStats(
        totalCustomersAdded: 18,
        activeCustomers: 12,
        totalCommissionEarned: 84500.0,
        pendingCommission: 14200.0,
        ordersByReferred: 47,
        salesVolumeGenerated: 1680000.0,
      );
}

class OnboardCustomerInput {
  const OnboardCustomerInput({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    this.referralCode,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String? referralCode;

  Map<String, dynamic> toJson() {
    final names = fullName.trim().split(RegExp(r'\s+'));
    final fn = names.isNotEmpty ? names.first : 'Customer';
    final ln = names.length > 1 ? names.last : '';
    final mn = names.length > 2 ? names.sublist(1, names.length - 1).join(' ') : '';
    final username = email.split('@').first.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');

    return {
      'first_name': fn,
      'last_name': ln.isNotEmpty ? ln : 'User',
      'middle_name': mn,
      'username': username,
      'phone': phone.trim(),
      'email': email.trim(),
      'password': password,
      'confirm_password': password,
      if (referralCode != null && referralCode!.isNotEmpty) 'referralCode': referralCode,
    };
  }
}

class OnboardCustomerResult {
  const OnboardCustomerResult({
    required this.success,
    this.customerId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    this.error,
  });

  final bool success;
  final String? customerId;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String? error;
}

