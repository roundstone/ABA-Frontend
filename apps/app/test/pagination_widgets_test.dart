import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/widgets/infinite_scroll_listener.dart';
import 'package:app/core/widgets/paginated_list_view.dart';
import 'package:app/core/network/paginated_list_state.dart';

void main() {
  group('PaginatedListState Tests', () {
    test('initial state defaults are correct', () {
      const state = PaginatedListState<String>();
      expect(state.items, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.isLoadingMore, isFalse);
      expect(state.hasMore, isTrue);
      expect(state.error, isNull);
      expect(state.isEmpty, isTrue);
      expect(state.currentPage, equals(1));
    });

    test('toLoading and withRefreshedItems transition correctly', () {
      const state = PaginatedListState<String>();
      final loading = state.toLoading();
      expect(loading.isLoading, isTrue);
      expect(loading.error, isNull);

      final refreshed = loading.withRefreshedItems(
        newItems: ['item1', 'item2'],
        defaultLimit: 2,
      );
      expect(refreshed.isLoading, isFalse);
      expect(refreshed.items, equals(['item1', 'item2']));
      expect(refreshed.hasMore, isTrue); // 2 items >= limit 2
    });

    test('toLoadingMore and withAppendedItems paginate correctly', () {
      final initial = const PaginatedListState<String>().withRefreshedItems(
        newItems: ['item1', 'item2'],
        defaultLimit: 2,
      );

      final loadingMore = initial.toLoadingMore();
      expect(loadingMore.isLoadingMore, isTrue);

      final appended = loadingMore.withAppendedItems(
        newItems: ['item3'],
        defaultLimit: 2,
      );
      expect(appended.items, equals(['item1', 'item2', 'item3']));
      expect(appended.isLoadingMore, isFalse);
      expect(appended.hasMore, isFalse); // 1 item < limit 2
      expect(appended.params.page, equals(2));
    });

    test('withError resets loading flags and captures error', () {
      final state = const PaginatedListState<String>().toLoading();
      final errState = state.withError('Network connection failed');
      expect(errState.isLoading, isFalse);
      expect(errState.isLoadingMore, isFalse);
      expect(errState.error, equals('Network connection failed'));
    });
  });

  group('InfiniteScrollListener Widget Tests', () {
    testWidgets('triggers onLoadMore before reaching bottom when scrolling down', (tester) async {
      int loadMoreCalls = 0;
      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: InfiniteScrollListener(
                prefetchDistance: 300,
                onLoadMore: () {
                  loadMoreCalls++;
                },
                child: ListView.builder(
                  controller: controller,
                  itemCount: 40,
                  itemExtent: 50, // total scroll extent: 2000px, viewport: 400px
                  itemBuilder: (_, i) => Text('Item $i'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(loadMoreCalls, equals(0));

      // Scroll down by 1400px (extentAfter will be 2000 - 400 - 1400 = 200px <= 300px threshold)
      await tester.drag(find.byType(ListView), const Offset(0, -1400));
      await tester.pumpAndSettle();

      expect(loadMoreCalls, greaterThanOrEqualTo(1));
    });

    testWidgets('does not trigger onLoadMore when hasMore is false', (tester) async {
      int loadMoreCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: InfiniteScrollListener(
                hasMore: false,
                prefetchDistance: 300,
                onLoadMore: () {
                  loadMoreCalls++;
                },
                child: ListView.builder(
                  itemCount: 40,
                  itemExtent: 50,
                  itemBuilder: (_, i) => Text('Item $i'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -1400));
      await tester.pumpAndSettle();

      expect(loadMoreCalls, equals(0));
    });

    testWidgets('does not trigger onLoadMore when isLoadingMore is true', (tester) async {
      int loadMoreCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: InfiniteScrollListener(
                isLoadingMore: true,
                prefetchDistance: 300,
                onLoadMore: () {
                  loadMoreCalls++;
                },
                child: ListView.builder(
                  itemCount: 40,
                  itemExtent: 50,
                  itemBuilder: (_, i) => Text('Item $i'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -1400));
      await tester.pumpAndSettle();

      expect(loadMoreCalls, equals(0));
    });
  });

  group('PaginatedListView Widget Tests', () {
    testWidgets('shows loading widget when isLoading and empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: const [],
              isLoading: true,
              onLoadMore: () {},
              itemBuilder: (_, item, __) => Text(item),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty widget when empty and not loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatedListView<String>(
              items: const [],
              isLoading: false,
              onLoadMore: () {},
              emptyWidget: const Text('Nothing found'),
              itemBuilder: (_, item, __) => Text(item),
            ),
          ),
        ),
      );

      expect(find.text('Nothing found'), findsOneWidget);
    });

    testWidgets('renders list items, header, footer and triggers prefetch onLoadMore', (tester) async {
      int loadMoreCount = 0;
      final items = List.generate(30, (i) => 'Item $i');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: PaginatedListView<String>(
                items: items,
                isLoading: false,
                prefetchDistance: 250,
                header: const Text('Header Widget'),
                footer: const Text('Footer Widget'),
                onLoadMore: () {
                  loadMoreCount++;
                },
                itemBuilder: (_, item, __) => SizedBox(height: 50, child: Text(item)),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Header Widget'), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);

      // Scroll towards bottom
      await tester.drag(find.byType(ListView), const Offset(0, -1200));
      await tester.pumpAndSettle();

      expect(loadMoreCount, greaterThanOrEqualTo(1));
    });
  });
}
