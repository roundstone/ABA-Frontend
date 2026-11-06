import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/network/api_error.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/application/auth_providers.dart';
import '../application/wallet_providers.dart';
import 'widgets/fund_wallet_sheet.dart';
import 'widgets/manage_bank_accounts_sheet.dart';
import 'widgets/payouts_history_sheet.dart';
import 'widgets/wallet_balance_card.dart';
import 'widgets/wallet_credits_banner.dart';
import 'widgets/wallet_filter_bar.dart';
import 'widgets/wallet_transactions_list.dart';
import 'widgets/withdraw_wallet_sheet.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletInfoAsync = ref.watch(walletInfoProvider);
    final shoppingCreditsAsync = ref.watch(shoppingCreditsProvider);
    final filter = ref.watch(walletFilterProvider);
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
                  final fallback = ref.read(authStateProvider).isMerchant
                      ? '/merchant'
                      : '/home';
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
            onPressed: () => ManageBankAccountsSheet.show(context),
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedBank,
              color: AppColors.grey,
            ),
            tooltip: 'Bank Accounts',
          ),
          IconButton(
            onPressed: () => PayoutsHistorySheet.show(context),
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedInvoice01,
              color: AppColors.grey,
            ),
            tooltip: 'Payouts History',
          ),
        ],
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final fallback = ref.read(authStateProvider).isMerchant
              ? '/merchant'
              : '/home';
          context.popOrGo(fallback);
        },
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(walletInfoProvider);
              ref.invalidate(shoppingCreditsProvider);
              ref.invalidate(walletTransactionsProvider);
              ref.invalidate(userBankAccountsProvider);
              ref.invalidate(myPayoutsProvider);
            },
            child: ListView(
              padding: AppSpacing.paddingHorizontalMD,
              children: [
                AppSpacing.verticalSpaceMD,
                // Balance Card (card always renders; only amount section loads)
                WalletBalanceCard(
                  info: walletInfoAsync.valueOrNull,
                  credits: shoppingCreditsAsync.valueOrNull,
                  isLoading: walletInfoAsync.isLoading,
                  isCreditsLoading: shoppingCreditsAsync.isLoading,
                  errorMessage:
                      walletInfoAsync.hasError &&
                          walletInfoAsync.valueOrNull == null
                      ? ApiError.toUserFriendlyMessage(walletInfoAsync.error)
                      : null,
                  onRetry: () {
                    ref.invalidate(walletInfoProvider);
                    ref.invalidate(shoppingCreditsProvider);
                  },
                  onFund: () => FundWalletSheet.show(context),
                  onWithdraw: () => WithdrawWalletSheet.show(
                    context,
                    availableBalance:
                        walletInfoAsync.valueOrNull?.balance ?? 0.0,
                  ),
                ),
                AppSpacing.verticalSpaceSM,
                // Shopping Credits Card (Non-Withdrawable) -> Not needed now; leave commented for future reference
                // WalletCreditsBanner(
                //   credits: shoppingCreditsAsync.valueOrNull,
                //   isLoading: shoppingCreditsAsync.isLoading,
                //   onRetry: () => ref.invalidate(shoppingCreditsProvider),
                // ),
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
                      color: isDark
                          ? const Color(0xFF1E2820)
                          : const Color(0xFFF1F8F3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF2C3E30)
                            : const Color(0xFFD0E6D5),
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
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.grey,
                          size: 20,
                        ),
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
                    if (filter.type != null)
                      TextButton(
                        onPressed: () {
                          ref
                              .read(walletFilterProvider.notifier)
                              .update((s) => s.copyWith(clearType: true));
                        },
                        child: const Text('Clear Filter'),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                const WalletFilterBar(),
                AppSpacing.verticalSpaceSM,

                // Transactions List
                const WalletTransactionsList(),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
