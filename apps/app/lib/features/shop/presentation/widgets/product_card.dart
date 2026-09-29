import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../application/shop_providers.dart';
import '../../domain/shop_entities.dart';

/// Product card — supports both grid and list mode.
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.listMode = false});

  final Product product;
  final bool listMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return listMode ? _ListCard(product: product) : _GridCard(product: product);
  }
}

// ─── Grid card ────────────────────────────────────────────────────────────

class _GridCard extends ConsumerWidget {
  const _GridCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartNotifier = ref.read(cartProvider.notifier);
    final cartItems = (ref.watch(cartProvider).valueOrNull ?? const Cart()).items;
    final inCart = cartItems.any((i) => i.product.id == product.id);

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: AppSpacing.borderRadiusMD,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 40 : 10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + badges
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusMD),
                      topRight: Radius.circular(AppSpacing.radiusMD),
                    ),
                    child: _ProductImage(
                      url: product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Discount badge
                  if (product.hasDiscount)
                    Positioned(
                      top: AppSpacing.xs,
                      left: AppSpacing.xs,
                      child: _DiscountBadge(discount: product.discount!),
                    ),
                  // New badge
                  if (product.isNew && !product.hasDiscount)
                    Positioned(
                      top: AppSpacing.xs,
                      left: AppSpacing.xs,
                      child: _NewBadge(),
                    ),
                  // Wishlist
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: _WishlistButton(productId: product.id),
                  ),
                ],
              ),
            ),

            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.brand,
                          style: AppTypography.label.copyWith(
                            color: cs.onSurface.withAlpha(120),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.name,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        _StarRating(rating: product.rating, compact: true),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatNaira(product.discountedPrice),
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.primary,
                                ),
                              ),
                              if (product.hasDiscount)
                                Text(
                                  formatNaira(product.price),
                                  style: AppTypography.label.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Quick add to cart
                        GestureDetector(
                          onTap: () {
                            if (!inCart) {
                              cartNotifier.addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.name} added to cart',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: AppSpacing.animationFast,
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: inCart
                                  ? cs.primary
                                  : cs.primary.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: HugeIcon(
                                icon: inCart
                                    ? HugeIcons.strokeRoundedTick01
                                    : HugeIcons.strokeRoundedShoppingCart01,
                                size: 15,
                                color: inCart ? Colors.white : cs.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── List card ────────────────────────────────────────────────────────────

class _ListCard extends ConsumerWidget {
  const _ListCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartNotifier = ref.read(cartProvider.notifier);
    final inCart = (ref.watch(cartProvider).valueOrNull ?? const Cart())
        .items
        .any((i) => i.product.id == product.id);

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: AppSpacing.borderRadiusMD,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 40 : 10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusMD),
                bottomLeft: Radius.circular(AppSpacing.radiusMD),
              ),
              child: _ProductImage(
                url: product.imageUrl,
                width: 100,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand,
                      style: AppTypography.label.copyWith(
                        color: cs.onSurface.withAlpha(120),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _StarRating(rating: product.rating, compact: true),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          formatNaira(product.discountedPrice),
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: cs.primary,
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            formatNaira(product.price),
                            style: AppTypography.label.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (!inCart) {
                              cartNotifier.addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.name} added to cart',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: AppSpacing.animationFast,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: inCart
                                  ? cs.primary
                                  : cs.primary.withAlpha(15),
                              borderRadius: AppSpacing.borderRadiusSM,
                            ),
                            child: Text(
                              inCart ? 'In cart' : 'Add',
                              style: AppTypography.label.copyWith(
                                color: inCart ? Colors.white : cs.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared sub-widgets ───────────────────────────────────────────────────

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Center(
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedImage01,
            size: 32,
            color: AppColors.grey,
          ),
        ),
      );
    }
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(
              width: width,
              height: height,
              color: Colors.grey.shade100,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade100,
        child: const Center(
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedImageNotFound01,
            size: 28,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.discount});
  final double discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs + 2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: AppSpacing.borderRadiusXS,
      ),
      child: Text(
        '-${discount.toInt()}%',
        style: AppTypography.label.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs + 2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: AppSpacing.borderRadiusXS,
      ),
      child: Text(
        'NEW',
        style: AppTypography.label.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _WishlistButton extends StatefulWidget {
  const _WishlistButton({required this.productId});
  final String productId;

  @override
  State<_WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<_WishlistButton> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _liked = !_liked),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(220),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: HugeIcon(
            icon: _liked
                ? HugeIcons.strokeRoundedFavourite
                : HugeIcons.strokeRoundedFavourite,
            size: 15,
            color: _liked ? AppColors.error : AppColors.grey,
          ),
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, this.compact = false});
  final double rating;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          size: 12,
          color: Color(0xFFF59E0B),
        ),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: AppTypography.label.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withAlpha(180),
          ),
        ),
      ],
    );
  }
}
