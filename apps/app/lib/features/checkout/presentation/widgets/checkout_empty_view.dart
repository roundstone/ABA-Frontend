import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class CheckoutEmptyView extends StatelessWidget {
  const CheckoutEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedShoppingCart01,
              color: AppColors.grey,
              size: 56,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Your cart is empty',
              style: AppTypography.h5.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Add items to your cart before proceeding to checkout.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: 'Explore Shop',
              isFullWidth: false,
              onPressed: () => context.go('/shop'),
            ),
          ],
        ),
      ),
    );
  }
}

