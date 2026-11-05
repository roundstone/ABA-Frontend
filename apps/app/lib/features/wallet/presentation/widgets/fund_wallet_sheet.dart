import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../checkout/presentation/widgets/paystack_payment_sheet.dart';
import '../../application/wallet_providers.dart';

class FundWalletSheet extends ConsumerStatefulWidget {
  const FundWalletSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: rootNavigatorKey.currentContext ?? context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FundWalletSheet(),
    );
  }

  @override
  ConsumerState<FundWalletSheet> createState() => _FundWalletSheetState();
}

class _FundWalletSheetState extends ConsumerState<FundWalletSheet> {
  static const List<int> _presets = [1000, 5000, 10000, 25000, 50000];

  final _amountCtrl = TextEditingController(text: '5000');
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _selectPreset(int amount) {
    setState(() {
      _amountCtrl.text = amount.toString();
      _errorText = null;
    });
  }

  Future<void> _handleProceed() async {
    final raw = _amountCtrl.text.replaceAll(',', '').trim();
    final amount = double.tryParse(raw);

    if (amount == null || amount < 100) {
      setState(() => _errorText = 'Please enter a valid amount (minimum ₦100)');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final repo = ref.read(walletRepositoryProvider);
      final initResult = await repo.initializeFundWallet(amount);

      if (!mounted) return;
      setState(() => _isLoading = false);

      final paidReference = await PaystackPaymentSheet.show(
        context,
        amount: initResult.amountNaira > 0 ? initResult.amountNaira : amount,
        email: initResult.email.isNotEmpty
            ? initResult.email
            : 'customer@buynaija.com',
        reference: initResult.reference,
        authorizationUrl: initResult.authorizationUrl,
      );

      if (!mounted) return;

      if (paidReference == null || paidReference.isEmpty) {
        return;
      }

      setState(() => _isLoading = true);
      final verifyRef = initResult.reference.isNotEmpty
          ? initResult.reference
          : paidReference;

      final verified = await repo.verifyFundWallet(verifyRef);
      if (!mounted) return;

      ref.invalidate(walletInfoProvider);
      ref.invalidate(walletTransactionsProvider);

      Navigator.of(context).pop(verified);
      AppSnackbar.show(
        context,
        message: verified
            ? 'Wallet funded successfully!'
            : 'Payment submitted! Your wallet balance will update shortly.',
        type: verified ? AppSnackbarType.success : AppSnackbarType.info,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorText = ApiError.toUserFriendlyMessage(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.lg + mq.padding.bottom,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          bottom: true,
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fund Wallet', style: AppTypography.h4),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Text(
              'Instant deposit via Paystack (Card, Bank Transfer, USSD, or OPay).',
              style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Amount (NGN)',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppTextField(
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              hintText: '5000.00',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  '₦',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              enabled: !_isLoading,
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets.map((preset) {
                final isSelected = _amountCtrl.text.trim() == preset.toString();
                return ActionChip(
                  label: Text('₦${preset ~/ 1000},000'),
                  backgroundColor: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : null,
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white12 : AppColors.border),
                  ),
                  onPressed: _isLoading ? null : () => _selectPreset(preset),
                );
              }).toList(),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusMD,
                ),
                child: Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedAlert02,
                      color: AppColors.error,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorText!,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: _isLoading ? 'Initializing...' : 'Proceed to Paystack',
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _handleProceed,
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}
