import '../../merchants/domain/merchant_entities.dart';
import 'marketer_entities.dart';

abstract class MarketerRepository {
  Future<MarketerStats> getStats();
  Future<OnboardCustomerResult> onboardCustomer(OnboardCustomerInput input);
  Future<List<OnboardCustomerResult>> onboardMultipleCustomers(
    List<OnboardCustomerInput> inputs,
  );
  Future<Merchant?> getAssociatedMerchant(String? merchantId);
}

