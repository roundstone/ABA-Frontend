import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/shop_providers.dart';

class PopularBrands extends ConsumerWidget {
  const PopularBrands({super.key, this.onSelect});

  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(popularBrandsProvider);
    final brands = brandsAsync.valueOrNull?.map((b) => b.name).toList() ??
        const ['Nike', 'Adidas', 'Gucci', 'Aba Artisans', 'Puma', 'Zara'];
    if (brands.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'Popular Brands',
            style: AppTypography.h6.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) => ActionChip(
              label: Text(brands[i]),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              onPressed: () {
                if (onSelect != null) {
                  onSelect!(brands[i]);
                } else {
                  ref.read(shopNotifierProvider.notifier).setSearch(brands[i]);
                }
              },
              side: BorderSide.none,
              shape: const RoundedRectangleBorder(
                borderRadius: AppSpacing.borderRadiusSM,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

