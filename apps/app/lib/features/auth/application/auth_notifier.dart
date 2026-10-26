import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/logging/app_logger.dart';
import '../domain/auth_entities.dart';
import '../domain/auth_repository.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required AuthRepository repository})
    : _repository = repository,
      super(AuthState(user: repository.getStoredUserSync())) {
    _checkStoredUser();
  }

  final AuthRepository _repository;

  Future<void> _checkStoredUser() async {
    try {
      final user = await _repository.getStoredUser();
      if (user != null && state.user != user) {
        state = state.copyWith(user: user);
      }
    } catch (e, stackTrace) {
      AppLogger.w(
        'Failed during background checkStoredUser: $e',
        stackTrace: stackTrace,
      );
    }
  }

  Future<bool> loginCustomer({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final loggedInUser = await _repository.loginCustomer(
        identifier: identifier,
        password: password,
      );
      final user = await _repository.getStoredUser() ?? loggedInUser;
      
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Customer login failed', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> registerCustomer(CustomerRegistrationParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.registerCustomer(params);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Customer registration failed', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> loginMerchant({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.loginMerchant(
        identifier: identifier,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> onboardMerchant(MerchantOnboardingParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.onboardMerchant(params);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.forgotPassword(email: email);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Forgot password failed', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
    String? email,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.resetPassword(
        token: token,
        password: password,
        confirmPassword: confirmPassword,
        email: email,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Reset password failed', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? businessName,
  }) async {
    if (state.user != null) {
      final updated = state.user!.copyWith(
        name: name,
        phone: phone,
        businessName: businessName,
      );
      state = state.copyWith(user: updated);
      await _repository.persistUser(updated);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
