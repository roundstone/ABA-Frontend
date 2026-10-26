import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/list_query_params.dart';
import '../domain/address_entities.dart';
import '../domain/address_repository.dart';

class AddressNotifier extends StateNotifier<List<DeliveryAddress>> {
  AddressNotifier({required AddressRepository repository})
      : _repository = repository,
        super([]);

  final AddressRepository _repository;
  ListQueryParams _queryParams = const ListQueryParams(orderBy: 'createdAt:DESC');
  bool _isLoadingMore = false;
  bool _hasMore = true;

  ListQueryParams get queryParams => _queryParams;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  Future<void> loadAddresses({ListQueryParams? params}) async {
    if (params != null) {
      _queryParams = params.copyWith(page: 1);
    } else {
      _queryParams = _queryParams.copyWith(page: 1);
    }
    try {
      final items = await _repository.getAddresses(params: _queryParams);
      state = items;
      _hasMore = items.length >= _queryParams.limit;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    try {
      final nextPage = _queryParams.page + 1;
      final nextParams = _queryParams.copyWith(page: nextPage);
      final newItems = await _repository.getAddresses(params: nextParams);
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _queryParams = nextParams;
        state = [...state, ...newItems];
        _hasMore = newItems.length >= nextParams.limit;
      }
    } catch (e) {
      // Retain state and allow retry
      rethrow;
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> searchAddresses(String query) async {
    final updated = _queryParams.withSearch(query);
    await loadAddresses(params: updated);
  }

  Future<void> filterByActive(bool? isActive) async {
    final updated = _queryParams.withActive(isActive);
    await loadAddresses(params: updated);
  }

  Future<void> sortAddresses(String field, [SortDirection direction = SortDirection.desc]) async {
    final updated = _queryParams.withSort(field, direction);
    await loadAddresses(params: updated);
  }

  Future<DeliveryAddress> createAddress(DeliveryAddress address) async {
    try {
      final newAddress = await _repository.createAddress(address);
      state = [...state, newAddress];
      return newAddress;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _repository.deleteAddress(id);
      state = state.where((address) => address.id != id).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<DeliveryAddress> updateAddress(String id, DeliveryAddress address) async {
    try {
      final updatedAddress = await _repository.updateAddress(id, address);
      state = state.map((a) => a.id == id ? updatedAddress : a).toList();
      return updatedAddress;
    } catch (e) {
      rethrow;
    }
  }

  void setDefault(String id) {
    state = state.map((a) => a.copyWith(isDefault: a.id == id)).toList();
  }
}