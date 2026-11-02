import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../marketer_profile_models.dart';

class MarketerProfileHeader extends StatelessWidget {
  const MarketerProfileHeader({
    super.key,
    required this.profile,
    required this.isPublic,
    required this.onPublicChanged,
  });

  final MarketerProfileData profile;
  final bool isPublic;
  final ValueChanged<bool> onPublicChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.green.shade50,
                child: Text(
                  profile.alias.isNotEmpty ? profile.alias[0] : 'A',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.alias,
                      style: AppTypography.h6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Level ${profile.level}',
                            style: AppTypography.caption.copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '•',
                          style: AppTypography.caption.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Joined ${profile.joinedDate?.year ?? "N/A"}',
                          style: AppTypography.caption.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (profile.performancePercentile != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Top ${100 - profile.performancePercentile!}% of peers',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? cs.surfaceContainerHighest : AppColors.background,
              borderRadius: AppSpacing.borderRadiusMD,
              border: Border.all(
                color: isDark ? Colors.transparent : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Public Profile',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Show your aggregated stats at /community/${profile.alias.replaceAll(" ", "").toLowerCase()}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                Switch(value: isPublic, onChanged: onPublicChanged),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

