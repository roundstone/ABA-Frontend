import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/merchant_product_entities.dart';
import '../domain/merchant_repository.dart';

class MerchantProductsState {
  const MerchantProductsState({
    this.products = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.selectedStockFilter = 'All',
  });

  final List<MerchantProduct> products;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String searchQuery;
  final String selectedCategory;
  final String selectedStockFilter;

  MerchantProductsState copyWith({
    List<MerchantProduct>? products,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategory,
    String? selectedStockFilter,
  }) {
    return MerchantProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedStockFilter: selectedStockFilter ?? this.selectedStockFilter,
    );
  }
}

class MerchantProductsNotifier extends StateNotifier<MerchantProductsState> {
  MerchantProductsNotifier({
    required this.repository,
    required this.merchantId,
  }) : super(const MerchantProductsState()) {
    loadProducts();
  }

  final MerchantRepository repository;
  final String merchantId;

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await repository.getProducts(
        merchantId,
        query: state.searchQuery,
        category: state.selectedCategory,
        stockFilter: state.selectedStockFilter,
      );
      state = state.copyWith(products: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadProducts();
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    loadProducts();
  }

  void setStockFilter(String filter) {
    state = state.copyWith(selectedStockFilter: filter);
    loadProducts();
  }

  Future<bool> addProduct(MerchantProduct product) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final created = await repository.addProduct(merchantId, product);
      state = state.copyWith(
        products: [created, ...state.products],
        isSaving: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> updateProduct(MerchantProduct product) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final updated = await repository.updateProduct(merchantId, product);
      final list = state.products.map((p) => p.id == updated.id ? updated : p).toList();
      state = state.copyWith(products: list, isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> adjustStock(String productId, int adjustment, String reason) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      await repository.adjustStock(merchantId, productId, adjustment, reason);
      final list = state.products.map((p) {
        if (p.id == productId) {
          final newStock = (p.stock + adjustment).clamp(0, 99999);
          return p.copyWith(stock: newStock, updatedAt: DateTime.now());
        }
        return p;
      }).toList();
      state = state.copyWith(products: list, isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}
