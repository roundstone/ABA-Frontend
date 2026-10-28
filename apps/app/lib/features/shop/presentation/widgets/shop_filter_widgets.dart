export 'category_tree_widget.dart';
export 'shop_filter_header.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
          const Divider(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: AppSpacing.avatarRadius,
          border: selected
              ? null
              : Border.all(color: cs.outline.withAlpha(80), width: 1),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            color: selected ? Colors.white : cs.onSurface,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class PriceRangeSlider extends StatelessWidget {
  const PriceRangeSlider({
    super.key,
    required this.range,
    required this.onChanged,
  });

  final (double, double) range;
  final ValueChanged<(double, double)> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        RangeSlider(
          values: RangeValues(range.$1, range.$2),
          min: 0,
          max: 500000,
          divisions: 100,
          activeColor: cs.primary,
          labels: RangeLabels(
            '₦${(range.$1 / 1000).toStringAsFixed(0)}k',
            '₦${(range.$2 / 1000).toStringAsFixed(0)}k',
          ),
          onChanged: (v) => onChanged((v.start, v.end)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₦${(range.$1 / 1000).toStringAsFixed(0)}k',
              style: AppTypography.bodySmall,
            ),
            Text(
              '₦${(range.$2 / 1000).toStringAsFixed(0)}k',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
