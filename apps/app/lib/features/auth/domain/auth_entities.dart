enum UserRole {
  customer('Customer'),
  merchant('Merchant'),
  admin('Admin');

  const UserRole(this.label);
  final String label;

  static UserRole fromString(String? role) {
    if (role == null) return UserRole.customer;
    final r = role.toLowerCase().trim();
    if (r == 'merchant' || r == 'seller' || r == 'vendor') {
      return UserRole.merchant;
    }
    if (r == 'admin' || r == 'super admin' || r == 'superadmin') {
      return UserRole.admin;
    }
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
    this.refreshToken,
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
  final String? refreshToken;
  final String? referralCode;
  final String? merchantId;
  final String? businessName;
  final double walletBalance;
  final DateTime createdAt;

  bool get isMerchant => role == UserRole.merchant;
  bool get isCustomer => role == UserRole.customer;
  bool get isAdmin => role == UserRole.admin;

  AuthUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? token,
    String? refreshToken,
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
      refreshToken: refreshToken ?? this.refreshToken,
      referralCode: referralCode ?? this.referralCode,
      merchantId: merchantId ?? this.merchantId,
      businessName: businessName ?? this.businessName,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'token': token,
      'refreshToken': refreshToken,
      'referralCode': referralCode,
      'merchantId': merchantId,
      'businessName': businessName,
      'walletBalance': walletBalance,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: UserRole.fromString(json['role'] as String?),
      token: json['token'] as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
      referralCode: json['referralCode'] as String?,
      merchantId: json['merchantId'] as String?,
      businessName: json['businessName'] as String?,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class CustomerRegistrationParams {
  const CustomerRegistrationParams({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.confirmPassword,
    this.referralCode,
  });

  final String fullName;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String confirmPassword;
  final String? referralCode;
}

class MerchantOnboardingParams {
  const MerchantOnboardingParams({
    required this.businessName,
    required this.businessType,
    this.rcNumber,
    this.isProvisional = false,
    this.cacDocumentName,
    required this.ownerName,
    required this.phone,
    required this.email,
    this.idType = 'National Identity Number (NIN)',
    this.ninNumber,
    this.idDocumentName,
    required this.address,
    this.marketCluster,
    required this.city,
    required this.state,
    this.productDescription,
    this.samplePhotosCount = 0,
    this.certificationType,
    this.certificationNumber,
    this.certificationDocumentName,
    this.agreedToFulfillmentSla = true,
    required this.bankName,
    required this.accountNumber,
  });

  final String businessName;
  final String businessType;
  final String? rcNumber;
  final bool isProvisional;
  final String? cacDocumentName;
  final String ownerName;
  final String phone;
  final String email;
  final String idType;
  final String? ninNumber;
  final String? idDocumentName;
  final String address;
  final String? marketCluster;
  final String city;
  final String state;
  final String? productDescription;
  final int samplePhotosCount;
  final String? certificationType;
  final String? certificationNumber;
  final String? certificationDocumentName;
  final bool agreedToFulfillmentSla;
  final String bankName;
  final String accountNumber;
}

class AuthState {
  const AuthState({this.user, this.isLoading = false, this.errorMessage});

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
