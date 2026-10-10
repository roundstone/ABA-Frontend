import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_entities.dart';
import '../domain/auth_repository.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required AuthRepository repository})
      : _repository = repository,
        super(const AuthState()) {
    _checkStoredUser();
  }

  final AuthRepository _repository;

  Future<void> _checkStoredUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.getStoredUser();
      state = state.copyWith(user: user, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> loginCustomer({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.loginCustomer(
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

  Future<bool> registerCustomer(CustomerRegistrationParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.registerCustomer(params);
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

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
