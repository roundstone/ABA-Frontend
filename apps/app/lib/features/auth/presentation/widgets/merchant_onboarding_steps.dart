import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';

class OnboardingStepBusiness extends StatelessWidget {
  const OnboardingStepBusiness({
    super.key,
    required this.nameController,
    required this.typeController,
    required this.rcController,
  });

  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController rcController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Business Name',
          hintText: 'e.g. Aba Leather Artisans Ltd',
          controller: nameController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedStore01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Business Category / Type',
          hintText: 'e.g. Footwear & Leather / Fashion',
          controller: typeController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedTag01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'CAC / RC Number (Optional)',
          hintText: 'e.g. RC-1234567',
          controller: rcController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedDocumentCode,
            color: AppColors.grey,
            size: 16,
          ),
        ),
      ],
    );
  }
}

class OnboardingStepContact extends StatelessWidget {
  const OnboardingStepContact({
    super.key,
    required this.ownerController,
    required this.phoneController,
    required this.emailController,
  });

  final TextEditingController ownerController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Owner / Contact Person Full Name',
          hintText: 'e.g. Emeka Nwosu',
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
          label: 'Business Email Address',
          hintText: 'e.g. emeka@abaleather.com',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedMail01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
      ],
    );
  }
}

class OnboardingStepLocation extends StatelessWidget {
  const OnboardingStepLocation({
    super.key,
    required this.addressController,
    required this.cityController,
    required this.stateController,
  });

  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Street / Workshop Address',
          hintText: 'e.g. 14 Faulks Road, Ariaria Market',
          controller: addressController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedLocation01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'City / Town',
          hintText: 'e.g. Aba',
          controller: cityController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedCity01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'State',
          hintText: 'e.g. Abia',
          controller: stateController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedMapPin,
            color: AppColors.grey,
            size: 16,
          ),
        ),
      ],
    );
  }
}

class OnboardingStepSettlement extends StatelessWidget {
  const OnboardingStepSettlement({
    super.key,
    required this.bankController,
    required this.accountController,
  });

  final TextEditingController bankController;
  final TextEditingController accountController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Bank Name',
          hintText: 'e.g. First Bank of Nigeria / GTBank',
          controller: bankController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedBank,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: '10-Digit NUBAN Account Number',
          hintText: '0123456789',
          controller: accountController,
          keyboardType: TextInputType.number,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedCreditCard,
            color: AppColors.grey,
            size: 16,
          ),
        ),
      ],
    );
  }
}
