import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/wallet_entities.dart';

class BankAccountSelectorList extends StatelessWidget {
  const BankAccountSelectorList({
    super.key,
    required this.accounts,
    required this.selectedAccountId,
    required this.isSubmitting,
    required this.onSelect,
    required this.onAddAccount,
  });

  final List<UserBankAccount> accounts;
  final int? selectedAccountId;
  final bool isSubmitting;
  final ValueChanged<int> onSelect;
  final VoidCallback onAddAccount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (accounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.white12 : AppColors.border,
          ),
          borderRadius: AppSpacing.borderRadiusMD,
        ),
        child: Column(
          children: [
            Text(
              'No bank account linked yet. Add a bank account to receive withdrawals.',
              style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.outlined(
              label: 'Add Bank Account',
              onPressed: isSubmitting ? null : onAddAccount,
            ),
          ],
        ),
      );
    }

    final activeId = selectedAccountId ??
        accounts.where((a) => a.isPrimary).firstOrNull?.id ??
        accounts.first.id;

    return Column(
      children: accounts.map((acc) {
        final isSelected = acc.id == activeId;
        return InkWell(
          onTap: isSubmitting ? null : () => onSelect(acc.id),
          borderRadius: AppSpacing.borderRadiusMD,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : null,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.white12 : AppColors.border),
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: AppSpacing.borderRadiusMD,
            ),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedBank,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.15),
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
                      Text(
                        '${acc.bankName} • ${acc.accountNumber}',
                        style: AppTypography.caption.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected ? AppColors.primary : AppColors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

