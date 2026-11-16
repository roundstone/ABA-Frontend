import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/network/api_error.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../wallet/application/wallet_providers.dart';
import '../application/referral_activation_provider.dart';
import '../data/kyc_service.dart';
import '../domain/kyc_models.dart';
import 'widgets/kyc_documents_section.dart';
import 'widgets/kyc_profile_form_card.dart';
import 'widgets/kyc_status_cards.dart';
import 'widgets/referral_activation_card.dart';
import 'widgets/referral_activation_sheet.dart';

class KycProfileScreen extends ConsumerStatefulWidget {
  const KycProfileScreen({super.key});

  @override
  ConsumerState<KycProfileScreen> createState() => _KycProfileScreenState();
}

class _KycProfileScreenState extends ConsumerState<KycProfileScreen> {
  final _dobCtrl = TextEditingController();
  final _nationalityCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _lgaCtrl = TextEditingController();
  int? _hydratedProfileId;
  bool _isSaving = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _dobCtrl.dispose();
    _nationalityCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _lgaCtrl.dispose();
    super.dispose();
  }

  void _syncForm(KycProfile? profile) {
    if (profile == null || _hydratedProfileId == profile.id) return;
    _hydratedProfileId = profile.id;
    _dobCtrl.text = profile.dateOfBirth ?? '';
    _nationalityCtrl.text = profile.nationality ?? '';
    _addressCtrl.text = profile.residentialAddress ?? '';
    _cityCtrl.text = profile.city ?? '';
    _stateCtrl.text = profile.state ?? '';
    _lgaCtrl.text = profile.lga ?? '';
  }

  Future<void> _pickDob() async {
    final initial = DateTime.tryParse(_dobCtrl.text) ?? DateTime(1995, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
    );
    if (picked != null && mounted) {
      setState(() {
        _dobCtrl.text =
            '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(kycServiceProvider).updateProfile(
            dateOfBirth: _dobCtrl.text.trim(),
            nationality: _nationalityCtrl.text.trim(),
            residentialAddress: _addressCtrl.text.trim(),
            city: _cityCtrl.text.trim(),
            state: _stateCtrl.text.trim(),
            lga: _lgaCtrl.text.trim(),
          );
      _hydratedProfileId = null;
      ref.invalidate(optionalKycProfileProvider);
      ref.invalidate(kycProfileProvider);
      if (mounted) AppSnackbar.success(context, 'KYC profile saved.');
    } catch (e) {
      if (mounted) AppSnackbar.error(context, ApiError.toUserFriendlyMessage(e));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _submitForReview() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(kycServiceProvider).submitProfile();
      _hydratedProfileId = null;
      ref.invalidate(optionalKycProfileProvider);
      ref.invalidate(kycProfileProvider);
      if (mounted) {
        AppSnackbar.success(context, 'KYC profile submitted for review.');
      }
    } catch (e) {
      if (mounted) AppSnackbar.error(context, ApiError.toUserFriendlyMessage(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    final profileAsync = ref.watch(optionalKycProfileProvider);
    final creditAsync = ref.watch(shoppingCreditsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('KYC Profile')),
        body: const Center(
          child: Text('Please sign in to manage your KYC profile.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          onPressed: () => context.popOrGo('/settings'),
        ),
        title: const Text('KYC Profile'),
      ),
      body: profileAsync.when(
        loading: () => const LoadingState(message: 'Loading KYC profile...'),
        error: (err, _) => ErrorState(
          message: ApiError.toUserFriendlyMessage(err),
          onRetry: () => ref.invalidate(optionalKycProfileProvider),
        ),
        data: (profile) {
          _syncForm(profile);
          final isEditable = profile == null || profile.isEditable;
          final isPaid = (profile?.isActivationPaid ?? false) ||
              (creditAsync.valueOrNull?.isActivated ?? false);
          final allDetailsPresent = [
            _dobCtrl.text,
            _nationalityCtrl.text,
            _addressCtrl.text,
            _cityCtrl.text,
            _stateCtrl.text,
          ].every((v) => v.trim().isNotEmpty);
          final canSubmit = profile != null &&
              isEditable &&
              allDetailsPresent &&
              profile.documents.isNotEmpty;

          return RefreshIndicator(
            onRefresh: () async {
              _hydratedProfileId = null;
              ref.invalidate(optionalKycProfileProvider);
              ref.invalidate(shoppingCreditsProvider);
              await ref.read(optionalKycProfileProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text(
                  'Provide your identity and address details for account verification.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
                ),
                const SizedBox(height: AppSpacing.md),
                const ReferralActivationCard(showKycProfileLink: false),
                const SizedBox(height: AppSpacing.md),
                KycStatusCard(profile: profile),
                const SizedBox(height: AppSpacing.md),
                KycActivationPaymentCard(
                  payment: profile?.activationPayment,
                  isShoppingCreditActivated:
                      creditAsync.valueOrNull?.isActivated ?? false,
                  onPayFee: isPaid
                      ? null
                      : () => ReferralActivationSheet.show(
                            context,
                            initialStep: 1,
                          ),
                ),
                const SizedBox(height: AppSpacing.md),
                KycProfileFormCard(
                  dobCtrl: _dobCtrl,
                  nationalityCtrl: _nationalityCtrl,
                  addressCtrl: _addressCtrl,
                  cityCtrl: _cityCtrl,
                  stateCtrl: _stateCtrl,
                  lgaCtrl: _lgaCtrl,
                  isEditable: isEditable,
                  canSubmit: canSubmit,
                  isSaving: _isSaving,
                  isSubmitting: _isSubmitting,
                  onPickDob: _pickDob,
                  onSave: _saveProfile,
                  onSubmit: _submitForReview,
                ),
                const SizedBox(height: AppSpacing.md),
                KycDocumentsSection(
                  documents: profile?.documents ?? const [],
                  isEditable: isEditable,
                  onAddDocuments: () => ReferralActivationSheet.show(context),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
