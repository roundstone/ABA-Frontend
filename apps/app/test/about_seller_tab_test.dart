import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/network/paginated_list_state.dart';
import 'package:app/core/widgets/app_button.dart';
import 'package:app/features/shop/application/paginated_reviews_notifier.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:app/features/shop/presentation/widgets/about_seller_tab.dart';

class _MockReviewsNotifier
    extends StateNotifier<PaginatedListState<ProductReview>>
    implements PaginatedReviewsNotifier {
  _MockReviewsNotifier()
      : super(const PaginatedListState<ProductReview>(
          isLoading: false,
          items: [],
          hasMore: false,
        ));

  @override
  int? get productId => 12;

  @override
  Future<void> fetchFirstPage() async {}

  @override
  Future<void> loadMore() async {}
}

void main() {
  testWidgets('AboutSellerTab renders AppButtons and routes Visit Store to merchant detail', (tester) async {
    String? navigatedRoute;

    final router = GoRouter(
      initialLocation: '/test',
      routes: [
        GoRoute(
          path: '/test',
          builder: (_, __) => const Scaffold(
            body: SingleChildScrollView(
              child: AboutSellerTab(
                merchantName: 'Aba Craftsman',
                merchantId: '99',
                productId: '12',
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/merchants/:id',
          builder: (_, state) {
            navigatedRoute = state.matchedLocation;
            return Scaffold(body: Text('Merchant Detail ${state.pathParameters['id']}'));
          },
        ),
        GoRoute(
          path: '/referrals',
          builder: (_, __) => const Scaffold(body: Text('Referrals Page')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paginatedReviewsNotifierProvider(12).overrideWith(
            (ref) => _MockReviewsNotifier(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify AppButtons exist
    final visitStoreBtn = find.widgetWithText(AppButton, 'Visit store');
    final messageSellerBtn = find.widgetWithText(AppButton, 'Message seller');
    final joinNetworkBtn = find.widgetWithText(AppButton, 'Join their network');

    expect(visitStoreBtn, findsOneWidget);
    expect(messageSellerBtn, findsOneWidget);
    expect(joinNetworkBtn, findsOneWidget);

    // Tap "Visit store"
    await tester.tap(visitStoreBtn);
    await tester.pumpAndSettle();

    expect(find.text('Merchant Detail 99'), findsOneWidget);
    expect(navigatedRoute, '/merchants/99');
  });

  testWidgets('AboutSellerTab routes to /merchants with merchantName when merchantId is null', (tester) async {
    String? matchedParam;

    final router = GoRouter(
      initialLocation: '/test',
      routes: [
        GoRoute(
          path: '/test',
          builder: (_, __) => const Scaffold(
            body: SingleChildScrollView(
              child: AboutSellerTab(
                merchantName: 'KanoCrafts',
                productId: '12',
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/merchants/:id',
          builder: (_, state) {
            matchedParam = state.pathParameters['id'];
            return Scaffold(body: Text('Merchant Detail ${state.pathParameters['id']}'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paginatedReviewsNotifierProvider(12).overrideWith(
            (ref) => _MockReviewsNotifier(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final visitStoreBtn = find.widgetWithText(AppButton, 'Visit store');
    await tester.tap(visitStoreBtn);
    await tester.pumpAndSettle();

    expect(matchedParam, 'KanoCrafts');
  });
}
