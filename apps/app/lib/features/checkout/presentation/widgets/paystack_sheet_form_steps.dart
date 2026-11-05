import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_widgets.dart';

class PaystackSheetHeader extends StatelessWidget {
  const PaystackSheetHeader({
    super.key,
    required this.email,
    required this.amount,
    required this.isTestMode,
    this.onCancelled,
  });

  final String email;
  final double amount;
  final bool isTestMode;
  final VoidCallback? onCancelled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0BA4DB).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'paystack',
                    style: TextStyle(
                      color: Color(0xFF0BA4DB),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (isTestMode ? Colors.amber : Colors.green)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isTestMode ? 'TEST MODE' : 'SECURE',
                    style: TextStyle(
                      color: isTestMode ? Colors.amber : Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onCancelled ?? () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          email,
          style: AppTypography.caption.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          'Pay ${formatNaira(amount)}',
          style: AppTypography.h5.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(height: 24),
      ],
    );
  }
}

class PaystackCardStepForm extends StatelessWidget {
  const PaystackCardStepForm({
    super.key,
    required this.cardNumberCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
    required this.isProcessing,
    required this.amount,
    required this.onPay,
  });

  final TextEditingController cardNumberCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;
  final bool isProcessing;
  final double amount;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Card Number',
          controller: cardNumberCtrl,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.credit_card, size: 20),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Expires (MM/YY)',
                controller: expiryCtrl,
                keyboardType: TextInputType.datetime,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                label: 'CVV',
                controller: cvvCtrl,
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton.primary(
          label: isProcessing
              ? 'Processing with Paystack...'
              : 'Pay ${formatNaira(amount)}',
          isLoading: isProcessing,
          onPressed: isProcessing ? null : onPay,
        ),
      ],
    );
  }
}

class PaystackPinStepForm extends StatelessWidget {
  const PaystackPinStepForm({
    super.key,
    required this.pinCtrl,
    this.displayText,
    required this.isProcessing,
    required this.onSubmit,
  });

  final TextEditingController pinCtrl;
  final String? displayText;
  final bool isProcessing;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          displayText ?? 'Enter your 4-digit card PIN to authorize payment',
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: 'Card PIN',
          controller: pinCtrl,
          keyboardType: TextInputType.number,
          obscureText: true,
          prefixIcon: const Icon(Icons.pin, size: 20),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton.primary(
          label: isProcessing ? 'Authorizing PIN...' : 'Authorize PIN',
          isLoading: isProcessing,
          onPressed: isProcessing ? null : onSubmit,
        ),
      ],
    );
  }
}

class PaystackOtpStepForm extends StatelessWidget {
  const PaystackOtpStepForm({
    super.key,
    required this.otpCtrl,
    this.displayText,
    required this.isProcessing,
    required this.onSubmit,
  });

  final TextEditingController otpCtrl;
  final String? displayText;
  final bool isProcessing;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          displayText ??
              'Enter the OTP sent to your phone/email (Demo OTP: 1234)',
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: 'One-Time Password (OTP)',
          controller: otpCtrl,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.lock_clock, size: 20),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton.primary(
          label: isProcessing ? 'Verifying with Bank...' : 'Authorize Payment',
          isLoading: isProcessing,
          onPressed: isProcessing ? null : onSubmit,
        ),
      ],
    );
  }
}
