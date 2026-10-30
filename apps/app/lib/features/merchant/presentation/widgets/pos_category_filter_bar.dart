import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shop/domain/shop_entities.dart';
import '../../application/merchant_providers.dart';

/// Counter-friendly compact category & subcategory chip filter for POS.
/// Maintains POS counter aesthetic while loading taxonomy dynamically from the API.
class PosCategoryFilterBar extends ConsumerWidget {
  const PosCategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.onSelectCategory,
    required this.onSelectSubcategory,
    this.isLoading = false,
  });

  final List<ShopCategory> categories;
  final ShopCategory? selectedCategory;
  final ShopCategory? selectedSubcategory;
  final ValueChanged<ShopCategory?> onSelectCategory;
  final ValueChanged<ShopCategory?> onSelectSubcategory;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.secondary : AppColors.primary;

    // Resolve subcategories for the selected category:
    // 1. From embedded children in ShopCategory (returned directly by API)
    // 2. From merchantSubcategoriesProvider if children list is empty
    List<ShopCategory> subcategories = const [];
    if (selectedCategory != null) {
      if (selectedCategory!.children.isNotEmpty) {
        subcategories = selectedCategory!.children;
      } else {
        final catId = int.tryParse(selectedCategory!.id);
        final subcatsAsync = ref.watch(merchantSubcategoriesProvider(catId));
        subcategories = subcatsAsync.valueOrNull ?? const [];
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Main categories row ──────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  visualDensity: VisualDensity.compact,
                  label: const Text(
                    'All',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  selected: selectedCategory == null,
                  selectedColor: primaryColor.withValues(alpha: 0.15),
                  onSelected: (_) => onSelectCategory(null),
                ),
              ),
              ...categories.map((cat) {
                final isSelected = selectedCategory?.id == cat.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: primaryColor.withValues(alpha: 0.15),
                    onSelected: (_) =>
                        onSelectCategory(isSelected ? null : cat),
                  ),
                );
              }),
            ],
          ),
        ),

        // ── Subcategories row (visible if category has subcategories) ──
        if (selectedCategory != null && subcategories.isNotEmpty) ...[
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      'All in ${selectedCategory!.name}',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: selectedSubcategory == null,
                    selectedColor: primaryColor.withValues(alpha: 0.2),
                    onSelected: (_) => onSelectSubcategory(null),
                  ),
                ),
                ...subcategories.map((sub) {
                  final isSubSelected = selectedSubcategory?.id == sub.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        sub.name,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: isSubSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      selected: isSubSelected,
                      selectedColor: primaryColor.withValues(alpha: 0.2),
                      onSelected: (_) =>
                          onSelectSubcategory(isSubSelected ? null : sub),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

