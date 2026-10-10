import 'merchant_entities.dart';

abstract class MerchantRepository {
  Future<MerchantDirectoryResult> getMerchants(MerchantFilterParams params);

  Future<Merchant?> getMerchantById(String id);
}
