import 'package:app/features/merchants/domain/merchant_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/application/auth_providers.dart';
import '../../merchants/application/merchant_providers.dart';
import '../data/marketer_remote_repository.dart';
import '../domain/marketer_entities.dart';
import '../domain/marketer_repository.dart';

export '../domain/marketer_entities.dart';
export '../domain/marketer_repository.dart';

final marketerRepositoryProvider = Provider<MarketerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final merchantRepo = ref.watch(merchantRepositoryProvider);
  return MarketerRemoteRepository(dio: dio, merchantRepository: merchantRepo);
});

final marketerStatsProvider =
    FutureProvider.autoDispose<MarketerStats>((ref) async {
  final repo = ref.watch(marketerRepositoryProvider);
  return repo.getStats();
});

final associatedMerchantProvider =
    FutureProvider.autoDispose<Merchant?>((ref) async {
  final user = ref.watch(currentUserProvider);
  final repo = ref.watch(marketerRepositoryProvider);
  return repo.getAssociatedMerchant(user?.merchantId);
});

class OnboardingState {
  const OnboardingState({
    this.isLoading = false,
    this.results = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final List<OnboardCustomerResult> results;
  final String? errorMessage;
}

class MarketerOnboardingNotifier extends StateNotifier<OnboardingState> {
  MarketerOnboardingNotifier(this._repository) : super(const OnboardingState());

  final MarketerRepository _repository;

  Future<OnboardCustomerResult> registerSingleCustomer(
    OnboardCustomerInput input,
  ) async {
    state = const OnboardingState(isLoading: true);
    final result = await _repository.onboardCustomer(input);
    state = OnboardingState(
      isLoading: false,
      results: [result],
      errorMessage: result.success ? null : result.error,
    );
    return result;
  }

  Future<List<OnboardCustomerResult>> registerMultipleCustomers(
    List<OnboardCustomerInput> inputs,
  ) async {
    state = const OnboardingState(isLoading: true);
    final results = await _repository.onboardMultipleCustomers(inputs);
    final anySuccess = results.any((r) => r.success);
    state = OnboardingState(
      isLoading: false,
      results: results,
      errorMessage: anySuccess ? null : 'Failed to register customers.',
    );
    return results;
  }

  void clear() {
    state = const OnboardingState();
  }
}

final marketerOnboardingProvider =
    StateNotifierProvider.autoDispose<MarketerOnboardingNotifier, OnboardingState>(
  (ref) {
    final repo = ref.watch(marketerRepositoryProvider);
    return MarketerOnboardingNotifier(repo);
  },
);

