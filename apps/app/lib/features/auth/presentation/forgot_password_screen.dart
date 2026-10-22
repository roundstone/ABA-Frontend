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

/// Shared Forgot Password screen for Customer and Merchant portals.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    this.role = UserRole.customer,
    this.initialEmail,
  });

  final UserRole role;
  final String? initialEmail;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _submittedSuccessfully = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String get _loginRoute =>
      widget.role == UserRole.merchant ? '/login/merchant' : '/login';

  Future<void> _submit() async {
    ref.read(authStateProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final success =
        await ref.read(authStateProvider.notifier).forgotPassword(email);

    if (success && mounted) {
      setState(() {
        _submittedSuccessfully = true;
      });
    }
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
            child: _submittedSuccessfully
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
            'Forgot Password?',
            style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter your registered account email and we will send you a password reset code / instructions.',
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
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(
            label: 'Send Reset Instructions',
            isLoading: authState.isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have a reset code? ',
                style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
              ),
              TextButton(
                onPressed: () {
                  final emailParam = Uri.encodeComponent(_emailController.text.trim());
                  context.go(
                    '/reset-password?email=$emailParam&role=${widget.role.name}',
                  );
                },
                child: Text(
                  'Reset Password',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
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
              Icons.mark_email_read_rounded,
              size: 40,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Reset Code Sent!',
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'We have dispatched password reset instructions to ${_emailController.text.trim()}. Please check your email inbox and spam folder.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          label: 'Enter Code & Reset Password',
          onPressed: () {
            final emailParam =
                Uri.encodeComponent(_emailController.text.trim());
            context.go(
              '/reset-password?email=$emailParam&role=${widget.role.name}',
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _submittedSuccessfully = false),
            child: Text(
              "Didn't receive email? Try another email",
              style: AppTypography.caption.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
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
    );
  }
}
