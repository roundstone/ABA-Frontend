import '../domain/merchant_entities.dart';
import '../domain/merchant_repository.dart';
import 'merchant_mock_data.dart';

class MerchantMockRepository implements MerchantRepository {
  @override
  Future<MerchantDirectoryResult> getMerchants(
    MerchantFilterParams params,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = List<Merchant>.from(kMockMerchants);

    if (params.query.trim().isNotEmpty) {
      final q = params.query.trim().toLowerCase();
      filtered = filtered.where((m) {
        return m.name.toLowerCase().contains(q) ||
            m.city.toLowerCase().contains(q) ||
            m.state.toLowerCase().contains(q) ||
            m.category.toLowerCase().contains(q) ||
            m.description.toLowerCase().contains(q);
      }).toList();
    }

    if (params.category.trim().isNotEmpty) {
      filtered = filtered
          .where((m) =>
              m.category.toLowerCase() == params.category.trim().toLowerCase())
          .toList();
    }

    if (params.state.trim().isNotEmpty) {
      filtered = filtered
          .where(
              (m) => m.state.toLowerCase() == params.state.trim().toLowerCase())
          .toList();
    }

    if (params.minRating != null) {
      filtered = filtered.where((m) => m.rating >= params.minRating!).toList();
    }

    if (params.verifiedOnly) {
      filtered = filtered.where((m) => m.isVerified).toList();
    }

    switch (params.sort) {
      case MerchantSort.recommended:
        filtered.sort((a, b) {
          if (a.isFeatured != b.isFeatured) {
            return a.isFeatured ? -1 : 1;
          }
          final scoreA = a.rating * (a.ordersCount + 1);
          final scoreB = b.rating * (b.ordersCount + 1);
          return scoreB.compareTo(scoreA);
        });
        break;
      case MerchantSort.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case MerchantSort.orders:
        filtered.sort((a, b) => b.ordersCount.compareTo(a.ordersCount));
        break;
      case MerchantSort.newest:
        filtered.sort((a, b) => b.onboardedAt.compareTo(a.onboardedAt));
        break;
    }

    final states = kMockMerchants.map((m) => m.state).toSet().toList()..sort();
    final categories =
        kMockMerchants.map((m) => m.category).toSet().toList()..sort();

    return MerchantDirectoryResult(
      merchants: filtered,
      totalCount: filtered.length,
      availableStates: states,
      availableCategories: categories,
    );
  }

  @override
  Future<Merchant?> getMerchantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return kMockMerchants.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
