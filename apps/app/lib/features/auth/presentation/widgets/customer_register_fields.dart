import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Form inputs for Customer Registration (Name, Email, Phone, Password, Referral Code).
class CustomerRegisterFields extends StatelessWidget {
  const CustomerRegisterFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.referralController,
    required this.obscurePassword,
    required this.onToggleObscurePassword,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController referralController;
  final bool obscurePassword;
  final VoidCallback onToggleObscurePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Full Name',
          hintText: 'Enter your full name',
          controller: nameController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedUser,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Email Address',
          hintText: 'Enter your email',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedMail01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Phone Number',
          hintText: 'Enter your phone number',
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
          label: 'Password',
          hintText: 'Create a secure password',
          controller: passwordController,
          obscureText: obscurePassword,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedLockPassword,
            color: AppColors.grey,
            size: 16,
          ),
          suffixIcon: IconButton(
            icon: HugeIcon(
              icon: obscurePassword
                  ? HugeIcons.strokeRoundedView
                  : HugeIcons.strokeRoundedViewOffSlash,
              color: AppColors.grey,
              size: 16,
            ),
            onPressed: onToggleObscurePassword,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Referral Code (Optional)',
          hintText: 'e.g. REF-JANE100',
          controller: referralController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedUserGroup,
            color: AppColors.grey,
            size: 16,
          ),
        ),
      ],
    );
  }
}
