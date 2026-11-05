import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/kyc_models.dart';
import 'kyc_service.dart';

extension KycDocumentsAndPayments on KycService {
  /// POST: /api/v1/kyc/activation-submission [multipart/form-data]
  Future<KycProfile> submitActivationDocuments({
    required int identityDocumentType,
    required String identityNumber,
    required List<KycUploadDocument> documents,
  }) async {
    if (AppConfig.isMockMode) {
      return KycProfile(
        id: 608,
        userId: 10,
        status: 1,
        documents: [
          KycDocument(
            id: 104,
            kycProfileId: 608,
            documentType: identityDocumentType,
            mediaId: 169,
            documentReference: identityNumber,
            originalName: documents.firstOrNull?.fileName,
          ),
          if (documents.length > 1)
            KycDocument(
              id: 105,
              kycProfileId: 608,
              documentType: 4,
              mediaId: 170,
              originalName: documents[1].fileName,
            ),
        ],
      );
    }

    try {
      final endpoint = ApiEndpoints.kyc.activationSubmission;
      final multipartFiles = <MultipartFile>[];
      for (final doc in documents) {
        if (doc.filePath != null && doc.filePath!.isNotEmpty) {
          multipartFiles.add(
            await MultipartFile.fromFile(
              doc.filePath!,
              filename: doc.fileName,
            ),
          );
        } else {
          multipartFiles.add(
            MultipartFile.fromBytes(
              doc.bytes ?? KycService.defaultDocumentPngBytes,
              filename: doc.fileName,
            ),
          );
        }
      }

      final formData = FormData.fromMap({
        'identityDocumentType': identityDocumentType,
        'identityNumber': identityNumber,
        'documents': multipartFiles,
      });

      AppLogger.d(
        'POST $endpoint [multipart/form-data] (identityDocumentType: $identityDocumentType, identityNumber: $identityNumber, files: ${documents.length})',
      );
      final response = await dio.post(endpoint, data: formData);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return KycProfile.fromJson(body);
      }
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Unexpected response submitting KYC activation documents.',
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to submit KYC activation documents', error: e);
      throw ApiError.fromDio(e);
    }
  }

  /// GET: /api/v1/kyc/mobile-app/documents
  Future<List<KycDocument>> getDocuments() async {
    if (AppConfig.isMockMode) {
      return const [
        KycDocument(
          id: 104,
          kycProfileId: 608,
          documentType: 1,
          mediaId: 169,
          documentReference: '12345678901',
          originalName: 'nin_slip_verified.png',
        ),
        KycDocument(
          id: 105,
          kycProfileId: 608,
          documentType: 4,
          mediaId: 170,
          originalName: 'utility_bill.png',
        ),
      ];
    }

    try {
      final endpoint = ApiEndpoints.kyc.documents;
      AppLogger.d('GET $endpoint');
      final response = await dio.get(endpoint);
      final body = response.data;
      final rawData = body is Map ? body['data'] : body;
      final list = rawData is List ? rawData : const [];
      return list
          .whereType<Map>()
          .map((d) => KycDocument.fromJson(Map<String, dynamic>.from(d)))
          .toList();
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch KYC documents', error: e);
      throw ApiError.fromDio(e);
    }
  }

  /// POST: /api/v1/payments/kyc-activation/paystack/initialize
  Future<KycPaymentInitResult> initializeKycActivationPayment() async {
    if (AppConfig.isMockMode) {
      return const KycPaymentInitResult(
        reference: 'KYC-ce6db04d5f2d482b9044feffef0ad650',
        email: 'c-davidenabs@gmail.com',
        amountInKobo: 500000,
        publicKey: 'pk_test_a3c52ce327f5f3e830c62d7d2209ca361833dbb9',
        paymentId: 1820,
        status: 'pending',
      );
    }

    try {
      final endpoint = ApiEndpoints.payments.kycActivationPaystackInitialize;
      AppLogger.d('POST $endpoint');
      final response = await dio.post(endpoint);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return KycPaymentInitResult.fromJson(body);
      }
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Unexpected response initializing KYC activation payment.',
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to initialize KYC activation payment', error: e);
      throw ApiError.fromDio(e);
    }
  }

  /// Verify Paystack payment if needed via /api/v1/payments/mobile-app/paystack/{reference}/verify
  Future<bool> verifyKycActivationPayment(String reference) async {
    if (AppConfig.isMockMode) return true;

    try {
      final endpoint = ApiEndpoints.payments.paystackVerify(reference);
      AppLogger.d('GET $endpoint');
      final response = await dio.get(endpoint);
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      AppLogger.w('Verify KYC activation payment notice: ${e.message}');
      return true;
    }
  }
}

