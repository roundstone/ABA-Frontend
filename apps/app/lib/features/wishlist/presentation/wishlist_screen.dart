import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../cart/application/cart_notifier.dart';
import '../../cart/domain/entities/cart_entities.dart';
import '../application/wishlist_providers.dart';
import '../domain/wishlist_item.dart';
import 'widgets/wishlist_item_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wishlistNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = ref.watch(cartProvider).valueOrNull ?? const Cart();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => context.popOrGo('/home'),
        ),
        title: const Text('My Wishlist'),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedRefresh,
              size: 20,
              color: AppColors.grey,
            ),
            tooltip: 'Refresh wishlist',
            onPressed: () =>
                ref.read(wishlistNotifierProvider.notifier).refresh(),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedShoppingCart01,
                  size: 22,
                  color: AppColors.grey,
                ),
                tooltip: 'Cart',
                onPressed: () => context.push('/cart'),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          context.popOrGo('/home');
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: AppTextField(
                hintText: 'Search saved items...',
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                onChanged: (val) {
                  ref
                      .read(wishlistNotifierProvider.notifier)
                      .setSearchQuery(val);
                },
              ),
            ),
            if (state.totalItems > 0)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    Text(
                      '${state.totalItems} saved ${state.totalItems == 1 ? 'item' : 'items'}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _buildBody(context, ref, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    WishlistState state,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const LoadingState(message: 'Loading wishlist…');
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return ErrorState(
        message: state.errorMessage!,
        onRetry: () =>
            ref.read(wishlistNotifierProvider.notifier).refresh(),
      );
    }

    return PaginatedListView<WishlistItem>(
      items: state.items,
      padding: const EdgeInsets.all(AppSpacing.md),
      hasMore: state.hasMore,
      isLoading: state.isLoading,
      isLoadingMore: state.isLoadingMore,
      onRefresh: () =>
          ref.read(wishlistNotifierProvider.notifier).refresh(),
      onLoadMore: () =>
          ref.read(wishlistNotifierProvider.notifier).loadMore(),
      itemBuilder: (context, item, index) => WishlistItemCard(item: item),
      emptyWidget: const _EmptyWishlistView(),
    );
  }
}

class _EmptyWishlistView extends StatelessWidget {
  const _EmptyWishlistView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedFavourite,
                  color: AppColors.grey,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Your wishlist is empty', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Explore the market and save items you want to purchase later.',
              style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: 'Explore Products',
              onPressed: () => context.go('/shop'),
            ),
          ],
        ),
      ),
    );
  }
}
