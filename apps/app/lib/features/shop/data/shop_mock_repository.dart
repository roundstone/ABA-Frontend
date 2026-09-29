import '../domain/shop_entities.dart';
import '../domain/shop_repository.dart';

/// Mock shop repository.
/// Data matches apps/web/src/services/mock/public.service.ts
///
/// To go live:
///   1. Implement ShopRemoteRepository(Dio dio) : ShopRepository
///   2. Change shopRepositoryProvider in shop_providers.dart — zero UI changes.
class ShopMockRepository implements ShopRepository {
  // ─── Static mock categories ───────────────────────────────────────────────

  static const _categories = <ShopCategory>[
    ShopCategory(
      id: 'cat_bags',
      name: 'Bags',
      slug: 'bags',
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=200',
      productCount: 12,
    ),
    ShopCategory(
      id: 'cat_shoes',
      name: 'Shoes',
      slug: 'shoes',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
      productCount: 9,
    ),
    ShopCategory(
      id: 'cat_clothes',
      name: 'Clothes',
      slug: 'clothes',
      imageUrl: 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=200',
      productCount: 24,
    ),
    ShopCategory(
      id: 'cat_accessories',
      name: 'Accessories',
      slug: 'accessories',
      imageUrl: 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=200',
      productCount: 18,
    ),
    ShopCategory(
      id: 'cat_electronics',
      name: 'Electronics',
      slug: 'electronics',
      imageUrl: 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=200',
      productCount: 6,
    ),
    ShopCategory(
      id: 'cat_home',
      name: 'Home & Living',
      slug: 'home',
      imageUrl: 'https://images.unsplash.com/photo-1484101403633-562f891dc89a?w=200',
      productCount: 15,
    ),
  ];

  // ─── Static mock products ─────────────────────────────────────────────────

