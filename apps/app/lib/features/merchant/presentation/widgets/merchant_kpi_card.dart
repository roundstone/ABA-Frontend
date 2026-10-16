import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MerchantKpiCard extends StatelessWidget {
  const MerchantKpiCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.badgeText,
    this.isPositiveTrend = true,
    this.onTap,
  });

  final String title;
  final String value;
  final String? subtitle;
  final List<List<dynamic>> icon;
  final Color? iconColor;
  final String? badgeText;
  final bool isPositiveTrend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0);
    final primaryIconColor = iconColor ?? (isDark ? AppColors.secondary : AppColors.primary);

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusLG,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: AppSpacing.borderRadiusLG,
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 30 : 8),
              blurRadius: 10,
              offset: const Offset(0, 3),
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
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primaryIconColor.withAlpha(isDark ? 40 : 25),
                    borderRadius: AppSpacing.borderRadiusSM,
                  ),
                  child: HugeIcon(
                    icon: icon,
                    size: 16,
                    color: primaryIconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            if (badgeText != null)
              Row(
                children: [
                  HugeIcon(
                    icon: isPositiveTrend
                        ? HugeIcons.strokeRoundedArrowUpRight01
                        : HugeIcons.strokeRoundedArrowDownRight01,
                    size: 12,
                    color: isPositiveTrend
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    badgeText!,
                    style: AppTypography.caption.copyWith(
                      color: isPositiveTrend
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              )
            else if (subtitle != null)
              Text(
                subtitle!,
                style: AppTypography.caption.copyWith(
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
