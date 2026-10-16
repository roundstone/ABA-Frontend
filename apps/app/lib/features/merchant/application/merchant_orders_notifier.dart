import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/merchant_order_entities.dart';
import '../domain/merchant_repository.dart';

class MerchantOrdersState {
  const MerchantOrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.isUpdating = false,
    this.errorMessage,
    this.selectedStatus,
    this.searchQuery = '',
  });

  final List<MerchantOrder> orders;
  final bool isLoading;
  final bool isUpdating;
  final String? errorMessage;
  final MerchantOrderStatus? selectedStatus;
  final String searchQuery;

  MerchantOrdersState copyWith({
    List<MerchantOrder>? orders,
    bool? isLoading,
    bool? isUpdating,
    String? errorMessage,
    MerchantOrderStatus? selectedStatus,
    bool clearStatus = false,
    String? searchQuery,
  }) {
    return MerchantOrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage,
      selectedStatus:
          clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MerchantOrdersNotifier extends StateNotifier<MerchantOrdersState> {
  MerchantOrdersNotifier({
    required this.repository,
    required this.merchantId,
  }) : super(const MerchantOrdersState()) {
    loadOrders();
  }

  final MerchantRepository repository;
  final String merchantId;

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await repository.getOrders(
        merchantId,
        status: state.selectedStatus,
        query: state.searchQuery,
      );
      state = state.copyWith(orders: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void setStatusFilter(MerchantOrderStatus? status) {
    state = state.copyWith(
      selectedStatus: status,
      clearStatus: status == null,
    );
    loadOrders();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadOrders();
  }

  Future<bool> updateOrderStatus(
    String orderId,
    MerchantOrderStatus newStatus,
  ) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);
    try {
      final updated = await repository.updateOrderStatus(
        merchantId,
        orderId,
        newStatus,
      );
      final list = state.orders.map((o) => o.id == orderId ? updated : o).toList();
      state = state.copyWith(orders: list, isUpdating: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}
