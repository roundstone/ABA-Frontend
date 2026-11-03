import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../cart/application/cart_providers.dart';

class HomeCartFloatingButton extends ConsumerWidget {
  final double? bottomPadding;
  final Object? heroTag;

  const HomeCartFloatingButton({
    super.key,
    this.bottomPadding,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider).valueOrNull?.itemCount ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (cartCount == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 120),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          FloatingActionButton(
            heroTag: heroTag,
            backgroundColor: isDark ? AppColors.secondary : AppColors.primary,
            elevation: 4,
            tooltip: 'Shopping Cart',
            shape: const CircleBorder(),
            onPressed: () => context.push('/cart'),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedShoppingCart01,
              color: Colors.white,
              size: AppSpacing.iconSizeMD,
            ),
          ),
          if (cartCount > 0)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
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
    );
  }
}
