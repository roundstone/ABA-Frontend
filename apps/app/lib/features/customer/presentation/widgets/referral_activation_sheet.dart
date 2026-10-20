import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/referral_activation_provider.dart';
import 'referral_activation_payment_views.dart';
import 'referral_activation_steps.dart';

/// Interactive modal sheet to complete KYC and Pay Referral Activation Fee.
class ReferralActivationSheet extends ConsumerStatefulWidget {
  const ReferralActivationSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
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
  String _idType = 'National Identity Number (NIN)';
  bool _idUploaded = true;
  bool _addressUploaded = true;
  bool _isProcessing = false;

  @override
  void dispose() {
    _ninController.dispose();
    super.dispose();
  }

  Future<void> _submitKyc() async {
    if (_ninController.text.trim().length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 11-digit NIN.')),
      );
      return;
    }
    await ref.read(referralActivationProvider.notifier).submitKyc(
          ninNumber: _ninController.text.trim(),
          idType: _idType,
          idDocumentName: 'nin_slip.pdf',
          proofOfAddressName: 'utility_bill.jpg',
        );
    setState(() => _step = 1);
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await ref.read(referralActivationProvider.notifier).payActivationFee();
    setState(() {
      _isProcessing = false;
      _step = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
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
                    idUploaded: _idUploaded,
                    addressUploaded: _addressUploaded,
                    onIdTypeChanged: (v) => setState(() => _idType = v),
                    onUploadId: () => setState(() => _idUploaded = true),
                    onUploadAddress: () => setState(() => _addressUploaded = true),
                    onSubmit: _submitKyc,
                  ),
                if (_step == 1)
                  ReferralPaymentStepView(
                    isProcessing: _isProcessing,
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
    );
  }
}
