import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/role_selection_screen.dart';
import '../../features/auth/presentation/customer_login_screen.dart';
import '../../features/auth/presentation/customer_register_screen.dart';
import '../../features/auth/presentation/merchant_login_screen.dart';
import '../../features/auth/presentation/merchant_onboarding_screen.dart';
import '../../features/customer/presentation/customer_shell.dart';
import '../../features/customer/presentation/dashboard_screen.dart';
import '../../features/customer/presentation/marketer_profile_screen.dart';
import '../../features/customer/presentation/referrals_screen.dart';
import '../../features/shop/presentation/home_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../features/shop/presentation/product_detail_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/checkout/presentation/checkout_success_screen.dart';
import '../../features/account/domain/customer_order.dart';
import '../../features/account/presentation/orders_screen.dart';
import '../../features/account/presentation/order_detail_screen.dart';
import '../../features/account/presentation/network_screen.dart';
import '../../features/account/presentation/earnings_screen.dart';
import '../../features/merchant/presentation/merchant_dashboard_screen.dart';
import '../../features/merchant/presentation/pos_screen.dart';
import '../../features/merchant/presentation/merchant_orders_screen.dart';
import '../../features/wallet/presentation/wallet_screen.dart';
import '../../features/rewards/presentation/rewards_screen.dart';
import '../../features/customer/presentation/notifications_screen.dart';
import '../../features/merchants/presentation/merchant_directory_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isMerchantPortal =
          loc == '/merchant' || loc.startsWith('/merchant/');
      if (isMerchantPortal) {
        final auth = ref.read(authStateProvider);
        if (!auth.isAuthenticated || !auth.isMerchant) {
          return '/login/merchant';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/role-select',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const CustomerLoginScreen(),
      ),
      GoRoute(
        path: '/login/customer',
        redirect: (context, state) => '/login',
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const CustomerRegisterScreen(),
      ),
      GoRoute(
        path: '/register/customer',
        redirect: (context, state) => '/register',
      ),
      GoRoute(
        path: '/login/merchant',
        builder: (context, state) => const MerchantLoginScreen(),
      ),
      GoRoute(
        path: '/merchants/onboarding',
        builder: (context, state) => const MerchantOnboardingScreen(),
      ),

      // ── Customer shell with bottom nav ─────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            CustomerShell(navigationShell: navigationShell),
        branches: [
          // Branch 0 – Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1 – Shop
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shop',
                builder: (context, state) => const ShopScreen(),
              ),
              GoRoute(
                path: '/product/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ProductDetailScreen(id: id, productId: id);
                },
              ),
            ],
          ),
          // Branch 2 – Wallet
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                builder: (context, state) => const WalletScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Standalone routes (no bottom nav) ─────────────────────────────
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/checkout/success',
        builder: (context, state) {
          final order = state.extra as CustomerOrder?;
          return CheckoutSuccessScreen(order: order);
        },
      ),
      GoRoute(
        path: '/account/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/portal/dashboard',
        redirect: (context, state) => '/account/dashboard',
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/account/orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/account/orders/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/account/network',
        builder: (context, state) => const NetworkScreen(),
      ),
      GoRoute(
        path: '/account/earnings',
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: '/referrals',
        builder: (context, state) => const ReferralsScreen(),
      ),
      GoRoute(
        path: '/referrals/profile',
        builder: (context, state) => const MarketerProfileScreen(),
      ),
      GoRoute(
        path: '/rewards',
        builder: (context, state) => const RewardsScreen(),
      ),
      GoRoute(
        path: '/account/rewards',
        redirect: (context, state) => '/rewards',
      ),
      GoRoute(
        path: '/portal/rewards',
        redirect: (context, state) => '/rewards',
      ),
      GoRoute(
        path: '/merchant',
        builder: (context, state) => const MerchantDashboardScreen(),
      ),
      GoRoute(
        path: '/merchant/pos',
        builder: (context, state) => const POSScreen(),
      ),
      GoRoute(
        path: '/merchant/orders',
        builder: (context, state) => const MerchantOrdersScreen(),
      ),
      GoRoute(
        path: '/merchants',
        builder: (context, state) => const MerchantDirectoryScreen(),
      ),
      GoRoute(
        path: '/merchants/directory',
        redirect: (context, state) => '/merchants',
      ),
      GoRoute(
        path: '/businesses',
        redirect: (context, state) => '/merchants',
      ),
    ],
  );
});
