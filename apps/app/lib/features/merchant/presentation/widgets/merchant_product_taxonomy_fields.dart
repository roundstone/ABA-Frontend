import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../shop/domain/brand.dart';
import '../../../shop/domain/shop_category.dart';

class MerchantProductTaxonomyFields extends StatelessWidget {
  const MerchantProductTaxonomyFields({
    super.key,
    required this.selectedCategoryId,
    required this.selectedSubcategoryId,
    required this.selectedBrandId,
    required this.productType,
    required this.categories,
    required this.subcategories,
    required this.brands,
    required this.onCategoryChanged,
    required this.onSubcategoryChanged,
    required this.onBrandChanged,
    required this.onTypeChanged,
  });

  final int? selectedCategoryId;
  final int? selectedSubcategoryId;
  final int? selectedBrandId;
  final int productType;
  final List<ShopCategory> categories;
  final List<ShopCategory> subcategories;
  final List<Brand> brands;
  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<int?> onSubcategoryChanged;
  final ValueChanged<int?> onBrandChanged;
  final ValueChanged<int> onTypeChanged;

  static const typeLabels = {
    1: 'Standard / Physical',
    2: 'Digital Product',
    3: 'Made-to-Order Service',
    4: 'Product Bundle',
  };

  int _parseId(String rawId, int fallbackIndex) {
    final direct = int.tryParse(rawId);
    if (direct != null && direct > 0) return direct;
    final digits = rawId.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isNotEmpty) {
      final parsed = int.tryParse(digits);
      if (parsed != null && parsed > 0) return parsed;
    }
    return fallbackIndex + 1;
  }

  @override
  Widget build(BuildContext context) {
    final categoryEntries = <int, String>{};
    for (var i = 0; i < categories.length; i++) {
      final c = categories[i];
      final id = _parseId(c.id, i);
      categoryEntries[id] = c.name;
    }

    final subcategoryEntries = <int, String>{};
    for (var i = 0; i < subcategories.length; i++) {
      final s = subcategories[i];
      final id = _parseId(s.id, i + 100);
      subcategoryEntries[id] = s.name;
    }

    final brandEntries = <int, String>{};
    for (var i = 0; i < brands.length; i++) {
      final b = brands[i];
      final id = b.id > 0 ? b.id : (i + 1);
      brandEntries[id] = b.name;
    }

    final effectiveCatId = categoryEntries.containsKey(selectedCategoryId) ? selectedCategoryId : null;
    final effectiveSubcatId = subcategoryEntries.containsKey(selectedSubcategoryId) ? selectedSubcategoryId : null;
    final effectiveBrandId = brandEntries.containsKey(selectedBrandId) ? selectedBrandId : null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppDropdownField<int?>(
                label: 'Category',
                value: effectiveCatId,
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('No Category', overflow: TextOverflow.ellipsis)),
                  ...categoryEntries.entries.map((e) => DropdownMenuItem<int?>(
                        value: e.key,
                        child: Text(e.value, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: onCategoryChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppDropdownField<int?>(
                label: 'Subcategory',
                value: effectiveSubcatId,
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('No Subcategory', overflow: TextOverflow.ellipsis)),
                  ...subcategoryEntries.entries.map((e) => DropdownMenuItem<int?>(
                        value: e.key,
                        child: Text(e.value, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: onSubcategoryChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: AppDropdownField<int?>(
                label: 'Brand',
                value: effectiveBrandId,
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('Generic / None', overflow: TextOverflow.ellipsis)),
                  ...brandEntries.entries.map((e) => DropdownMenuItem<int?>(
                        value: e.key,
                        child: Text(e.value, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: onBrandChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppDropdownField<int>(
                label: 'Type [1-4]',
                value: productType,
                items: typeLabels.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (v) => onTypeChanged(v ?? 1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
