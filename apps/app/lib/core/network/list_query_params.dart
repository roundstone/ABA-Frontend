import 'query_param_helpers.dart';
import 'sort_direction.dart';
export 'query_param_helpers.dart';
export 'sort_direction.dart';

/// Standardized, reusable query parameters for list endpoints in ABA ERP.
///
/// Implements standard OpenAPI parameters:
/// - [page]: 1-based page index (defaults to 1).
/// - [limit]: Number of items per page (defaults to 10).
/// - [search]: Free-text search term (e.g. "Adeyemi").
/// - [startDate]: Start date string ($date format YYYY-MM-DD, e.g. "2026-01-01").
/// - [endDate]: End date string ($date format YYYY-MM-DD, e.g. "2026-01-31").
/// - [orderBy]: Sort expression in format `field:ASC` or `field:DESC` (default: "createdAt:DESC").
/// - [isActive]: Filter by active status (boolean).
/// - [categoryId]: Filter by category ID (number).
/// - [includeVariants]: Include product variants in each result (boolean).
/// - [customParams]: Additional endpoint-specific filter parameters.
class ListQueryParams {
  const ListQueryParams({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.startDate,
    this.endDate,
    this.orderBy = 'createdAt:DESC',
    this.isActive,
    this.categoryId,
    this.includeVariants,
    this.customParams = const {},
  })  : assert(page >= 1, 'page must be >= 1'),
        assert(limit >= 1, 'limit must be >= 1');

  final int page;
  final int limit;
  final String? search;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? orderBy;
  final bool? isActive;
  final int? categoryId;
  final bool? includeVariants;
  final Map<String, dynamic> customParams;

  static String formatDate(DateTime date) => QueryParamHelpers.formatDate(date);
  static DateTime? parseDate(dynamic value) => QueryParamHelpers.parseDate(value);
  static String formatOrderBy(String field, [SortDirection direction = SortDirection.desc]) =>
      QueryParamHelpers.formatOrderBy(field, direction);

  String? get sortField =>
      orderBy?.contains(':') == true ? orderBy!.split(':').first.trim() : orderBy;

  SortDirection? get sortDirection {
    if (orderBy?.contains(':') != true) return null;
    return SortDirection.fromString(orderBy!.split(':')[1]);
  }

  String? get startDateString => startDate != null ? formatDate(startDate!) : null;
  String? get endDateString => endDate != null ? formatDate(endDate!) : null;

  factory ListQueryParams.ordered({
    required String field,
    SortDirection direction = SortDirection.desc,
    int page = 1,
    int limit = 10,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? categoryId,
    bool? includeVariants,
    Map<String, dynamic> customParams = const {},
  }) {
    return ListQueryParams(
      page: page,
      limit: limit,
      search: search,
      startDate: startDate,
      endDate: endDate,
      orderBy: formatOrderBy(field, direction),
      isActive: isActive,
      categoryId: categoryId,
      includeVariants: includeVariants,
      customParams: customParams,
    );
  }

  factory ListQueryParams.fromJson(Map<String, dynamic> json) {
    const standardKeys = {
      'page',
      'limit',
      'search',
      'startDate',
      'endDate',
      'orderBy',
      'isActive',
      'categoryId',
      'includeVariants',
    };
    final custom = <String, dynamic>{};
    json.forEach((k, v) {
      if (!standardKeys.contains(k) && v != null) custom[k] = v;
    });

    return ListQueryParams(
      page: QueryParamHelpers.parseInt(json['page'], 1),
      limit: QueryParamHelpers.parseInt(json['limit'], 10),
      search: json['search'] as String?,
      startDate: parseDate(json['startDate']),
      endDate: parseDate(json['endDate']),
      orderBy: json['orderBy']?.toString() ?? 'createdAt:DESC',
      isActive: QueryParamHelpers.parseBool(json['isActive']),
      categoryId: QueryParamHelpers.parseIntNullable(json['categoryId']),
      includeVariants: QueryParamHelpers.parseBool(json['includeVariants']),
      customParams: custom,
    );
  }

