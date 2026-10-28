import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/router/app_router.dart';
import '../domain/auth_entities.dart';
import '../presentation/widgets/session_expired_dialog.dart';
import 'auth_providers.dart';

/// Central coordinator for session expiration events across the app.
/// Ensures that when an unrecoverable 401 is received, a single non-dismissible
/// modal informs the user and routes them to their role-specific login screen.
class SessionExpirationCoordinator {
  SessionExpirationCoordinator(this._ref);

  final Ref _ref;
  bool _isDialogShowing = false;

  bool get isDialogShowing => _isDialogShowing;

  /// Triggered by [TokenRefreshInterceptor] when token refresh fails on 401
  /// or when a session has expired.
  void handleSessionExpired(UserRole role) {
    if (_isDialogShowing) {
      AppLogger.w('[SessionExpiration] Dialog is already active, ignoring duplicate trigger.');
      return;
    }

    _isDialogShowing = true;
    AppLogger.w('[SessionExpiration] Handling session expiration for ${role.name}.');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final context = rootNavigatorKey.currentContext;
      if (context == null || !context.mounted) {
        AppLogger.w('[SessionExpiration] Root navigator context not mounted. Performing direct logout.');
        _isDialogShowing = false;
        await _performLogoutAndRedirect(role);
        return;
      }

      // If user is already on an auth screen, skip redundant dialog
      String? currentLoc;
      try {
        currentLoc = GoRouterState.of(context).matchedLocation;
      } catch (_) {}

      final isAlreadyOnAuth = currentLoc == '/login' ||
          currentLoc == '/login/customer' ||
          currentLoc == '/login/merchant' ||
          currentLoc == '/role-select';

      if (isAlreadyOnAuth) {
        AppLogger.i('[SessionExpiration] User is already on $currentLoc. Skipping dialog.');
        _isDialogShowing = false;
        await _ref.read(authStateProvider.notifier).logout();
        return;
      }

      await showSessionExpiredDialog(
        context: context,
        role: role,
        onConfirmLogin: () async {
          await _performLogoutAndRedirect(role);
        },
      );

      _isDialogShowing = false;
    });
  }

  Future<void> _performLogoutAndRedirect(UserRole role) async {
    try {
      await _ref.read(authStateProvider.notifier).logout();
    } catch (e, stackTrace) {
      AppLogger.w('[SessionExpiration] Error during logout: $e', stackTrace: stackTrace);
    }

    final targetRoute = role == UserRole.merchant ? '/login/merchant' : '/login';
    AppLogger.i('[SessionExpiration] Redirecting expired session to $targetRoute');

    final navCtx = rootNavigatorKey.currentContext;
    if (navCtx != null && navCtx.mounted) {
      navCtx.go(targetRoute);
    }
  }
}

final sessionExpirationCoordinatorProvider =
    Provider<SessionExpirationCoordinator>((ref) {
  return SessionExpirationCoordinator(ref);
});
