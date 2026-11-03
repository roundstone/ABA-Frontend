import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/auth_entities.dart';
import '../../features/cart/domain/entities/cart_entities.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/role_selection_screen.dart';
import '../../features/auth/presentation/customer_login_screen.dart';
import '../../features/auth/presentation/customer_register_screen.dart';
import '../../features/auth/presentation/merchant_login_screen.dart';
import '../../features/auth/presentation/marketer_login_screen.dart';
import '../../features/auth/presentation/merchant_onboarding_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/marketer/presentation/marketer_dashboard_screen.dart';
import '../../features/marketer/presentation/marketer_add_customer_screen.dart';
import '../../features/marketer/presentation/marketer_merchant_profile_screen.dart';
import '../../features/customer/presentation/customer_shell.dart';
import '../../features/customer/presentation/dashboard_screen.dart';
import '../../features/customer/presentation/marketer_profile_screen.dart';
import '../../features/customer/presentation/referrals_screen.dart';
import '../../features/customer/presentation/commission_ledger_screen.dart';
import '../../features/shop/presentation/home_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../features/shop/presentation/product_detail_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/checkout/presentation/checkout_success_screen.dart';
import '../../features/account/domain/customer_order.dart';
import '../../features/account/presentation/orders_screen.dart';
import '../../features/account/presentation/order_detail_screen.dart';
import '../../features/account/presentation/saved_addresses_screen.dart';
import '../../features/customer/presentation/settings_screen.dart';
import '../../features/merchant/presentation/merchant_dashboard_screen.dart';
import '../../features/merchant/presentation/merchant_products_screen.dart';
import '../../features/merchant/presentation/pos_screen.dart';
import '../../features/merchant/presentation/merchant_orders_screen.dart';
import '../../features/merchant/presentation/merchant_order_detail_screen.dart';
import '../../features/wallet/presentation/wallet_screen.dart';
import '../../features/rewards/presentation/rewards_screen.dart';
import '../../features/customer/presentation/notifications_screen.dart';
import '../../features/merchants/presentation/merchant_directory_screen.dart';
import '../../features/merchants/presentation/merchant_detail_screen.dart';
import '../../features/content/presentation/about_screen.dart';
import '../../features/wishlist/presentation/wishlist_screen.dart';
import '../../features/content/presentation/community_screen.dart';
import '../../features/content/presentation/community_profile_screen.dart';

