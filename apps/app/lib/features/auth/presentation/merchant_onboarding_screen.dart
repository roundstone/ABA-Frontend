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
import 'widgets/merchant_onboarding_step_builder.dart';
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
  bool _isProvisional = false;
  bool _cacUploaded = true;

  final _ownerName = TextEditingController(text: 'Emeka Nwosu');
  final _phone = TextEditingController(text: '+2348031234567');
  final _email = TextEditingController(text: 'emeka@abaleather.com');
  final _ninNumber = TextEditingController(text: '12345678901');
  String _idType = 'National Identity Number (NIN)';
  bool _idUploaded = true;

  final _address = TextEditingController(text: '14 Faulks Road');
  String _marketCluster = 'Ariaria International Market';
  final _city = TextEditingController(text: 'Aba');
  final _state = TextEditingController(text: 'Abia');
  final _bankName = TextEditingController(text: 'First Bank of Nigeria');
  final _accountNumber = TextEditingController(text: '0123456789');

  final _products = TextEditingController(text: 'Handcrafted leather shoes, sandals, and belts');
  final _capacity = TextEditingController(text: '450 pairs/month');
  int _samplePhotosCount = 3;

  String _certType = 'None / Artisanal Guild';
  final _certNumber = TextEditingController();
  bool _certUploaded = false;
  bool _confirmSupply = true;
  bool _agreeToFulfillmentSla = true;

  static const _stepTitles = [
    'Business & Registration',
    'Owner Identity & NIN',
    'Location & Settlement',
    'Products & Quality Standards',
    'Certifications & Fulfillment',
  ];

  @override
  void dispose() {
    for (final c in [
      _businessName, _businessType, _rcNumber, _ownerName, _phone,
      _email, _ninNumber, _address, _city, _state, _bankName,
      _accountNumber, _products, _capacity, _certNumber,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onNext() =>
      _currentStep < 4 ? setState(() => _currentStep++) : _submit();

  void _onBack() => _currentStep > 0
      ? setState(() => _currentStep--)
      : context.go('/login/merchant');

  Future<void> _submit() async {
    final success = await ref.read(authStateProvider.notifier).onboardMerchant(
      MerchantOnboardingParams(
        businessName: _businessName.text.trim(),
        businessType: _businessType.text.trim(),
        rcNumber: _isProvisional ? null : _rcNumber.text.trim(),
        isProvisional: _isProvisional,
        cacDocumentName: _cacUploaded ? 'cac_cert.pdf' : null,
        ownerName: _ownerName.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        idType: _idType,
        ninNumber: _ninNumber.text.trim(),
        idDocumentName: _idUploaded ? 'owner_id.jpg' : null,
        address: _address.text.trim(),
        marketCluster: _marketCluster,
        city: _city.text.trim(),
        state: _state.text.trim(),
        productDescription: _products.text.trim(),
        samplePhotosCount: _samplePhotosCount,
        certificationType: _certType,
        certificationNumber:
            _certNumber.text.trim().isEmpty ? null : _certNumber.text.trim(),
        certificationDocumentName: _certUploaded ? 'cert.pdf' : null,
        agreedToFulfillmentSla: _agreeToFulfillmentSla,
        bankName: _bankName.text.trim(),
        accountNumber: _accountNumber.text.trim(),
      ),
    );
    if (success && mounted) setState(() => _isSuccess = true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authStateProvider);

    if (_isSuccess) {
      return MerchantOnboardingSuccess(isProvisional: _isProvisional);
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
          'Merchant Verification',
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
                value: (_currentStep + 1) / 5,
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
                    'Step ${_currentStep + 1} of 5',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _stepTitles[_currentStep],
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              MerchantOnboardingStepBuilder(
                currentStep: _currentStep,
                businessName: _businessName,
                businessType: _businessType,
                rcNumber: _rcNumber,
                isProvisional: _isProvisional,
                cacUploaded: _cacUploaded,
                onProvisionalChanged: (v) => setState(() => _isProvisional = v),
                onUploadCac: () => setState(() => _cacUploaded = true),
                ownerName: _ownerName,
                phone: _phone,
                email: _email,
                ninNumber: _ninNumber,
                idType: _idType,
                idUploaded: _idUploaded,
                onIdTypeChanged: (v) => setState(() => _idType = v),
                onUploadId: () => setState(() => _idUploaded = true),
                address: _address,
                city: _city,
                state: _state,
                marketCluster: _marketCluster,
                bankName: _bankName,
                accountNumber: _accountNumber,
                onClusterChanged: (v) => setState(() => _marketCluster = v),
                products: _products,
                capacity: _capacity,
                samplePhotosCount: _samplePhotosCount,
                onAddPhoto: () => setState(() {
                  if (_samplePhotosCount < 4) _samplePhotosCount++;
                }),
                certType: _certType,
                certNumber: _certNumber,
                certUploaded: _certUploaded,
                confirmSupply: _confirmSupply,
                agreeToFulfillmentSla: _agreeToFulfillmentSla,
                onCertTypeChanged: (v) => setState(() => _certType = v),
                onUploadCert: () => setState(() => _certUploaded = true),
                onToggleSupplyCapacity: (v) => setState(() => _confirmSupply = v ?? false),
                onToggleFulfillmentSla: (v) => setState(() => _agreeToFulfillmentSla = v ?? false),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: AppButton.outlined(label: 'Back', onPressed: _onBack),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    flex: 2,
                    child: AppButton.primary(
                      label: _currentStep == 4 ? 'Submit for Verification' : 'Continue',
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
}
