import '../domain/auth_entities.dart';
import '../domain/auth_repository.dart';

class AuthMockRepository implements AuthRepository {
  static AuthUser? _currentUser;

  static final AuthUser demoCustomer = AuthUser(
    id: 'CUST-100',
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    phone: '+2348012345678',
    role: UserRole.customer,
    token: 'mock-customer-token',
    referralCode: 'REF-JANE100',
    walletBalance: 24500.0,
    createdAt: DateTime(2025, 1, 15),
  );

  static final AuthUser demoMerchant = AuthUser(
    id: 'MERCH-501',
    name: 'Emeka Nwosu',
    email: 'emeka@abaleather.com',
    phone: '+2348031234567',
    role: UserRole.merchant,
    token: 'mock-merchant-token',
    referralCode: 'REF-EMEKA501',
    merchantId: 'mer-1',
    businessName: 'Enyimba Leather Works',
    walletBalance: 185000.0,
    createdAt: DateTime(2025, 2, 10),
  );

  @override
  Future<AuthUser> loginCustomer({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (password.length < 4) {
      throw Exception('Invalid password. Minimum 4 characters required.');
    }

    final user = AuthUser(
      id: identifier.contains('jane') ? demoCustomer.id : 'CUST-${DateTime.now().millisecondsSinceEpoch % 1000}',
      name: identifier.contains('jane') ? demoCustomer.name : identifier.split('@').first,
      email: identifier.contains('@') ? identifier : '$identifier@example.com',
      phone: identifier.contains('@') ? demoCustomer.phone : identifier,
      role: UserRole.customer,
      token: 'mock-customer-token-${DateTime.now().millisecondsSinceEpoch}',
      referralCode: 'REF-CUST-${DateTime.now().millisecondsSinceEpoch % 10000}',
      walletBalance: 15000.0,
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<AuthUser> registerCustomer(CustomerRegistrationParams params) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (params.fullName.trim().isEmpty) {
      throw Exception('Full name is required.');
    }
    if (!params.email.contains('@')) {
      throw Exception('A valid email address is required.');
    }

    final user = AuthUser(
      id: 'CUST-${DateTime.now().millisecondsSinceEpoch % 1000}',
      name: params.fullName.trim(),
      email: params.email.trim(),
      phone: params.phone.trim(),
      role: UserRole.customer,
      token: 'mock-customer-token-${DateTime.now().millisecondsSinceEpoch}',
      referralCode: 'REF-${params.fullName.substring(0, 3).toUpperCase()}${DateTime.now().millisecondsSinceEpoch % 1000}',
      walletBalance: 500.0, // Welcome signup bonus
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<AuthUser> loginMerchant({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (password.length < 4) {
      throw Exception('Invalid merchant password.');
    }

    final isDemo = identifier.contains('emeka') || identifier.contains('abaleather');
    final user = isDemo
        ? demoMerchant
        : AuthUser(
            id: 'MERCH-${DateTime.now().millisecondsSinceEpoch % 1000}',
            name: identifier.split('@').first,
            email: identifier.contains('@') ? identifier : '$identifier@merchant.aba.ng',
            phone: '+2348099887766',
            role: UserRole.merchant,
            token: 'mock-merchant-token-${DateTime.now().millisecondsSinceEpoch}',
            referralCode: 'REF-MERCH-${DateTime.now().millisecondsSinceEpoch % 1000}',
            merchantId: 'mer-custom',
            businessName: '${identifier.split('@').first.toUpperCase()} Enterprises',
            walletBalance: 50000.0,
            createdAt: DateTime.now(),
          );

    _currentUser = user;
    return user;
  }

  @override
  Future<AuthUser> onboardMerchant(MerchantOnboardingParams params) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (params.businessName.trim().isEmpty) {
      throw Exception('Business name is required.');
    }

    final user = AuthUser(
      id: 'MERCH-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: params.ownerName.trim(),
      email: params.email.trim(),
      phone: params.phone.trim(),
      role: UserRole.merchant,
      token: 'mock-merchant-token-${DateTime.now().millisecondsSinceEpoch}',
      referralCode: 'REF-M-${DateTime.now().millisecondsSinceEpoch % 1000}',
      merchantId: 'mer-${DateTime.now().millisecondsSinceEpoch % 1000}',
      businessName: params.businessName.trim(),
      walletBalance: 0.0,
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<AuthUser?> getStoredUser() async {
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }
}
