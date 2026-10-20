import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'merchant_onboarding_common_widgets.dart';

class MerchantStepIdentity extends StatelessWidget {
  const MerchantStepIdentity({
    super.key,
    required this.ownerController,
    required this.phoneController,
    required this.emailController,
    required this.ninController,
    required this.idType,
    required this.idUploaded,
    required this.onIdTypeChanged,
    required this.onUploadId,
  });

  final TextEditingController ownerController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController ninController;
  final String idType;
  final bool idUploaded;
  final ValueChanged<String> onIdTypeChanged;
  final VoidCallback onUploadId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Owner / Representative Full Name',
          hintText: 'e.g. Emeka Christopher Nwosu',
          controller: ownerController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedUser,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Phone Number',
          hintText: 'e.g. +2348031234567',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedCall,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Business Email',
          hintText: 'e.g. emeka@abaleather.com',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedMail01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: idType,
          decoration: const InputDecoration(
            labelText: 'Identity Document Type',
          ),
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
          onChanged: (v) {
            if (v != null) onIdTypeChanged(v);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'ID / NIN Number',
          hintText: 'e.g. 11-digit NIN or ID number',
          controller: ninController,
          keyboardType: TextInputType.number,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedSecurityCheck,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        MerchantUploadBox(
          title: 'Upload Identification Document',
          subtitle: idUploaded
              ? 'owner_id_document.jpg'
              : 'Upload clear photo or PDF of government ID',
          isUploaded: idUploaded,
          onTap: onUploadId,
        ),
      ],
    );
  }
}
