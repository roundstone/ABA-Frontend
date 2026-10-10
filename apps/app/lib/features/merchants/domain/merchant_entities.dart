enum MerchantSort {
  recommended('Recommended'),
  rating('Highest Rated'),
  orders('Most Orders'),
  newest('Newest First');

  const MerchantSort(this.label);
  final String label;
}

class Merchant {
  const Merchant({
    required this.id,
    required this.merchantNo,
    required this.name,
    required this.legalName,
    required this.logoUrl,
    required this.bannerImage,
    required this.description,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    this.category = 'General',
    this.rating = 4.5,
    this.reviewCount = 0,
    this.ordersCount = 0,
    this.isVerified = true,
    this.isFeatured = false,
    required this.onboardedAt,
  });

  final String id;
  final String merchantNo;
  final String name;
  final String legalName;
  final String logoUrl;
  final String bannerImage;
  final String description;
  final String ownerName;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final String category;
  final double rating;
  final int reviewCount;
  final int ordersCount;
  final bool isVerified;
  final bool isFeatured;
  final DateTime onboardedAt;

  int get joinedYear => onboardedAt.year;
}

class MerchantFilterParams {
  const MerchantFilterParams({
    this.query = '',
    this.category = '',
    this.state = '',
    this.minRating,
    this.verifiedOnly = false,
    this.sort = MerchantSort.recommended,
  });

  final String query;
  final String category;
  final String state;
  final double? minRating;
  final bool verifiedOnly;
  final MerchantSort sort;

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      category.isNotEmpty ||
      state.isNotEmpty ||
      minRating != null ||
      verifiedOnly ||
      sort != MerchantSort.recommended;

  MerchantFilterParams copyWith({
    String? query,
    String? category,
    String? state,
    double? minRating,
    bool clearRating = false,
    bool? verifiedOnly,
    MerchantSort? sort,
  }) {
    return MerchantFilterParams(
      query: query ?? this.query,
      category: category ?? this.category,
      state: state ?? this.state,
      minRating: clearRating ? null : (minRating ?? this.minRating),
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      sort: sort ?? this.sort,
    );
  }
}

class MerchantDirectoryResult {
  const MerchantDirectoryResult({
    required this.merchants,
    required this.totalCount,
    required this.availableStates,
    required this.availableCategories,
  });

  final List<Merchant> merchants;
  final int totalCount;
  final List<String> availableStates;
  final List<String> availableCategories;
}
