import 'package:app/features/shop/application/shop_providers.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:app/features/shop/domain/shop_repository.dart';
import 'package:app/features/shop/presentation/widgets/review_form_sheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeShopRepo implements ShopRepository {
  bool shouldThrow403 = false;
  bool wasCreateCalled = false;
  bool wasUpdateCalled = false;

  @override
  Future<ProductReview> createReview(CreateReviewInput input) async {
    wasCreateCalled = true;
    if (shouldThrow403) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v1/reviews'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/reviews'),
          statusCode: 403,
          data: {
            'success': false,
            'statusCode': 403,
            'message': 'You can review only products you have ordered',
          },
        ),
      );
    }
    return ProductReview(
      id: 99,
      reviewableType: input.reviewableType,
      reviewableId: input.reviewableId,
      rating: input.rating,
      comment: input.comment,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<ProductReview> updateReview(String id, UpdateReviewInput input) async {
    wasUpdateCalled = true;
    return ProductReview(
      id: int.parse(id),
      reviewableType: 'product',
      reviewableId: 10,
      rating: input.rating ?? 5.0,
      comment: input.comment ?? '',
      createdAt: DateTime.now(),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ReviewFormSheet Tests', () {
    testWidgets('shows validation error when comment is empty', (tester) async {
      final fakeRepo = _FakeShopRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shopRepositoryProvider.overrideWithValue(fakeRepo),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ReviewFormSheet(reviewableId: 10),
            ),
          ),
        ),
      );

      // Tap submit with empty text
      await tester.tap(find.text('Submit Review'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your review comments.'), findsOneWidget);
      expect(fakeRepo.wasCreateCalled, isFalse);
    });

    testWidgets('shows backend 403 error message when user has not ordered product', (tester) async {
      final fakeRepo = _FakeShopRepo()..shouldThrow403 = true;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shopRepositoryProvider.overrideWithValue(fakeRepo),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ReviewFormSheet(reviewableId: 10),
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Great product, highly recommended!',
      );
      await tester.tap(find.text('Submit Review'));
      await tester.pumpAndSettle();

      expect(fakeRepo.wasCreateCalled, isTrue);
      expect(
        find.text('You can review only products you have ordered'),
        findsWidgets,
      );
    });

    testWidgets('pre-populates existing review and calls updateReview', (tester) async {
      final fakeRepo = _FakeShopRepo();
      final existingReview = ProductReview(
        id: 7,
        reviewableType: 'product',
        reviewableId: 10,
        rating: 4.0,
        comment: 'Existing initial review',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shopRepositoryProvider.overrideWithValue(fakeRepo),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ReviewFormSheet(
                reviewableId: 10,
                existing: existingReview,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Edit Review'), findsOneWidget);
      expect(find.text('Update Review'), findsOneWidget);
      expect(find.text('Existing initial review'), findsOneWidget);

      await tester.tap(find.text('Update Review'));
      await tester.pumpAndSettle();

      expect(fakeRepo.wasUpdateCalled, isTrue);
    });
  });
}
