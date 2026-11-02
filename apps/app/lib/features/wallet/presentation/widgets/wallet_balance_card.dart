import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/wallet_entities.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
    this.info,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    required this.onFund,
    required this.onWithdraw,
  });

  final WalletInfo? info;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback onFund;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withAlpha(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.borderRadiusLG,
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Total Balance',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white.withAlpha(204),
                ),
              ),
              const Spacer(),
              const HugeIcon(
                icon: HugeIcons.strokeRoundedWallet01,
                color: Colors.white,
                size: AppSpacing.iconSizeSM,
              ),
            ],
          ),
          AppSpacing.verticalSpaceXS,
          _buildAmountSection(),
          AppSpacing.verticalSpaceMD,
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onFund,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: cs.primary,
                  ),
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedPlusSign,
                    color: cs.primary,
                    size: AppSpacing.iconSizeSM,
                  ),
                  label: const Text('Fund Wallet'),
                ),
              ),
              AppSpacing.horizontalSpaceSM,
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onWithdraw,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDownRight01,
                    color: Colors.white,
                    size: AppSpacing.iconSizeSM,
                  ),
                  label: const Text('Withdraw'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    if (isLoading && info == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(55),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isLoading && info != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatNaira(info!.balance),
            style: AppTypography.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      );
    }

    if (errorMessage != null && info == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: onRetry,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Failed to load',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedReload,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Text(
      formatNaira(info?.balance ?? 0.0),
      style: AppTypography.h3.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
