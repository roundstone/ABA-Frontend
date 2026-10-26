import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/merchant_product_entities.dart';
import 'merchant_status_badge.dart';

class MerchantProductCard extends StatelessWidget {
  const MerchantProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onAdjustStock,
  });

  final MerchantProduct product;
  final VoidCallback onEdit;
  final VoidCallback onAdjustStock;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNetworkImage.product(
                imageUrl: product.imageUrl,
                width: 64,
                height: 64,
                borderRadius: AppSpacing.borderRadiusMD,
                backgroundColor: isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF1F5F9),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        MerchantStockBadge(product: product),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'SKU: ${product.sku} • ${product.category}',
                      style: AppTypography.caption.copyWith(
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF64748B),
                        fontSize: 11.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatNaira(product.price),
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.secondary
                                : AppColors.primary,
                          ),
                        ),
                        if (product.costPrice > 0)
                          Text(
                            'Margin: ${product.marginPercentage.toStringAsFixed(0)}%',
                            style: AppTypography.caption.copyWith(
                              color: const Color(0xFF10B981),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Divider(
            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F5F9),
            height: 1,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onAdjustStock,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedExchange01,
                  size: 14,
                  color: Color(0xFF0284C7),
                ),
                label: const Text(
                  'Adjust Stock',
                  style: TextStyle(fontSize: 12, color: Color(0xFF0284C7)),
                ),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedEdit02,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
                label: const Text('Edit', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF3B4252)
                        : const Color(0xFFCBD5E1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
