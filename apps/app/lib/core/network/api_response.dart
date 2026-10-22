/// Generic model for standardized API success responses from the BuyNaija backend.
///
/// Handles both non-paginated and paginated envelopes:
/// ```json
/// {
///   "success": true,
///   "statusCode": 200,
///   "message": "Request completed successfully",
///   "data": { ... },
///   "timestamp": "2026-10-21T12:00:00.000Z",
///   "path": "/api/v1/products"
/// }
/// ```
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    this.timestamp,
    this.path,
  });

  final bool success;
  final int statusCode;
  final String message;
  final T data;
  final String? timestamp;
  final String? path;

  /// Parses a standard API response envelope, using [fromJsonT] to map the inner payload.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic data) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 200,
      message: json['message'] as String? ?? 'Request completed successfully',
      data: fromJsonT(json.containsKey('data') ? json['data'] : json),
      timestamp: json['timestamp'] as String?,
      path: json['path'] as String?,
    );
  }

  /// Parses a paginated response envelope:
  /// ```json
  /// {
  ///   "success": true,
  ///   "statusCode": 200,
  ///   "data": {
  ///     "data": [ ... ],
  ///     "meta": { ... }
  ///   }
  /// }
  /// ```
  static ApiResponse<PaginatedData<ItemType>> fromPaginatedJson<ItemType>(
    Map<String, dynamic> json,
    ItemType Function(dynamic item) fromJsonItem,
  ) {
    return ApiResponse<PaginatedData<ItemType>>.fromJson(
      json,
      (data) {
        if (data is Map<String, dynamic>) {
          return PaginatedData<ItemType>.fromJson(data, fromJsonItem);
        }
        return PaginatedData<ItemType>(
          items: const [],
          meta: PaginationMeta.empty(),
        );
      },
    );
  }

  /// Safely extracts the inner `data` payload whether the response is wrapped
  /// in `{ "success": true, "data": ... }` or returned as bare data.
  static dynamic unwrap(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data')) {
        return responseData['data'];
      }
      return responseData;
    }
    return responseData;
  }

  /// Safely unwraps a `Map<String, dynamic>` from a response.
  static Map<String, dynamic> unwrapMap(dynamic responseData) {
    final unwrapped = unwrap(responseData);
    if (unwrapped is Map<String, dynamic>) {
      return unwrapped;
    }
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }
    return const {};
  }

  /// Safely unwraps a `List<dynamic>` from a response.
  /// Handles both direct lists and paginated `{ "data": [ ... ] }`.
  static List<dynamic> unwrapList(dynamic responseData) {
    final unwrapped = unwrap(responseData);
    if (unwrapped is List) {
      return unwrapped;
    }
    if (unwrapped is Map<String, dynamic> && unwrapped.containsKey('data') && unwrapped['data'] is List) {
      return unwrapped['data'] as List<dynamic>;
    }
    if (responseData is List) {
      return responseData;
    }
    return const [];
  }
}

/// Metadata describing pagination state returned by the backend.
class PaginationMeta {
  const PaginationMeta({
    required this.totalItems,
    required this.itemCount,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
    this.currentPageUrl,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  final int totalItems;
  final int itemCount;
  final int itemsPerPage;
  final int totalPages;
  final int currentPage;
  final String? currentPageUrl;
  final String? nextPageUrl;
  final String? previousPageUrl;

  bool get hasNextPage => nextPageUrl != null || (totalPages > 0 && currentPage < totalPages);
  bool get hasPreviousPage => previousPageUrl != null || currentPage > 1;

  factory PaginationMeta.empty() {
    return const PaginationMeta(
      totalItems: 0,
      itemCount: 0,
      itemsPerPage: 10,
      totalPages: 0,
      currentPage: 1,
    );
  }

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      itemsPerPage: (json['itemsPerPage'] as num?)?.toInt() ?? 10,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      currentPageUrl: json['currentPageUrl'] as String?,
      nextPageUrl: json['nextPageUrl'] as String?,
      previousPageUrl: json['previousPageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'itemCount': itemCount,
      'itemsPerPage': itemsPerPage,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'currentPageUrl': currentPageUrl,
      'nextPageUrl': nextPageUrl,
      'previousPageUrl': previousPageUrl,
    };
  }

  @override
  String toString() =>
      'PaginationMeta(page: $currentPage/$totalPages, items: $itemCount/$totalItems, next: $hasNextPage)';
}

/// Generic wrapper for paginated items with attached pagination metadata.
class PaginatedData<T> {
  const PaginatedData({
    required this.items,
    required this.meta,
  });

  final List<T> items;
  final PaginationMeta meta;

  factory PaginatedData.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic item) fromJsonItem,
  ) {
    final rawList = json['data'] is List
        ? json['data'] as List
        : (json['items'] is List ? json['items'] as List : const []);

    final items = rawList.map((item) => fromJsonItem(item)).toList();

    final meta = json['meta'] is Map<String, dynamic>
        ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
        : PaginationMeta(
            totalItems: items.length,
            itemCount: items.length,
            itemsPerPage: items.length,
            totalPages: items.isNotEmpty ? 1 : 0,
            currentPage: 1,
          );

    return PaginatedData<T>(
      items: items,
      meta: meta,
    );
  }

  @override
  String toString() => 'PaginatedData(items: ${items.length}, meta: $meta)';
}
