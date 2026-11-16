import 'package:flutter/material.dart';
import '../../../../core/location/nigeria_location_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Opens a date picker for Date of Birth and writes `YYYY-MM-DD` to [controller].
Future<void> pickDateOfBirth(
  BuildContext context,
  TextEditingController controller,
) async {
  final now = DateTime.now();
  final firstDate = DateTime(1920);
  final lastDate = DateTime(now.year - 16, now.month, now.day);
  final parsed = DateTime.tryParse(controller.text.trim());
  final initial =
      (parsed != null && !parsed.isBefore(firstDate) && !parsed.isAfter(lastDate))
          ? parsed
          : DateTime(1995, 1, 1);
  final picked = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: firstDate,
    lastDate: lastDate,
  );
  if (picked != null && context.mounted) {
    controller.text =
        '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
  }
}

/// Read-only date of birth field that opens a date picker on tap.
class KycDobField extends StatelessWidget {
  const KycDobField({
    super.key,
    required this.controller,
    required this.enabled,
    this.label = 'Date of Birth',
    this.onTap,
  });

  final TextEditingController controller;
  final bool enabled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? (onTap ?? () => pickDateOfBirth(context, controller)) : null,
      child: AbsorbPointer(
        child: AppTextField(
          label: label,
          hintText: 'YYYY-MM-DD',
          controller: controller,
          enabled: enabled,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
      ),
    );
  }
}

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
          KycDobField(
            controller: dobCtrl,
            enabled: isEditable,
            label: 'Date of birth',
            onTap: onPickDob,
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
                child: NigeriaLocationField(
                  label: 'State',
                  hintText: 'Select state',
                  controller: stateCtrl,
                  enabled: isEditable,
                  onChanged: () => lgaCtrl.clear(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          NigeriaLocationField(
            label: 'LGA (optional)',
            hintText: 'Select LGA',
            controller: lgaCtrl,
            stateController: stateCtrl,
            isLga: true,
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
