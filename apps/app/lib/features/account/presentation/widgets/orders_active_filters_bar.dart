import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/orders_providers.dart';

class OrdersActiveFiltersBar extends ConsumerWidget {
  const OrdersActiveFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerOrdersNotifierProvider);
    final notifier = ref.read(customerOrdersNotifierProvider.notifier);

    if (!state.hasActiveFilters) {
      return const SizedBox.shrink();
    }

    final dateFmt = DateFormat('MMM d');
    final hasDate = state.startDate != null && state.endDate != null;
    final dateLabel = hasDate
        ? '${dateFmt.format(state.startDate!)} - ${dateFmt.format(state.endDate!)}'
        : (state.startDate != null
            ? 'From ${dateFmt.format(state.startDate!)}'
            : (state.endDate != null
                ? 'Until ${dateFmt.format(state.endDate!)}'
                : ''));

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (state.statusFilter != null) ...[
              InputChip(
                label: Text(
                  'Status: ${state.statusFilter!.label}',
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => notifier.setStatusFilter(null),
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                side: const BorderSide(color: AppColors.primary, width: 0.5),
              ),
              const SizedBox(width: 8),
            ],
            if (dateLabel.isNotEmpty) ...[
              InputChip(
                avatar: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar03,
                  size: 14,
                  color: AppColors.primary,
                ),
                label: Text(
                  dateLabel,
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => notifier.clearDateRange(),
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                side: const BorderSide(color: AppColors.primary, width: 0.5),
              ),
              const SizedBox(width: 8),
            ],
            TextButton(
              onPressed: () => notifier.clearAllFilters(),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                'Clear All',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

