import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/auth_providers.dart';
import 'widgets/demo_login_button.dart';

class MerchantLoginScreen extends ConsumerStatefulWidget {
  const MerchantLoginScreen({super.key});

  @override
  ConsumerState<MerchantLoginScreen> createState() =>
      _MerchantLoginScreenState();
}

class _MerchantLoginScreenState extends ConsumerState<MerchantLoginScreen> {
  final _identifierController =
      TextEditingController(text: 'emeka@abaleather.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your business email and password'),
        ),
      );
      return;
    }

    final success = await ref.read(authStateProvider.notifier).loginMerchant(
          identifier: identifier,
          password: password,
        );

    if (success && mounted) {
      context.go('/merchant');
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
          onPressed: () => context.go('/role-select'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(isDark ? 40 : 20),
                      borderRadius: AppSpacing.avatarRadius,
                    ),
                    child: Text(
                      'MERCHANT & SELLER PORTAL',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Merchant Sign In',
                  style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Access your vendor orders, inventory catalog, and in-store POS.',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
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
                      style:
                          AppTypography.caption.copyWith(color: AppColors.error),
                    ),
                  ),
                AppTextField(
                  label: 'Business Email or Phone',
                  hintText: 'Enter business email or phone',
                  controller: _identifierController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedMail01,
                    color: AppColors.grey,
                    size: 16,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedLockPassword,
                    color: AppColors.grey,
                    size: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: HugeIcon(
                      icon: _obscurePassword
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOffSlash,
                      color: AppColors.grey,
                      size: 16,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton.primary(
                  label: 'Sign In to Merchant Hub',
                  isLoading: authState.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.md),
                // DemoLoginButton(
                //   label: 'Quick Login as Emeka Nwosu (Demo)',
                //   icon: HugeIcons.strokeRoundedStore01,
                //   onPressed: () {
                //     _identifierController.text = 'emeka@abaleather.com';
                //     _passwordController.text = 'password123';
                //     _submit();
                //   },
                // ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New manufacturer or artisan? ',
                      style:
                          AppTypography.bodySmall.copyWith(color: AppColors.grey),
                    ),
                    TextButton(
                      onPressed: () => context.go('/merchants/onboarding'),
                      child: Text(
                        'Apply Now',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login/customer'),
                    child: Text(
                      'Looking to buy products? Sign in as Customer',
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.secondary : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