  static final _products = <Product>[
    Product(
      id: 'p001',
      name: 'Wander Pack Heaven Backpack',
      slug: 'wander-pack-heaven-backpack',
      price: 18_999,
      category: 'Bags',
      brand: 'ABA Originals',
      rating: 4.5,
      reviewCount: 128,
      stock: 20,
      discount: 10,
      isNew: true,
      isFeatured: true,
      colors: ['Black', 'Navy', 'Olive'],
      images: [
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
        'https://images.unsplash.com/photo-1622560480654-d96214fdc887?w=400',
      ],
      description:
          'Premium quality backpack perfect for everyday adventures. Crafted with water-resistant fabric and ergonomic design.',
      tags: ['backpack', 'travel', 'everyday'],
    ),
    Product(
      id: 'p002',
      name: 'Executive Leather Briefcase',
      slug: 'executive-leather-briefcase',
      price: 45_000,
      category: 'Bags',
      brand: 'Lagos Craft Co.',
      rating: 4.8,
      reviewCount: 67,
      stock: 8,
      isFeatured: true,
      colors: ['Brown', 'Black'],
      images: [
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
        'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=400',
      ],
      description:
          'Handcrafted genuine leather briefcase for the modern professional.',
      tags: ['leather', 'professional', 'office'],
    ),
    Product(
      id: 'p003',
      name: 'Ankara Print Tote Bag',
      slug: 'ankara-print-tote-bag',
      price: 8_500,
      category: 'Bags',
      brand: 'Eko Fabrics',
      rating: 4.3,
      reviewCount: 204,
      stock: 50,
      discount: 15,
      isNew: true,
      colors: ['Multi', 'Blue', 'Red'],
      images: [
        'https://images.unsplash.com/photo-1623205863604-d62a5b56f1c4?w=400',
      ],
      description: 'Vibrant Ankara print tote bag — celebrate African fashion.',
      tags: ['ankara', 'tote', 'fashion'],
    ),
    Product(
      id: 'p004',
      name: 'Classic White Sneakers',
      slug: 'classic-white-sneakers',
      price: 22_500,
      category: 'Shoes',
      brand: 'StepUp Lagos',
      rating: 4.6,
      reviewCount: 345,
      stock: 30,
      discount: 5,
      isFeatured: true,
      sizes: ['38', '39', '40', '41', '42', '43', '44'],
      colors: ['White', 'Off-White'],
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
      ],
      description: 'Timeless clean white sneakers that go with everything.',
      tags: ['sneakers', 'casual', 'footwear'],
    ),
    Product(
      id: 'p005',
      name: 'Agbada Fabric Set (3-piece)',
      slug: 'agbada-fabric-set',
      price: 35_000,
      category: 'Clothes',
      brand: 'Aso-oke Masters',
      rating: 4.9,
      reviewCount: 89,
      stock: 15,
      isNew: true,
      isFeatured: true,
      colors: ['Royal Blue', 'White', 'Gold'],
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      images: [
        'https://images.unsplash.com/photo-1529374255404-311a2a4f1fd9?w=400',
      ],
      description:
          'Premium 3-piece Agbada set crafted from finest aso-oke fabric.',
      tags: ['agbada', 'traditional', 'native'],
    ),
    Product(
      id: 'p006',
      name: 'Smart Watch Pro',
      slug: 'smart-watch-pro',
      price: 65_000,
      category: 'Electronics',
      brand: 'TechGear NG',
      rating: 4.4,
      reviewCount: 156,
      stock: 12,
      discount: 20,
      isFeatured: true,
      colors: ['Black', 'Silver', 'Rose Gold'],
      images: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400',
      ],
      description:
          'Feature-packed smartwatch with health tracking, GPS, and 7-day battery life.',
      tags: ['smartwatch', 'tech', 'wearable'],
    ),
    Product(
      id: 'p007',
      name: 'Gold Plated Oja Bead Necklace',
      slug: 'gold-plated-oja-bead-necklace',
      price: 12_000,
      category: 'Accessories',
      brand: 'Eko Fabrics',
      rating: 4.7,
      reviewCount: 98,
      stock: 40,
      discount: 0,
      isNew: true,
      colors: ['Gold'],
      images: [
        'https://images.unsplash.com/photo-1573408301185-9519f94816b5?w=400',
      ],
      description:
          'Handcrafted gold-plated necklace with traditional Nigerian bead accents.',
      tags: ['jewellery', 'necklace', 'traditional'],
    ),
    Product(
      id: 'p008',
      name: 'Rattan Weave Basket Lamp',
      slug: 'rattan-weave-basket-lamp',
      price: 28_000,
      category: 'Home & Living',
      brand: 'Abuja Artisans',
      rating: 4.2,
      reviewCount: 43,
      stock: 7,
      colors: ['Natural', 'Black'],
      images: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      ],
      description:
          'Handwoven rattan pendant lamp — artisanal Nigerian home decor.',
      tags: ['lamp', 'home', 'rattan', 'artisan'],
    ),
    Product(
      id: 'p009',
      name: 'Leather Oxford Shoes',
      slug: 'leather-oxford-shoes',
      price: 32_500,
      category: 'Shoes',
      brand: 'Lagos Craft Co.',
      rating: 4.5,
      reviewCount: 77,
      stock: 18,
      discount: 8,
      sizes: ['39', '40', '41', '42', '43', '44', '45'],
      colors: ['Black', 'Brown', 'Burgundy'],
      images: [
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      ],
      description:
          'Handcrafted leather Oxford shoes for the modern professional.',
      tags: ['oxford', 'leather', 'formal'],
    ),
    Product(
      id: 'p010',
      name: 'Linen Kaftan Dress',
      slug: 'linen-kaftan-dress',
      price: 14_500,
      category: 'Clothes',
      brand: 'Eko Fabrics',
      rating: 4.6,
      reviewCount: 212,
      stock: 35,
      isNew: true,
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['White', 'Peach', 'Sky Blue', 'Mint'],
      images: [
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400',
      ],
      description:
          'Lightweight breathable linen kaftan — perfect for Nigerian weather.',
      tags: ['kaftan', 'dress', 'linen', 'casual'],
    ),
    Product(
      id: 'p011',
      name: 'Wireless Earbuds Elite',
      slug: 'wireless-earbuds-elite',
      price: 29_999,
      category: 'Electronics',
      brand: 'TechGear NG',
      rating: 4.3,
      reviewCount: 289,
      stock: 25,
      discount: 12,
      colors: ['White', 'Black'],
      images: [
        'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
      ],
      description:
          'True wireless earbuds with ANC, 30hr battery, and crystal clear audio.',
      tags: ['earbuds', 'wireless', 'audio'],
    ),
    Product(
      id: 'p012',
      name: 'Handwoven Throw Blanket',
      slug: 'handwoven-throw-blanket',
      price: 9_500,
      category: 'Home & Living',
      brand: 'Abuja Artisans',
      rating: 4.8,
      reviewCount: 61,
      stock: 22,
      colors: ['Terracotta', 'Indigo', 'Sage'],
      images: [
        'https://images.unsplash.com/photo-1605117882932-f9e32b03fea9?w=400',
      ],
      description:
          'Cozy handwoven throw blanket using traditional Nigerian weaving techniques.',
      tags: ['blanket', 'home', 'artisan', 'handwoven'],
    ),
  ];

  // ─── Interface implementation ─────────────────────────────────────────────

  @override
  Future<ShopCatalogue> fetchCatalogue() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return ShopCatalogue(
      products: _products,
      categories: _categories,
      featuredBannerUrl:
          'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
    );
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> fetchProducts({
    ShopFilter? filter,
    SortOrder sort = SortOrder.featured,
    int page = 1,
    int pageSize = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var result = List<Product>.from(_products);

    if (filter != null) {
      if (filter.categories.isNotEmpty) {
        result = result
            .where((p) => filter.categories.contains(p.category))
            .toList();
      }
      if (filter.brands.isNotEmpty) {
        result =
            result.where((p) => filter.brands.contains(p.brand)).toList();
      }
      if (filter.colors.isNotEmpty) {
        result = result
            .where((p) =>
                p.colors != null &&
                p.colors!.any((c) => filter.colors.contains(c)))
            .toList();
      }
      if (filter.ratings.isNotEmpty) {
        result = result
            .where((p) => filter.ratings.contains(p.rating.floor()))
            .toList();
      }
      result = result
          .where((p) =>
              p.price >= filter.priceRange.$1 &&
              p.price <= filter.priceRange.$2)
          .toList();
    }

    switch (sort) {
      case SortOrder.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
      case SortOrder.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
      case SortOrder.priceLow:
        result.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
      case SortOrder.priceHigh:
        result.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
      case SortOrder.newest:
        result = result.where((p) => p.isNew).toList() +
            result.where((p) => !p.isNew).toList();
      case SortOrder.featured:
        result = result.where((p) => p.isFeatured).toList() +
            result.where((p) => !p.isFeatured).toList();
    }

    // Pagination
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, result.length);
    return result.sublist(start.clamp(0, result.length), end);
  }

  @override
  Future<List<ShopCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_categories);
  }
}
