import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../marketer_profile_models.dart';

class MarketerPerformanceCharts extends StatelessWidget {
  const MarketerPerformanceCharts({super.key, required this.profile});
  final MarketerProfileData profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BarChart(
          title: 'Team Size by Level',
          data: profile.teamSizeByLevel,
          isCurrency: false,
        ),
        const SizedBox(height: AppSpacing.md),
        _BarChart(
          title: 'Sales by Level',
          data: profile.salesByLevel,
          isCurrency: true,
        ),
      ],
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({
    required this.title,
    required this.data,
    required this.isCurrency,
  });
  final String title;
  final List<LevelStat> data;
  final bool isCurrency;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final int maxValue = data.fold(
      0,
      (max, stat) => stat.value > max ? stat.value : max,
    );

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
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...data.map((stat) {
            final double percent = maxValue == 0 ? 0 : stat.value / maxValue;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(stat.name, style: AppTypography.caption),
                      Text(
                        isCurrency
                            ? formatNaira(stat.value / 100)
                            : stat.value.toString(),
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percent,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: isCurrency
                                ? AppColors.success
                                : AppColors.info,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

