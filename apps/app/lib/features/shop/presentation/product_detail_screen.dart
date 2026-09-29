import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/shop_providers.dart';
import '../domain/shop_entities.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId, required String id});
  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends ConsumerState<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return productAsync.when(
      loading: () => const Scaffold(
        body: LoadingState(message: 'Loading product…'),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorState(message: e.toString()),
      ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const ErrorState(message: 'Product not found.'),
          );
        }
        return _ProductDetailBody(
          product: product,
          selectedImageIndex: _selectedImageIndex,
          onImageSelect: (i) => setState(() => _selectedImageIndex = i),
          selectedColor: _selectedColor,
          onColorSelect: (c) => setState(() => _selectedColor = c),
          selectedSize: _selectedSize,
          onSizeSelect: (s) => setState(() => _selectedSize = s),
          quantity: _quantity,
          onQuantityChange: (q) => setState(() => _quantity = q),
        );
      },
    );
  }
}

// ─── Detail body ──────────────────────────────────────────────────────────

class _ProductDetailBody extends ConsumerWidget {
  const _ProductDetailBody({
    required this.product,
    required this.selectedImageIndex,
    required this.onImageSelect,
    required this.selectedColor,
    required this.onColorSelect,
    required this.selectedSize,
    required this.onSizeSelect,
    required this.quantity,
    required this.onQuantityChange,
  });

