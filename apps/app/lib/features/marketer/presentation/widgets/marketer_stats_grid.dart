import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/marketer_entities.dart';

class MarketerStatsGrid extends StatelessWidget {
  const MarketerStatsGrid({super.key, required this.stats});

  final MarketerStats stats;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance Overview',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withAlpha(50)
                    : AppColors.primary.withAlpha(18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Live Metrics',
                style: TextStyle(
                  color: isDark ? AppColors.secondary : AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                context: context,
                isDark: isDark,
                title: 'Customers Added',
                value: '${stats.totalCustomersAdded}',
                subtitle: '${stats.activeCustomers} currently active',
                icon: HugeIcons.strokeRoundedUserAdd01,
                iconColor: const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildKpiCard(
                context: context,
                isDark: isDark,
                title: 'Total Commission',
                isCurrency: true,
                amount: stats.totalCommissionEarned,
                subtitle: 'Earned to date',
                icon: HugeIcons.strokeRoundedCoins01,
                iconColor: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                context: context,
                isDark: isDark,
                title: 'Referred Orders',
                value: '${stats.ordersByReferred}',
                subtitle: 'Placed by customers',
                icon: HugeIcons.strokeRoundedShoppingBag01,
                iconColor: const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildKpiCard(
                context: context,
                isDark: isDark,
                title: 'Sales Volume',
                isCurrency: true,
                amount: stats.salesVolumeGenerated,
                subtitle: 'Gross referred sales',
                icon: HugeIcons.strokeRoundedAnalytics01,
                iconColor: const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    String? value,
    bool isCurrency = false,
    double? amount,
    required String subtitle,
    required dynamic icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: HugeIcon(icon: icon, color: iconColor, size: 15),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (isCurrency && amount != null)
            Text(
              formatNaira(amount),
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
            )
          else
            Text(
              value ?? '-',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
            ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSubtle,
            ),
          ),
        ],
      ),
    );
  }
}
