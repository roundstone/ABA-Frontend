import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/shop_providers.dart';
import '../../domain/shop_entities.dart';
import 'shop_filter_sheet.dart';
import 'sort_bottom_sheet.dart';

class ShopToolbar extends ConsumerWidget {
  const ShopToolbar({
    super.key,
    required this.sort,
    required this.viewMode,
    required this.filterActive,
    required this.productCount,
  });

  final SortOrder sort;
  final ViewMode viewMode;
  final bool filterActive;
  final int productCount;

  String get _sortLabel {
    switch (sort) {
      case SortOrder.featured:
        return 'Featured';
      case SortOrder.nameAsc:
        return 'A–Z';
      case SortOrder.nameDesc:
        return 'Z–A';
      case SortOrder.priceLow:
        return 'Price ↑';
      case SortOrder.priceHigh:
        return 'Price ↓';
      case SortOrder.newest:
        return 'Newest';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final notifier = ref.read(shopNotifierProvider.notifier);

    return Row(
      children: [
        Text(
          '$productCount items',
          style: AppTypography.bodySmall.copyWith(
            color: cs.onSurface.withAlpha(153),
          ),
        ),
        const Spacer(),

        // Sort button
        _ToolbarButton(
          icon: HugeIcons.strokeRoundedSorting01,
          label: _sortLabel,
          onTap: () => showSortSheet(context, sort, (s) => notifier.setSort(s)),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Filter button
        _ToolbarButton(
          icon: HugeIcons.strokeRoundedFilterHorizontal,
          label: 'Filter',
          active: filterActive,
          onTap: () => showShopFilterSheet(context),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Grid/List toggle
        GestureDetector(
          onTap: () => notifier.setViewMode(
            viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: AppSpacing.borderRadiusSM,
            ),
            child: HugeIcon(
              icon: viewMode == ViewMode.grid
                  ? HugeIcons.strokeRoundedGridView
                  : HugeIcons.strokeRoundedListView,
              size: AppSpacing.iconSizeSM,
              color: cs.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? cs.secondary : cs.primary;
    final color = active ? primaryColor : cs.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: active
              ? primaryColor.withAlpha(20)
              : cs.surfaceContainerHighest,
          borderRadius: AppSpacing.borderRadiusSM,
          border: active
              ? Border.all(color: primaryColor.withAlpha(80), width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(icon: icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTypography.label.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

