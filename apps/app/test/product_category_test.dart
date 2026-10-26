import 'package:app/core/network/api_endpoints.dart';
import 'package:app/core/network/list_query_params.dart';
import 'package:app/features/shop/data/shop_remote_repository.dart';
import 'package:app/features/shop/domain/shop_category.dart';
import 'package:app/features/shop/presentation/widgets/category_chip_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShopCategory Model Tests', () {
    test('fromJson parses backend category schema accurately', () {
      final json = {
        'id': 12,
        'name': 'Demo Category 8',
        'slug': 'demo-category-8',
        'description': 'Demo catalogue category 8',
        'is_active': true,
        'createdAt': '2026-10-23T08:53:05.363Z',
        'updatedAt': '2026-10-23T08:53:05.363Z',
        'deletedAt': null,
      };

      final cat = ShopCategory.fromJson(json);

      expect(cat.id, '12');
      expect(cat.name, 'Demo Category 8');
      expect(cat.slug, 'demo-category-8');
      expect(cat.description, 'Demo catalogue category 8');
      expect(cat.isActive, true);
      expect(cat.createdAt, DateTime.parse('2026-10-23T08:53:05.363Z'));
      expect(cat.updatedAt, DateTime.parse('2026-10-23T08:53:05.363Z'));
      expect(cat.deletedAt, isNull);
    });

    test('toJson serializes ShopCategory correctly', () {
      const cat = ShopCategory(
        id: '5',
        name: 'Demo Category 1',
        slug: 'demo-category-1',
        description: 'Demo description',
        isActive: true,
      );

      final json = cat.toJson();

      expect(json['id'], '5');
      expect(json['name'], 'Demo Category 1');
      expect(json['slug'], 'demo-category-1');
      expect(json['description'], 'Demo description');
      expect(json['is_active'], true);
    });
  });

  group('ShopRemoteRepository fetchCategories Tests', () {
    test('fetches categories from backend and maps paginated response', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, ApiEndpoints.productCategories.base);
            expect(options.queryParameters['page'], 1);
            expect(options.queryParameters['limit'], 10);
            expect(options.queryParameters['orderBy'], 'createdAt:DESC');
            expect(options.queryParameters['isActive'], true);

            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'statusCode': 200,
                  'message': 'Request completed successfully',
                  'data': {
                    'data': [
                      {
                        'id': 12,
                        'name': 'Demo Category 8',
                        'slug': 'demo-category-8',
                        'description': 'Demo catalogue category 8',
                        'is_active': true,
                        'createdAt': '2026-10-23T08:53:05.363Z',
                        'updatedAt': '2026-10-23T08:53:05.363Z',
                        'deletedAt': null,
                      },
                      {
                        'id': 5,
                        'name': 'Demo Category 1',
                        'slug': 'demo-category-1',
                        'description': 'Demo catalogue category 1',
                        'is_active': true,
                        'createdAt': '2026-10-23T08:53:05.363Z',
                        'updatedAt': '2026-10-23T08:53:05.363Z',
                        'deletedAt': null,
                      },
                    ],
                    'meta': {
                      'totalItems': 2,
                      'itemCount': 2,
                      'itemsPerPage': 10,
                      'totalPages': 1,
                      'currentPage': 1,
                    },
                  },
                },
              ),
            );
          },
        ),
      );

      final repo = ShopRemoteRepository(dio: dio);
      final categories = await repo.fetchCategories(
        params: const ListQueryParams(
          page: 1,
          limit: 10,
          orderBy: 'createdAt:DESC',
          isActive: true,
        ),
      );

      expect(categories.length, 2);
      expect(categories[0].id, '12');
      expect(categories[0].name, 'Demo Category 8');
      expect(categories[1].id, '5');
      expect(categories[1].name, 'Demo Category 1');
    });
  });

  group('CategoryChipBar Widget Tests', () {
    final sampleCategories = [
      const ShopCategory(
        id: '12',
        name: 'Demo Category 8',
        slug: 'demo-category-8',
      ),
      const ShopCategory(
        id: '5',
        name: 'Demo Category 1',
        slug: 'demo-category-1',
      ),
    ];

    testWidgets('renders All chip and category chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChipBar(
              categories: sampleCategories,
              selected: null,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Demo Category 8'), findsOneWidget);
      expect(find.text('Demo Category 1'), findsOneWidget);
    });

    testWidgets('calls onSelect with category name when tapped', (tester) async {
      String? selectedCat = 'initial';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChipBar(
              categories: sampleCategories,
              selected: null,
              onSelect: (cat) => selectedCat = cat,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Demo Category 8'));
      expect(selectedCat, 'Demo Category 8');
    });

    testWidgets('calls onSelect(null) when All chip is tapped', (tester) async {
      String? selectedCat = 'Demo Category 8';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChipBar(
              categories: sampleCategories,
              selected: 'Demo Category 8',
              onSelect: (cat) => selectedCat = cat,
            ),
          ),
        ),
      );

      await tester.tap(find.text('All'));
      expect(selectedCat, isNull);
    });

    testWidgets('renders skeleton bars when loading with empty categories',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChipBar(
              categories: const [],
              selected: null,
              isLoading: true,
              onSelect: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsNothing);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
