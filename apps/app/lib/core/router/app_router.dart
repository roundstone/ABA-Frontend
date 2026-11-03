import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/domain/auth_entities.dart';
import '../notifications/notification_navigation_handler.dart';
import 'app_routes.dart';
import 'router_redirect.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen<AuthState>(authStateProvider, (_, __) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      return appRouterRedirect(context, state, auth);
    },
    routes: buildAppRoutes(rootNavigatorKey),
  );

  ref.listen<AuthState>(authStateProvider, (previous, next) {
    if (previous?.isAuthenticated != next.isAuthenticated ||
        previous?.user?.role != next.user?.role) {
      router.refresh();
    }
  });

  NotificationNavigationHandler.instance.attachRouter(router);
  return router;
});
