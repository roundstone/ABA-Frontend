import 'merchant_entities.dart';

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

