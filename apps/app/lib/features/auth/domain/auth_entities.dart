enum UserRole {
  customer('Customer'),
  merchant('Merchant'),
  admin('Admin');

  const UserRole(this.label);
  final String label;

  static UserRole fromString(String? role) {
    if (role == null) return UserRole.customer;
    final r = role.toLowerCase().trim();
    if (r == 'merchant' || r == 'seller') return UserRole.merchant;
    if (r == 'admin') return UserRole.admin;
    return UserRole.customer;
  }
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.token,
    this.referralCode,
    this.merchantId,
    this.businessName,
    this.walletBalance = 0,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String token;
  final String? referralCode;
  final String? merchantId;
  final String? businessName;
  final double walletBalance;
  final DateTime createdAt;

  bool get isMerchant => role == UserRole.merchant;
  bool get isCustomer => role == UserRole.customer;

  AuthUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? token,
    String? referralCode,
    String? merchantId,
    String? businessName,
    double? walletBalance,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      token: token ?? this.token,
      referralCode: referralCode ?? this.referralCode,
      merchantId: merchantId ?? this.merchantId,
      businessName: businessName ?? this.businessName,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CustomerRegistrationParams {
  const CustomerRegistrationParams({
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
}

class MerchantOnboardingParams {
  const MerchantOnboardingParams({
    required this.businessName,
    required this.businessType,
    this.rcNumber,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.bankName,
    required this.accountNumber,
  });

  final String businessName;
  final String businessType;
  final String? rcNumber;
  final String ownerName;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final String bankName;
  final String accountNumber;
}

class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  final AuthUser? user;
  final bool isLoading;
  final String? errorMessage;

  bool get isAuthenticated => user != null;
  bool get isMerchant => user?.isMerchant ?? false;
  UserRole get role => user?.role ?? UserRole.customer;

  AuthState copyWith({
    AuthUser? user,
    bool clearUser = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
