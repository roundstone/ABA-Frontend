import 'auth_entities.dart';

abstract class AuthRepository {
  Future<AuthUser> loginCustomer({
    required String identifier,
    required String password,
  });

  Future<AuthUser> registerCustomer(CustomerRegistrationParams params);

  Future<AuthUser> loginMerchant({
    required String identifier,
    required String password,
  });

  Future<AuthUser> onboardMerchant(MerchantOnboardingParams params);

  Future<AuthUser?> getStoredUser();

  Future<void> logout();

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
    String? email,
  });

  Future<String?> refreshToken();
}
