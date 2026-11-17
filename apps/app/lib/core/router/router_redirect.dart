import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/auth_entities.dart';

/// Top-level router redirect logic that handles route guarding,
/// public route access, role-based portal enforcement, and auth redirects.
String? appRouterRedirect(
  BuildContext context,
  GoRouterState state,
  AuthState auth,
) {
  final loc = state.matchedLocation;

  final isPublicRoute = loc == '/splash' ||
      loc == '/login' ||
      loc == '/login/customer' ||
      loc == '/login/merchant' ||
      loc == '/register' ||
      loc == '/register/customer' ||
      loc == '/merchants/onboarding' ||
      loc == '/forgot-password' ||
      loc == '/reset-password' ||
      loc == '/about' ||
      loc == '/community' ||
      loc.startsWith('/community/');

  if (!auth.isAuthenticated) {
    if (loc == '/merchant' || loc.startsWith('/merchant/')) {
      return '/login/merchant';
    }
    if (!isPublicRoute) {
      return '/login';
    }
    return null;
  }

  final isMerchantPortal =
      loc == '/merchant' || loc.startsWith('/merchant/');
  if (isMerchantPortal && !auth.isMerchant) {
    return '/home';
  }

  final isAuthScreen = loc == '/login' ||
      loc == '/login/customer' ||
      loc == '/login/merchant' ||
      loc == '/register' ||
      loc == '/register/customer';

  if (isAuthScreen) {
    if (auth.isMerchant) return '/merchant';
    return '/home';
  }

  return null;
}

