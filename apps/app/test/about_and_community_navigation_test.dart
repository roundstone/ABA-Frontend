import 'package:app/features/auth/application/auth_notifier.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/content/presentation/about_screen.dart';
import 'package:app/features/content/presentation/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _StaticAuthNotifier extends StateNotifier<AuthState>
    implements AuthNotifier {
  _StaticAuthNotifier(super.state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _testUser = AuthUser(
  id: 'usr_1',
  email: 'test@example.com',
  name: 'Test User',
  phone: '+2348012345678',
  role: UserRole.customer,
  token: 'jwt_token',
  createdAt: DateTime.now(),
);

void main() {
  group('CommunityScreen Auth State Tests', () {
    testWidgets(
        'shows Join the Community button when unauthenticated and redirects to /login',
        (tester) async {
      String? navigatedRoute;

      final router = GoRouter(
        initialLocation: '/community',
        routes: [
          GoRoute(
            path: '/community',
            builder: (context, state) => const CommunityScreen(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              navigatedRoute = '/login';
              return const Scaffold(body: Text('Login Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => _StaticAuthNotifier(const AuthState(user: null)),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final joinButtonFinder = find.text('Join the Community');
      expect(joinButtonFinder, findsOneWidget);

      await tester.ensureVisible(joinButtonFinder);
      await tester.tap(joinButtonFinder);
      await tester.pumpAndSettle();

      expect(navigatedRoute, equals('/login'));
    });

    testWidgets(
        'hides Join the Community button when authenticated',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => _StaticAuthNotifier(AuthState(user: _testUser)),
            ),
          ],
          child: const MaterialApp(
            home: CommunityScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Join the Community'), findsNothing);
    });
  });

  group('AboutScreen Auth Navigation Tests', () {
    testWidgets(
        'Start Shopping redirects to /login when unauthenticated',
        (tester) async {
      String? navigatedRoute;

      final router = GoRouter(
        initialLocation: '/about',
        routes: [
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              navigatedRoute = '/login';
              return const Scaffold(body: Text('Login Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => _StaticAuthNotifier(const AuthState(user: null)),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final startShoppingFinder = find.text('Start Shopping');
      expect(startShoppingFinder, findsOneWidget);

      await tester.ensureVisible(startShoppingFinder);
      await tester.tap(startShoppingFinder);
      await tester.pumpAndSettle();

      expect(navigatedRoute, equals('/login'));
    });

    testWidgets(
        'Start Shopping redirects to /shop when authenticated',
        (tester) async {
      String? navigatedRoute;

      final router = GoRouter(
        initialLocation: '/about',
        routes: [
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            path: '/shop',
            builder: (context, state) {
              navigatedRoute = '/shop';
              return const Scaffold(body: Text('Shop Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => _StaticAuthNotifier(AuthState(user: _testUser)),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final startShoppingFinder = find.text('Start Shopping');
      expect(startShoppingFinder, findsOneWidget);

      await tester.ensureVisible(startShoppingFinder);
      await tester.tap(startShoppingFinder);
      await tester.pumpAndSettle();

      expect(navigatedRoute, equals('/shop'));
    });
  });
}
