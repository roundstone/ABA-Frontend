import 'wishlist_item.dart';

abstract class WishlistRepository {
  Future<PaginatedWishlistResult> getWishlist({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    String? orderBy = 'createdAt:DESC',
  });

  Future<WishlistItem> addToWishlist({
    String wishlistableType = 'product',
    required int wishlistableId,
  });

  Future<bool> removeFromWishlist(int id);
}

