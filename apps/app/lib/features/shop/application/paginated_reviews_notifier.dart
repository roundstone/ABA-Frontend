import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/list_query_params.dart';
import '../../../core/network/paginated_list_state.dart';
import '../domain/shop_entities.dart';
import 'shop_providers.dart';

/// StateNotifier that manages pagination for product reviews.
class PaginatedReviewsNotifier
    extends StateNotifier<PaginatedListState<ProductReview>> {
  PaginatedReviewsNotifier(this._ref, this.productId)
      : super(const PaginatedListState<ProductReview>(isLoading: true)) {
    fetchFirstPage();
  }

  final Ref _ref;
  final int? productId;

  Future<void> fetchFirstPage() async {
    if (!mounted) return;
    state = state.toLoading(
      newParams: const ListQueryParams(page: 1, limit: 10, orderBy: 'createdAt:DESC'),
    );
    try {
      final repo = _ref.read(shopRepositoryProvider);
      final res = await repo.fetchReviews(
        params: state.params,
        reviewableId: productId,
        reviewableType: 'product',
      );
      if (!mounted) return;
      state = state.withRefreshedItems(
        newItems: res.items,
        paginationMeta: res.meta,
        defaultLimit: 10,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.withError(e);
    }
  }

  Future<void> loadMore() async {
    if (!mounted || !state.hasMore || state.isLoadingMore || state.isLoading) {
      return;
    }
    state = state.toLoadingMore();
    try {
      final repo = _ref.read(shopRepositoryProvider);
      final nextPage = state.currentPage + 1;
      final nextParams = state.params.copyWith(page: nextPage);
      final res = await repo.fetchReviews(
        params: nextParams,
        reviewableId: productId,
        reviewableType: 'product',
      );
      if (!mounted) return;
      if (res.items.isEmpty) {
        state = state.copyWith(isLoadingMore: false, hasMore: false);
      } else {
        state = state.withAppendedItems(
          newItems: res.items,
          paginationMeta: res.meta,
          defaultLimit: 10,
        );
      }
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }
}

final paginatedReviewsNotifierProvider = StateNotifierProvider.autoDispose
    .family<PaginatedReviewsNotifier, PaginatedListState<ProductReview>, int?>(
  (ref, productId) => PaginatedReviewsNotifier(ref, productId),
);

