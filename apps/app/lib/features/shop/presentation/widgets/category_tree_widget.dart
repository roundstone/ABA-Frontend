import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/shop_entities.dart';

/// Hierarchical tree widget for browsing and selecting categories and subcategories.
class CategoryTreeWidget extends StatefulWidget {
  const CategoryTreeWidget({
    super.key,
    required this.categories,
    required this.selectedSlugs,
    required this.onToggle,
    required this.isDark,
  });

  final List<ShopCategory> categories;
  final List<String> selectedSlugs;
  final ValueChanged<String> onToggle;
  final bool isDark;

  @override
  State<CategoryTreeWidget> createState() => _CategoryTreeWidgetState();
}

class _CategoryTreeWidgetState extends State<CategoryTreeWidget> {
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    _autoExpandActive();
  }

  @override
  void didUpdateWidget(covariant CategoryTreeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSlugs != widget.selectedSlugs ||
        oldWidget.categories != widget.categories) {
      _autoExpandActive();
    }
  }

  void _autoExpandActive() {
    for (final cat in widget.categories) {
      _checkAndExpand(cat);
    }
  }

  bool _checkAndExpand(ShopCategory node) {
    bool hasActive = false;
    for (final child in node.children) {
      if (widget.selectedSlugs.contains(child.slug) ||
          widget.selectedSlugs.contains(child.id) ||
          widget.selectedSlugs.contains(child.name)) {
        hasActive = true;
      }
      if (_checkAndExpand(child)) {
        hasActive = true;
      }
    }
    if (hasActive) {
      _expanded.add(node.id.toString());
    }
    return hasActive;
  }

  Widget _buildNode(ShopCategory node) {
    final fullPath = node.slug;
    final isSelected = widget.selectedSlugs.contains(fullPath);
    final hasChildren = node.children.isNotEmpty;
    final isExpanded = _expanded.contains(node.id.toString());
    final hasActiveChild = node.children.any(
      (c) =>
          widget.selectedSlugs.contains(c.slug) ||
          widget.selectedSlugs.contains(c.id) ||
          widget.selectedSlugs.contains(c.name) ||
          c.children.any((gc) => widget.selectedSlugs.contains(gc.slug)),
    );

    final color = widget.isDark ? AppColors.secondary : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => widget.onToggle(fullPath),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                if (hasChildren)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expanded.remove(node.id.toString());
                        } else {
                          _expanded.add(node.id.toString());
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        size: 20,
                        color: AppColors.grey,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 28),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          node.name,
                          style: AppTypography.bodySmall.copyWith(
                            color: isSelected ? color : null,
                            fontWeight: isSelected ? FontWeight.w700 : null,
                          ),
                        ),
                      ),
                      if (hasActiveChild && !isSelected) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  '(${node.productCount})',
                  style: AppTypography.label.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ),
        if (hasChildren && isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  node.children.map((child) => _buildNode(child)).toList(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.categories.map((c) => _buildNode(c)).toList(),
    );
  }
}
