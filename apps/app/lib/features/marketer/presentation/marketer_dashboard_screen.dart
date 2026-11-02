import 'package:app/core/network/dio_client.dart';
import 'package:app/core/widgets/app_snackbar.dart';
import 'package:app/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:app/features/wallet/presentation/widgets/wallet_filter_bar.dart';
import 'package:app/features/wallet/presentation/widgets/wallet_transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../auth/application/auth_providers.dart';
import '../../customer/presentation/more_menu_sheet.dart';
import '../../wallet/application/wallet_providers.dart';
import '../application/marketer_providers.dart';
import 'widgets/marketer_quick_actions.dart';
import 'widgets/marketer_stats_grid.dart';

class MarketerDashboardScreen extends ConsumerWidget {
  const MarketerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(marketerStatsProvider);
    final walletAsync = ref.watch(walletInfoProvider);
    // final merchantAsync = ref.watch(associatedMerchantProvider);

    final stats = statsAsync.valueOrNull ?? MarketerStats.empty();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: isDark
                  ? AppColors.primary.withAlpha(60)
                  : AppColors.secondary,
              child: Text(
                user != null && user.name.isNotEmpty
                    ? user.name[0].toUpperCase()
                    : 'M',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Marketer',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user?.referralCode != null && user!.referralCode!.isNotEmpty
                        ? 'Code: ${user.referralCode}'
                        : 'MARKETER PORTAL',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.secondary : AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          const NotificationIconButton(iconSize: 20),
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedMenu01,
              color: AppColors.primary,
              size: 22,
            ),
            tooltip: 'Menu',
            onPressed: () => showMoreMenu(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(marketerStatsProvider);
          ref.invalidate(walletInfoProvider);
          ref.invalidate(walletTransactionsProvider);
          await Future.wait([
            ref.read(marketerStatsProvider.future),
            ref.read(walletInfoProvider.future),
            ref.read(walletTransactionsProvider.future),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Wallet Card
              WalletBalanceCard(
                info: walletAsync.valueOrNull,
                isLoading: walletAsync.isLoading,
                errorMessage:
                    walletAsync.hasError && walletAsync.valueOrNull == null
                    ? ApiError.toUserFriendlyMessage(walletAsync.error)
                    : null,
                onRetry: () => ref.invalidate(walletInfoProvider),
                onFund: () {
                  AppSnackbar.info(context, 'Fund wallet coming soon');
                },
                onWithdraw: () {
                  AppSnackbar.info(context, 'Withdrawal coming soon');
                },
              ),
              AppSpacing.verticalSpaceMD,

              const SizedBox(height: AppSpacing.lg),

              // Quick Actions
              const MarketerQuickActions(),

              const SizedBox(height: AppSpacing.lg),

              // Performance Stats Grid
              MarketerStatsGrid(stats: stats),

              const SizedBox(height: AppSpacing.lg),

              // Affiliated Merchant Preview
              // MarketerAssociatedMerchantCard(
              //   merchant: merchantAsync.valueOrNull,
              // ),
              const SizedBox(height: AppSpacing.lg),

              // Recent Transactions History
              const SizedBox(height: AppSpacing.xs),
              const WalletFilterBar(),
              AppSpacing.verticalSpaceSM,
              const WalletTransactionsList(),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
