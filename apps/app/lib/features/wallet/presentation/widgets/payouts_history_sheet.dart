import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../application/wallet_providers.dart';

class PayoutsHistorySheet extends ConsumerWidget {
  const PayoutsHistorySheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PayoutsHistorySheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final payoutsAsync = ref.watch(myPayoutsProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
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
                Text('Payouts & Withdrawals', style: AppTypography.h4),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            payoutsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (err, _) => ErrorState(
                message: ApiError.toUserFriendlyMessage(err),
                onRetry: () => ref.invalidate(myPayoutsProvider),
              ),
              data: (payouts) {
                if (payouts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Text(
                      'No withdrawals or payouts recorded yet.',
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: payouts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final p = payouts[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => _showPayoutDetailDialog(context, ref, p.id),
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowUpRight01,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                        title: Text(
                          formatNaira(p.amount),
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${p.bankName ?? 'Bank Payout'} • ${DateFormat('MMM d, y').format(p.createdAt)}',
                          style: AppTypography.caption.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(p.status).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            p.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _statusColor(p.status),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPayoutDetailDialog(
    BuildContext context,
    WidgetRef ref,
    String payoutId,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final detailAsync = ref.watch(payoutByIdProvider(payoutId));
          return AlertDialog(
            title: const Text('Payout Details'),
            content: detailAsync.when(
              loading: () => const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (err, _) => Text(ApiError.toUserFriendlyMessage(err)),
              data: (p) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount: ${formatNaira(p.amount)}',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Status: ${p.status.toUpperCase()}'),
                  if (p.reference != null) Text('Reference: ${p.reference}'),
                  if (p.bankName != null) Text('Bank: ${p.bankName}'),
                  if (p.accountNumber != null)
                    Text('Account: ${p.accountNumber}'),
                  if (p.accountName != null) Text('Name: ${p.accountName}'),
                  if (p.failureReason != null)
                    Text(
                      'Reason: ${p.failureReason}',
                      style: const TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('complete') || s.contains('paid') || s.contains('success')) {
      return AppColors.success;
    }
    if (s.contains('fail') || s.contains('reject') || s.contains('cancel')) {
      return AppColors.error;
    }
    return AppColors.warning;
  }
}