  final Product product;
  final int selectedImageIndex;
  final ValueChanged<int> onImageSelect;
  final String? selectedColor;
  final ValueChanged<String?> onColorSelect;
  final String? selectedSize;
  final ValueChanged<String?> onSizeSelect;
  final int quantity;
  final ValueChanged<int> onQuantityChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final cartNotifier = ref.read(cartProvider.notifier);
    final inCart = (ref.watch(cartProvider).valueOrNull ?? const Cart()).items.any(
          (i) => i.product.id == product.id,
        );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Image gallery app bar
          _ImageSliverAppBar(
            product: product,
            selectedIndex: selectedImageIndex,
            onImageSelect: onImageSelect,
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xl + AppSpacing.xxxl, // nav bar clearance
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    product.brand,
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Name
                  Text(
                    product.name,
                    style: AppTypography.h4.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Rating + review count
                  _RatingRow(product: product),
                  const SizedBox(height: AppSpacing.md),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatNaira(product.discountedPrice),
                        style: AppTypography.h5.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.primary,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          formatNaira(product.price),
                          style: AppTypography.bodyMedium.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs + 2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withAlpha(20),
                            borderRadius: AppSpacing.borderRadiusXS,
                          ),
                          child: Text(
                            '-${product.discount!.toInt()}%',
                            style: AppTypography.label.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),

                  // Color selector
                  if (product.colors != null && product.colors!.isNotEmpty) ...[
                    _SelectorRow(
                      title: 'Color',
                      selected: selectedColor,
                      options: product.colors!,
                      onSelect: onColorSelect,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Size selector
                  if (product.sizes != null && product.sizes!.isNotEmpty) ...[
                    _SelectorRow(
                      title: 'Size',
                      selected: selectedSize,
                      options: product.sizes!,
                      onSelect: onSizeSelect,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Quantity
                  _QuantitySelector(
                    quantity: quantity,
                    onChanged: onQuantityChange,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),

                  // Description
                  if (product.description != null) ...[
                    Text(
                      'Description',
                      style: AppTypography.bodyMedium
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      product.description!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: cs.onSurface.withAlpha(180),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Tags
                  if (product.tags != null && product.tags!.isNotEmpty) ...[
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: product.tags!
                          .map(
                            (t) => Chip(
                              label: Text('#$t',
                                  style: AppTypography.label),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Stock status
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: product.inStock
                              ? const Color(0xFF10B981)
                              : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        product.inStock
                            ? '${product.stock} in stock'
                            : 'Out of stock',
                        style: AppTypography.bodySmall.copyWith(
                          color: product.inStock
                              ? const Color(0xFF10B981)
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
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

      // Bottom CTA bar
      bottomNavigationBar: _DetailBottomBar(
        product: product,
        inCart: inCart,
        quantity: quantity,
        selectedColor: selectedColor,
        selectedSize: selectedSize,
        onAddToCart: () {
          cartNotifier.addToCart(
            product,
            quantity: quantity,
            color: selectedColor,
            size: selectedSize,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added to cart!'),
              action: SnackBarAction(
                label: 'View Cart',
                onPressed: () => context.push('/cart'),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}

// ─── Image gallery sliver app bar ─────────────────────────────────────────

class _ImageSliverAppBar extends StatelessWidget {
  const _ImageSliverAppBar({
    required this.product,
    required this.selectedIndex,
    required this.onImageSelect,
  });
  final Product product;
  final int selectedIndex;
  final ValueChanged<int> onImageSelect;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final images = product.images;

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: cs.surface,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(220),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              size: AppSpacing.iconSizeSM,
              color: AppColors.onBackground,
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(220),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(6),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedShare01,
                size: AppSpacing.iconSizeSM,
                color: AppColors.onBackground,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (images.isNotEmpty)
              Image.network(
                images[selectedIndex],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade100,
                ),
              )
            else
              Container(color: Colors.grey.shade100),

            // Thumbnail strip
            if (images.length > 1)
              Positioned(
                bottom: AppSpacing.md,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (i) => GestureDetector(
                      onTap: () => onImageSelect(i),
                      child: AnimatedContainer(
                        duration: AppSpacing.animationFast,
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs / 2),
                        width: selectedIndex == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: selectedIndex == i
                              ? cs.primary
                              : Colors.white.withAlpha(180),
                          borderRadius: AppSpacing.avatarRadius,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Rating row ───────────────────────────────────────────────────────────

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = i < product.rating.floor();
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: HugeIcon(
              icon: filled
                  ? HugeIcons.strokeRoundedStar
                  : HugeIcons.strokeRoundedStar,
              size: 16,
              color: i < product.rating.floor()
                  ? const Color(0xFFF59E0B)
                  : Colors.grey.shade300,
            ),
          );
        }),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${product.rating} (${product.reviewCount} reviews)',
          style: AppTypography.bodySmall.copyWith(
            color: cs.onSurface.withAlpha(153),
          ),
        ),
      ],
    );
  }
}

// ─── Option selector ──────────────────────────────────────────────────────

class _SelectorRow extends StatelessWidget {
  const _SelectorRow({
    required this.title,
    required this.selected,
    required this.options,
    required this.onSelect,
  });
  final String title;
  final String? selected;
  final List<String> options;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,
                style: AppTypography.bodyMedium
                    .copyWith(fontWeight: FontWeight.w700)),
            if (selected != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(': $selected',
                  style: AppTypography.bodySmall
                      .copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: options.map((opt) {
            final isSel = opt == selected;
            return GestureDetector(
              onTap: () => onSelect(isSel ? null : opt),
              child: AnimatedContainer(
                duration: AppSpacing.animationFast,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: isSel ? cs.primary : Colors.transparent,
                  borderRadius: AppSpacing.borderRadiusSM,
                  border: Border.all(
                    color: isSel ? cs.primary : cs.outline.withAlpha(100),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  opt,
                  style: AppTypography.bodySmall.copyWith(
                    color: isSel ? Colors.white : cs.onSurface,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Quantity selector ────────────────────────────────────────────────────

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onChanged,
  });
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Text('Quantity',
            style:
                AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF2A2A2A)
                : cs.surfaceContainerHighest,
            borderRadius: AppSpacing.borderRadiusSM,
          ),
          child: Row(
            children: [
              _QtyButton(
                icon: HugeIcons.strokeRoundedMinusSign,
                onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  '$quantity',
                  style: AppTypography.bodyMedium
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _QtyButton(
                icon: HugeIcons.strokeRoundedPlusSign,
                onTap: () => onChanged(quantity + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, this.onTap});
  final List<List<dynamic>> icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: HugeIcon(
          icon: icon,
          size: AppSpacing.iconSizeSM,
          color: onTap != null ? cs.primary : AppColors.grey,
        ),
      ),
    );
  }
}

// ─── Bottom CTA bar ───────────────────────────────────────────────────────

class _DetailBottomBar extends StatelessWidget {
  const _DetailBottomBar({
    required this.product,
    required this.inCart,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
    required this.onAddToCart,
  });

  final Product product;
  final bool inCart;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 60 : 15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Wishlist button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              border:
                  Border.all(color: cs.outline.withAlpha(80), width: 1.5),
              borderRadius: AppSpacing.borderRadiusMD,
            ),
            child: Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedFavourite,
                size: AppSpacing.iconSizeSM,
                color: AppColors.error,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Add to cart / view cart button
          Expanded(
            child: FilledButton.icon(
              onPressed: product.inStock
                  ? (inCart ? () => context.push('/cart') : onAddToCart)
                  : null,
              icon: HugeIcon(
                icon: inCart
                    ? HugeIcons.strokeRoundedShoppingCart01
                    : HugeIcons.strokeRoundedShoppingBag01,
                size: AppSpacing.iconSizeSM,
                color: Colors.white,
              ),
              label: Text(
                product.inStock
                    ? (inCart ? 'View Cart' : 'Add to Cart')
                    : 'Out of Stock',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
