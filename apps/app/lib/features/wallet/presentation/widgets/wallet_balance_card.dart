import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/wallet_entities.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
    required this.info,
    required this.onFund,
    required this.onWithdraw,
  });

  final WalletInfo info;
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
          Text(
            formatNaira(info.balance),
            style: AppTypography.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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
}