  factory ListQueryParams.fromUri(Uri uri) => ListQueryParams.fromJson(uri.queryParameters);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search!.trim().isNotEmpty) map['search'] = search!.trim();
    if (startDate != null) map['startDate'] = formatDate(startDate!);
    if (endDate != null) map['endDate'] = formatDate(endDate!);
    if (orderBy != null && orderBy!.trim().isNotEmpty) map['orderBy'] = orderBy!.trim();
    if (isActive != null) map['isActive'] = isActive;
    if (categoryId != null) map['categoryId'] = categoryId;
    if (includeVariants != null) map['includeVariants'] = includeVariants;
    customParams.forEach((k, v) {
      if (v != null) map[k] = v;
    });
    return map;
  }

  Map<String, String> toQueryParameters() => toMap().map((k, v) => MapEntry(k, v.toString()));

  String toQueryString() => toQueryParameters()
      .entries
      .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
      .join('&');

  ListQueryParams copyWith({
    int? page,
    int? limit,
    String? search,
    bool clearSearch = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? orderBy,
    bool clearOrderBy = false,
    bool? isActive,
    bool clearIsActive = false,
    int? categoryId,
    bool clearCategoryId = false,
    bool? includeVariants,
    bool clearIncludeVariants = false,
    Map<String, dynamic>? customParams,
  }) {
    return ListQueryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: clearSearch ? null : (search ?? this.search),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      orderBy: clearOrderBy ? null : (orderBy ?? this.orderBy),
      isActive: clearIsActive ? null : (isActive ?? this.isActive),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      includeVariants: clearIncludeVariants ? null : (includeVariants ?? this.includeVariants),
      customParams: customParams ?? this.customParams,
    );
  }

  ListQueryParams nextPage() => copyWith(page: page + 1);
  ListQueryParams previousPage() => copyWith(page: page > 1 ? page - 1 : 1);
  ListQueryParams resetPage() => copyWith(page: 1);

  ListQueryParams withSort(String field, [SortDirection direction = SortDirection.desc]) =>
      copyWith(orderBy: formatOrderBy(field, direction), page: 1);

  ListQueryParams withSearch(String? term) => copyWith(search: term, page: 1);
  ListQueryParams withDateRange(DateTime? start, DateTime? end) =>
      copyWith(startDate: start, endDate: end, page: 1);
  ListQueryParams withActive(bool? active) => copyWith(isActive: active, page: 1);
  ListQueryParams withCategory(int? id) => copyWith(categoryId: id, page: 1);
  ListQueryParams withVariants(bool? include) => copyWith(includeVariants: include);

  ListQueryParams withParam(String key, dynamic value) {
    final updated = Map<String, dynamic>.from(customParams);
    if (value == null) {
      updated.remove(key);
    } else {
      updated[key] = value;
    }
    return copyWith(customParams: updated);
  }

  dynamic operator [](String key) => switch (key) {
        'page' => page,
        'limit' => limit,
        'search' => search,
        'startDate' => startDateString,
        'endDate' => endDateString,
        'orderBy' => orderBy,
        'isActive' => isActive,
        'categoryId' => categoryId,
        'includeVariants' => includeVariants,
        _ => customParams[key],
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ListQueryParams &&
        other.page == page &&
        other.limit == limit &&
        other.search == search &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.orderBy == orderBy &&
        other.isActive == isActive &&
        other.categoryId == categoryId &&
        other.includeVariants == includeVariants &&
        QueryParamHelpers.mapEquals(other.customParams, customParams);
  }

  @override
  int get hashCode => Object.hash(
        page,
        limit,
        search,
        startDate,
        endDate,
        orderBy,
        isActive,
        categoryId,
        includeVariants,
        Object.hashAll(customParams.entries.map((e) => Object.hash(e.key, e.value))),
      );

  @override
  String toString() => 'ListQueryParams(${toQueryString()})';
}

typedef StandardQueryParams = ListQueryParams;
typedef ApiQueryParams = ListQueryParams;
