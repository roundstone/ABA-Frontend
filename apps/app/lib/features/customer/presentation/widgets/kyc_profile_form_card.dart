import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class KycProfileFormCard extends StatelessWidget {
  const KycProfileFormCard({
    super.key,
    required this.dobCtrl,
    required this.nationalityCtrl,
    required this.addressCtrl,
    required this.cityCtrl,
    required this.stateCtrl,
    required this.lgaCtrl,
    required this.isEditable,
    required this.canSubmit,
    required this.isSaving,
    required this.isSubmitting,
    required this.onPickDob,
    required this.onSave,
    required this.onSubmit,
  });

  final TextEditingController dobCtrl;
  final TextEditingController nationalityCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController stateCtrl;
  final TextEditingController lgaCtrl;
  final bool isEditable;
  final bool canSubmit;
  final bool isSaving;
  final bool isSubmitting;
  final VoidCallback onPickDob;
  final VoidCallback onSave;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Personal and address details',
            style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: isEditable ? onPickDob : null,
            child: AbsorbPointer(
              child: AppTextField(
                label: 'Date of birth',
                hintText: 'YYYY-MM-DD',
                controller: dobCtrl,
                enabled: isEditable,
                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Nationality',
            controller: nationalityCtrl,
            enabled: isEditable,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Residential address',
            controller: addressCtrl,
            enabled: isEditable,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'City',
                  controller: cityCtrl,
                  enabled: isEditable,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  label: 'State',
                  controller: stateCtrl,
                  enabled: isEditable,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'LGA (optional)',
            controller: lgaCtrl,
            enabled: isEditable,
          ),
          if (isEditable) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton.primary(
                    label: isSaving ? 'Saving...' : 'Save profile',
                    isLoading: isSaving,
                    onPressed: isSaving ? null : onSave,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton.outlined(
                    label: isSubmitting ? 'Submitting...' : 'Submit for review',
                    isLoading: isSubmitting,
                    onPressed: (!canSubmit || isSubmitting) ? null : onSubmit,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
