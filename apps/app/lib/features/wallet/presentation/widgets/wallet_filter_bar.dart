import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/wallet_providers.dart';

class WalletFilterBar extends ConsumerWidget {
  const WalletFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(walletFilterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final chips = <Map<String, dynamic>>[
      {'label': 'All', 'type': null},
      {'label': 'Deposits', 'type': WalletTransactionType.deposit},
      {'label': 'Payments', 'type': WalletTransactionType.orderPayment},
      {'label': 'Withdrawals', 'type': WalletTransactionType.withdrawal},
      {'label': 'Refunds', 'type': WalletTransactionType.refund},
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final item = chips[index];
          final type = item['type'] as WalletTransactionType?;
          final isSelected = filter.type == type;

          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            label: Text(
              item['label'] as String,
              style: AppTypography.caption.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.onBackground),
              ),
            ),
            backgroundColor: isDark ? const Color(0xFF252525) : Colors.grey.shade100,
            selectedColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.white12 : AppColors.border),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            onSelected: (_) {
              ref.read(walletFilterProvider.notifier).update(
                    (state) => state.copyWith(type: type, clearType: type == null),
                  );
            },
          );
        },
      ),
    );
  }
}

