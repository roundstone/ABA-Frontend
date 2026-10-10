import 'package:dio/dio.dart';
import '../domain/auth_entities.dart';
import '../domain/auth_repository.dart';

class AuthRemoteRepository implements AuthRepository {
  AuthRemoteRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.aba-market.ng/api/v1',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  final Dio _dio;

  @override
  Future<AuthUser> loginCustomer({
    required String identifier,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/customer/login',
      data: {'identifier': identifier, 'password': password},
    );
    return _mapJsonToUser(response.data['user'], response.data['token'], UserRole.customer);
  }

  @override
  Future<AuthUser> registerCustomer(CustomerRegistrationParams params) async {
    final response = await _dio.post(
      '/auth/customer/register',
      data: {
        'fullName': params.fullName,
        'email': params.email,
        'phone': params.phone,
        'password': params.password,
        'referralCode': params.referralCode,
      },
    );
    return _mapJsonToUser(response.data['user'], response.data['token'], UserRole.customer);
  }

  @override
  Future<AuthUser> loginMerchant({
    required String identifier,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/merchant/login',
      data: {'identifier': identifier, 'password': password},
    );
    return _mapJsonToUser(response.data['user'], response.data['token'], UserRole.merchant);
  }

  @override
  Future<AuthUser> onboardMerchant(MerchantOnboardingParams params) async {
    final response = await _dio.post(
      '/merchants/onboarding',
      data: {
        'businessName': params.businessName,
        'businessType': params.businessType,
        'rcNumber': params.rcNumber,
        'ownerName': params.ownerName,
        'phone': params.phone,
        'email': params.email,
        'address': params.address,
        'city': params.city,
        'state': params.state,
        'bankName': params.bankName,
        'accountNumber': params.accountNumber,
      },
    );
    return _mapJsonToUser(response.data['user'], response.data['token'], UserRole.merchant);
  }

  @override
  Future<AuthUser?> getStoredUser() async {
    try {
      final response = await _dio.get('/auth/me');
      final data = response.data;
      return _mapJsonToUser(data['user'], data['token'] ?? '', UserRole.fromString(data['user']['role']));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {
      // Ignore network errors on logout
    }
  }

  AuthUser _mapJsonToUser(dynamic json, String token, UserRole defaultRole) {
    return AuthUser(
      id: json['id'] as String,
      name: json['name'] as String? ?? json['fullName'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] != null ? UserRole.fromString(json['role'] as String) : defaultRole,
      token: token,
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
