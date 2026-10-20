import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Reusable card showcasing one of the three core platform pillars.
class AboutPillarCard extends StatelessWidget {
  const AboutPillarCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonLabel,
    required this.onTap,
    required this.accentColor,
  });

  final dynamic icon;
  final String title;
  final String subtitle;
  final String description;
  final String buttonLabel;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusXL,
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 8),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(isDark ? 60 : 30),
                  borderRadius: AppSpacing.borderRadiusMD,
                ),
                child: Center(
                  child: HugeIcon(
                    icon: icon,
                    color: accentColor,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h4.copyWith(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: accentColor,
                size: 16,
              ),
              label: Text(
                buttonLabel,
                style: AppTypography.bodyMedium.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
