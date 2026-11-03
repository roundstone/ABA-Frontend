import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SellerRatingsSection extends StatelessWidget {
  const SellerRatingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed seller ratings',
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.md),
        const _SellerRatingBar(
          label: 'Accurate description',
          score: 4.6,
          percentage: 92,
        ),
        const SizedBox(height: AppSpacing.sm),
        const _SellerRatingBar(
          label: 'Reasonable shipping cost',
          score: 4.4,
          percentage: 88,
        ),
        const SizedBox(height: AppSpacing.sm),
        const _SellerRatingBar(
          label: 'Shipping speed',
          score: 4.9,
          percentage: 98,
        ),
        const SizedBox(height: AppSpacing.sm),
        const _SellerRatingBar(
          label: 'Communication',
          score: 4.9,
          percentage: 98,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Average for the last 12 months',
          style: AppTypography.label.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SellerRatingBar extends StatelessWidget {
  const _SellerRatingBar({
    required this.label,
    required this.score,
    required this.percentage,
  });

  final String label;
  final double score;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 4,
              child: ClipRRect(
                borderRadius: AppSpacing.borderRadiusXS,
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: cs.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(cs.onSurface),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 24,
              child: Text(
                score.toStringAsFixed(1),
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

