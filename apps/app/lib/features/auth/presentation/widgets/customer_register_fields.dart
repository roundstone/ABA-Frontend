import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'referral_signup_field.dart';

class CustomerRegisterFields extends StatefulWidget {
  const CustomerRegisterFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.referralController,
    required this.obscurePassword,
    required this.onToggleObscurePassword,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController referralController;
  final bool obscurePassword;
  final VoidCallback onToggleObscurePassword;

  @override
  State<CustomerRegisterFields> createState() => _CustomerRegisterFieldsState();
}

class _CustomerRegisterFieldsState extends State<CustomerRegisterFields> {
  bool get _hasMinLength => widget.passwordController.text.length >= 8;

  bool get _hasLettersAndNumbers {
    final password = widget.passwordController.text;

    return RegExp(r'[A-Za-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  bool get _passwordsMatch =>
      widget.confirmPasswordController.text.isNotEmpty &&
      widget.passwordController.text == widget.confirmPasswordController.text;

  @override
  void initState() {
    super.initState();

    widget.passwordController.addListener(_refreshPasswordState);
    widget.confirmPasswordController.addListener(_refreshPasswordState);
  }

  void _refreshPasswordState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_refreshPasswordState);
    widget.confirmPasswordController.removeListener(_refreshPasswordState);
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Please enter your full name.';
    }

    final parts = name.split(RegExp(r'\s+'));

    if (parts.length < 2 || parts.length > 3) {
      return 'Enter your first and last name, with an optional middle name.';
    }

    final validName = RegExp(r"^[A-Za-z]+(?:[-'][A-Za-z]+)*$");

    if (parts.any((part) => !validName.hasMatch(part))) {
      return 'Use letters only; hyphens and apostrophes are allowed.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email address.';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? _validateUsername(String? value) {
    final username = value?.trim() ?? '';

    if (username.isEmpty) {
      return 'Please enter a username.';
    }

    if (username.length < 3) {
      return 'Username must be at least 3 characters.';
    }

    if (username.contains(' ')) {
      return 'Username cannot contain spaces.';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Please enter your phone number.';
    }

    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a valid phone number.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please create a password.';
    }

    if (!_hasMinLength || !_hasLettersAndNumbers) {
      return 'Your password does not meet the requirements.';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != widget.passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  Widget _buildPasswordRule(String text, bool passed) {
    final color = passed
        ? Colors.green
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            passed ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordGuide() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, left: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password must contain:',
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildPasswordRule('At least 6 characters', _hasMinLength),
          _buildPasswordRule(
            'A mix of letters and numbers',
            _hasLettersAndNumbers,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Full Name',
          hintText: 'e.g. David Osagie Enabulele',
          controller: widget.nameController,
          validator: _validateName,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedUser,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Username',
          hintText: 'Enter your username',
          controller: widget.usernameController,
          validator: _validateUsername,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedUser02,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Email Address',
          hintText: 'Enter your email',
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
          controller: widget.phoneController,
          keyboardType: TextInputType.phone,
          validator: _validatePhone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
          controller: widget.passwordController,
          obscureText: widget.obscurePassword,
          validator: _validatePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedLockPassword,
            color: AppColors.grey,
            size: 16,
          ),
          suffixIcon: IconButton(
            icon: HugeIcon(
              icon: widget.obscurePassword
                  ? HugeIcons.strokeRoundedView
                  : HugeIcons.strokeRoundedViewOffSlash,
              color: AppColors.grey,
              size: 16,
            ),
            onPressed: widget.onToggleObscurePassword,
          ),
        ),
        _buildPasswordGuide(),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Confirm Password',
          hintText: 'Re-enter your password',
          controller: widget.confirmPasswordController,
          obscureText: widget.obscurePassword,
          validator: _validateConfirmPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedLockPassword,
            color: AppColors.grey,
            size: 16,
          ),
          suffixIcon: IconButton(
            icon: HugeIcon(
              icon: widget.obscurePassword
                  ? HugeIcons.strokeRoundedView
                  : HugeIcons.strokeRoundedViewOffSlash,
              color: AppColors.grey,
              size: 16,
            ),
            onPressed: widget.onToggleObscurePassword,
          ),
        ),
        if (widget.confirmPasswordController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xs,
              left: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Icon(
                  _passwordsMatch ? Icons.check_circle : Icons.info_outline,
                  size: 16,
                  color: _passwordsMatch
                      ? Colors.green
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _passwordsMatch
                      ? 'Passwords match'
                      : 'Passwords do not match yet',
                  style: AppTypography.bodySmall.copyWith(
                    color: _passwordsMatch
                        ? Colors.green
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        ReferralSignupField(controller: widget.referralController),
      ],
    );
  }
}
