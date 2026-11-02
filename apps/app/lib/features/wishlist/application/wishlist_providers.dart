import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../shop/domain/product.dart';
import '../data/wishlist_remote_repository.dart';
import '../domain/wishlist_item.dart';
import '../domain/wishlist_repository.dart';
import 'wishlist_state.dart';

export 'wishlist_state.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return WishlistRemoteRepository(dio);
});

class WishlistNotifier extends StateNotifier<WishlistState> {
  final WishlistRepository _repository;

  WishlistNotifier(this._repository) : super(const WishlistState()) {
    loadInitial();
  }

  void _syncIdMaps(List<WishlistItem> items) {
    final ids = <int>{};
    final map = <int, int>{};
    for (final item in items) {
      ids.add(item.wishlistableId);
      map[item.wishlistableId] = item.id;
    }
    state = state.copyWith(
      wishlistedProductIds: ids,
      productToWishlistIdMap: map,
    );
  }

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final startStr = state.startDate?.toIso8601String().split('T').first;
      final endStr = state.endDate?.toIso8601String().split('T').first;

      final res = await _repository.getWishlist(
        page: 1,
        limit: 10,
        search: state.searchQuery,
        startDate: startStr,
        endDate: endStr,
        orderBy: state.orderBy,
      );

      final ids = res.items.map((i) => i.wishlistableId).toSet();
      final map = {for (final i in res.items) i.wishlistableId: i.id};

      state = state.copyWith(
        items: res.items,
        totalItems: res.totalItems,
        totalPages: res.totalPages,
        currentPage: res.currentPage,
        hasMore: res.hasNext,
        isLoading: false,
        wishlistedProductIds: ids,
        productToWishlistIdMap: map,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ApiError.toUserFriendlyMessage(e),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);

    try {
      final startStr = state.startDate?.toIso8601String().split('T').first;
      final endStr = state.endDate?.toIso8601String().split('T').first;

      final res = await _repository.getWishlist(
        page: state.currentPage + 1,
        limit: 10,
        search: state.searchQuery,
        startDate: startStr,
        endDate: endStr,
        orderBy: state.orderBy,
      );

      final combined = [...state.items, ...res.items];
      _syncIdMaps(combined);

      state = state.copyWith(
        items: combined,
        totalItems: res.totalItems,
        totalPages: res.totalPages,
        currentPage: res.currentPage,
        hasMore: res.hasNext,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void setSearchQuery(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query);
    loadInitial();
  }

  Future<void> refresh() => loadInitial();

  Future<bool> toggleWishlist(Product product) async {
    final pId = int.tryParse(product.id) ?? 0;
    if (pId == 0) return false;

    if (state.wishlistedProductIds.contains(pId)) {
      final wishlistItemId = state.productToWishlistIdMap[pId];
      if (wishlistItemId == null) return false;

      final prevItems = List<WishlistItem>.from(state.items);
      state = state.copyWith(
        items: state.items.where((i) => i.id != wishlistItemId).toList(),
        totalItems: (state.totalItems - 1).clamp(0, 999999),
        wishlistedProductIds: Set.from(state.wishlistedProductIds)..remove(pId),
        productToWishlistIdMap: Map.from(state.productToWishlistIdMap)
          ..remove(pId),
      );

      try {
        await _repository.removeFromWishlist(wishlistItemId);
        return false;
      } catch (e) {
        _syncIdMaps(prevItems);
        state = state.copyWith(items: prevItems);
        rethrow;
      }
    } else {
      final tempItem = WishlistItem(
        id: -DateTime.now().millisecondsSinceEpoch,
        customerId: 4,
        wishlistableType: 'product',
        wishlistableId: pId,
        product: product,
        createdAt: DateTime.now(),
      );

      final prevItems = List<WishlistItem>.from(state.items);
      state = state.copyWith(
        items: [tempItem, ...state.items],
        totalItems: state.totalItems + 1,
        wishlistedProductIds: Set.from(state.wishlistedProductIds)..add(pId),
        productToWishlistIdMap: Map.from(state.productToWishlistIdMap)
          ..[pId] = tempItem.id,
      );

      try {
        final serverItem = await _repository.addToWishlist(
          wishlistableType: 'product',
          wishlistableId: pId,
        );

        final finalizedItems = state.items.map((i) {
          return i.id == tempItem.id
              ? WishlistItem(
                  id: serverItem.id,
                  customerId: serverItem.customerId,
                  wishlistableType: serverItem.wishlistableType,
                  wishlistableId: serverItem.wishlistableId,
                  product: product,
                  createdAt: serverItem.createdAt,
                )
              : i;
        }).toList();

        state = state.copyWith(
          items: finalizedItems,
          productToWishlistIdMap: Map.from(state.productToWishlistIdMap)
            ..[pId] = serverItem.id,
        );
        return true;
      } catch (e) {
        _syncIdMaps(prevItems);
        state = state.copyWith(items: prevItems);
        rethrow;
      }
    }
  }

  Future<void> removeFromWishlist(int id) async {
    final prevItems = List<WishlistItem>.from(state.items);
    final targetItem = state.items.where((i) => i.id == id).firstOrNull;
    if (targetItem == null) return;

    state = state.copyWith(
      items: state.items.where((i) => i.id != id).toList(),
      totalItems: (state.totalItems - 1).clamp(0, 999999),
      wishlistedProductIds: Set.from(state.wishlistedProductIds)
        ..remove(targetItem.wishlistableId),
      productToWishlistIdMap: Map.from(state.productToWishlistIdMap)
        ..remove(targetItem.wishlistableId),
    );

    try {
      await _repository.removeFromWishlist(id);
    } catch (e) {
      _syncIdMaps(prevItems);
      state = state.copyWith(items: prevItems);
      rethrow;
    }
  }
}

final wishlistNotifierProvider =
    StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  final repo = ref.watch(wishlistRepositoryProvider);
  return WishlistNotifier(repo);
});

final isProductInWishlistProvider =
    Provider.family<bool, String>((ref, productId) {
  final id = int.tryParse(productId);
  if (id == null) return false;
  return ref.watch(wishlistNotifierProvider).wishlistedProductIds.contains(id);
});
