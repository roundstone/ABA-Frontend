import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';

class DashboardOverviewMetrics extends StatelessWidget {
  const DashboardOverviewMetrics({
    super.key,
    required this.activeOrdersCount,
    required this.referralEarned,
    required this.networkMembersCount,
    required this.rewardPoints,
  });

  final int activeOrdersCount;
  final double referralEarned;
  final int networkMembersCount;
  final int rewardPoints;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MetricCard(
              title: 'Pending Orders',
              value: '$activeOrdersCount Active',
              subtitle: 'Track status',
              icon: HugeIcons.strokeRoundedShoppingBag01,
              iconColor: AppColors.info,
              actionLabel: 'Track Orders',
              route: '/account/orders',
            ),
            const SizedBox(width: AppSpacing.md),
            _MetricCard(
              title: 'Referral Earnings',
              value: formatNaira(referralEarned),
              subtitle: 'Network: $networkMembersCount members',
              icon: HugeIcons.strokeRoundedUserMultiple,
              iconColor: AppColors.success,
              actionLabel: 'My Network',
              route: '/referrals',
            ),
            const SizedBox(width: AppSpacing.md),
            _MetricCard(
              title: 'Reward Points',
              value: '$rewardPoints pts',
              subtitle: 'Available points',
              icon: HugeIcons.strokeRoundedAward01,
              iconColor: const Color(0xFFF59E0B),
              actionLabel: 'Redeem Points',
              route: '/rewards',
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.actionLabel,
    required this.route,
  });

  final String title;
  final String value;
  final String subtitle;
  final List<List<dynamic>> icon;
  final Color iconColor;
  final String actionLabel;
  final String route;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: AppSpacing.borderRadiusLG,
        child: Container(
          width: 175,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: AppSpacing.borderRadiusLG,
            border: Border.all(
              color: isDark ? Colors.white12 : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 6),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.caption.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iconColor.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: HugeIcon(icon: icon, color: iconColor, size: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: AppTypography.h5.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  color: cs.onSurfaceVariant,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel,
                    style: AppTypography.caption.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 2),
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    size: 14,
                    color: cs.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
