import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../application/wallet_providers.dart';
import 'add_bank_account_sheet.dart';

class ManageBankAccountsSheet extends ConsumerStatefulWidget {
  const ManageBankAccountsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ManageBankAccountsSheet(),
    );
  }

  @override
  ConsumerState<ManageBankAccountsSheet> createState() =>
      _ManageBankAccountsSheetState();
}

class _ManageBankAccountsSheetState
    extends ConsumerState<ManageBankAccountsSheet> {
  int? _busyId;

  Future<void> _setPrimary(UserBankAccount acc) async {
    setState(() => _busyId = acc.id);
    try {
      await ref
          .read(walletRepositoryProvider)
          .updateBankAccount(acc.id, isPrimary: true);
      ref.invalidate(userBankAccountsProvider);
      if (mounted) {
        AppSnackbar.show(
          context,
          message: '${acc.bankName} set as primary account.',
          type: AppSnackbarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(
          context,
          message: ApiError.toUserFriendlyMessage(e),
          type: AppSnackbarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  Future<void> _deleteAccount(UserBankAccount acc) async {
    setState(() => _busyId = acc.id);
    try {
      await ref.read(walletRepositoryProvider).deleteBankAccount(acc.id);
      ref.invalidate(userBankAccountsProvider);
      if (mounted) {
        AppSnackbar.show(
          context,
          message: 'Bank account removed.',
          type: AppSnackbarType.info,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(
          context,
          message: ApiError.toUserFriendlyMessage(e),
          type: AppSnackbarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accountsAsync = ref.watch(userBankAccountsProvider);

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
                Text('Saved Bank Accounts', style: AppTypography.h4),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            accountsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (err, _) => ErrorState(
                message: ApiError.toUserFriendlyMessage(err),
                onRetry: () => ref.invalidate(userBankAccountsProvider),
              ),
              data: (accounts) {
                if (accounts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Text(
                      'No bank accounts saved yet.',
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: accounts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final acc = accounts[index];
                      final isBusy = _busyId == acc.id;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedBank,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                acc.accountName.isNotEmpty
                                    ? acc.accountName
                                    : acc.bankName,
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (acc.isPrimary)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.success.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PRIMARY',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          '${acc.bankName} • ${acc.accountNumber}',
                          style: AppTypography.caption.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        trailing: isBusy
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                ),
                              )
                            : PopupMenuButton<String>(
                                onSelected: (action) {
                                  if (action == 'primary') {
                                    _setPrimary(acc);
                                  } else if (action == 'edit') {
                                    AddBankAccountSheet.show(
                                      context,
                                      existingAccount: acc,
                                    );
                                  } else if (action == 'delete') {
                                    _deleteAccount(acc);
                                  }
                                },
                                itemBuilder: (_) => [
                                  if (!acc.isPrimary)
                                    const PopupMenuItem(
                                      value: 'primary',
                                      child: Text('Set as Primary'),
                                    ),
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit Account'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: AppColors.error),
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton.primary(
              label: 'Add New Bank Account',
              onPressed: () => AddBankAccountSheet.show(context),
            ),
          ],
        ),
      ),
    );
  }
}
