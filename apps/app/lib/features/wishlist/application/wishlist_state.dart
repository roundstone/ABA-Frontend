import '../domain/wishlist_item.dart';

class WishlistState {
  final List<WishlistItem> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final String orderBy;
  final Set<int> wishlistedProductIds;
  final Map<int, int> productToWishlistIdMap;

  const WishlistState({
    this.items = const [],
    this.totalItems = 0,
    this.totalPages = 1,
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.searchQuery = '',
    this.startDate,
    this.endDate,
    this.orderBy = 'createdAt:DESC',
    this.wishlistedProductIds = const {},
    this.productToWishlistIdMap = const {},
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || startDate != null || endDate != null;

  WishlistState copyWith({
    List<WishlistItem>? items,
    int? totalItems,
    int? totalPages,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    String? searchQuery,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? orderBy,
    Set<int>? wishlistedProductIds,
    Map<int, int>? productToWishlistIdMap,
  }) {
    return WishlistState(
      items: items ?? this.items,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      orderBy: orderBy ?? this.orderBy,
      wishlistedProductIds: wishlistedProductIds ?? this.wishlistedProductIds,
      productToWishlistIdMap:
          productToWishlistIdMap ?? this.productToWishlistIdMap,
    );
  }
}

