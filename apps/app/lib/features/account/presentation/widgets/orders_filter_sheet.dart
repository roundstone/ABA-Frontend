import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../application/orders_providers.dart';
import '../../domain/customer_order.dart';

class OrdersFilterSheet extends ConsumerStatefulWidget {
  const OrdersFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLG),
        ),
      ),
      builder: (_) => const OrdersFilterSheet(),
    );
  }

  @override
  ConsumerState<OrdersFilterSheet> createState() => _OrdersFilterSheetState();
}

class _OrdersFilterSheetState extends ConsumerState<OrdersFilterSheet> {
  OrderStatus? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final state = ref.read(customerOrdersNotifierProvider);
    _selectedStatus = state.statusFilter;
    _startDate = state.startDate;
    _endDate = state.endDate;
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: _startDate ?? now.subtract(const Duration(days: 30)),
      end: _endDate ?? now,
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: initialRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _applyQuickPreset(int days) {
    final now = DateTime.now();
    setState(() {
      _endDate = now;
      _startDate = now.subtract(Duration(days: days));
    });
  }

  void _applyFilters() {
    final notifier = ref.read(customerOrdersNotifierProvider.notifier);
    notifier.setStatusFilter(_selectedStatus);
    notifier.setDateRange(_startDate, _endDate);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = null;
      _startDate = null;
      _endDate = null;
    });
    ref.read(customerOrdersNotifierProvider.notifier).clearAllFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateFmt = DateFormat('MMM d, yyyy');

    final dateRangeLabel = _startDate != null && _endDate != null
        ? '${dateFmt.format(_startDate!)} - ${dateFmt.format(_endDate!)}'
        : 'Select date range...';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter Orders', style: AppTypography.h4),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset All'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Date Range',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            GestureDetector(
              onTap: _pickDateRange,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: AppSpacing.borderRadiusMD,
                  border: Border.all(
                    color: _startDate != null
                        ? AppColors.primary
                        : (isDark ? Colors.white12 : AppColors.border),
                  ),
                ),
                child: Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedCalendar03,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        dateRangeLabel,
                        style: AppTypography.bodyMedium.copyWith(
                          color: _startDate != null ? cs.onSurface : AppColors.grey,
                        ),
                      ),
                    ),
                    if (_startDate != null)
                      GestureDetector(
                        onTap: () => setState(() {
                          _startDate = null;
                          _endDate = null;
                        }),
                        child: const Icon(Icons.close, size: 18),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Last 7 days'),
                  onPressed: () => _applyQuickPreset(7),
                ),
                ActionChip(
                  label: const Text('Last 30 days'),
                  onPressed: () => _applyQuickPreset(30),
                ),
                ActionChip(
                  label: const Text('Last 90 days'),
                  onPressed: () => _applyQuickPreset(90),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Order Status',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedStatus == null,
                  onSelected: (_) => setState(() => _selectedStatus = null),
                ),
                ...OrderStatus.values.map((status) {
                  return ChoiceChip(
                    label: Text(status.label),
                    selected: _selectedStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = selected ? status : null;
                      });
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: 'Apply Filters',
              onPressed: _applyFilters,
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ),
      ),
    );
  }
}

