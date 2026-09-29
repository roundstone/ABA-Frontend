import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../shop/application/shop_providers.dart';
import '../../shop/domain/shop_entities.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // cartProvider is now AsyncNotifierProvider — handle all 3 states.
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'My Cart',
          style: AppTypography.h6.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Colors.white,
            size: AppSpacing.iconSizeSM,
          ),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: cartAsync.when(
        loading: () => const LoadingState(message: 'Loading cart…'),
        error: (e, _) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(cartProvider),
        ),
        data: (cart) {
          if (cart.isEmpty) {
            return _EmptyCart(onShop: () => context.go('/shop'));
          }
          return _CartBody(cart: cart);
        },
      ),
    );
  }
}

// ─── Cart body ────────────────────────────────────────────────────────────

class _CartBody extends ConsumerWidget {
  const _CartBody({required this.cart});
  final Cart cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);

    return Column(
      children: [
        // Items list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) => _CartItem(
              item: cart.items[i],
              onRemove: () =>
                  notifier.removeFromCart(cart.items[i].product.id),
              onDecrease: () => notifier.updateQuantity(
                cart.items[i].product.id,
                cart.items[i].quantity - 1,
              ),
              onIncrease: () => notifier.updateQuantity(
                cart.items[i].product.id,
                cart.items[i].quantity + 1,
              ),
            ),
          ),
        ),

        // Order summary
        _OrderSummary(
          cart: cart,
          onCheckout: () => context.push('/checkout'),
          onClear: () => notifier.clearCart(),
        ),
      ],
    );
  }
}

// ─── Cart item row ────────────────────────────────────────────────────────

class _CartItem extends StatelessWidget {
  const _CartItem({
    required this.item,
    required this.onRemove,
    required this.onDecrease,
    required this.onIncrease,
  });

  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = item.product;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusMD,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusSM,
            child: Image.network(
              p.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: Colors.grey.shade100,
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedImageNotFound01,
                    size: 24,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: AppTypography.bodySmall
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (item.selectedColor != null || item.selectedSize != null)
                  Text(
                    [
                      if (item.selectedColor != null) item.selectedColor!,
                      if (item.selectedSize != null)
                        'Size ${item.selectedSize}',
                    ].join(' · '),
                    style: AppTypography.label.copyWith(
                      color: cs.onSurface.withAlpha(130),
                    ),
                  ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      formatNaira(p.discountedPrice),
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),

                    // Quantity stepper
                    _QtyStepper(
                      quantity: item.quantity,
                      onDecrease: onDecrease,
                      onIncrease: onIncrease,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),

          // Remove button
          GestureDetector(
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.xs),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedDelete02,
                size: AppSpacing.iconSizeSM,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quantity stepper ─────────────────────────────────────────────────────

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : cs.surfaceContainerHighest,
        borderRadius: AppSpacing.borderRadiusSM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: HugeIcons.strokeRoundedMinusSign,
            onTap: onDecrease,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              '$quantity',
              style: AppTypography.bodySmall
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _StepBtn(
            icon: HugeIcons.strokeRoundedPlusSign,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final List<List<dynamic>> icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs + 2),
        child: HugeIcon(icon: icon, size: 14, color: cs.primary),
      ),
    );
  }
}

// ─── Order summary ────────────────────────────────────────────────────────

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.cart,
    required this.onCheckout,
    required this.onClear,
  });
  final Cart cart;
  final VoidCallback onCheckout;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget row(String label, double value, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: bold
                    ? AppTypography.bodyMedium
                        .copyWith(fontWeight: FontWeight.w700)
                    : AppTypography.bodySmall.copyWith(
                        color: cs.onSurface.withAlpha(160),
                      ),
              ),
              Text(
                formatNaira(value),
                style: bold
                    ? AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.primary,
                      )
                    : AppTypography.bodySmall,
              ),
            ],
          ),
        );

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 60 : 12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          row('Subtotal (${cart.itemCount} items)', cart.subtotal),
          row(
            'Shipping',
            cart.shipping,
          ),
          if (cart.shipping == 0)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Free!',
                style: AppTypography.label.copyWith(
                  color: const Color(0xFF10B981),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          row('VAT (7.5%)', cart.tax),
          const Divider(height: AppSpacing.md),
          row('Total', cart.total, bold: true),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              // Clear cart
              OutlinedButton(
                onPressed: onClear,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  size: AppSpacing.iconSizeSM,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: onCheckout,
                  child: const Text('Checkout'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Empty cart ───────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onShop});
  final VoidCallback onShop;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedShoppingCart01,
              size: 72,
              color: cs.primary.withAlpha(80),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Your cart is empty',
              style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Add items from the shop to get started',
              style: AppTypography.bodySmall.copyWith(
                color: cs.onSurface.withAlpha(153),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onShop,
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedShoppingBag01,
                size: AppSpacing.iconSizeSM,
                color: Colors.white,
              ),
              label: const Text('Browse Shop'),
            ),
          ],
        ),
      ),
    );
  }
}
