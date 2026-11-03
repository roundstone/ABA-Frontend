import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/auth/application/auth_notifier.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/domain/auth_entities.dart';

void main() {
  testWidgets('Router navigation across shell and standalone routes does not duplicate keys', (tester) async {
    final user = AuthUser(
      id: 'u1',
      email: 'test@example.com',
      role: UserRole.customer,
      name: 'Test Customer',
      phone: '+2348000000000',
      token: 'jwt_token',
      createdAt: DateTime.now(),
    );
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith((ref) => _StaticAuthNotifier(AuthState(user: user))),
      ],
    );

    final router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Start on Home inside shell
    router.go('/home');
    await tester.pumpAndSettle();

    // 2. Push merchant detail from home
    router.push('/merchants/mer-1');
    await tester.pumpAndSettle();

    // 3. Push product from merchant detail (root navigator to product)
    router.push('/product/prod-1');
    await tester.pumpAndSettle();

    // 4. Push nested product from product detail
    router.push('/product/prod-2');
    await tester.pumpAndSettle();

    // 5. Pop back to merchant detail
    router.pop();
    await tester.pumpAndSettle();
    router.pop();
    await tester.pumpAndSettle();

    // 6. Pop back to home
    router.pop();
    await tester.pumpAndSettle();

    // Verify still on /home without key reservation crashes
    expect(router.routerDelegate.currentConfiguration.uri.path, '/home');
  });
}

class _StaticAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  _StaticAuthNotifier(super.state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
