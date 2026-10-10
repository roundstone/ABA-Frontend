import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/merchant_entities.dart';

class MerchantRatingRow extends StatelessWidget {
  const MerchantRatingRow({super.key, required this.merchant});
  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          color: Color(0xFFF59E0B),
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          merchant.rating.toStringAsFixed(1),
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${merchant.reviewCount})',
          style: AppTypography.caption.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}

class MerchantMetaRow extends StatelessWidget {
  const MerchantMetaRow({super.key, required this.merchant});
  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    final joinedYear = merchant.onboardedAt.year;

    return Column(
      children: [
        Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedLocation01,
              color: AppColors.grey,
              size: 13,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${merchant.city}, ${merchant.state}',
                style: AppTypography.caption.copyWith(color: AppColors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedShoppingBag01,
              color: AppColors.grey,
              size: 13,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Joined $joinedYear · ${merchant.ordersCount} orders',
                style: AppTypography.caption.copyWith(color: AppColors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
