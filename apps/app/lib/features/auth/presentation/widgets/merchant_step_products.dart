import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';

class MerchantStepProducts extends StatelessWidget {
  const MerchantStepProducts({
    super.key,
    required this.productController,
    required this.capacityController,
    required this.samplePhotosCount,
    required this.onAddPhoto,
  });

  final TextEditingController productController;
  final TextEditingController capacityController;
  final int samplePhotosCount;
  final VoidCallback onAddPhoto;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Primary Products & Specialty Description',
          hintText: 'e.g. Men\'s Handcrafted Leather Oxfords, Loafers & Belts',
          controller: productController,
          maxLines: 2,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedShoppingBag01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Estimated Monthly Supply Capacity',
          hintText: 'e.g. 500 pairs / units per month',
          controller: capacityController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedDeliveryBox01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Quality Standards Notice
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2820) : const Color(0xFFF1F6F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF2C3E30) : const Color(0xFFDCE8DF),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedCamera01,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'BuyNaija Product Quality Standards',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '• High-resolution photos with clear lighting\n• Clean or neutral background showing true craftsmanship\n• Accurate product representation without distortion',
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Photo Upload Grid
        Text(
          'Sample Product Photos ($samplePhotosCount/4 uploaded)',
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white70 : AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: List.generate(4, (index) {
            final hasPhoto = index < samplePhotosCount;
            return Expanded(
              child: GestureDetector(
                onTap: onAddPhoto,
                child: Container(
                  height: 72,
                  margin: EdgeInsets.only(right: index < 3 ? AppSpacing.xs : 0),
                  decoration: BoxDecoration(
                    color: hasPhoto
                        ? AppColors.primary.withAlpha(isDark ? 50 : 25)
                        : (isDark ? const Color(0xFF282828) : AppColors.surface2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasPhoto
                          ? AppColors.primary
                          : (isDark ? Colors.white12 : AppColors.border),
                    ),
                  ),
                  child: Center(
                    child: HugeIcon(
                      icon: hasPhoto
                          ? HugeIcons.strokeRoundedCheckmarkCircle02
                          : HugeIcons.strokeRoundedCamera01,
                      color: hasPhoto ? AppColors.primary : AppColors.grey,
                      size: 22,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
