import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  static const _actions = [
    _QuickActionItem(
      label: 'My Orders',
      icon: HugeIcons.strokeRoundedShoppingBag01,
      color: AppColors.primary,
      route: '/account/orders',
    ),
    _QuickActionItem(
      label: 'My Wallet',
      icon: HugeIcons.strokeRoundedWallet01,
      color: Color(0xFF10B981),
      route: '/wallet',
    ),
    _QuickActionItem(
      label: 'Referrals',
      icon: HugeIcons.strokeRoundedUserMultiple,
      color: Color(0xFFEC4899),
      route: '/referrals',
    ),
    _QuickActionItem(
      label: 'Rewards',
      icon: HugeIcons.strokeRoundedAward01,
      color: Color(0xFFF59E0B),
      route: '/rewards',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _QuickActionButton(item: action),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String label;
  final List<List<dynamic>> icon;
  final Color color;
  final String route;
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.item});
  final _QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: cs.surface,
      borderRadius: AppSpacing.borderRadiusMD,
      child: InkWell(
        onTap: () {
          if (item.route == '/wallet') {
            context.go('/wallet');
          } else {
            context.push(item.route);
          }
        },
        borderRadius: AppSpacing.borderRadiusMD,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusMD,
            border: Border.all(
              color: isDark ? Colors.white12 : AppColors.border,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.color.withAlpha(isDark ? 35 : 20),
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
                child: Center(
                  child: HugeIcon(
                    icon: item.icon,
                    color: item.color,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                item.label,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
