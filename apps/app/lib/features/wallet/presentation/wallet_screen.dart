import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/wallet_providers.dart';
import 'widgets/transaction_tile.dart';
import 'widgets/wallet_balance_card.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletInfoAsync = ref.watch(walletInfoProvider);
    final transactionsAsync = ref.watch(walletTransactionsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'My Wallet',
          style: AppTypography.h5.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSettings01,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(walletInfoProvider);
            ref.invalidate(walletTransactionsProvider);
          },
          child: ListView(
            padding: AppSpacing.paddingHorizontalMD,
            children: [
              AppSpacing.verticalSpaceMD,
              // Balance Card
              walletInfoAsync.when(
                loading: () => const SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => ErrorState(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(walletInfoProvider),
                ),
                data: (info) => WalletBalanceCard(
                  info: info,
                  onFund: () {
                    // TODO: Implement fund action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fund wallet tapped')),
                    );
                  },
                  onWithdraw: () {
                    // TODO: Implement withdraw action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Withdraw tapped')),
                    );
                  },
                ),
              ),
              AppSpacing.verticalSpaceLG,

              // Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: AppTypography.h6.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to all transactions
                    },
                    child: Text(
                      'See All',
                      style: AppTypography.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalSpaceSM,

              // Transactions List
              transactionsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => ErrorState(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(walletTransactionsProvider),
                ),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Center(
                        child: Text(
                          'No recent transactions',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionTile(
                        transaction: transactions[index],
                      );
                    },
                  );
                },
              ),
              
              // Extra padding at the bottom for the navigation bar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