List<RouteBase> buildAppRoutes(GlobalKey<NavigatorState> rootKey) => [
  GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
  GoRoute(path: '/role-select', builder: (_, __) => const RoleSelectionScreen()),
  GoRoute(path: '/login', builder: (_, __) => const CustomerLoginScreen()),
  GoRoute(path: '/login/customer', redirect: (_, __) => '/login'),
  GoRoute(path: '/register', builder: (_, __) => const CustomerRegisterScreen()),
  GoRoute(path: '/register/customer', redirect: (_, __) => '/register'),
  GoRoute(path: '/login/merchant', builder: (_, __) => const MerchantLoginScreen()),
  GoRoute(path: '/merchants/onboarding', builder: (_, __) => const MerchantOnboardingScreen()),
  GoRoute(path: '/login/marketer', builder: (_, __) => const MarketerLoginScreen()),
  GoRoute(
    path: '/forgot-password',
    builder: (_, s) => ForgotPasswordScreen(
      role: UserRole.fromString(s.uri.queryParameters['role']),
      initialEmail: s.uri.queryParameters['email'],
    ),
  ),
  GoRoute(
    path: '/reset-password',
    builder: (_, s) => ResetPasswordScreen(
      role: UserRole.fromString(s.uri.queryParameters['role']),
      initialEmail: s.uri.queryParameters['email'],
      initialToken: s.uri.queryParameters['token'],
    ),
  ),
  // ── Customer shell with bottom nav ──
  StatefulShellRoute.indexedStack(
    builder: (_, __, shell) => CustomerShell(navigationShell: shell),
    branches: [
      StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, __) => const HomeScreen())]),
      StatefulShellBranch(routes: [GoRoute(path: '/shop', builder: (_, __) => const ShopScreen())]),
      StatefulShellBranch(routes: [GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen())]),
    ],
  ),
  // ── Standalone / Detail routes (mounted directly on root navigator) ──
  GoRoute(
    path: '/product/:id',
    parentNavigatorKey: rootKey,
    builder: (_, s) {
      final extraId = s.extra is String ? s.extra as String : null;
      final pathId = s.pathParameters['id']!;
      final resolvedId = (extraId != null && int.tryParse(extraId) != null) ? extraId : pathId;
      return ProductDetailScreen(id: resolvedId, productId: resolvedId);
    },
  ),
  GoRoute(path: '/cart', parentNavigatorKey: rootKey, builder: (_, __) => const CartScreen()),
  GoRoute(
    path: '/checkout',
    parentNavigatorKey: rootKey,
    builder: (_, s) => CheckoutScreen(
      directCart: s.extra is Cart ? s.extra as Cart : null,
    ),
  ),
  GoRoute(
    path: '/checkout/success',
    parentNavigatorKey: rootKey,
    builder: (_, s) => CheckoutSuccessScreen(order: s.extra as CustomerOrder?),
  ),
  GoRoute(path: '/account/dashboard', parentNavigatorKey: rootKey, builder: (_, __) => const DashboardScreen()),
  GoRoute(path: '/portal/dashboard', redirect: (_, __) => '/account/dashboard'),
  GoRoute(path: '/notifications', parentNavigatorKey: rootKey, builder: (_, __) => const NotificationsScreen()),
  GoRoute(path: '/account/orders', parentNavigatorKey: rootKey, builder: (_, __) => const OrdersScreen()),
  GoRoute(
    path: '/account/orders/:id',
    parentNavigatorKey: rootKey,
    builder: (_, s) => OrderDetailScreen(orderId: s.pathParameters['id']!),
  ),
  GoRoute(path: '/account/network', redirect: (_, __) => '/referrals/profile'),
  GoRoute(path: '/account/earnings', redirect: (_, __) => '/referrals'),
  GoRoute(path: '/account/addresses', parentNavigatorKey: rootKey, builder: (_, __) => const SavedAddressesScreen()),
  GoRoute(path: '/wishlist', parentNavigatorKey: rootKey, builder: (_, __) => const WishlistScreen()),
  GoRoute(path: '/account/wishlist', redirect: (_, __) => '/wishlist'),
  GoRoute(path: '/settings', parentNavigatorKey: rootKey, builder: (_, __) => const SettingsScreen()),
  GoRoute(path: '/referrals', parentNavigatorKey: rootKey, builder: (_, __) => const ReferralsScreen()),
  GoRoute(path: '/referrals/profile', parentNavigatorKey: rootKey, builder: (_, __) => const MarketerProfileScreen()),
  GoRoute(path: '/referrals/ledger', parentNavigatorKey: rootKey, builder: (_, __) => const CommissionLedgerScreen()),
  GoRoute(path: '/account/ledger', redirect: (_, __) => '/referrals/ledger'),
  GoRoute(path: '/rewards', parentNavigatorKey: rootKey, builder: (_, __) => const RewardsScreen()),
  GoRoute(path: '/account/rewards', redirect: (_, __) => '/rewards'),
  GoRoute(path: '/portal/rewards', redirect: (_, __) => '/rewards'),
  GoRoute(path: '/marketer', parentNavigatorKey: rootKey, builder: (_, __) => const MarketerDashboardScreen()),
  GoRoute(path: '/marketer/dashboard', redirect: (_, __) => '/marketer'),
  GoRoute(path: '/marketer/add-customer', parentNavigatorKey: rootKey, builder: (_, __) => const MarketerAddCustomerScreen()),
  GoRoute(path: '/marketer/merchant', parentNavigatorKey: rootKey, builder: (_, __) => const MarketerMerchantProfileScreen()),
  GoRoute(path: '/merchant', parentNavigatorKey: rootKey, builder: (_, __) => const MerchantDashboardScreen()),
  GoRoute(path: '/merchant/dashboard', redirect: (_, __) => '/merchant'),
  GoRoute(path: '/merchant/products', parentNavigatorKey: rootKey, builder: (_, __) => const MerchantProductsScreen()),
  GoRoute(path: '/merchant/pos', parentNavigatorKey: rootKey, builder: (_, __) => const POSScreen()),
  GoRoute(path: '/merchant/orders', parentNavigatorKey: rootKey, builder: (_, __) => const MerchantOrdersScreen()),
  GoRoute(
    path: '/merchant/orders/:id',
    parentNavigatorKey: rootKey,
    builder: (_, s) => MerchantOrderDetailScreen(orderId: s.pathParameters['id']!),
  ),
  GoRoute(path: '/merchants', parentNavigatorKey: rootKey, builder: (_, __) => const MerchantDirectoryScreen()),
  GoRoute(
    path: '/merchants/:id',
    parentNavigatorKey: rootKey,
    builder: (_, s) => MerchantDetailScreen(merchantId: s.pathParameters['id']!),
  ),
  GoRoute(path: '/merchants/directory', redirect: (_, __) => '/merchants'),
  GoRoute(path: '/businesses', redirect: (_, __) => '/merchants'),
  GoRoute(path: '/about', parentNavigatorKey: rootKey, builder: (_, __) => const AboutScreen()),
  GoRoute(path: '/community', parentNavigatorKey: rootKey, builder: (_, __) => const CommunityScreen()),
  GoRoute(
    path: '/community/:handle',
    parentNavigatorKey: rootKey,
    builder: (_, s) => CommunityProfileScreen(handle: s.pathParameters['handle'] ?? ''),
  ),
];

