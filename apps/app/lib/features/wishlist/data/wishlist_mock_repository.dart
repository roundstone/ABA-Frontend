import '../../shop/domain/product.dart';
import '../domain/wishlist_item.dart';
import '../domain/wishlist_repository.dart';

class WishlistMockRepository implements WishlistRepository {
  WishlistMockRepository() {
    _items = [
      WishlistItem(
        id: 1,
        customerId: 4,
        wishlistableType: 'product',
        wishlistableId: 42,
        createdAt: DateTime(2026, 11, 2, 12, 19, 49),
        product: const Product(
          id: '42',
          name: 'Demo Product 41',
          slug: 'demo-product-41',
          description: 'Demo product used for ERP staging demonstrations.',
          price: 16600.0,
          category: 'Demo Category',
          brand: 'ABA Demo',
          rating: 4.5,
          reviewCount: 12,
          stock: 20,
          images: [
            'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800&auto=format&fit=crop&q=80',
          ],
          isFeatured: true,
          merchantId: 7,
          categoryId: 6,
          subcategoryId: 26,
          baseSellingPrice: 16600.0,
          baseCostPrice: 14100.0,
          baseUnitOfMeasurement: 'piece',
        ),
      ),
    ];
  }

  late List<WishlistItem> _items;

  @override
  Future<PaginatedWishlistResult> getWishlist({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    String? orderBy = 'createdAt:DESC',
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    var filtered = List<WishlistItem>.from(_items);

    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      filtered = filtered.where((item) {
        final name = item.product?.name.toLowerCase() ?? '';
        final desc = item.product?.description?.toLowerCase() ?? '';
        return name.contains(q) || desc.contains(q);
      }).toList();
    }

    if (startDate != null && startDate.isNotEmpty) {
      final start = DateTime.tryParse(startDate);
      if (start != null) {
        final startDay = DateTime(start.year, start.month, start.day);
        filtered =
            filtered.where((item) => !item.createdAt.isBefore(startDay)).toList();
      }
    }

    if (endDate != null && endDate.isNotEmpty) {
      final end = DateTime.tryParse(endDate);
      if (end != null) {
        final endDay = DateTime(end.year, end.month, end.day, 23, 59, 59);
        filtered =
            filtered.where((item) => !item.createdAt.isAfter(endDay)).toList();
      }
    }

    if (orderBy == 'createdAt:ASC') {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    final total = filtered.length;
    final pages = (total / limit).ceil().clamp(1, 999);
    final start = (page - 1) * limit;
    final paged = start >= total
        ? <WishlistItem>[]
        : filtered.skip(start).take(limit).toList();

    return PaginatedWishlistResult(
      items: paged,
      totalItems: total,
      totalPages: pages,
      currentPage: page,
      hasNext: page < pages,
    );
  }

  @override
  Future<WishlistItem> addToWishlist({
    String wishlistableType = 'product',
    required int wishlistableId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final existingIndex = _items.indexWhere(
      (item) =>
          item.wishlistableType == wishlistableType &&
          item.wishlistableId == wishlistableId,
    );

    if (existingIndex >= 0) {
      return _items[existingIndex];
    }

    final nextId = _items.isEmpty
        ? 1
        : _items.map((i) => i.id).reduce((a, b) => a > b ? a : b) + 1;

    final newItem = WishlistItem(
      id: nextId,
      customerId: 4,
      wishlistableType: wishlistableType,
      wishlistableId: wishlistableId,
      createdAt: DateTime.now(),
      product: Product(
        id: wishlistableId.toString(),
        name: 'Product #$wishlistableId',
        slug: 'product-$wishlistableId',
        category: 'Marketplace',
        brand: 'BuyNaija',
        rating: 4.0,
        reviewCount: 0,
        stock: 10,
        images: const [
          'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800&auto=format&fit=crop&q=80',
        ],
        price: 15000.0,
        baseSellingPrice: 15000.0,
      ),
    );

    _items.insert(0, newItem);
    return newItem;
  }

  @override
  Future<bool> removeFromWishlist(int id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final before = _items.length;
    _items.removeWhere((item) => item.id == id);
    return _items.length < before;
  }
}
