import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../auth/application/auth_providers.dart';
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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: context.canPopSafely
            ? IconButton(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft01,
                  color: isDark ? Colors.white : AppColors.onBackground,
                  size: 20,
                ),
                tooltip: 'Back',
                onPressed: () {
                  final fallback = ref.read(authStateProvider).isMerchant ? '/merchant' : '/home';
                  context.popOrGo(fallback);
                },
              )
            : null,
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
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final fallback = ref.read(authStateProvider).isMerchant ? '/merchant' : '/home';
          context.popOrGo(fallback);
        },
        child: SafeArea(
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
                AppSpacing.verticalSpaceMD,

                // Commission Flow Ledger Card
                InkWell(
                  onTap: () => context.push('/referrals/ledger'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm + 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2820) : const Color(0xFFF1F8F3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2C3E30) : const Color(0xFFD0E6D5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedBook02,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Commission Flow Ledger',
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Trace double-entry journal entries from order to bank payout',
                                style: AppTypography.caption.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
                      ],
                    ),
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
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xl,
                        ),
                        child: Center(
                          child: Text(
                            'No recent transactions',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(153),
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
      ),
    );
  }
}
