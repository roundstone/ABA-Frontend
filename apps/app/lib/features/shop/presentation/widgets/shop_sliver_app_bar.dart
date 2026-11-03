import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ShopSliverAppBar extends StatelessWidget {
  const ShopSliverAppBar({super.key, required this.cartCount});
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: true,
      backgroundColor: cs.primary,
      title: Text(
        'Shop',
        style: AppTypography.h6.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedShoppingCart01,
                color: Colors.white,
                size: AppSpacing.iconSizeMD,
              ),
              onPressed: () => context.push('/cart'),
            ),
            if (cartCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      cartCount > 9 ? '9+' : '$cartCount',
                      style: AppTypography.label.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}

