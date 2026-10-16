import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/merchant_dashboard_entities.dart';
import '../domain/merchant_repository.dart';

class MerchantDashboardState {
  const MerchantDashboardState({
    this.metrics,
    this.isLoading = false,
    this.errorMessage,
  });

  final MerchantDashboardMetrics? metrics;
  final bool isLoading;
  final String? errorMessage;

  MerchantDashboardState copyWith({
    MerchantDashboardMetrics? metrics,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MerchantDashboardState(
      metrics: metrics ?? this.metrics,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class MerchantDashboardNotifier extends StateNotifier<MerchantDashboardState> {
  MerchantDashboardNotifier({
    required this.repository,
    required this.merchantId,
  }) : super(const MerchantDashboardState()) {
    loadMetrics();
  }

  final MerchantRepository repository;
  final String merchantId;

  Future<void> loadMetrics() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final metrics = await repository.getDashboardMetrics(merchantId);
      state = state.copyWith(
        metrics: metrics,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> refresh() async {
    await loadMetrics();
  }
}
