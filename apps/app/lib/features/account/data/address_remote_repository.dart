import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../account/domain/address_entities.dart';
import '../../account/domain/address_repository.dart';

class AddressRemoteRepository implements AddressRepository {
  AddressRemoteRepository({Dio? dio, Ref? ref})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl)),
      _ref = ref;

  final Dio _dio;
  final Ref? _ref;

  @override
  Future<List<DeliveryAddress>> getAddresses({ListQueryParams? params}) async {
    try {
      final query = params ?? const ListQueryParams(orderBy: 'createdAt:DESC');
      final res = await _dio.get(
        ApiEndpoints.deliveryAddresses.base,
        queryParameters: query.toMap(),
        options: _getAuthOptions(),
      );

      final list = ApiResponse.unwrapList(res.data);

      return list
          .whereType<Map>()
          .map((item) => DeliveryAddress.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw ApiError.fromDio(e);
    }
  }

  @override
  Future<DeliveryAddress> createAddress(DeliveryAddress address) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.deliveryAddresses.base,
        data: {
          'name': address.name,
          'street': address.street,
          'city': address.city,
          'state': address.state,
          'zip': address.zip,
        },
        options: _getAuthOptions(),
      );

      final data = ApiResponse.unwrapMap(res.data);
      return DeliveryAddress.fromJson(data);
    } on DioException catch (e) {
      throw ApiError.fromDio(e);
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    try {
      await _dio.delete(
        ApiEndpoints.deliveryAddresses.byId(id),
        options: _getAuthOptions(),
      );
    } on DioException catch (e) {
      throw ApiError.fromDio(e);
    }
  }

  @override
  Future<DeliveryAddress> updateAddress(
    String id,
    DeliveryAddress address,
  ) async {
    try {
      final res = await _dio.put(
        ApiEndpoints.deliveryAddresses.byId(id),
        data: {
          'name': address.name,
          'street': address.street,
          'city': address.city,
          'state': address.state,
          'zip': address.zip,
        },
        options: _getAuthOptions(),
      );

      final data = ApiResponse.unwrapMap(res.data);
      return DeliveryAddress.fromJson(data);
    } on DioException catch (e) {
      throw ApiError.fromDio(e);
    }
  }

  Options _getAuthOptions() {
    final token = _ref?.read(dioProvider).options.headers['Authorization'];
    return Options(headers: {if (token != null) 'Authorization': token});
  }
}
