import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/shop_providers.dart';
import '../../domain/shop_entities.dart';
import 'shop_filter_widgets.dart';

/// Launch the filter bottom sheet.
void showShopFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _FilterSheet(),
  );
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet();

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late ShopFilter _local;

  @override
  void initState() {
    super.initState();
    _local = ref.read(shopNotifierProvider).filter;
  }

  void _apply() {
    ref.read(shopNotifierProvider.notifier).setFilter(_local);
    Navigator.of(context).pop();
  }

  void _reset() => setState(() => _local = const ShopFilter());

  List<String> get _brands =>
      ref.read(shopCatalogueProvider).valueOrNull?.products.map((p) => p.brand).toSet().toList() ??
      const [];

  static const _merchants = [
    'Aba Shoemakers',
    'Nigerian Fabrics',
    'Lagos Boutique',
    'Local Artisans',
  ];

  List<String> get _colors {
    final prods = ref.read(shopCatalogueProvider).valueOrNull?.products;
    if (prods == null) return const [];
    return {for (final p in prods) if (p.colors != null) ...p.colors!}.toList()..sort();
  }

  List<ShopCategory> get _categories =>
      ref.read(productCategoriesProvider).valueOrNull ??
      ref.read(shopCatalogueProvider).valueOrNull?.categories ??
      const [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusXXL),
            topRight: Radius.circular(AppSpacing.radiusXXL),
          ),
        ),
        child: Column(
          children: [
            FilterSheetHeader(isDark: isDark, onReset: _reset),

            // Scrollable filter sections
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  // Categories
                  FilterSection(
                    title: 'Categories',
                    child: CategoryTreeWidget(
                      categories: _categories,
                      selectedSlugs: _local.categories,
                      isDark: isDark,
                      onToggle: (slug) {
                        setState(() {
                          final updated = List<String>.from(_local.categories);
                          if (updated.contains(slug)) {
                            updated.remove(slug);
                          } else {
                            updated.add(slug);
                          }
                          _local = _local.copyWith(categories: updated);
                        });
                      },
                    ),
                  ),

                  // Price range
                  FilterSection(
                    title: 'Price Range',
                    child: PriceRangeSlider(
                      range: _local.priceRange,
                      onChanged: (v) =>
                          setState(() => _local = _local.copyWith(priceRange: v)),
                    ),
                  ),

                  // Brands
                  FilterSection(
                    title: 'Brand',
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: _brands.map((brand) {
                        final selected = _local.brands.contains(brand);
                        return FilterChipWidget(
                          label: brand,
                          selected: selected,
                          onTap: () => setState(() {
                            final updated = List<String>.from(_local.brands);
                            selected
                                ? updated.remove(brand)
                                : updated.add(brand);
                            _local = _local.copyWith(brands: updated);
                          }),
                        );
                      }).toList(),
                    ),
                  ),

                  // Merchants
                  FilterSection(
                    title: 'Merchant',
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: _merchants.map((merchant) {
                        final selected = _local.merchants.contains(merchant);
                        return FilterChipWidget(
                          label: merchant,
                          selected: selected,
                          onTap: () => setState(() {
                            final updated = List<String>.from(_local.merchants);
                            selected
                                ? updated.remove(merchant)
                                : updated.add(merchant);
                            _local = _local.copyWith(merchants: updated);
                          }),
                        );
                      }).toList(),
                    ),
                  ),

                  // Colors
                  FilterSection(
                    title: 'Color',
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: _colors.map((color) {
                        final selected = _local.colors.contains(color);
                        return FilterChipWidget(
                          label: color,
                          selected: selected,
                          onTap: () => setState(() {
                            final updated = List<String>.from(_local.colors);
                            selected
                                ? updated.remove(color)
                                : updated.add(color);
                            _local = _local.copyWith(colors: updated);
                          }),
                        );
                      }).toList(),
                    ),
                  ),

                  // Rating
                  FilterSection(
                    title: 'Minimum Rating',
                    child: Row(
                      children: List.generate(5, (i) {
                        final star = i + 1;
                        final selected = _local.ratings.contains(star);
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: FilterChipWidget(
                            label: '$star★',
                            selected: selected,
                            onTap: () => setState(() {
                              final updated = List<int>.from(_local.ratings);
                              selected
                                  ? updated.remove(star)
                                  : updated.add(star);
                              _local = _local.copyWith(ratings: updated);
                            }),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),

            // Apply button
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md + MediaQuery.of(context).padding.bottom,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _apply,
                  child: const Text('Apply Filters'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
