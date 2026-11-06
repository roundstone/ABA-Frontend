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
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 0 : 4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatColumn(
                title: 'Total Network',
                value: metrics.totalNetwork.toString(),
                subtitle: '${metrics.totalNetwork} members',
                icon: HugeIcons.strokeRoundedUserMultiple,
                iconColor: AppColors.primary,
                iconBg: AppColors.primary.withAlpha(25),
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: isDark ? Colors.white10 : AppColors.border,
            ),
            Expanded(
              child: _StatColumn(
                title: 'Active Buyers',
                value: metrics.activeBuyers.toString(),
                subtitle: metrics.totalNetwork > 0
                    ? '${((metrics.activeBuyers / metrics.totalNetwork) * 100).toStringAsFixed(0)}% conv'
                    : '0% conv',
                icon: HugeIcons.strokeRoundedTarget01,
                iconColor: AppColors.success,
                iconBg: AppColors.success.withAlpha(25),
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: isDark ? Colors.white10 : AppColors.border,
            ),
            Expanded(
              child: _StatColumn(
                title: 'Total Earned',
                value: formatNaira(metrics.totalEarned.toDouble()),
                subtitle: 'Lifetime',
                icon: HugeIcons.strokeRoundedDollarCircle,
                iconColor: AppColors.warning,
                iconBg: AppColors.warning.withAlpha(25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: HugeIcon(icon: icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.caption.copyWith(
              color: AppColors.success,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
