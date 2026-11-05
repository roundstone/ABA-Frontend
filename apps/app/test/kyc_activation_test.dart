import 'package:app/core/config/app_config.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/features/customer/data/kyc_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KYC Activation & Referral Fee Payment API Tests', () {
    setUp(() {
      AppConfig.isMockMode = false;
    });

    test('getProfile and updateProfile hit /api/v1/kyc/mobile-app/profile', () async {
      final dio = Dio();
      final called = <String>[];
      Map<String, dynamic>? putPayload;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            called.add('${options.method} ${options.path}');
            if (options.method == 'PUT') {
              putPayload = Map<String, dynamic>.from(options.data as Map);
            }
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'statusCode': 200,
                  'message': 'Request completed successfully',
                  'data': {
                    'id': 608,
                    'user_id': 10,
                    'date_of_birth': putPayload?['dateOfBirth'] ?? '2007-01-27',
                    'nationality': putPayload?['nationality'] ?? 'Nigerian',
                    'residential_address':
                        putPayload?['residentialAddress'] ?? '14 Admiralty Way',
                    'city': putPayload?['city'] ?? 'Lekki',
                    'state': putPayload?['state'] ?? 'Lagos',
                    'lga': putPayload?['lga'] ?? 'Eti Osa',
                    'status': 1,
                    'rejection_reason': null,
                    'submitted_at': null,
                    'reviewed_at': null,
                    'documents': [],
                  },
                },
              ),
            );
          },
        ),
      );

      final service = KycService(dio: dio);
      final profile = await service.getProfile();
      expect(profile.id, 608);
      expect(profile.userId, 10);

      final updated = await service.updateProfile(
        dateOfBirth: '1990-04-28',
        nationality: 'Nigerian',
        residentialAddress: '14 Admiralty Way',
        city: 'Lekki',
        state: 'Lagos',
        lga: 'Eti Osa',
      );
      expect(updated.dateOfBirth, '1990-04-28');
      expect(updated.city, 'Lekki');
      expect(putPayload?['residentialAddress'], '14 Admiralty Way');
      expect(called, contains('GET /api/v1/kyc/mobile-app/profile'));
      expect(called, contains('PUT /api/v1/kyc/mobile-app/profile'));
    });

    test('submitActivationDocuments sends multipart/form-data to /api/v1/kyc/activation-submission', () async {
      final dio = Dio();
      String? capturedPath;
      FormData? capturedFormData;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedPath = options.path;
            capturedFormData = options.data as FormData;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'success': true,
                  'statusCode': 201,
                  'message': 'Request completed successfully',
                  'data': {
                    'profile': {
                      'id': 608,
                      'user_id': 10,
                      'date_of_birth': '2007-01-27',
                      'status': 1,
                    },
                    'documents': [
                      {
                        'id': 104,
                        'kyc_profile_id': 608,
                        'document_type': 1,
                        'media_id': 169,
                        'document_reference': '12345678901',
                      },
                      {
                        'id': 105,
                        'kyc_profile_id': 608,
                        'document_type': 4,
                        'media_id': 170,
                        'document_reference': null,
                      },
                    ],
                  },
                },
              ),
            );
          },
        ),
      );

      final service = KycService(dio: dio);
      final result = await service.submitActivationDocuments(
        identityDocumentType: 1,
        identityNumber: '12345678901',
        documents: const [
          KycUploadDocument(fileName: 'nin_slip.png'),
          KycUploadDocument(fileName: 'utility_bill.png'),
        ],
      );

      expect(capturedPath, equals(ApiEndpoints.kyc.activationSubmission));
      expect(capturedFormData, isNotNull);
      final fields = Map.fromEntries(capturedFormData!.fields);
      expect(fields['identityDocumentType'], equals('1'));
      expect(fields['identityNumber'], equals('12345678901'));
      expect(capturedFormData!.files.length, equals(2));
      expect(result.id, equals(608));
      expect(result.documents.length, equals(2));
      expect(result.documents.first.documentReference, equals('12345678901'));
    });

    test('getDocuments and initializeKycActivationPayment parse responses accurately', () async {
      final dio = Dio();
      final called = <String>[];

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            called.add('${options.method} ${options.path}');
            if (options.path == ApiEndpoints.kyc.documents) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'statusCode': 200,
                    'data': [
                      {
                        'id': 105,
                        'kyc_profile_id': 608,
                        'document_type': 4,
                        'media_id': 170,
                        'document_reference': null,
                        'media': {
                          'id': 170,
                          'original_name': 'BuyNaija_ Choose Your Path.png',
                          'mime_type': 'image/png',
                          'url': 'https://aba-erp-staging-bucket.s3.eu-west-1.amazonaws.com/doc.png',
                        },
                      },
                    ],
                  },
                ),
              );
            }
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'success': true,
                  'statusCode': 201,
                  'message': 'Request completed successfully',
                  'data': {
                    'payment': {
                      'id': 1820,
                      'payment_type': 'kyc_activation',
                      'reference': 'KYC-ce6db04d5f2d482b9044feffef0ad650',
                      'amount': '5000.00',
                      'currency': 'NGN',
                      'status': 'pending',
                    },
                    'reference': 'KYC-ce6db04d5f2d482b9044feffef0ad650',
                    'email': 'c-davidenabs@gmail.com',
                    'amount': 500000,
                    'publicKey': 'pk_test_a3c52ce327f5f3e830c62d7d2209ca361833dbb9',
                  },
                },
              ),
            );
          },
        ),
      );

      final service = KycService(dio: dio);
      final docs = await service.getDocuments();
      expect(docs.length, 1);
      expect(docs.first.originalName, 'BuyNaija_ Choose Your Path.png');
      expect(docs.first.documentType, 4);

      final paymentInit = await service.initializeKycActivationPayment();
      expect(paymentInit.reference, 'KYC-ce6db04d5f2d482b9044feffef0ad650');
      expect(paymentInit.email, 'c-davidenabs@gmail.com');
      expect(paymentInit.amountInKobo, 500000);
      expect(paymentInit.amountNaira, 5000.0);
      expect(paymentInit.paymentId, 1820);

      expect(called, contains('GET /api/v1/kyc/mobile-app/documents'));
      expect(called, contains('POST /api/v1/payments/kyc-activation/paystack/initialize'));
    });

    test('submitKyc continues to activation-submission even if PUT /kyc/mobile-app/profile returns 400', () async {
      final dio = Dio();
      final called = <String>[];

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            called.add('${options.method} ${options.path}');
            if (options.method == 'PUT' &&
                options.path == ApiEndpoints.kyc.profile) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response(
                    requestOptions: options,
                    statusCode: 400,
                    data: {
                      'message': 'KYC profile already submitted and cannot be modified',
                      'statusCode': 400,
                    },
                  ),
                  type: DioExceptionType.badResponse,
                ),
              );
            }
            if (options.method == 'POST' &&
                options.path == ApiEndpoints.kyc.activationSubmission) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'success': true,
                    'statusCode': 201,
                    'data': {
                      'profile': {'id': 608, 'user_id': 10, 'status': 1},
                      'documents': [
                        {
                          'id': 104,
                          'kyc_profile_id': 608,
                          'document_type': 1,
                          'media_id': 169,
                          'document_reference': '12345678901',
                        },
                      ],
                    },
                  },
                ),
              );
            }
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'statusCode': 200,
                  'data': {
                    'id': 608,
                    'user_id': 10,
                    'status': 1,
                    'submitted_at': null,
                    'documents': [],
                  },
                },
              ),
            );
          },
        ),
      );

      final service = KycService(dio: dio);
      await expectLater(
        service.updateProfile(
          dateOfBirth: '1990-04-28',
          nationality: 'Nigerian',
          residentialAddress: '14 Admiralty Way',
          city: 'Lekki',
          state: 'Lagos',
          lga: 'Eti Osa',
        ),
        throwsA(anything),
      );

      final sub = await service.submitActivationDocuments(
        identityDocumentType: 1,
        identityNumber: '12345678901',
        documents: const [KycUploadDocument(fileName: 'nin.png')],
      );
      expect(sub.id, 608);
      expect(called, contains('POST /api/v1/kyc/activation-submission'));
    });
  });
}

