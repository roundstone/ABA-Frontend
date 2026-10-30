import 'package:app/core/network/api_endpoints.dart';
import 'package:app/core/network/list_query_params.dart';
import 'package:app/features/shop/data/shop_remote_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sampleReviewsEnvelope = {
    'success': true,
    'statusCode': 200,
    'message': 'Request completed successfully',
    'data': {
      'data': [
        {
          'id': 9,
          'customer_id': 42,
          'rating': 4,
          'reviewable_type': 'product',
          'reviewable_id': 93,
          'comment': 'Demo customer review for Demo Product 89',
          'customer': {
            'id': 42,
            'user_id': 46,
            'user': {
              'id': 46,
              'first_name': 'DemoCustomer9',
              'middle_name': null,
              'last_name': 'User9',
              'user_type_id': 3,
              'phone': '+2348110000009',
              'email': 'demo.customer.9@example.test',
              'username': 'demo.customer.9',
              'emailVerifiedAt': null,
              'lastLoginAt': null,
              'createdAt': '2026-10-23T08:53:05.363Z',
              'updatedAt': '2026-10-23T08:53:05.363Z',
            },
            'status': 'active',
            'referred_by_marketer_id': null,
            'createdAt': '2026-10-23T08:53:05.363Z',
            'updatedAt': '2026-10-23T08:53:05.363Z',
          },
          'createdAt': '2026-10-27T09:18:41.847Z',
          'updatedAt': '2026-10-27T09:18:41.847Z',
        },
        {
          'id': 10,
          'customer_id': 43,
          'rating': 4.5,
          'reviewable_type': 'product',
          'reviewable_id': 114,
          'comment': 'Demo customer review for Demo Product 110',
          'customer': {
            'id': 43,
            'user_id': 47,
            'user': {
              'id': 47,
              'first_name': 'DemoCustomer10',
              'middle_name': null,
              'last_name': 'User10',
              'user_type_id': 3,
              'phone': '+2348110000010',
              'email': 'demo.customer.10@example.test',
              'username': 'demo.customer.10',
              'emailVerifiedAt': null,
              'lastLoginAt': null,
              'createdAt': '2026-10-23T08:53:05.363Z',
              'updatedAt': '2026-10-23T08:53:05.363Z',
            },
            'status': 'active',
            'referred_by_marketer_id': null,
            'createdAt': '2026-10-23T08:53:05.363Z',
            'updatedAt': '2026-10-23T08:53:05.363Z',
          },
          'createdAt': '2026-10-27T09:18:41.847Z',
          'updatedAt': '2026-10-27T09:18:41.847Z',
        },
      ],
      'meta': {
        'totalItems': 160,
        'itemCount': 10,
        'itemsPerPage': 10,
        'totalPages': 16,
        'currentPage': 1,
        'currentPageUrl': '?limit=10&orderBy=createdAt%3ADESC&page=1',
        'nextPageUrl': '?limit=10&orderBy=createdAt%3ADESC&page=2',
        'previousPageUrl': null,
      },
    },
    'timestamp': '2026-10-28T10:37:06.646Z',
  };

  group('Product Reviews Endpoints (/api/v1/reviews)', () {
    test('GET /api/v1/reviews parses paginated reviews and passes query params', () async {
      final dio = Dio();
      RequestOptions? captured;

      dio.interceptors.add(InterceptorsWrapper(onRequest: (opt, handler) {
        captured = opt;
        return handler.resolve(Response(
          requestOptions: opt,
          statusCode: 200,
          data: sampleReviewsEnvelope,
        ));
      }));

      final repo = ShopRemoteRepository(dio: dio);
      final result = await repo.fetchReviews(
        params: ListQueryParams(
          page: 1,
          limit: 10,
          search: 'Demo',
          startDate: DateTime.utc(2026, 10, 1),
          endDate: DateTime.utc(2026, 10, 28),
          orderBy: 'createdAt:DESC',
        ),
      );

      expect(captured?.path, ApiEndpoints.reviews.base);
      expect(captured?.method, 'GET');
      expect(captured?.queryParameters['page'], 1);
      expect(captured?.queryParameters['limit'], 10);
      expect(captured?.queryParameters['search'], 'Demo');
      expect(captured?.queryParameters['startDate'], '2026-10-01');
      expect(captured?.queryParameters['endDate'], '2026-10-28');
      expect(captured?.queryParameters['orderBy'], 'createdAt:DESC');

      expect(result.items.length, 2);
      expect(result.meta.totalItems, 160);
      expect(result.meta.totalPages, 16);

      final first = result.items.first;
      expect(first.id, 9);
      expect(first.customerId, 42);
      expect(first.userId, 46);
      expect(first.rating, 4.0);
      expect(first.reviewableType, 'product');
      expect(first.reviewableId, 93);
      expect(first.authorName, 'DemoCustomer9 User9');
      expect(first.authorEmail, 'demo.customer.9@example.test');
      expect(result.items[1].rating, 4.5);
    });

    test('POST /api/v1/reviews sends exact request body and parses created review', () async {
      final dio = Dio();
      RequestOptions? captured;

      dio.interceptors.add(InterceptorsWrapper(onRequest: (opt, handler) {
        captured = opt;
        return handler.resolve(Response(
          requestOptions: opt,
          statusCode: 201,
          data: {
            'success': true,
            'statusCode': 201,
            'data': {
              'id': 161,
              'customer_id': 42,
              'rating': 4.5,
              'reviewable_type': 'product',
              'reviewable_id': 42,
              'comment': 'Fast delivery and exactly as described.',
              'createdAt': '2026-10-28T11:00:00.000Z',
              'updatedAt': '2026-10-28T11:00:00.000Z',
            },
          },
        ));
      }));

      final repo = ShopRemoteRepository(dio: dio);
      final created = await repo.createReview(
        const CreateReviewInput(
          reviewableType: 'product',
          reviewableId: 42,
          rating: 4.5,
          comment: 'Fast delivery and exactly as described.',
        ),
      );

      expect(captured?.path, ApiEndpoints.reviews.base);
      expect(captured?.method, 'POST');
      expect(captured?.data, {
        'reviewableType': 'product',
        'reviewableId': 42,
        'rating': 4.5,
        'comment': 'Fast delivery and exactly as described.',
      });
      expect(created.id, 161);
      expect(created.reviewableId, 42);
      expect(created.rating, 4.5);
      expect(created.comment, 'Fast delivery and exactly as described.');
    });

    test('PATCH /api/v1/reviews/{id} and DELETE /api/v1/reviews/{id} work as expected', () async {
      final dio = Dio();
      final requests = <RequestOptions>[];

      dio.interceptors.add(InterceptorsWrapper(onRequest: (opt, handler) {
        requests.add(opt);
        if (opt.method == 'PATCH') {
          return handler.resolve(Response(
            requestOptions: opt,
            statusCode: 200,
            data: {
              'success': true,
              'data': {
                'id': 9,
                'rating': 5.0,
                'reviewable_type': 'product',
                'reviewable_id': 93,
                'comment': 'Updated review comment',
              },
            },
          ));
        }
        return handler.resolve(Response(requestOptions: opt, statusCode: 200, data: {'success': true}));
      }));

      final repo = ShopRemoteRepository(dio: dio);
      final updated = await repo.updateReview(
        '9',
        const UpdateReviewInput(rating: 5.0, comment: 'Updated review comment'),
      );
      expect(updated.rating, 5.0);
      expect(updated.comment, 'Updated review comment');
      expect(requests.first.path, '/api/v1/reviews/9');
      expect(requests.first.method, 'PATCH');

      await repo.deleteReview('9');
      expect(requests.last.path, '/api/v1/reviews/9');
      expect(requests.last.method, 'DELETE');
    });
  });
}

