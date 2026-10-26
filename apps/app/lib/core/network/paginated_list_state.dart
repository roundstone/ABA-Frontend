import 'api_response.dart';
import 'list_query_params.dart';

/// Immutable state container for paginated lists across the app.
class PaginatedListState<T> {
  const PaginatedListState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.meta,
    this.params = const ListQueryParams(),
  });

  final List<T> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Object? error;
  final PaginationMeta? meta;
  final ListQueryParams params;

  bool get isEmpty => items.isEmpty && !isLoading;
  bool get isInitialLoading => isLoading && items.isEmpty;
  int get totalCount => meta?.totalItems ?? items.length;
  int get currentPage => params.page;

  PaginatedListState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Object? error,
    bool clearError = false,
    PaginationMeta? meta,
    ListQueryParams? params,
  }) {
    return PaginatedListState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      meta: meta ?? this.meta,
      params: params ?? this.params,
    );
  }

  /// Transition state to initial loading or refreshed state.
  PaginatedListState<T> toLoading({ListQueryParams? newParams}) {
    return copyWith(
      isLoading: true,
      isLoadingMore: false,
      clearError: true,
      params: newParams ?? params.copyWith(page: 1),
    );
  }

  /// Transition state to loading more items silently.
  PaginatedListState<T> toLoadingMore() {
    return copyWith(
      isLoadingMore: true,
      clearError: true,
    );
  }

  /// Append newly fetched items to the existing list.
  PaginatedListState<T> withAppendedItems({
    required List<T> newItems,
    PaginationMeta? paginationMeta,
    int? defaultLimit,
  }) {
    final limit = defaultLimit ?? (params.limit > 0 ? params.limit : 20);
    final more = paginationMeta != null
        ? paginationMeta.hasNextPage
        : newItems.length >= limit;

    return copyWith(
      items: [...items, ...newItems],
      isLoading: false,
      isLoadingMore: false,
      hasMore: more,
      clearError: true,
      meta: paginationMeta ?? meta,
      params: params.nextPage(),
    );
  }

  /// Replace all items (typically for page 1 results).
  PaginatedListState<T> withRefreshedItems({
    required List<T> newItems,
    PaginationMeta? paginationMeta,
    int? defaultLimit,
  }) {
    final limit = defaultLimit ?? (params.limit > 0 ? params.limit : 20);
    final more = paginationMeta != null
        ? paginationMeta.hasNextPage
        : newItems.length >= limit;

    return copyWith(
      items: newItems,
      isLoading: false,
      isLoadingMore: false,
      hasMore: more,
      clearError: true,
      meta: paginationMeta,
      params: params.copyWith(page: 1),
    );
  }

  /// Set error state while ending active loading indicators.
  PaginatedListState<T> withError(Object error) {
    return copyWith(
      isLoading: false,
      isLoadingMore: false,
      error: error,
    );
  }
}
