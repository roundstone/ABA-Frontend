import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../checkout/presentation/widgets/paystack_payment_sheet.dart';
import '../../../wallet/application/wallet_providers.dart';
import '../../application/referral_activation_provider.dart';
import 'referral_activation_payment_views.dart';
import 'referral_activation_steps.dart';

/// Interactive modal sheet to complete KYC and Pay Referral Activation Fee.
class ReferralActivationSheet extends ConsumerStatefulWidget {
  const ReferralActivationSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReferralActivationSheet(),
    );
  }

  @override
  ConsumerState<ReferralActivationSheet> createState() =>
      _ReferralActivationSheetState();
}

class _ReferralActivationSheetState
    extends ConsumerState<ReferralActivationSheet> {
  int _step = 0; // 0: KYC, 1: Payment, 2: Success
  final _ninController = TextEditingController(text: '12345678901');
  final _dobController = TextEditingController(text: '1990-04-28');
  final _nationalityController = TextEditingController(text: 'Nigerian');
  final _addressController = TextEditingController(text: '14 Admiralty Way');
  final _cityController = TextEditingController(text: 'Lekki');
  final _stateController = TextEditingController(text: 'Lagos');
  final _lgaController = TextEditingController(text: 'Eti Osa');

  String _idType = 'National Identity Number (NIN)';
  bool _idUploaded = true;
  bool _addressUploaded = true;
  String _idFileName = 'nin_slip_verified.png';
  String _addressFileName = 'utility_bill.png';
  bool _isSubmittingKyc = false;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _prefillFromExistingProfile();
  }

  Future<void> _prefillFromExistingProfile() async {
    try {
      final profile = await ref.read(kycProfileProvider.future);
      final docs = await ref.read(kycDocumentsProvider.future);
      if (!mounted) return;
      setState(() {
        if (profile.dateOfBirth != null && profile.dateOfBirth!.isNotEmpty) {
          _dobController.text = profile.dateOfBirth!;
        }
        if (profile.nationality != null && profile.nationality!.isNotEmpty) {
          _nationalityController.text = profile.nationality!;
        }
        if (profile.residentialAddress != null &&
            profile.residentialAddress!.isNotEmpty) {
          _addressController.text = profile.residentialAddress!;
        }
        if (profile.city != null && profile.city!.isNotEmpty) {
          _cityController.text = profile.city!;
        }
        if (profile.state != null && profile.state!.isNotEmpty) {
          _stateController.text = profile.state!;
        }
        if (profile.lga != null && profile.lga!.isNotEmpty) {
          _lgaController.text = profile.lga!;
        }
        for (final doc in docs) {
          if (doc.documentReference != null &&
              doc.documentReference!.isNotEmpty) {
            _ninController.text = doc.documentReference!;
          }
          if (doc.originalName != null && doc.originalName!.isNotEmpty) {
            if (doc.documentType == 4) {
              _addressFileName = doc.originalName!;
              _addressUploaded = true;
            } else {
              _idFileName = doc.originalName!;
              _idUploaded = true;
            }
          }
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _ninController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _lgaController.dispose();
    super.dispose();
  }

  Future<void> _submitKyc() async {
    if (_ninController.text.trim().length < 10) {
      AppSnackbar.warning(context, 'Please enter a valid ID / NIN number.');
      return;
    }

    setState(() => _isSubmittingKyc = true);
    try {
      await ref.read(referralActivationProvider.notifier).submitKyc(
            ninNumber: _ninController.text.trim(),
            idType: _idType,
            idDocumentName: _idFileName,
            proofOfAddressName: _addressFileName,
            dateOfBirth: _dobController.text.trim(),
            nationality: _nationalityController.text.trim(),
            residentialAddress: _addressController.text.trim(),
            city: _cityController.text.trim(),
            stateName: _stateController.text.trim(),
            lga: _lgaController.text.trim(),
          );
      if (!mounted) return;
      setState(() {
        _isSubmittingKyc = false;
        _step = 1;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmittingKyc = false);
      AppSnackbar.error(context, ApiError.toUserFriendlyMessage(e));
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessingPayment = true);
    try {
      final notifier = ref.read(referralActivationProvider.notifier);
      final initResult = await notifier.initializeActivationPayment();

      if (!mounted) return;
      setState(() => _isProcessingPayment = false);

      final paidRef = await PaystackPaymentSheet.show(
        context,
        amount: initResult.amountNaira > 0 ? initResult.amountNaira : 5000.0,
        email: initResult.email.isNotEmpty
            ? initResult.email
            : 'customer@buynaija.com',
        reference: initResult.reference,
        authorizationUrl: initResult.authorizationUrl,
      );

      if (!mounted || paidRef == null || paidRef.isEmpty) return;

      setState(() => _isProcessingPayment = true);
      final refToVerify =
          initResult.reference.isNotEmpty ? initResult.reference : paidRef;
      await notifier.completeActivationPayment(refToVerify);

      ref.invalidate(walletInfoProvider);
      ref.invalidate(walletTransactionsProvider);

      if (!mounted) return;
      setState(() {
        _isProcessingPayment = false;
        _step = 2;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessingPayment = false);
      AppSnackbar.error(context, ApiError.toUserFriendlyMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: mq.size.height * 0.90),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.black12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_step == 0)
                      ReferralKycStepView(
                        idType: _idType,
                        ninController: _ninController,
                        dobController: _dobController,
                        nationalityController: _nationalityController,
                        addressController: _addressController,
                        cityController: _cityController,
                        stateController: _stateController,
                        lgaController: _lgaController,
                        idUploaded: _idUploaded,
                        addressUploaded: _addressUploaded,
                        idFileName: _idFileName,
                        addressFileName: _addressFileName,
                        isSubmitting: _isSubmittingKyc,
                        onIdTypeChanged: (v) => setState(() => _idType = v),
                        onUploadId: () => setState(() => _idUploaded = true),
                        onUploadAddress: () =>
                            setState(() => _addressUploaded = true),
                        onSubmit: _submitKyc,
                      ),
                    if (_step == 1)
                      ReferralPaymentStepView(
                        isProcessing: _isProcessingPayment,
                        onPay: _processPayment,
                        onBack: () => setState(() => _step = 0),
                      ),
                    if (_step == 2)
                      ReferralSuccessStepView(
                        onClose: () => Navigator.of(context).pop(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
