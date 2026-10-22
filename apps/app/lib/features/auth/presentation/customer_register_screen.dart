import 'dart:math';

import 'package:app/core/config/app_brand.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../application/auth_providers.dart';
import '../domain/auth_entities.dart';
import 'widgets/customer_register_fields.dart';

class CustomerRegisterScreen extends ConsumerStatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  ConsumerState<CustomerRegisterScreen> createState() =>
      _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState
    extends ConsumerState<CustomerRegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();
  bool _acceptTerms = false;
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Debug: pre-fill with registration credentials
    if (kDebugMode) {
      _nameController.text = 'David Osagie Enabulele';
      final random = DateTime.now().millisecondsSinceEpoch;
      _emailController.text = 'david$random@gmail.com';
      _usernameController.text = 'david$random';
      final randomPhone = Random().nextInt(99999999);
      _phoneController.text = '081$randomPhone';
      _passwordController.text = 'password123';
      _confirmPasswordController.text = 'password123';
      _referralController.text = '';
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _emailController,
      _usernameController,
      _phoneController,
      _passwordController,
      _confirmPasswordController,
      _referralController,
    ]) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms and conditions.')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final referralCode = _referralController.text.trim();

    final success = await ref
        .read(authStateProvider.notifier)
        .registerCustomer(
          CustomerRegistrationParams(
            fullName: name,
            email: email,
            username: username,
            phone: phone,
            password: password,
            confirmPassword: confirmPassword,
            referralCode: referralCode.isEmpty ? null : referralCode,
          ),
        );

    if (success && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          onPressed: () => context.go('/login/customer'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Customer Account',
                style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),

              Text(
                'Join the ${AppBrand.name} community. Shop, refer friends, and earn commissions.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (authState.errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(20),
                    borderRadius: AppSpacing.borderRadiusMD,
                    border: Border.all(color: AppColors.error.withAlpha(60)),
                  ),
                  child: Text(
                    authState.errorMessage!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              Form(
                key: _formKey,
                child: CustomerRegisterFields(
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  referralController: _referralController,
                  obscurePassword: _obscurePassword,
                  onToggleObscurePassword: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              CheckboxListTile(
                value: _acceptTerms,
                onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                title: Text(
                  'I agree to the Terms of Service & Privacy Policy',
                  style: AppTypography.caption,
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton.primary(
                label: 'Create Account',
                isLoading: authState.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login/customer'),
                    child: Text(
                      'Log in',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
