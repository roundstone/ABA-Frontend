import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/shop_providers.dart';
import '../../domain/shop_entities.dart';

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

  void _reset() {
    setState(() => _local = const ShopFilter());
  }

  // Derived options from catalogue
  List<String> get _brands {
    final cat = ref.read(shopCatalogueProvider).valueOrNull;
    if (cat == null) return [];
    return cat.products.map((p) => p.brand).toSet().toList()..sort();
  }

  List<String> get _colors {
    final cat = ref.read(shopCatalogueProvider).valueOrNull;
    if (cat == null) return [];
    final all = <String>{};
    for (final p in cat.products) {
      if (p.colors != null) all.addAll(p.colors!);
    }
    return all.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
            // Handle + header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: Column(
                children: [
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
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text('Filter',
                          style: AppTypography.h6
                              .copyWith(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      TextButton(
                        onPressed: _reset,
                        child: Text('Reset all',
                            style:
                                AppTypography.bodySmall.copyWith(color: AppColors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable filter sections
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  // Price range
                  _FilterSection(
                    title: 'Price Range',
                    child: Column(
                      children: [
                        RangeSlider(
                          values: RangeValues(
                            _local.priceRange.$1,
                            _local.priceRange.$2,
                          ),
                          min: 0,
                          max: 500000,
                          divisions: 100,
                          activeColor: cs.primary,
                          labels: RangeLabels(
                            '₦${(_local.priceRange.$1 / 1000).toStringAsFixed(0)}k',
                            '₦${(_local.priceRange.$2 / 1000).toStringAsFixed(0)}k',
                          ),
                          onChanged: (v) => setState(() => _local =
                              _local.copyWith(priceRange: (v.start, v.end))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₦${(_local.priceRange.$1 / 1000).toStringAsFixed(0)}k',
                              style: AppTypography.bodySmall,
                            ),
                            Text(
                              '₦${(_local.priceRange.$2 / 1000).toStringAsFixed(0)}k',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Brands
                  _FilterSection(
                    title: 'Brand',
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: _brands.map((brand) {
                        final selected = _local.brands.contains(brand);
                        return _FilterChip(
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

                  // Colors
                  _FilterSection(
                    title: 'Color',
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: _colors.map((color) {
                        final selected = _local.colors.contains(color);
                        return _FilterChip(
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
                  _FilterSection(
                    title: 'Minimum Rating',
                    child: Row(
                      children: List.generate(5, (i) {
                        final star = i + 1;
                        final selected = _local.ratings.contains(star);
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: _FilterChip(
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
                AppSpacing.md +
                    MediaQuery.of(context).padding.bottom,
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

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.bodyMedium
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          child,
          const Divider(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: AppSpacing.avatarRadius,
          border: selected
              ? null
              : Border.all(color: cs.outline.withAlpha(80), width: 1),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            color: selected ? Colors.white : cs.onSurface,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
