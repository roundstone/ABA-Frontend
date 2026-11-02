import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../shop/domain/product.dart';
import '../../application/wishlist_providers.dart';

class WishlistButton extends ConsumerWidget {
  const WishlistButton({
    super.key,
    required this.product,
    this.size = 18,
    this.backgroundColor,
    this.showSnackbar = true,
  });

  final Product product;
  final double size;
  final Color? backgroundColor;
  final bool showSnackbar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWishlisted = ref.watch(isProductInWishlistProvider(product.id));

    return Tooltip(
      message:
          isWishlisted ? 'Remove from wishlist' : 'Save to wishlist',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          try {
            final nowAdded = await ref
                .read(wishlistNotifierProvider.notifier)
                .toggleWishlist(product);
            if (context.mounted && showSnackbar) {
              AppSnackbar.show(
                context,
                message: nowAdded
                    ? '${product.name} saved to wishlist'
                    : '${product.name} removed from wishlist',
                type: nowAdded
                    ? AppSnackbarType.success
                    : AppSnackbarType.info,
              );
            }
          } catch (_) {
            if (context.mounted && showSnackbar) {
              AppSnackbar.show(
                context,
                message: 'Failed to update wishlist. Please try again.',
                type: AppSnackbarType.error,
              );
            }
          }
        },
        child: Container(
          width: size + 14,
          height: size + 14,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withAlpha(220),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedFavourite,
              size: size,
              color: isWishlisted ? AppColors.error : AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
