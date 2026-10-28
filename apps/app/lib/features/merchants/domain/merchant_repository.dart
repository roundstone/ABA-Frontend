import '../../../core/network/list_query_params.dart';
import 'merchant_entities.dart';

abstract class MerchantRepository {
  Future<MerchantDirectoryResult> getMerchants([
    MerchantFilterParams params = const MerchantFilterParams(),
    ListQueryParams? queryParams,
  ]);

  Future<Merchant?> getMerchantById(String id);

  /// Fetch merchant spotlight showcase from `/api/v1/storefront/merchants-spotlight`.
  Future<List<Merchant>> getMerchantsSpotlight();
}
