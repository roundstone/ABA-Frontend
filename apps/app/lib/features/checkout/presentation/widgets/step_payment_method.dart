import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/config/app_brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../cart/application/cart_providers.dart';
import '../../../wallet/application/wallet_providers.dart';
import '../../../wallet/presentation/widgets/fund_wallet_sheet.dart';
import '../../domain/checkout_entities.dart';
import 'payment_option_tile.dart';

class StepPaymentMethod extends ConsumerWidget {
  const StepPaymentMethod({
    super.key,
    required this.selectedType,
    required this.onSelectType,
    required this.onBack,
    required this.onContinue,
  });

  final CheckoutPaymentType selectedType;
  final ValueChanged<CheckoutPaymentType> onSelectType;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final walletAsync = ref.watch(walletInfoProvider);
    final cartAsync = ref.watch(cartProvider);
    final orderTotal = cartAsync.value?.subtotal ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedCreditCard,
                color: isDark ? AppColors.secondary : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Payment Method',
                  style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 1. Paystack Gateway (Card, Transfer, USSD)
          PaymentOptionTile(
            isSelected:
                selectedType == CheckoutPaymentType.paystack ||
                selectedType == CheckoutPaymentType.card,
            onTap: () => onSelectType(CheckoutPaymentType.paystack),
            icon: HugeIcons.strokeRoundedCreditCard,
            title: 'Paystack Gateway',
            subtitle: 'Debit card, Bank Transfer, USSD (Secured by Paystack)',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0BA4DB).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'paystack',
                style: TextStyle(
                  color: Color(0xFF0BA4DB),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 2. ABA Wallet (paymentMethod: 2)
          walletAsync.when(
            data: (info) {
              final isSufficient = info.balance >= orderTotal;
              return PaymentOptionTile(
                isSelected: selectedType == CheckoutPaymentType.wallet,
                onTap: () => onSelectType(CheckoutPaymentType.wallet),
                icon: HugeIcons.strokeRoundedWallet01,
                title: '${AppBrand.shortName} Wallet',
                subtitle: isSufficient
                    ? 'Available Balance: ${formatNaira(info.balance)}'
                    : 'Available Balance: ${formatNaira(info.balance)} (Low balance)',
              );
            },
            loading: () => PaymentOptionTile(
              isSelected: selectedType == CheckoutPaymentType.wallet,
              onTap: () => onSelectType(CheckoutPaymentType.wallet),
              icon: HugeIcons.strokeRoundedWallet01,
              title: '${AppBrand.shortName} Wallet',
              subtitle: 'Checking balance...',
            ),
            error: (_, __) => PaymentOptionTile(
              isSelected: selectedType == CheckoutPaymentType.wallet,
              onTap: () => onSelectType(CheckoutPaymentType.wallet),
              icon: HugeIcons.strokeRoundedWallet01,
              title: '${AppBrand.shortName} Wallet',
              subtitle: 'Pay directly from your wallet balance',
            ),
          ),

          // 3. Bank Transfer
          PaymentOptionTile(
            isSelected: selectedType == CheckoutPaymentType.bankTransfer,
            onTap: () =>
                AppSnackbar.info(context, 'Bank transfer coming soon!'),
            icon: HugeIcons.strokeRoundedBank,
            title: 'Bank Transfer',
            subtitle: 'Instant transfer to designated escrow account',
          ),

          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : AppColors.surface2,
              borderRadius: AppSpacing.borderRadiusMD,
            ),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedShieldCheck,
                  color: AppColors.success,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '256-bit SSL encrypted & NDPR compliant checkout.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(label: 'Back', onPressed: onBack),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.primary(
                  label: 'Review Order',
                  onPressed: () {
                    if (selectedType == CheckoutPaymentType.wallet) {
                      final balance = walletAsync.value?.balance ?? 0.0;
                      if (orderTotal > 0 && balance < orderTotal) {
                        AppSnackbar.error(
                          context,
                          'Insufficient wallet balance (${formatNaira(balance)}).',
                          actionLabel: 'Fund wallet',
                          onAction: () async {
                            final funded = await FundWalletSheet.show(context);
                            if (funded == true) {
                              ref.invalidate(walletInfoProvider);
                            }
                          },
                        );
                        return;
                      }
                    }
                    onContinue();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
