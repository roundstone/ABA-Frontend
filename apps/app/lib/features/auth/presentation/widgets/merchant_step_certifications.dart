import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'merchant_onboarding_common_widgets.dart';

class MerchantStepCertifications extends StatelessWidget {
  const MerchantStepCertifications({
    super.key,
    required this.certificationType,
    required this.certNumberController,
    required this.certUploaded,
    required this.confirmSupplyCapacity,
    required this.agreeToFulfillmentSla,
    required this.onCertTypeChanged,
    required this.onUploadCert,
    required this.onToggleSupplyCapacity,
    required this.onToggleFulfillmentSla,
  });

  final String certificationType;
  final TextEditingController certNumberController;
  final bool certUploaded;
  final bool confirmSupplyCapacity;
  final bool agreeToFulfillmentSla;
  final ValueChanged<String> onCertTypeChanged;
  final VoidCallback onUploadCert;
  final ValueChanged<bool?> onToggleSupplyCapacity;
  final ValueChanged<bool?> onToggleFulfillmentSla;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: certificationType,
          decoration: const InputDecoration(
            labelText: 'Industry / Product Certification',
          ),
          items: const [
            DropdownMenuItem(
              value: 'None / Artisanal Guild',
              child: Text('None / Artisanal Guild'),
            ),
            DropdownMenuItem(
              value: 'NAFDAC (Regulated Goods)',
              child: Text('NAFDAC (Regulated Goods)'),
            ),
            DropdownMenuItem(
              value: 'SON (Standards Organisation of Nigeria)',
              child: Text('SON (Standards Organisation)'),
            ),
            DropdownMenuItem(
              value: 'NEPC (Export Promotion)',
              child: Text('NEPC (Export Promotion)'),
            ),
          ],
          onChanged: (v) {
            if (v != null) onCertTypeChanged(v);
          },
        ),
        if (certificationType != 'None / Artisanal Guild') ...[
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Certification / Registration Number',
            hintText: 'e.g. NAFDAC-A1-998822 or SON-CAP-456',
            controller: certNumberController,
            prefixIcon: const HugeIcon(
              icon: HugeIcons.strokeRoundedAward01,
              color: AppColors.grey,
              size: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MerchantUploadBox(
            title: 'Upload Certificate Document',
            subtitle: certUploaded
                ? 'certification_verified.pdf'
                : 'Attach valid certificate document',
            isUploaded: certUploaded,
            onTap: onUploadCert,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Operational Verification & SLA Commitment',
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white70 : AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        CheckboxListTile(
          value: confirmSupplyCapacity,
          onChanged: onToggleSupplyCapacity,
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
          title: Text(
            'Supply Capacity Confirmation',
            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            'I confirm that my workshop/store has the operational capacity to fulfill listed products reliably.',
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
          ),
        ),
        CheckboxListTile(
          value: agreeToFulfillmentSla,
          onChanged: onToggleFulfillmentSla,
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
          title: Text(
            'Fulfillment & Dispatch Standards',
            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            'I agree to dispatch orders within 24–48 hours and adhere to BuyNaija buyer protection and packaging rules.',
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
