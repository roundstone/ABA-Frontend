import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/merchant_product_entities.dart';
import 'pos_product_tile.dart';

/// Grid of products for POS walk-in session with responsive states.
class PosProductsGrid extends StatelessWidget {
  const PosProductsGrid({
    super.key,
    required this.products,
    required this.cart,
    required this.isLoading,
    required this.errorMessage,
    required this.onAddToCart,
    required this.onRetry,
  });

  final List<MerchantProduct> products;
  final Map<String, int> cart;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<MerchantProduct> onAddToCart;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (errorMessage != null && products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $errorMessage'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 60),
          Center(
            child: Text(
              'No products found matching filters',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.sm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.25,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final p = products[i];
        final inCartQty = cart[p.id] ?? 0;
        return PosProductTile(
          product: p,
          inCartQty: inCartQty,
          onTap: () => onAddToCart(p),
        );
      },
    );
  }
}

