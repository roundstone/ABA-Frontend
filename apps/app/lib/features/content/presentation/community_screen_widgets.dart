import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/content_entities.dart';

/// Informational tile for hierarchy, rewards, and purchasing power.
class CommunityInfoTile extends StatelessWidget {
  const CommunityInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  final dynamic icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white10 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(icon: icon, color: const Color(0xFFC28B38), size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// Expandable FAQ card.
class CommunityFaqCard extends StatelessWidget {
  const CommunityFaqCard({super.key, required this.faq});
  final CommunityFaqItem faq;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(color: isDark ? Colors.white10 : AppColors.border),
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        children: [
          Text(
            faq.answer,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
