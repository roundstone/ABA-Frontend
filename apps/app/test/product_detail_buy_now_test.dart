import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/network/api_response.dart';
import 'package:app/core/network/paginated_list_state.dart';
import 'package:app/core/widgets/app_button.dart';
import 'package:app/features/shop/application/shop_providers.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:app/features/shop/presentation/product_detail_screen.dart';
import 'package:app/features/wishlist/application/wishlist_providers.dart';

class _FakeReviewsNotifier
    extends StateNotifier<PaginatedListState<ProductReview>>
    implements PaginatedReviewsNotifier {
  _FakeReviewsNotifier()
      : super(const PaginatedListState<ProductReview>(
          isLoading: false,
          items: [],
          hasMore: false,
        ));

  @override
  int? get productId => 42;

  @override
  Future<void> fetchFirstPage() async {}

  @override
  Future<void> loadMore() async {}
}

void main() {
  const testProduct = Product(
    id: '42',
    name: 'Aba Craft Leather Oxford',
    slug: 'aba-craft-leather-oxford',
    price: 35000,
    category: 'Footwear',
    brand: 'Aba Craftsman',
    rating: 4.8,
    reviewCount: 22,
    stock: 5,
    colors: ['Black', 'Brown'],
    sizes: ['42', '43'],
    images: ['https://example.com/shoe.jpg'],
  );

  testWidgets('ProductDetailScreen renders AppButton for Buy It Now and Watchlist', (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Cart? directCartNavigated;

    final router = GoRouter(
      initialLocation: '/product/42',
      routes: [
        GoRoute(
          path: '/product/:id',
          builder: (_, __) => const ProductDetailScreen(
            id: '42',
            productId: '42',
          ),
        ),
        GoRoute(
          path: '/checkout',
          builder: (_, state) {
            directCartNavigated = state.extra is Cart ? state.extra as Cart : null;
            return const Scaffold(body: Text('Checkout Screen'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productDetailProvider('42').overrideWith((ref) => Future.value(testProduct)),
          productReviewsProvider(42).overrideWith(
            (ref) => Future.value(
              PaginatedData<ProductReview>(
                items: const [],
                meta: PaginationMeta.empty(),
              ),
            ),
          ),
          shopCatalogueProvider.overrideWith(
            (ref) => Future.value(
              const ShopCatalogue(
                products: [],
                categories: [],
                featuredBannerUrl: '',
              ),
            ),
          ),
          paginatedReviewsNotifierProvider(42).overrideWith(
            (ref) => _FakeReviewsNotifier(),
          ),
          isProductInWishlistProvider('42').overrideWith((ref) => false),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify AppButtons exist
    final buyNowButton = find.widgetWithText(AppButton, 'Buy It Now');
    final watchlistButton = find.widgetWithText(AppButton, 'Add to Watchlist');

    expect(buyNowButton, findsOneWidget);
    expect(watchlistButton, findsOneWidget);

    await tester.ensureVisible(buyNowButton);
    await tester.pumpAndSettle();

    // Tap "Buy It Now"
    await tester.tap(buyNowButton);
    await tester.pumpAndSettle();

    // Verify it navigated directly to /checkout with directCart populated
    expect(find.text('Checkout Screen'), findsOneWidget);
    expect(directCartNavigated, isNotNull);
    expect(directCartNavigated!.items.length, 1);
    expect(directCartNavigated!.items.first.product.id, '42');
    expect(directCartNavigated!.items.first.quantity, 1);
  });
}
