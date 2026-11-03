import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/shop_providers.dart';

class RelatedSearches extends ConsumerWidget {
  const RelatedSearches({super.key, this.onSelect});

  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searches = [
      'Leather bags',
      'Men shoes',
      'Traditional wear',
      'Accessories',
      'Wholesale fabrics',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Searches',
            style: AppTypography.h6.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: searches
                .map(
                  (s) => ActionChip(
                    label: Text(s),
                    onPressed: () {
                      if (onSelect != null) {
                        onSelect!(s);
                      } else {
                        ref.read(shopNotifierProvider.notifier).setSearch(s);
                      }
                    },
                    side: BorderSide(color: AppColors.outline.withAlpha(100)),
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusSM,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

