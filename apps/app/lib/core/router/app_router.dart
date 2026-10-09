import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/customer/presentation/customer_shell.dart';
import '../../features/customer/presentation/dashboard_screen.dart';
import '../../features/customer/presentation/marketer_profile_screen.dart';
import '../../features/customer/presentation/referrals_screen.dart';
import '../../features/shop/presentation/home_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../features/shop/presentation/product_detail_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/account/presentation/orders_screen.dart';
import '../../features/account/presentation/order_detail_screen.dart';
import '../../features/account/presentation/network_screen.dart';
import '../../features/account/presentation/earnings_screen.dart';
import '../../features/merchant/presentation/merchant_dashboard_screen.dart';
import '../../features/merchant/presentation/pos_screen.dart';
import '../../features/merchant/presentation/merchant_orders_screen.dart';
import '../../features/wallet/presentation/wallet_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
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
        path: '/account/dashboard',
        builder: (context, state) => const DashboardScreen(),
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
    ],
  );
});
