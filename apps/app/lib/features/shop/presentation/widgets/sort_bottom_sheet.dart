import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/shop_entities.dart';

/// Bottom sheet for selecting sort order.
void showSortSheet(
  BuildContext context,
  SortOrder current,
  ValueChanged<SortOrder> onSelect,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _SortSheet(current: current, onSelect: onSelect),
  );
}

class _SortSheet extends StatelessWidget {
  const _SortSheet({required this.current, required this.onSelect});
  final SortOrder current;
  final ValueChanged<SortOrder> onSelect;

  static const _options = <(SortOrder, String)>[
    (SortOrder.featured, 'Featured'),
    (SortOrder.newest, 'Newest first'),
    (SortOrder.nameAsc, 'Name: A–Z'),
    (SortOrder.nameDesc, 'Name: Z–A'),
    (SortOrder.priceLow, 'Price: Low to High'),
    (SortOrder.priceHigh, 'Price: High to Low'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXXL),
          topRight: Radius.circular(AppSpacing.radiusXXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withAlpha(40)
                  : Colors.black.withAlpha(20),
              borderRadius: AppSpacing.avatarRadius,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sort by',
                style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          ..._options.map(
            (opt) => ListTile(
              title: Text(opt.$2, style: AppTypography.bodyMedium),
              trailing: current == opt.$1
                  ? Icon(Icons.check_rounded, color: cs.primary, size: 20)
                  : null,
              onTap: () {
                Navigator.of(context).pop();
                onSelect(opt.$1);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
