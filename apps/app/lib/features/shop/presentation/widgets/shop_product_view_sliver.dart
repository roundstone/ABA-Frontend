import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/shop_entities.dart';
import 'product_card.dart';
import 'shop_empty_products.dart';

class ShopProductViewSliver extends StatelessWidget {
  const ShopProductViewSliver({
    super.key,
    required this.products,
    required this.viewMode,
    required this.isInitialLoading,
    required this.error,
    required this.onRetry,
  });

  final List<Product> products;
  final ViewMode viewMode;
  final bool isInitialLoading;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      );
    }

    if (error != null && products.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorState(
          message: error.toString(),
          onRetry: onRetry,
        ),
      );
    }

    if (products.isEmpty) {
      return const SliverFillRemaining(child: ShopEmptyProducts());
    }

    if (viewMode == ViewMode.grid) {
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, i) => ProductCard(
              key: ValueKey('product_grid_${products[i].id}'),
              product: products[i],
            ),
            childCount: products.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.68,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => ProductCard(
            key: ValueKey('product_list_${products[i].id}'),
            product: products[i],
            listMode: true,
          ),
          childCount: products.length,
        ),
      ),
    );
  }
}

