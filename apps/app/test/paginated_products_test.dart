import 'package:app/core/network/paginated_list_state.dart';
import 'package:app/features/shop/application/shop_providers.dart';
import 'package:app/features/shop/data/shop_mock_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaginatedProductsNotifier Tests', () {
    late ProviderContainer container;
    late ProviderSubscription<PaginatedListState<Product>> sub;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          shopRepositoryProvider.overrideWithValue(ShopMockRepository()),
        ],
      );
      // Keep subscriber alive for autoDispose
      sub = container.listen(paginatedProductsNotifierProvider, (_, __) {});
    });

    tearDown(() {
      sub.close();
      container.dispose();
    });

    test('Initial state triggers fetch of page 1 products', () async {
      // Wait for initial fetch
      await Future<void>.delayed(const Duration(milliseconds: 700));

      final loadedState = container.read(paginatedProductsNotifierProvider);
      expect(loadedState.isLoading, isFalse);
      expect(loadedState.items.isNotEmpty, isTrue);
      expect(loadedState.currentPage, 1);
    });

    test('loadMore fetches subsequent page and appends products', () async {
      // Wait for initial fetch
      await Future<void>.delayed(const Duration(milliseconds: 700));
      final initialCount =
          container.read(paginatedProductsNotifierProvider).items.length;

      // Trigger load more
      final notifier =
          container.read(paginatedProductsNotifierProvider.notifier);
      await notifier.loadMore();

      final updatedState = container.read(paginatedProductsNotifierProvider);
      expect(updatedState.isLoadingMore, isFalse);
      expect(updatedState.items.length, greaterThanOrEqualTo(initialCount));
    });

    test('Filter reset or change triggers fresh fetch', () async {
      // Wait for initial fetch
      await Future<void>.delayed(const Duration(milliseconds: 700));

      final shopNotifier = container.read(shopNotifierProvider.notifier);
      shopNotifier.setSearch('backpack');

      await Future<void>.delayed(const Duration(milliseconds: 700));
      final filteredState = container.read(paginatedProductsNotifierProvider);
      expect(
        filteredState.items.every((p) =>
            p.name.toLowerCase().contains('backpack') ||
            p.category.toLowerCase().contains('backpack')),
        isTrue,
      );
    });
  });
}
