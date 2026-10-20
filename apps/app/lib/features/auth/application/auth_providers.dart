import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../data/auth_remote_repository.dart';
import '../domain/auth_entities.dart';
import '../domain/auth_repository.dart';
import 'auth_notifier.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRemoteRepository(dio: dio, prefs: prefs);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository: repo);
});

final currentUserProvider = Provider<AuthUser?>((ref) {
  return ref.watch(authStateProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

final isMerchantProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isMerchant;
});

final userRoleProvider = Provider<UserRole>((ref) {
  return ref.watch(authStateProvider).role;
});
