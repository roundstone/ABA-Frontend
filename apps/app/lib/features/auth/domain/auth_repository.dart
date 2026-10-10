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
}
