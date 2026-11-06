// ignore_for_file: use_build_context_synchronously
import 'package:app/features/auth/presentation/utils/auth_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/application/auth_providers.dart';

class MoreMenuItem {
  const MoreMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    this.route,
    this.onTap,
  });

  final dynamic icon;
  final String label;
  final Color color;
  final String? route;
  final void Function(BuildContext context)? onTap;
}

List<MoreMenuItem> buildMoreMenuItems({
  required BuildContext context,
  required bool isMerchant,
  bool isMarketer = false,
  required WidgetRef ref,
}) {
  final logoutItem = _buildLogoutItem(ref);

  if (isMarketer) {
    return [
      const MoreMenuItem(
        icon: HugeIcons.strokeRoundedNotification01,
        label: 'Notifications',
        color: Color(0xFF6366F1),
        route: '/notifications',
      ),
      const MoreMenuItem(
        icon: HugeIcons.strokeRoundedNetwork,
        label: 'Referrals',
        color: Color(0xFFEC4899),
        route: '/referrals',
      ),
      const MoreMenuItem(
        icon: HugeIcons.strokeRoundedAward01,
        label: 'Reward Points',
        color: Color(0xFFF59E0B),
        route: '/rewards',
      ),
      const MoreMenuItem(
        icon: HugeIcons.strokeRoundedSettings01,
        label: 'Settings',
        color: Color(0xFF64748B),
        route: '/settings',
      ),
      logoutItem,
    ];
  }

  return [
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedDashboardSquare02,
      label: 'My Account',
      color: Color(0xFF3B82F6),
      route: '/account/dashboard',
    ),
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedNotification01,
      label: 'Notifications',
      color: Color(0xFF6366F1),
      route: '/notifications',
    ),
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedStore01,
      label: 'Businesses',
      color: Color(0xFF10B981),
      route: '/merchants',
    ),
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedUserGroup,
      label: 'Community',
      color: Color(0xFFC28B38),
      route: '/community',
    ),
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedAward01,
      label: 'Reward Points',
      color: Color(0xFFF59E0B),
      route: '/rewards',
    ),
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedNetwork,
      label: 'Referrals',
      color: Color(0xFFEC4899),
      route: '/referrals',
    ),
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedShoppingBag01,
      label: 'My Orders',
      color: AppColors.primary,
      route: '/account/orders',
    ),
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedFavourite,
      label: 'Wishlist',
      color: Color(0xFFEF4444),
      route: '/wishlist',
    ),
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedInformationCircle,
      label: 'About Us',
      color: Color(0xFF0284C7),
      route: '/about',
    ),
    MoreMenuItem(
      icon: isMerchant
          ? HugeIcons.strokeRoundedStore01
          : HugeIcons.strokeRoundedLocation01,
      label: isMerchant ? 'Merchant Hub' : 'Saved Address',
      color: const Color(0xFF8B5CF6),
      route: isMerchant ? '/merchant' : '/account/addresses',
    ),
    const MoreMenuItem(
      icon: HugeIcons.strokeRoundedSettings01,
      label: 'Settings',
      color: Color(0xFF64748B),
      route: '/settings',
    ),
    logoutItem,
  ];
}

MoreMenuItem _buildLogoutItem(WidgetRef ref) => MoreMenuItem(
  icon: HugeIcons.strokeRoundedLogout01,
  label: 'Logout',
  color: AppColors.error,
  onTap: (ctx) async {
    await confirmLogout(ctx, ref);
  },
);
