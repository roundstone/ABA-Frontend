import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/shop_entities.dart';
import 'shop_mock_repository.dart';

/// Remote service handling product review API calls for [ShopRemoteRepository].
class ShopReviewsRemoteService {
  ShopReviewsRemoteService(this._dio);

  final Dio _dio;

  Future<PaginatedData<ProductReview>> fetchReviews({
    ListQueryParams? params,
    int? reviewableId,
    String reviewableType = 'product',
  }) async {
    try {
      final q = params ??
          const ListQueryParams(page: 1, limit: 10, orderBy: 'createdAt:DESC');
      final query = <String, dynamic>{
        'page': q.page,
        'limit': q.limit,
        if (q.search != null && q.search!.trim().isNotEmpty)
          'search': q.search!.trim(),
        if (q.startDateString != null) 'startDate': q.startDateString,
        if (q.endDateString != null) 'endDate': q.endDateString,
        if (q.orderBy != null && q.orderBy!.trim().isNotEmpty)
          'orderBy': q.orderBy!.trim(),
      };
      final res = await _dio.get(
        ApiEndpoints.reviews.base,
        queryParameters: query,
      );
      final rawMap = res.data is Map
          ? Map<String, dynamic>.from(res.data as Map)
          : <String, dynamic>{'data': res.data};
      final parsed = ApiResponse.fromPaginatedJson<ProductReview>(
        rawMap,
        (item) => ProductReview.fromJson(Map<String, dynamic>.from(item as Map)),
      ).data;
      var items = parsed.items
          .where((r) =>
              r.reviewableType.toLowerCase() == reviewableType.toLowerCase())
          .toList();
      if (reviewableId != null) {
        final exact = items.where((r) => r.reviewableId == reviewableId).toList();
        if (exact.isNotEmpty) items = exact;
      }
      return PaginatedData<ProductReview>(items: items, meta: parsed.meta);
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchReviews(
          params: params,
          reviewableId: reviewableId,
          reviewableType: reviewableType,
        );
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchReviews(
          params: params,
          reviewableId: reviewableId,
          reviewableType: reviewableType,
        );
      }
      rethrow;
    }
  }

  Future<ProductReview> createReview(CreateReviewInput input) async {
    final res = await _dio.post(
      ApiEndpoints.reviews.base,
      data: input.toJson(),
    );
    final map = ApiResponse.unwrapMap(res.data);
    return map.isNotEmpty
        ? ProductReview.fromJson(map)
        : ProductReview(
            id: 0,
            reviewableType: input.reviewableType,
            reviewableId: input.reviewableId,
            rating: input.rating,
            comment: input.comment.trim(),
            createdAt: DateTime.now().toUtc(),
          );
  }

  Future<ProductReview> updateReview(String id, UpdateReviewInput input) async {
    final res = await _dio.patch(
      ApiEndpoints.reviews.byId(id),
      data: input.toJson(),
    );
    final map = ApiResponse.unwrapMap(res.data);
    return ProductReview.fromJson(map);
  }

  Future<void> deleteReview(String id) async {
    await _dio.delete(ApiEndpoints.reviews.byId(id));
  }
}
