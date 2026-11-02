import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../application/wallet_providers.dart';
import 'transaction_tile.dart';

/// Renders the reactive list of wallet transactions including loading,
/// filtered-empty, error with retry, and populated tile states.
class WalletTransactionsList extends ConsumerWidget {
  const WalletTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(walletTransactionsProvider);
    final filter = ref.watch(walletFilterProvider);

    return transactionsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (err, stack) => ErrorState(
        message: ApiError.toUserFriendlyMessage(err),
        onRetry: () => ref.invalidate(walletTransactionsProvider),
      ),
      data: (transactions) {
        if (transactions.isEmpty) {
          final hasFilter = filter.type != null;
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xl,
            ),
            child: Center(
              child: Text(
                hasFilter
                    ? 'No ${filter.type!.displayName.toLowerCase()} transactions found'
                    : 'No recent transactions',
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
    );
  }
}

