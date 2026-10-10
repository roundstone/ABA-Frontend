import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/merchant_entities.dart';

class MerchantFilterNotifier extends StateNotifier<MerchantFilterParams> {
  MerchantFilterNotifier() : super(const MerchantFilterParams());

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setCategory(String category) {
    if (state.category == category) {
      state = state.copyWith(category: '');
    } else {
      state = state.copyWith(category: category);
    }
  }

  void setStateFilter(String stateName) {
    if (state.state == stateName) {
      state = state.copyWith(state: '');
    } else {
      state = state.copyWith(state: stateName);
    }
  }

  void setMinRating(double? minRating) {
    if (minRating == null) {
      state = state.copyWith(clearRating: true);
    } else {
      state = state.copyWith(minRating: minRating);
    }
  }

  void toggleVerifiedOnly(bool verified) {
    state = state.copyWith(verifiedOnly: verified);
  }

  void setSort(MerchantSort sort) {
    state = state.copyWith(sort: sort);
  }

  void updateParams(MerchantFilterParams params) {
    state = params;
  }

  void clearFilters() {
    state = const MerchantFilterParams();
  }
}
