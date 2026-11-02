import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../marketer_profile_models.dart';

class MarketerProfileKpis extends StatelessWidget {
  const MarketerProfileKpis({super.key, required this.profile});
  final MarketerProfileData profile;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.2,
      children: [
        _SmallKpiCard(
          title: 'Network Sales',
          value: formatNaira(profile.networkSales / 100),
        ),
        _SmallKpiCard(
          title: 'Personal Sales',
          value: formatNaira(profile.personalSales / 100),
        ),
        _SmallKpiCard(
          title: 'Total Team Size',
          value: profile.totalTeamSize.toString(),
        ),
        _SmallKpiCard(
          title: 'Active Members',
          value: profile.activeMembers.toString(),
        ),
      ],
    );
  }
}

class _SmallKpiCard extends StatelessWidget {
  const _SmallKpiCard({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

