import 'package:flutter/material.dart';
import '../../../../core/config/paystack_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_widgets.dart';

/// Modal bottom sheet simulating the official Paystack payment gateway experience.
class PaystackPaymentSheet extends StatefulWidget {
  const PaystackPaymentSheet({
    super.key,
    required this.amount,
    required this.email,
    required this.onSuccess,
    this.onCancelled,
  });

  final double amount;
  final String email;
  final ValueChanged<String> onSuccess;
  final VoidCallback? onCancelled;

  static Future<String?> show(
    BuildContext context, {
    required double amount,
    required String email,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaystackPaymentSheet(
        amount: amount,
        email: email,
        onSuccess: (ref) => Navigator.of(ctx).pop(ref),
        onCancelled: () => Navigator.of(ctx).pop(null),
      ),
    );
  }

  @override
  State<PaystackPaymentSheet> createState() => _PaystackPaymentSheetState();
}

class _PaystackPaymentSheetState extends State<PaystackPaymentSheet> {
  final _cardNumberCtrl = TextEditingController(text: '4084 0840 0840 0840');
  final _expiryCtrl = TextEditingController(text: '12/30');
  final _cvvCtrl = TextEditingController(text: '408');
  final _otpCtrl = TextEditingController(text: '1234');
  bool _isProcessing = false;
  bool _showOtpStep = false;
  String? _errorMessage;

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _handlePay() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _showOtpStep = true;
    });
  }

  Future<void> _handleAuthorizeOtp() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    if (_otpCtrl.text.trim() != '1234' && _otpCtrl.text.trim().length < 4) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Invalid OTP. Enter 1234 to authorize.';
      });
      return;
    }
    final reference =
        'pstk_${DateTime.now().millisecondsSinceEpoch}_${widget.email.split('@').first}';
    widget.onSuccess(reference);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.md + bottomInset),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0BA4DB).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('paystack', style: TextStyle(color: Color(0xFF0BA4DB), fontWeight: FontWeight.w900, fontSize: 14)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: const Text('TEST MODE', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: widget.onCancelled ?? () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.email,
              style: AppTypography.caption.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 2),
            Text(
              'Pay ${formatNaira(widget.amount)}',
              style: AppTypography.h5.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ),
            if (!_showOtpStep) ...[
              AppTextField(
                label: 'Card Number',
                controller: _cardNumberCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.credit_card, size: 20),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Expires (MM/YY)',
                      controller: _expiryCtrl,
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: 'CVV',
                      controller: _cvvCtrl,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton.primary(
                label: _isProcessing ? 'Processing...' : 'Pay ${formatNaira(widget.amount)}',
                isLoading: _isProcessing,
                onPressed: _isProcessing ? null : _handlePay,
              ),
            ] else ...[
              const Text(
                'Enter the 4-digit OTP sent to your registered number (Demo OTP: 1234)',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'One-Time Password (OTP)',
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.lock_clock, size: 20),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton.primary(
                label: _isProcessing ? 'Verifying...' : 'Authorize Payment',
                isLoading: _isProcessing,
                onPressed: _isProcessing ? null : _handleAuthorizeOtp,
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                'Key: ${PaystackConfig.publicKey.substring(0, 15)}...',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
