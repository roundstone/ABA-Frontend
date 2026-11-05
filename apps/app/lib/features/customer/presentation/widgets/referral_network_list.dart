import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/referral_summary_models.dart';

class ReferralNetworkList extends StatelessWidget {
  const ReferralNetworkList({super.key, required this.stats});
  final List<ReferralStat> stats;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (stats.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppSpacing.borderRadiusLG,
          border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline,
                size: 40,
                color: isDark ? Colors.white38 : AppColors.grey,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No referrals in your network yet',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? Colors.white60 : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final stat = stats[i];
          final isActive = stat.status.toLowerCase() == 'active';
          final initial = stat.referredUserName.trim().isNotEmpty
              ? stat.referredUserName.trim()[0].toUpperCase()
              : 'U';

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withAlpha(25),
              child: Text(
                initial,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              stat.referredUserName,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              stat.username != null && stat.username!.isNotEmpty
                  ? '@${stat.username} • Level ${stat.level} • ${stat.status}'
                  : 'Level ${stat.level} • ${stat.status}',
              style: AppTypography.caption.copyWith(
                color: isActive ? AppColors.success : cs.onSurfaceVariant,
              ),
            ),
            trailing: Text(
              formatNaira(stat.earnings.toDouble()),
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
