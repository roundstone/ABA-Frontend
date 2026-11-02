import 'dart:math';
import 'package:app/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/marketer_providers.dart';
import 'onboarding_success_dialog.dart';

class SingleCustomerForm extends ConsumerStatefulWidget {
  const SingleCustomerForm({super.key, required this.referralCode});

  final String referralCode;

  @override
  ConsumerState<SingleCustomerForm> createState() => _SingleCustomerFormState();
}

class _SingleCustomerFormState extends ConsumerState<SingleCustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    final rand = 1000 + Random().nextInt(9000);
    _passwordController.text = 'AbaCust@$rand';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final input = OnboardCustomerInput(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      referralCode: widget.referralCode,
    );

    final result = await ref
        .read(marketerOnboardingProvider.notifier)
        .registerSingleCustomer(input);

    if (!mounted) return;

    if (result.success) {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _generatePassword();

      showDialog(
        context: context,
        builder: (_) => OnboardingSuccessDialog(results: [result]),
      );
    } else {
      AppSnackbar.error(context, result.error ?? 'Failed to register customer.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(marketerOnboardingProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: AppSpacing.borderRadiusLG,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Details',
                  style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Full Name',
                  hintText: 'e.g. Chisom Okonkwo',
                  controller: _nameController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter customer name'
                      : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Email Address',
                  hintText: 'customer@example.com',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter email';
                    }
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Phone Number',
                  hintText: '08012345678',
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  validator: (v) => (v == null || v.trim().length < 9)
                      ? 'Enter a valid phone number'
                      : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Temporary Password',
                        hintText: 'Password for login',
                        obscureText: _obscurePassword,
                        controller: _passwordController,
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Min 6 characters'
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    IconButton(
                      tooltip: 'Toggle visibility',
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Auto generate password',
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      onPressed: () => setState(_generatePassword),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Register Customer',
            isLoading: state.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
