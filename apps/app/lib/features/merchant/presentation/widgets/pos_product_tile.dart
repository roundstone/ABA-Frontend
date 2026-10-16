import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/merchant_product_entities.dart';

class PosProductTile extends StatelessWidget {
  const PosProductTile({
    super.key,
    required this.product,
    required this.inCartQty,
    required this.onTap,
  });

  final MerchantProduct product;
  final int inCartQty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMD,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: AppSpacing.borderRadiusMD,
          border: Border.all(
            color: inCartQty > 0
                ? (isDark ? AppColors.secondary : AppColors.primary)
                : (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0)),
            width: inCartQty > 0 ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (inCartQty > 0)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: isDark ? AppColors.secondary : AppColors.primary,
                    child: Text(
                      '$inCartQty',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatNaira(product.price),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.secondary : AppColors.primary,
                  ),
                ),
                Text(
                  product.isOutOfStock ? 'Out' : '${product.stock} left',
                  style: TextStyle(
                    fontSize: 10,
                    color: product.isOutOfStock ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
