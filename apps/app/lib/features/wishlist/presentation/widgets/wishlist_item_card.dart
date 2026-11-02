import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../cart/application/cart_notifier.dart';
import '../../application/wishlist_providers.dart';
import '../../domain/wishlist_item.dart';

class WishlistItemCard extends ConsumerWidget {
  const WishlistItemCard({super.key, required this.item});

  final WishlistItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat('#,##0.00');

    final product = item.product;
    final name = product?.name ?? 'Product #${item.wishlistableId}';
    final price = product?.price ?? 0.0;
    final imageUrl = product?.imageUrl ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: InkWell(
        onTap: () => context.push('/product/${item.wishlistableId}'),
        borderRadius: AppSpacing.borderRadiusMD,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: AppSpacing.borderRadiusSM,
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: cs.surfaceContainerHighest,
                            child: const Center(
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedPackage,
                                color: AppColors.grey,
                                size: 24,
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: cs.surfaceContainerHighest,
                            child: const Center(
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedPackage,
                                color: AppColors.grey,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: cs.surfaceContainerHighest,
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedPackage,
                              color: AppColors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₦${formatter.format(price)}',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.secondary : cs.primary,
                      ),
                    ),
                    if (product?.brand != null && product!.brand.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        product.brand,
                        style: AppTypography.caption.copyWith(
                          color: cs.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Actions Column
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Remove from wishlist',
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedDelete02,
                      color: AppColors.grey,
                      size: 18,
                    ),
                    onPressed: () {
                      ref
                          .read(wishlistNotifierProvider.notifier)
                          .removeFromWishlist(item.id);
                      AppSnackbar.show(
                        context,
                        message: 'Item removed from wishlist',
                        type: AppSnackbarType.info,
                      );
                    },
                  ),
                  if (product != null)
                    IconButton(
                      tooltip: 'Add to Cart',
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedShoppingCart01,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      onPressed: () {
                        ref.read(cartProvider.notifier).addToCart(product);
                        AppSnackbar.show(
                          context,
                          message: '${product.name} added to cart',
                          type: AppSnackbarType.success,
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
