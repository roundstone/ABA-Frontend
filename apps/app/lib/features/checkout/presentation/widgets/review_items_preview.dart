import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../shop/domain/shop_entities.dart';

class ReviewItemsPreview extends StatelessWidget {
  const ReviewItemsPreview({super.key, required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...items.take(3).map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                AppNetworkImage.product(
                  imageUrl: item.product.images.isNotEmpty
                      ? item.product.images.first
                      : null,
                  width: 36,
                  height: 36,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Qty: ${item.quantity}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatNaira(item.itemTotal),
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }),
        if (items.length > 3) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '+ ${items.length - 3} more items',
              style: AppTypography.caption.copyWith(
                color: AppColors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
