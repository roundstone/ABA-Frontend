import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/config/app_brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../wallet/application/wallet_providers.dart';
import '../../domain/checkout_entities.dart';

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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
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
              Text(
                'Payment Method',
                style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 1. Credit / Debit Card
          _PaymentOptionTile(
            isSelected: selectedType == CheckoutPaymentType.card,
            onTap: () => onSelectType(CheckoutPaymentType.card),
            icon: HugeIcons.strokeRoundedCreditCard,
            title: 'Credit / Debit Card',
            subtitle: 'Secure payment via Visa, Mastercard, or Verve',
          ),

          // 2. ABA Wallet
          walletAsync.when(
            data: (info) => _PaymentOptionTile(
              isSelected: selectedType == CheckoutPaymentType.wallet,
              onTap: () => onSelectType(CheckoutPaymentType.wallet),
              icon: HugeIcons.strokeRoundedWallet01,
              title: '${AppBrand.shortName} Wallet',
              subtitle: 'Available Balance: ${formatNaira(info.balance)}',
            ),
            loading: () => _PaymentOptionTile(
              isSelected: selectedType == CheckoutPaymentType.wallet,
              onTap: () => onSelectType(CheckoutPaymentType.wallet),
              icon: HugeIcons.strokeRoundedWallet01,
              title: '${AppBrand.shortName} Wallet',
              subtitle: 'Checking balance...',
            ),
            error: (_, __) => _PaymentOptionTile(
              isSelected: selectedType == CheckoutPaymentType.wallet,
              onTap: () => onSelectType(CheckoutPaymentType.wallet),
              icon: HugeIcons.strokeRoundedWallet01,
              title: '${AppBrand.shortName} Wallet',
              subtitle: 'Wallet balance available',
            ),
          ),

          // 3. Bank Transfer
          _PaymentOptionTile(
            isSelected: selectedType == CheckoutPaymentType.bankTransfer,
            onTap: () => onSelectType(CheckoutPaymentType.bankTransfer),
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
                child: AppButton.outlined(
                  label: 'Back',
                  onPressed: onBack,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.primary(
                  label: 'Review Order',
                  onPressed: onContinue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  const _PaymentOptionTile({
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final List<List<dynamic>> icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.secondary.withAlpha(25)
                  : AppColors.primary.withAlpha(15))
              : (isDark ? const Color(0xFF252525) : Colors.white),
          borderRadius: AppSpacing.borderRadiusMD,
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.secondary : AppColors.primary)
                : (isDark ? Colors.white12 : AppColors.border),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: icon,
              color: isSelected
                  ? (isDark ? AppColors.secondary : AppColors.primary)
                  : AppColors.grey,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                color: isDark ? AppColors.secondary : AppColors.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
