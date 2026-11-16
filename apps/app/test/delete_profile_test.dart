import 'package:app/features/auth/application/auth_notifier.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/data/auth_remote_repository.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/auth/domain/auth_repository.dart';
import 'package:app/features/customer/presentation/widgets/settings_dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Delete User Profile', () {
    test('AuthRemoteRepository.deleteProfile calls DELETE /api/v1/profile/mobile-app', () async {
      SharedPreferences.setMockInitialValues({'auth_access_token': 'tok-123'});
      final prefs = await SharedPreferences.getInstance();
      final adapter = _RecordingAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      final repo = AuthRemoteRepository(dio: dio, prefs: prefs);

      await repo.deleteProfile();

      expect(
        adapter.requests.any(
          (r) => r.method == 'DELETE' && r.path == '/api/v1/profile/mobile-app',
        ),
        isTrue,
      );
      expect(prefs.getString('auth_access_token'), isNull);
    });

    testWidgets('showCustomerDeleteAccountDialog deletes profile and navigates to /login', (
      tester,
    ) async {
      final repo = _FakeDeleteRepo();
      final router = GoRouter(
        initialLocation: '/settings',
        routes: [
          GoRoute(
            path: '/settings',
            builder: (context, _) => Consumer(
              builder: (_, ref, __) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => showCustomerDeleteAccountDialog(context, ref),
                  child: const Text('Open Delete'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/login',
            builder: (_, __) => const Scaffold(body: Text('LOGIN_PAGE')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Delete'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(repo.deleted, isTrue);
      expect(find.text('LOGIN_PAGE'), findsOneWidget);
    });
  });
}

class _RecordingAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      '{"success":true,"statusCode":200}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FakeDeleteRepo implements AuthRepository {
  bool deleted = false;
  final AuthUser _user = AuthUser(
    id: '1',
    name: 'Test User',
    email: 'test@aba.ng',
    phone: '+2348012345678',
    role: UserRole.customer,
    token: 'jwt',
    createdAt: DateTime(2026),
  );

  @override
  AuthUser? getStoredUserSync() => deleted ? null : _user;

  @override
  Future<AuthUser?> getStoredUser() async => deleted ? null : _user;

  @override
  Future<void> deleteProfile() async {
    deleted = true;
  }

  @override
  Future<void> logout() async {
    deleted = true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
