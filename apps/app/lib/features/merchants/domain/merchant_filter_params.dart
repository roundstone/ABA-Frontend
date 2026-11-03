enum MerchantSort {
  recommended('Recommended'),
  rating('Highest Rated'),
  orders('Most Orders'),
  newest('Newest First');

  const MerchantSort(this.label);
  final String label;
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
