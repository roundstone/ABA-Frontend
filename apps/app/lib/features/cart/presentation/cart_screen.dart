import 'package:app/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../shop/application/shop_providers.dart';
import '../../shop/domain/shop_entities.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/cart_order_summary.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onPressed: () => context.popOrGo('/home'),
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
            return AppEmptyState(
              icon: HugeIcons.strokeRoundedShoppingCart01,
              title: 'Your cart is empty',
              description: 'Add items from the shop to get started',
              action: FilledButton.icon(
                onPressed: () => context.go('/shop'),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedShoppingBag01,
                  size: AppSpacing.iconSizeSM,
                  color: Colors.white,
                ),
                label: const Text('Browse Shop'),
              ),
            );
          }
          return _CartBody(cart: cart);
        },
      ),
    );
  }
}

class _CartBody extends ConsumerWidget {
  const _CartBody({required this.cart});
  final Cart cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(cartProvider.future),
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
              itemBuilder: (context, i) => CartItemTile(
                item: cart.items[i],
                onRemove: () =>
                    notifier.removeFromCart(cart.items[i].effectiveId),
                onDecrease: () => notifier.updateQuantity(
                  cart.items[i].effectiveId,
                  cart.items[i].quantity - 1,
                ),
                onIncrease: () => notifier.updateQuantity(
                  cart.items[i].effectiveId,
                  cart.items[i].quantity + 1,
                ),
              ),
            ),
          ),
        ),
        CartOrderSummary(
          cart: cart,
          onCheckout: () => context.push('/checkout'),
          onClear: () {
            notifier
                .clearCart()
                .then((_) {
                  if (context.mounted) {
                    AppSnackbar.success(context, 'Cart cleared successfully');
                  }
                })
                .catchError((onError) {
                  if (context.mounted) {
                    AppSnackbar.error(context, onError.toString());
                  }
                });
          },
        ),
      ],
    );
  }
}
