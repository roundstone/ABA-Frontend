import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/merchant_product_entities.dart';

class MerchantLowStockTile extends StatelessWidget {
  const MerchantLowStockTile({
    super.key,
    required this.product,
    required this.onRestock,
  });

  final MerchantProduct product;
  final VoidCallback onRestock;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: product.isOutOfStock ? Colors.red : Colors.amber,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTypography.titleSmall.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.isOutOfStock
                      ? 'Out of Stock (0 units)'
                      : '${product.stock} units left (Threshold: ${product.lowStockThreshold})',
                  style: AppTypography.caption.copyWith(
                    color: product.isOutOfStock ? Colors.red : Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onRestock,
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: const Text('Restock', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
