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
import 'widgets/merchant_onboarding_steps.dart';
import 'widgets/merchant_onboarding_success.dart';

class MerchantOnboardingScreen extends ConsumerStatefulWidget {
  const MerchantOnboardingScreen({super.key});

  @override
  ConsumerState<MerchantOnboardingScreen> createState() =>
      _MerchantOnboardingScreenState();
}

class _MerchantOnboardingScreenState
    extends ConsumerState<MerchantOnboardingScreen> {
  int _currentStep = 0;
  bool _isSuccess = false;

  final _businessName = TextEditingController(text: 'Aba Leathercraft Hub');
  final _businessType = TextEditingController(text: 'Footwear & Leather');
  final _rcNumber = TextEditingController(text: 'RC-998822');
  final _ownerName = TextEditingController(text: 'Emeka Nwosu');
  final _phone = TextEditingController(text: '+2348031234567');
  final _email = TextEditingController(text: 'emeka@abaleather.com');
  final _address = TextEditingController(text: '14 Faulks Road, Ariaria Market');
  final _city = TextEditingController(text: 'Aba');
  final _state = TextEditingController(text: 'Abia');
  final _bankName = TextEditingController(text: 'First Bank of Nigeria');
  final _accountNumber = TextEditingController(text: '0123456789');

  static const _stepTitles = [
    'Business Information',
    'Contact Details',
    'Workshop & Store Location',
    'Settlement Account',
  ];

  @override
  void dispose() {
    for (final c in [
      _businessName, _businessType, _rcNumber, _ownerName, _phone,
      _email, _address, _city, _state, _bankName, _accountNumber,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onNext() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.go('/login/merchant');
    }
  }

  Future<void> _submit() async {
    final success = await ref.read(authStateProvider.notifier).onboardMerchant(
          MerchantOnboardingParams(
            businessName: _businessName.text.trim(),
            businessType: _businessType.text.trim(),
            rcNumber:
                _rcNumber.text.trim().isEmpty ? null : _rcNumber.text.trim(),
            ownerName: _ownerName.text.trim(),
            phone: _phone.text.trim(),
            email: _email.text.trim(),
            address: _address.text.trim(),
            city: _city.text.trim(),
            state: _state.text.trim(),
            bankName: _bankName.text.trim(),
            accountNumber: _accountNumber.text.trim(),
          ),
        );

    if (success && mounted) {
      setState(() => _isSuccess = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authStateProvider);

    if (_isSuccess) {
      return const MerchantOnboardingSuccess();
    }

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
          onPressed: _onBack,
        ),
        title: Text(
          'Merchant Onboarding',
          style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(
                value: (_currentStep + 1) / 4,
                backgroundColor: isDark ? Colors.white12 : AppColors.surface2,
                color: AppColors.primary,
                minHeight: 6,
                borderRadius: AppSpacing.borderRadiusSM,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step ${_currentStep + 1} of 4',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _stepTitles[_currentStep],
                    style: AppTypography.caption.copyWith(
                      color:
                          isDark ? AppColors.darkTextSecondary : AppColors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildStepContent(),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: AppButton.outlined(
                        label: 'Back',
                        onPressed: _onBack,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    flex: 2,
                    child: AppButton.primary(
                      label: _currentStep == 3
                          ? 'Complete Registration'
                          : 'Continue',
                      isLoading: authState.isLoading,
                      onPressed: _onNext,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return OnboardingStepBusiness(
          nameController: _businessName,
          typeController: _businessType,
          rcController: _rcNumber,
        );
      case 1:
        return OnboardingStepContact(
          ownerController: _ownerName,
          phoneController: _phone,
          emailController: _email,
        );
      case 2:
        return OnboardingStepLocation(
          addressController: _address,
          cityController: _city,
          stateController: _state,
        );
      default:
        return OnboardingStepSettlement(
          bankController: _bankName,
          accountController: _accountNumber,
        );
    }
  }
}
