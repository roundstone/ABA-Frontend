import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ReferralKycStepView extends StatelessWidget {
  const ReferralKycStepView({
    super.key,
    required this.idType,
    required this.ninController,
    required this.idUploaded,
    required this.addressUploaded,
    required this.onIdTypeChanged,
    required this.onUploadId,
    required this.onUploadAddress,
    required this.onSubmit,
  });

  final String idType;
  final TextEditingController ninController;
  final bool idUploaded;
  final bool addressUploaded;
  final ValueChanged<String> onIdTypeChanged;
  final VoidCallback onUploadId;
  final VoidCallback onUploadAddress;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs + 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedUserCheck01,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Step 1 of 2: KYC Verification',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Provide identity and address proof to activate referral commission eligibility. Users who only shop can skip this.',
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        DropdownButtonFormField<String>(
          initialValue: idType,
          decoration: const InputDecoration(labelText: 'Identification Type'),
          items: const [
            DropdownMenuItem(
              value: 'National Identity Number (NIN)',
              child: Text('National Identity Number (NIN)'),
            ),
            DropdownMenuItem(
              value: 'Voter\'s Card',
              child: Text('Voter\'s Card'),
            ),
            DropdownMenuItem(
              value: 'Driver\'s License',
              child: Text('Driver\'s License'),
            ),
          ],
          onChanged: (v) {
            if (v != null) onIdTypeChanged(v);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'ID / NIN Number (11 Digits)',
          hintText: 'e.g. 12345678901',
          controller: ninController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.md),
        _uploadTile(
          title: 'Proof of Identity (Government ID)',
          fileName: idUploaded ? 'nin_slip_verified.jpg' : null,
          onTap: onUploadId,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        _uploadTile(
          title: 'Proof of Address (Utility Bill)',
          fileName: addressUploaded ? 'electric_bill.pdf' : null,
          onTap: onUploadAddress,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          label: 'Continue to Activation Fee',
          onPressed: onSubmit,
        ),
      ],
    );
  }

  Widget _uploadTile({
    required String title,
    required String? fileName,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF282828) : AppColors.surface2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? Colors.white10 : AppColors.border),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: fileName != null
                  ? HugeIcons.strokeRoundedCheckmarkCircle02
                  : HugeIcons.strokeRoundedUpload01,
              color: fileName != null ? AppColors.success : AppColors.grey,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    fileName ?? 'Tap to select document',
                    style: AppTypography.caption.copyWith(
                      color: fileName != null
                          ? AppColors.success
                          : (isDark ? Colors.white38 : AppColors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
