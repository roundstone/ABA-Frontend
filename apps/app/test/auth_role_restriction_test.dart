import 'package:app/features/auth/application/auth_notifier.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/auth/domain/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthNotifier Mobile Role Restriction', () {
    test('allows customer role after login and profile', () async {
      expect(UserRole.fromString('market'), UserRole.marketer);
      expect(UserRole.fromString('customer'), UserRole.customer);

      final repo = _FakeAuthRepo(UserRole.customer);
      final notifier = AuthNotifier(repository: repo);

      final ok = await notifier.loginCustomer(
        identifier: 'c@aba.ng',
        password: 'password',
      );
      expect(ok, isTrue);
      expect(notifier.state.isAuthenticated, isTrue);
      expect(notifier.state.errorMessage, isNull);
    });

    test('logs out and sets error when profile role is marketer/market', () async {
      final repo = _FakeAuthRepo(UserRole.marketer);
      final notifier = AuthNotifier(repository: repo);

      final ok = await notifier.loginCustomer(
        identifier: 'm@aba.ng',
        password: 'password',
      );

      expect(ok, isFalse);
      expect(repo.logoutCalls, greaterThanOrEqualTo(1));
      expect(notifier.state.isAuthenticated, isFalse);
      expect(notifier.state.errorMessage, AuthNotifier.disallowedRoleError);
    });

    test('logs out and sets error when profile role is admin', () async {
      final repo = _FakeAuthRepo(UserRole.admin);
      final notifier = AuthNotifier(repository: repo);

      final ok = await notifier.loginCustomer(
        identifier: 'admin@aba.ng',
        password: 'password',
      );

      expect(ok, isFalse);
      expect(repo.logoutCalls, greaterThanOrEqualTo(1));
      expect(notifier.state.isAuthenticated, isFalse);
      expect(notifier.state.errorMessage, AuthNotifier.disallowedRoleError);
    });

    test('fetchProfile logs out and sets error when role is merchant', () async {
      final repo = _FakeAuthRepo(UserRole.customer);
      final notifier = AuthNotifier(repository: repo);
      await notifier.loginCustomer(identifier: 'c@aba.ng', password: 'password');
      expect(notifier.state.isAuthenticated, isTrue);

      repo.profileRole = UserRole.merchant;
      final res = await notifier.fetchProfile();

      expect(res, isNull);
      expect(repo.logoutCalls, greaterThanOrEqualTo(1));
      expect(notifier.state.isAuthenticated, isFalse);
      expect(notifier.state.errorMessage, AuthNotifier.disallowedRoleError);
    });
  });
}

class _FakeAuthRepo implements AuthRepository {
  _FakeAuthRepo(this.profileRole);
  UserRole profileRole;
  int logoutCalls = 0;
  AuthUser? _stored;

  AuthUser _makeUser(UserRole role) => AuthUser(
        id: '1',
        name: 'Test User',
        email: 'test@aba.ng',
        phone: '+2348012345678',
        role: role,
        token: 'jwt',
        createdAt: DateTime(2026),
      );

  @override
  AuthUser? getStoredUserSync() => _stored;

  @override
  Future<AuthUser?> getStoredUser() async => _stored;

  @override
  Future<AuthUser> loginCustomer({
    required String identifier,
    required String password,
  }) async {
    _stored = _makeUser(UserRole.customer);
    return _stored!;
  }

  @override
  Future<AuthUser> getProfile() async {
    _stored = _makeUser(profileRole);
    return _stored!;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
    _stored = null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
