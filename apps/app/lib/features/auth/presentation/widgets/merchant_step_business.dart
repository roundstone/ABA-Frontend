import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'merchant_onboarding_common_widgets.dart';

class MerchantStepBusiness extends StatelessWidget {
  const MerchantStepBusiness({
    super.key,
    required this.nameController,
    required this.typeController,
    required this.rcController,
    required this.isProvisional,
    required this.cacUploaded,
    required this.onProvisionalChanged,
    required this.onUploadCac,
  });

  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController rcController;
  final bool isProvisional;
  final bool cacUploaded;
  final ValueChanged<bool> onProvisionalChanged;
  final VoidCallback onUploadCac;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Registered Business / Brand Name',
          hintText: 'e.g. Aba Leathercraft Artisans Ltd',
          controller: nameController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedStore01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Primary Business Industry / Category',
          hintText: 'e.g. Footwear & Leather / Fashion & Apparel',
          controller: typeController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedTag01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'CAC Registration Status',
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white70 : AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: MerchantSelectionChip(
                label: 'CAC Registered',
                isSelected: !isProvisional,
                icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                onTap: () => onProvisionalChanged(false),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: MerchantSelectionChip(
                label: 'Provisional (60 Days)',
                isSelected: isProvisional,
                icon: HugeIcons.strokeRoundedHourglass,
                onTap: () => onProvisionalChanged(true),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (!isProvisional) ...[
          AppTextField(
            label: 'CAC RC / Business Number (BN)',
            hintText: 'e.g. RC-1234567 or BN-987654',
            controller: rcController,
            prefixIcon: const HugeIcon(
              icon: HugeIcons.strokeRoundedDocumentCode,
              color: AppColors.grey,
              size: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MerchantUploadBox(
            title: 'CAC Certificate or Status Report',
            subtitle: cacUploaded
                ? 'cac_certificate_verified.pdf'
                : 'Upload proof of business registration',
            isUploaded: cacUploaded,
            onTap: onUploadCac,
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFC28B38).withAlpha(isDark ? 30 : 15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFC28B38).withAlpha(isDark ? 90 : 60),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedHourglass,
                  color: Color(0xFFC28B38),
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Provisional Registration (60-Day Grace Period)',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFC28B38),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'No CAC registration yet? You can sell temporarily under provisional status. You have 60 days to complete your registration and submit documents to retain verified merchant privileges.',
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
