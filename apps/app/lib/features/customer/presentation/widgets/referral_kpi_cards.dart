import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/referral_summary_models.dart';

class ReferralKpiCardsRow extends StatelessWidget {
  const ReferralKpiCardsRow({super.key, required this.metrics});
  final ReferralMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReferralKpiCard(
              title: 'Total Network',
              value: metrics.totalNetwork.toString(),
              subtitle: '${metrics.totalNetwork} members',
              icon: HugeIcons.strokeRoundedUserMultiple,
              iconColor: AppColors.primary,
              iconBg: AppColors.primary.withAlpha(25),
            ),
            const SizedBox(width: AppSpacing.md),
            ReferralKpiCard(
              title: 'Active Buyers',
              value: metrics.activeBuyers.toString(),
              subtitle: metrics.totalNetwork > 0
                  ? '${((metrics.activeBuyers / metrics.totalNetwork) * 100).toStringAsFixed(0)}% conversion'
                  : '0% conversion',
              icon: HugeIcons.strokeRoundedTarget01,
              iconColor: AppColors.success,
              iconBg: AppColors.success.withAlpha(25),
            ),
            const SizedBox(width: AppSpacing.md),
            ReferralKpiCard(
              title: 'Total Earned',
              value: formatNaira(metrics.totalEarned.toDouble()),
              subtitle: 'Lifetime',
              icon: HugeIcons.strokeRoundedDollarCircle,
              iconColor: AppColors.warning,
              iconBg: AppColors.warning.withAlpha(25),
            ),
          ],
        ),
      ),
    );
  }
}

class ReferralKpiCard extends StatelessWidget {
  const ReferralKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  final String title;
  final String value;
  final String subtitle;
  final dynamic icon;
  final Color iconColor;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 156,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(icon: icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.label.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: AppTypography.h5.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(color: AppColors.success),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
