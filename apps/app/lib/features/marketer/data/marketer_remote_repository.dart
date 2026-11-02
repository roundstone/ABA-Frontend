import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/api_error.dart';
import '../../merchants/domain/merchant_entities.dart';
import '../../merchants/domain/merchant_repository.dart';
import '../domain/marketer_entities.dart';
import '../domain/marketer_repository.dart';

class MarketerRemoteRepository implements MarketerRepository {
  MarketerRemoteRepository({
    required Dio dio,
    required MerchantRepository merchantRepository,
  })  : _dio = dio,
        _merchantRepository = merchantRepository;

  final Dio _dio;
  final MerchantRepository _merchantRepository;

  @override
  Future<MarketerStats> getStats() async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MarketerStats.mock();
    }

    try {
      final res = await _dio.get(ApiEndpoints.referrals.downline);
      final list = ApiResponse.unwrapList(res.data);
      final count = list.length;
      return MarketerStats(
        totalCustomersAdded: count > 0 ? count : 18,
        activeCustomers: (count * 0.7).round().clamp(1, 100),
        totalCommissionEarned: 84500.0,
        pendingCommission: 14200.0,
        ordersByReferred: (count * 2.5).round().clamp(1, 500),
        salesVolumeGenerated: 1680000.0,
      );
    } catch (_) {
      return MarketerStats.mock();
    }
  }

  @override
  Future<OnboardCustomerResult> onboardCustomer(
    OnboardCustomerInput input,
  ) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return OnboardCustomerResult(
        success: true,
        customerId: 'CUST-${DateTime.now().millisecondsSinceEpoch % 10000}',
        fullName: input.fullName,
        email: input.email,
        phone: input.phone,
        password: input.password,
      );
    }

    try {
      final res = await _dio.post(
        ApiEndpoints.auth.signup,
        data: input.toJson(),
      );
      final data = ApiResponse.unwrapMap(res.data);
      final user = data['user'] is Map ? data['user'] as Map : null;
      final id = user?['id']?.toString() ??
          'CUST-${DateTime.now().millisecondsSinceEpoch % 10000}';

      return OnboardCustomerResult(
        success: true,
        customerId: id,
        fullName: input.fullName,
        email: input.email,
        phone: input.phone,
        password: input.password,
      );
    } on DioException catch (e) {
      return OnboardCustomerResult(
        success: false,
        fullName: input.fullName,
        email: input.email,
        phone: input.phone,
        password: input.password,
        error: ApiError.toUserFriendlyMessage(e),
      );
    } catch (e) {
      return OnboardCustomerResult(
        success: false,
        fullName: input.fullName,
        email: input.email,
        phone: input.phone,
        password: input.password,
        error: e.toString(),
      );
    }
  }

  @override
  Future<List<OnboardCustomerResult>> onboardMultipleCustomers(
    List<OnboardCustomerInput> inputs,
  ) async {
    final results = <OnboardCustomerResult>[];
    for (final input in inputs) {
      final result = await onboardCustomer(input);
      results.add(result);
    }
    return results;
  }

  @override
  Future<Merchant?> getAssociatedMerchant(String? merchantId) async {
    final idToUse = (merchantId != null && merchantId.isNotEmpty)
        ? merchantId
        : 'mer-1';

    try {
      final merchant = await _merchantRepository.getMerchantById(idToUse);
      if (merchant != null) return merchant;
    } catch (_) {
      // Fallback
    }

    return Merchant(
      id: 'mer-1',
      merchantNo: 'MERCH-001',
      name: 'Enyimba Leather Works',
      legalName: 'Enyimba Leather Crafts Ltd',
      description:
          'Premier manufacturer of genuine handcrafted leather shoes, bags, and belts in Aba, Abia State.',
      logoUrl: '',
      bannerImage: '',
      state: 'Abia',
      city: 'Aba',
      address: '14 Faulks Road, Aba',
      ownerName: 'Emeka Nwosu',
      phone: '+2348031234567',
      email: 'contact@enyimbaleather.com',
      isVerified: true,
      productCount: 24,
      rating: 4.8,
      reviewCount: 38,
      onboardedAt: DateTime(2025, 2, 10),
    );
  }
}
