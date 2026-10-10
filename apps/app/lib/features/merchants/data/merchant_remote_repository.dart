import 'package:dio/dio.dart';
import '../domain/merchant_entities.dart';
import '../domain/merchant_repository.dart';

class MerchantRemoteRepository implements MerchantRepository {
  MerchantRemoteRepository(this._dio);
  final Dio _dio;

  @override
  Future<MerchantDirectoryResult> getMerchants(
    MerchantFilterParams params,
  ) async {
    final queryParams = <String, dynamic>{
      if (params.query.isNotEmpty) 'q': params.query,
      if (params.category.isNotEmpty) 'category': params.category,
      if (params.state.isNotEmpty) 'state': params.state,
      if (params.minRating != null) 'rating': params.minRating,
      if (params.verifiedOnly) 'verified': '1',
      'sort': params.sort.name,
    };

    final response = await _dio.get(
      '/merchants/directory',
      queryParameters: queryParams,
    );

    final data = response.data['data'] as List<dynamic>;
    final facets = response.data['facets'] as Map<String, dynamic>? ?? {};

    final merchants = data.map((json) => _mapJsonToMerchant(json)).toList();
    final states = (facets['states'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final categories = (facets['categories'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return MerchantDirectoryResult(
      merchants: merchants,
      totalCount: merchants.length,
      availableStates: states,
      availableCategories: categories,
    );
  }

  @override
  Future<Merchant?> getMerchantById(String id) async {
    final response = await _dio.get('/merchants/$id');
    final data = response.data['data'];
    if (data == null) return null;
    return _mapJsonToMerchant(data as Map<String, dynamic>);
  }

  Merchant _mapJsonToMerchant(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'] as String,
      merchantNo: json['merchantNo'] as String? ?? '',
      name: json['name'] as String,
      legalName: json['legalName'] as String? ?? json['name'] as String,
      logoUrl: json['logoUrl'] as String? ?? '',
      bannerImage: json['bannerImage'] as String? ?? '',
      description: json['description'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      ordersCount: (json['ordersCount'] as num?)?.toInt() ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      onboardedAt: json['onboardedAt'] != null
          ? DateTime.parse(json['onboardedAt'] as String)
          : DateTime.now(),
    );
  }
}
