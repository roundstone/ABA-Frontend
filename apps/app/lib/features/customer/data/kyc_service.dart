import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/kyc_models.dart';
export 'kyc_documents_payment_ext.dart';

class KycUploadDocument {
  const KycUploadDocument({
    required this.fileName,
    this.filePath,
    this.bytes,
    this.mimeType = 'image/png',
  });

  final String fileName;
  final String? filePath;
  final Uint8List? bytes;
  final String mimeType;
}

class KycService {
  KycService({required this.dio});

  final Dio dio;

  /// Minimal valid 1x1 PNG image bytes used as fallback when no local file path is provided.
  static final Uint8List defaultDocumentPngBytes = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);

  /// GET: /api/v1/kyc/mobile-app/profile
  Future<KycProfile> getProfile() async {
    if (AppConfig.isMockMode) {
      return const KycProfile(
        id: 608,
        userId: 10,
        dateOfBirth: '1990-04-28',
        nationality: 'Nigerian',
        residentialAddress: '14 Admiralty Way',
        city: 'Lekki',
        state: 'Lagos',
        lga: 'Eti Osa',
        status: 1,
      );
    }

    try {
      final endpoint = ApiEndpoints.kyc.profile;
      AppLogger.d('GET $endpoint');
      final response = await dio.get(endpoint);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return KycProfile.fromJson(body);
      }
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Unexpected KYC profile response.',
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch KYC profile', error: e);
      throw ApiError.fromDio(e);
    }
  }

  /// PUT: /api/v1/kyc/mobile-app/profile
  Future<KycProfile> updateProfile({
    required String dateOfBirth,
    required String nationality,
    required String residentialAddress,
    required String city,
    required String state,
    required String lga,
  }) async {
    if (AppConfig.isMockMode) {
      return KycProfile(
        id: 608,
        userId: 10,
        dateOfBirth: dateOfBirth,
        nationality: nationality,
        residentialAddress: residentialAddress,
        city: city,
        state: state,
        lga: lga,
        status: 1,
      );
    }

    try {
      final endpoint = ApiEndpoints.kyc.profile;
      final payload = {
        'dateOfBirth': dateOfBirth,
        'nationality': nationality,
        'residentialAddress': residentialAddress,
        'city': city,
        'state': state,
        'lga': lga,
      };
      AppLogger.d('PUT $endpoint with $payload');
      final response = await dio.put(endpoint, data: payload);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return KycProfile.fromJson(body);
      }
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Unexpected response updating KYC profile.',
      );
    } on DioException catch (e) {
      AppLogger.w(
        'KYC profile update notice (${e.response?.statusCode}): ${e.response?.data ?? e.message}',
      );
      throw ApiError.fromDio(e);
    }
  }

  /// POST: /api/v1/kyc/mobile-app/profile/submit (if they haven't submitted before)
  Future<KycProfile?> submitProfileIfNotSubmitted() async {
    if (AppConfig.isMockMode) {
      return KycProfile(
        id: 608,
        userId: 10,
        status: 2,
        submittedAt: DateTime.now(),
      );
    }

    final endpoint = ApiEndpoints.kyc.submitProfile;
    try {
      AppLogger.d('POST $endpoint');
      final response = await dio.post(endpoint);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return KycProfile.fromJson(body);
      }
      return null;
    } on DioException catch (e) {
      final msg = e.response?.data?.toString().toLowerCase() ?? '';
      if (e.response?.statusCode == 400 ||
          e.response?.statusCode == 409 ||
          msg.contains('already') ||
          msg.contains('submitted')) {
        AppLogger.w('KYC profile already submitted; continuing.');
        return null;
      }
      AppLogger.e('Failed to submit KYC profile', error: e);
      throw ApiError.fromDio(e);
    }
  }
}

final kycServiceProvider = Provider<KycService>((ref) {
  return KycService(dio: ref.watch(dioProvider));
});
