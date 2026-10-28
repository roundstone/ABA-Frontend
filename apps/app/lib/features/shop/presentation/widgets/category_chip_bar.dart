import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/shop_entities.dart';
import 'category_chip_items.dart';

/// Horizontal scrollable category chip strip supporting live categories,
/// expandable subcategories, and active indicators.
class CategoryChipBar extends StatefulWidget {
  const CategoryChipBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
    this.isLoading = false,
  });

  final List<ShopCategory> categories;
  final String? selected;
  final ValueChanged<String?> onSelect;
  final bool isLoading;

  @override
  State<CategoryChipBar> createState() => _CategoryChipBarState();
}

class _CategoryChipBarState extends State<CategoryChipBar> {
  String? _expandedCategoryId;

  @override
  void initState() {
    super.initState();
    _syncExpandedWithSelection();
  }

  @override
  void didUpdateWidget(covariant CategoryChipBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected ||
        oldWidget.categories != widget.categories) {
      _syncExpandedWithSelection();
    }
  }

  void _syncExpandedWithSelection() {
    if (widget.selected == null || widget.selected!.isEmpty) return;
    for (final cat in widget.categories) {
      final hasActiveChild =
          cat.children.any((c) => c.matches(widget.selected));
      if (hasActiveChild || cat.matches(widget.selected)) {
        if (cat.hasChildren) _expandedCategoryId = cat.id;
        break;
      }
    }
  }

  ShopCategory? get _expandedCategory {
    if (_expandedCategoryId == null) return null;
    try {
      return widget.categories.firstWhere((c) => c.id == _expandedCategoryId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? cs.secondary : cs.primary;

    if (widget.isLoading && widget.categories.isEmpty) {
      return _buildSkeletonBar(context, isDark);
    }

    final expandedCat = _expandedCategory;
    final showSubcategories = expandedCat != null && expandedCat.hasChildren;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 32,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 1,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
            itemBuilder: (context, i) {
              if (i == 0) {
                final isAll =
                    widget.selected == null || widget.selected!.isEmpty;
                return CategoryChipItem(
                  label: 'All',
                  isSelected: isAll,
                  onTap: () {
                    setState(() => _expandedCategoryId = null);
                    widget.onSelect(null);
                  },
                  primaryColor: primaryColor,
                  isDark: isDark,
                );
              }

              final cat = widget.categories[i - 1];
              final isDirectlySelected = cat.matches(widget.selected);
              final hasActiveSub =
                  cat.children.any((c) => c.matches(widget.selected));
              final isExpanded = _expandedCategoryId == cat.id;

              return CategoryChipItem(
                label: cat.name,
                count: cat.productCount,
                isSelected: isDirectlySelected,
                hasActiveChild: hasActiveSub,
                hasChildren: cat.hasChildren,
                isExpanded: isExpanded,
                onTap: () {
                  setState(() {
                    if (cat.hasChildren) {
                      _expandedCategoryId = isExpanded ? null : cat.id;
                    }
                  });
                  widget.onSelect(isDirectlySelected ? null : cat.name);
                },
                onToggleExpand: cat.hasChildren
                    ? () {
                        setState(() {
                          _expandedCategoryId = isExpanded ? null : cat.id;
                        });
                      }
                    : null,
                primaryColor: primaryColor,
                isDark: isDark,
              );
            },
          ),
        ),
        if (showSubcategories) ...[
          const SizedBox(height: 6),
          SizedBox(
            height: 28,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 1,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: expandedCat.children.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, idx) {
                if (idx == 0) {
                  final isAllSelected = expandedCat.matches(widget.selected);
                  return SubCategoryChipItem(
                    label: 'All in ${expandedCat.name}',
                    isSelected: isAllSelected,
                    onTap: () => widget.onSelect(expandedCat.name),
                    primaryColor: primaryColor,
                    isDark: isDark,
                  );
                }

                final sub = expandedCat.children[idx - 1];
                final isSubSelected = sub.matches(widget.selected);
                final label = sub.productCount > 0
                    ? '${sub.name} (${sub.productCount})'
                    : sub.name;

                return SubCategoryChipItem(
                  label: label,
                  isSelected: isSubSelected,
                  onTap: () {
                    widget.onSelect(
                      isSubSelected ? expandedCat.name : sub.name,
                    );
                  },
                  primaryColor: primaryColor,
                  isDark: isDark,
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSkeletonBar(BuildContext context, bool isDark) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 2,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, i) => Container(
          width: i == 0 ? 48 : 84,
          height: 32,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB),
            borderRadius: AppSpacing.avatarRadius,
          ),
        ),
      ),
    );
  }
}
