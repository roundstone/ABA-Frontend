import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/dio_client.dart';
import '../data/orders_api.dart';
import '../domain/customer_order.dart';

final ordersApiProvider = Provider<OrdersApi>((ref) {
  final dio = ref.watch(dioProvider);
  return OrdersApi(dio);
});

class CustomerOrdersState {
  final List<CustomerOrder> orders;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final OrderStatus? statusFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final String searchQuery;

  const CustomerOrdersState({
    this.orders = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.hasMore = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.statusFilter,
    this.startDate,
    this.endDate,
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      statusFilter != null || startDate != null || endDate != null;

  CustomerOrdersState copyWith({
    List<CustomerOrder>? orders,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    OrderStatus? statusFilter,
    bool clearStatusFilter = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? searchQuery,
  }) {
    return CustomerOrdersState(
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      statusFilter:
          clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CustomerOrdersNotifier extends StateNotifier<CustomerOrdersState> {
  final OrdersApi _api;

  CustomerOrdersNotifier(this._api) : super(const CustomerOrdersState()) {
    loadInitial();
  }

  String? _formatDate(DateTime? dt) =>
      dt != null ? DateFormat('yyyy-MM-dd').format(dt) : null;

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _api.getOrders(
        page: 1,
        search: state.searchQuery,
        status: state.statusFilter,
        startDate: _formatDate(state.startDate),
        endDate: _formatDate(state.endDate),
      );
      state = state.copyWith(
        orders: res.orders,
        currentPage: res.currentPage,
        totalPages: res.totalPages,
        totalItems: res.totalItems,
        hasMore: res.hasNext,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ApiError.toUserFriendlyMessage(e),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final res = await _api.getOrders(
        page: nextPage,
        search: state.searchQuery,
        status: state.statusFilter,
        startDate: _formatDate(state.startDate),
        endDate: _formatDate(state.endDate),
      );
      state = state.copyWith(
        orders: [...state.orders, ...res.orders],
        currentPage: res.currentPage,
        totalPages: res.totalPages,
        totalItems: res.totalItems,
        hasMore: res.hasNext,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void setSearchQuery(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query);
    loadInitial();
  }

  void setStatusFilter(OrderStatus? filter) {
    if (state.statusFilter == filter) return;
    if (filter == null) {
      state = state.copyWith(clearStatusFilter: true);
    } else {
      state = state.copyWith(statusFilter: filter);
    }
    loadInitial();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(
      startDate: start,
      endDate: end,
      clearStartDate: start == null,
      clearEndDate: end == null,
    );
    loadInitial();
  }

  void clearDateRange() {
    state = state.copyWith(clearStartDate: true, clearEndDate: true);
    loadInitial();
  }

  void clearAllFilters() {
    state = state.copyWith(
      clearStatusFilter: true,
      clearStartDate: true,
      clearEndDate: true,
    );
    loadInitial();
  }

  Future<void> refresh() => loadInitial();
}

final customerOrdersNotifierProvider =
    StateNotifierProvider<CustomerOrdersNotifier, CustomerOrdersState>((ref) {
  return CustomerOrdersNotifier(ref.watch(ordersApiProvider));
});

final orderFilterProvider = StateProvider<OrderStatus?>((ref) {
  return ref.watch(customerOrdersNotifierProvider).statusFilter;
});

final orderSearchQueryProvider = StateProvider<String>((ref) {
  return ref.watch(customerOrdersNotifierProvider).searchQuery;
});

final customerOrdersProvider = FutureProvider<List<CustomerOrder>>((ref) async {
  return ref.watch(customerOrdersNotifierProvider).orders;
});

final customerOrderByIdProvider =
    FutureProvider.family<CustomerOrder, String>((ref, id) async {
  final api = ref.watch(ordersApiProvider);
  return api.getOrderById(id);
});
