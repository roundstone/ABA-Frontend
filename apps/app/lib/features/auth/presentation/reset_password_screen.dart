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
import '../domain/auth_entities.dart';
import 'widgets/auth_password_requirements.dart';

/// Shared Reset Password screen for Customer and Merchant portals.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({
    super.key,
    this.role = UserRole.customer,
    this.initialEmail,
    this.initialToken,
  });

  final UserRole role;
  final String? initialEmail;
  final String? initialToken;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _tokenController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _passwordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onFieldChanged);
    _confirmPasswordController.removeListener(_onFieldChanged);
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _loginRoute =>
      widget.role == UserRole.merchant ? '/login/merchant' : '/login';

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasLetter => RegExp(r'[A-Za-z]').hasMatch(_passwordController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _passwordsMatch =>
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validateToken(String? value) {
    final token = value?.trim() ?? '';
    if (token.isEmpty) {
      return 'Please enter the reset code from your email.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please create a new password.';
    }
    if (!_hasMinLength || !_hasLetter || !_hasNumber) {
      return 'Password does not meet the requirements.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password.';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  Future<void> _submit() async {
    ref.read(authStateProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(authStateProvider.notifier).resetPassword(
          token: _tokenController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          email: _emailController.text.trim(),
        );

    if (success && mounted) {
      setState(() => _isSuccess = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMerchant = widget.role == UserRole.merchant;
    final portalBadgeColor = isMerchant ? AppColors.success : AppColors.info;
    final portalBadgeText =
        isMerchant ? 'MERCHANT PORTAL' : 'CUSTOMER PORTAL';

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
          onPressed: () => context.go(_loginRoute),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _isSuccess
                ? _buildSuccessView(isDark)
                : _buildFormView(
                    context,
                    authState,
                    isDark,
                    portalBadgeColor,
                    portalBadgeText,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView(
    BuildContext context,
    AuthState authState,
    bool isDark,
    Color badgeColor,
    String badgeText,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withAlpha(isDark ? 40 : 20),
                borderRadius: AppSpacing.avatarRadius,
              ),
              child: Text(
                badgeText,
                style: AppTypography.caption.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Reset Password',
            style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter the reset code sent to your email and create a new secure password.',
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
                style: AppTypography.caption.copyWith(color: AppColors.error),
              ),
            ),
          AppTextField(
            label: 'Registered Email',
            hintText: 'Enter your email address',
            controller: _emailController,
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
            label: 'Reset Code or Token',
            hintText: 'Enter code received in email',
            controller: _tokenController,
            validator: _validateToken,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            prefixIcon: const HugeIcon(
              icon: HugeIcons.strokeRoundedKey01,
              color: AppColors.grey,
              size: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'New Password',
            hintText: 'Create a new secure password',
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: _validatePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
          AuthPasswordRequirements(password: _passwordController.text),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Confirm New Password',
            hintText: 'Re-enter your new password',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            validator: _validateConfirmPassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            prefixIcon: const HugeIcon(
              icon: HugeIcons.strokeRoundedLockPassword,
              color: AppColors.grey,
              size: 16,
            ),
            suffixIcon: IconButton(
              icon: HugeIcon(
                icon: _obscureConfirmPassword
                    ? HugeIcons.strokeRoundedView
                    : HugeIcons.strokeRoundedViewOffSlash,
                color: AppColors.grey,
                size: 16,
              ),
              onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
            ),
          ),
          if (_confirmPasswordController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.xs,
                left: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Icon(
                    _passwordsMatch ? Icons.check_circle : Icons.info_outline,
                    size: 14,
                    color: _passwordsMatch ? AppColors.success : AppColors.grey,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    _passwordsMatch
                        ? 'Passwords match'
                        : 'Passwords do not match yet',
                    style: AppTypography.caption.copyWith(
                      color:
                          _passwordsMatch ? AppColors.success : AppColors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(
            label: 'Reset Password',
            isLoading: authState.isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: TextButton.icon(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft02,
                color: AppColors.grey,
                size: 16,
              ),
              label: Text(
                'Back to Sign In',
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.secondary : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => context.go(_loginRoute),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 40,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Password Reset Successful!',
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'Your password has been changed successfully. You can now use your new password to sign in.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          label: 'Proceed to Sign In',
          onPressed: () => context.go(_loginRoute),
        ),
      ],
    );
  }
}
