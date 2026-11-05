import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.idFileName,
    this.addressFileName,
    this.dobController,
    this.nationalityController,
    this.addressController,
    this.cityController,
    this.stateController,
    this.lgaController,
    this.isSubmitting = false,
  });

  final String idType;
  final TextEditingController ninController;
  final bool idUploaded;
  final bool addressUploaded;
  final ValueChanged<String> onIdTypeChanged;
  final VoidCallback onUploadId;
  final VoidCallback onUploadAddress;
  final VoidCallback onSubmit;
  final String? idFileName;
  final String? addressFileName;
  final TextEditingController? dobController;
  final TextEditingController? nationalityController;
  final TextEditingController? addressController;
  final TextEditingController? cityController;
  final TextEditingController? stateController;
  final TextEditingController? lgaController;
  final bool isSubmitting;

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
            Expanded(
              child: Text(
                'Step 1 of 2: KYC Verification',
                style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
              ),
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
            DropdownMenuItem(
              value: 'International Passport',
              child: Text('International Passport'),
            ),
          ],
          onChanged: isSubmitting
              ? null
              : (v) {
                  if (v != null) onIdTypeChanged(v);
                },
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'ID / NIN Number (11 Digits)',
          hintText: 'e.g. 12345678901',
          controller: ninController,
          keyboardType: TextInputType.number,
          maxLength: 11,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          enabled: !isSubmitting,
        ),
        if (dobController != null && addressController != null) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Date of Birth',
                  hintText: 'YYYY-MM-DD',
                  controller: dobController,
                  enabled: !isSubmitting,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  label: 'Nationality',
                  hintText: 'Nigerian',
                  controller: nationalityController,
                  enabled: !isSubmitting,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Residential Address',
            hintText: '14 Admiralty Way',
            controller: addressController,
            enabled: !isSubmitting,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'City',
                  hintText: 'Lekki',
                  controller: cityController,
                  enabled: !isSubmitting,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: AppTextField(
                  label: 'State',
                  hintText: 'Lagos',
                  controller: stateController,
                  enabled: !isSubmitting,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: AppTextField(
                  label: 'LGA',
                  hintText: 'Eti Osa',
                  controller: lgaController,
                  enabled: !isSubmitting,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        _uploadTile(
          title: 'Proof of Identity (Government ID)',
          fileName: idUploaded
              ? (idFileName ?? 'nin_slip_verified.png')
              : null,
          onTap: onUploadId,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        _uploadTile(
          title: 'Proof of Address (Utility Bill)',
          fileName: addressUploaded
              ? (addressFileName ?? 'electric_bill.png')
              : null,
          onTap: onUploadAddress,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          label: isSubmitting
              ? 'Submitting KYC...'
              : 'Continue to Activation Fee',
          isLoading: isSubmitting,
          onPressed: isSubmitting ? null : onSubmit,
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
      onTap: isSubmitting ? null : onTap,
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
