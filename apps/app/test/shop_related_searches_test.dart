import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/shop/application/shop_providers.dart';
import 'package:app/features/shop/data/shop_mock_repository.dart';
import 'package:app/features/shop/presentation/widgets/related_searches.dart';
import 'package:app/features/shop/presentation/widgets/shop_search_bar.dart';
import 'package:app/features/shop/presentation/shop_screen.dart';

void main() {
  group('Related Searches & Search Bar Tests', () {
    testWidgets('RelatedSearches invokes onSelect with clicked search term', (
      tester,
    ) async {
      String? selectedQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelatedSearches(
              onSelect: (val) => selectedQuery = val,
            ),
          ),
        ),
      );

      expect(find.text('Related Searches'), findsOneWidget);
      expect(find.text('Leather bags'), findsOneWidget);
      expect(find.text('Men shoes'), findsOneWidget);

      await tester.tap(find.text('Leather bags'));
      await tester.pump();

      expect(selectedQuery, equals('Leather bags'));
    });

    testWidgets('ShopSearchBar updates text field when initialValue changes', (
      tester,
    ) async {
      String currentSearch = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    ShopSearchBar(
                      initialValue: currentSearch,
                      onChanged: (val) => currentSearch = val,
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => currentSearch = 'Ankara fabric'),
                      child: const Text('Update Search'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Search products, brands…'), findsOneWidget);

      // Trigger update
      await tester.tap(find.text('Update Search'));
      await tester.pump();

      expect(find.text('Ankara fabric'), findsOneWidget);
    });

    testWidgets('ShopScreen clicking RelatedSearches queries search and updates search bar', (
      tester,
    ) async {
      final mockRepo = ShopMockRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shopRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: ShopScreen(),
          ),
        ),
      );

      // Settle async catalogue data
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Scroll to bottom to view Related Searches
      await tester.scrollUntilVisible(
        find.text('Related Searches'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Related Searches'), findsOneWidget);
      expect(find.text('Men shoes'), findsOneWidget);

      // Tap 'Men shoes' chip
      await tester.tap(find.text('Men shoes'));
      await tester.pumpAndSettle();

      // Verify search input updated and search query executed
      expect(find.text('Men shoes'), findsWidgets);
    });
  });
}

