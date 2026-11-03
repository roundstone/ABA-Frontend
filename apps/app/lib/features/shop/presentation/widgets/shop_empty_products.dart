import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/shop_providers.dart';

class ShopEmptyProducts extends ConsumerWidget {
  const ShopEmptyProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedSearchList01,
            size: AppSpacing.iconSizeXXL,
            color: AppColors.grey,
          ),
          AppSpacing.verticalSpaceMD,
          Text(
            'No products found',
            style: AppTypography.h6.copyWith(color: AppColors.grey),
          ),
          AppSpacing.verticalSpaceXS,
          Text(
            'Try adjusting your filters',
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
          ),
          AppSpacing.verticalSpaceMD,
          TextButton(
            onPressed: () =>
                ref.read(shopNotifierProvider.notifier).resetFilters(),
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}

