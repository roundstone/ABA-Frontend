import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_error.dart';
import '../domain/wishlist_item.dart';
import '../domain/wishlist_repository.dart';
import 'wishlist_mock_repository.dart';

class WishlistRemoteRepository implements WishlistRepository {
  final Dio _dio;
  final WishlistMockRepository _mock;

  WishlistRemoteRepository(this._dio, [WishlistMockRepository? mock])
      : _mock = mock ?? WishlistMockRepository();

  @override
  Future<PaginatedWishlistResult> getWishlist({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    String? orderBy = 'createdAt:DESC',
  }) async {
    if (AppConfig.isMockMode) {
      return _mock.getWishlist(
        page: page,
        limit: limit,
        search: search,
        startDate: startDate,
        endDate: endDate,
        orderBy: orderBy,
      );
    }

    try {
      final endpoint = ApiEndpoints.wishlists.base;
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (orderBy != null) 'orderBy': orderBy,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (startDate != null && startDate.isNotEmpty) 'startDate': startDate,
        if (endDate != null && endDate.isNotEmpty) 'endDate': endDate,
      };

      AppLogger.d('GET $endpoint with params: $queryParams');
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      final rawData = response.data is Map ? response.data['data'] : null;

      List itemsList = [];
      Map<String, dynamic>? meta;
      if (rawData is Map) {
        if (rawData['data'] is List) itemsList = rawData['data'] as List;
        if (rawData['meta'] is Map) {
          meta = rawData['meta'] as Map<String, dynamic>;
        }
      } else if (rawData is List) {
        itemsList = rawData;
      }

      final items = itemsList
          .whereType<Map<String, dynamic>>()
          .map((json) => WishlistItem.fromJson(json))
          .toList();

      final totalPages = (meta?['totalPages'] as num?)?.toInt() ?? 1;
      final totalItems =
          (meta?['totalItems'] as num?)?.toInt() ?? items.length;
      final currentPage = (meta?['currentPage'] as num?)?.toInt() ?? page;
      final hasNext = meta?['nextPageUrl'] != null || currentPage < totalPages;

      return PaginatedWishlistResult(
        items: items,
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: currentPage,
        hasNext: hasNext,
      );
    } on DioException catch (e, stack) {
      AppLogger.e('WishlistRemoteRepository.getWishlist failed',
          error: e, stackTrace: stack);
      throw ApiError.fromDio(e);
    } catch (e, stack) {
      AppLogger.e('WishlistRemoteRepository.getWishlist error',
          error: e, stackTrace: stack);
      throw ApiError(
        success: false,
        statusCode: 500,
        message: ApiError.toUserFriendlyMessage(e),
      );
    }
  }

  @override
  Future<WishlistItem> addToWishlist({
    String wishlistableType = 'product',
    required int wishlistableId,
  }) async {
    if (AppConfig.isMockMode) {
      return _mock.addToWishlist(
        wishlistableType: wishlistableType,
        wishlistableId: wishlistableId,
      );
    }

    try {
      final endpoint = ApiEndpoints.wishlists.base;
      final payload = {
        'wishlistableType': wishlistableType,
        'wishlistableId': wishlistableId,
      };

      AppLogger.d('POST $endpoint with $payload');
      final response = await _dio.post(endpoint, data: payload);
      final rawData = response.data is Map ? response.data['data'] : null;

      if (rawData is Map<String, dynamic>) {
        return WishlistItem.fromJson(rawData);
      }
      return WishlistItem.fromJson(Map<String, dynamic>.from(rawData as Map));
    } on DioException catch (e, stack) {
      AppLogger.e('WishlistRemoteRepository.addToWishlist failed',
          error: e, stackTrace: stack);
      throw ApiError.fromDio(e);
    } catch (e, stack) {
      AppLogger.e('WishlistRemoteRepository.addToWishlist error',
          error: e, stackTrace: stack);
      throw ApiError(
        success: false,
        statusCode: 500,
        message: ApiError.toUserFriendlyMessage(e),
      );
    }
  }

  @override
  Future<bool> removeFromWishlist(int id) async {
    if (AppConfig.isMockMode) {
      return _mock.removeFromWishlist(id);
    }

    try {
      final endpoint = ApiEndpoints.wishlists.byId(id);
      AppLogger.d('DELETE $endpoint');
      final response = await _dio.delete(endpoint);
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e, stack) {
      AppLogger.e('WishlistRemoteRepository.removeFromWishlist failed',
          error: e, stackTrace: stack);
      throw ApiError.fromDio(e);
    } catch (e, stack) {
      AppLogger.e('WishlistRemoteRepository.removeFromWishlist error',
          error: e, stackTrace: stack);
      throw ApiError(
        success: false,
        statusCode: 500,
        message: ApiError.toUserFriendlyMessage(e),
      );
    }
  }
}

