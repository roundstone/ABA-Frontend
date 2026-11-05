import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../data/kyc_service.dart';
import '../domain/kyc_models.dart';
import '../domain/referral_activation_model.dart';

class ReferralActivationNotifier
    extends StateNotifier<ReferralActivationState> {
  ReferralActivationNotifier(this._ref)
      : super(
          const ReferralActivationState(
            referralCode: null,
            status: ReferralActivationStatus.inactive,
            feeAmountNaira: 5000,
            isKycCompleted: false,
            isFeePaid: false,
          ),
        ) {
    fetchMyReferralCode();
  }

  final Ref _ref;

  Future<void> fetchMyReferralCode() async {
    state = state.copyWith(isLoading: true, clearError: true);
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 250));
      if (state.referralCode != null) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          clearReferralCode: true,
          isActive: false,
          status: ReferralActivationStatus.inactive,
        );
      }
      return;
    }

    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.get(ApiEndpoints.referralCodes.me);
      final body = response.data;
      final rawData = body is Map ? body['data'] : null;

      if (rawData is Map) {
        final id = (rawData['id'] as num?)?.toInt();
        final code = (rawData['referralCode'] ?? rawData['code'])?.toString();
        final isActive = rawData['isActive'] == true;

        if (code != null && code.isNotEmpty) {
          state = state.copyWith(
            id: id,
            referralCode: code,
            isActive: isActive,
            status: isActive
                ? ReferralActivationStatus.active
                : ReferralActivationStatus.inactive,
            isLoading: false,
          );
          return;
        }
      }

      state = state.copyWith(
        clearReferralCode: true,
        isActive: false,
        status: ReferralActivationStatus.inactive,
        isLoading: false,
      );
    } catch (e, stack) {
      AppLogger.e('fetchMyReferralCode error', error: e, stackTrace: stack);
      state = state.copyWith(
        isLoading: false,
        errorMessage: ApiError.toUserFriendlyMessage(e),
      );
    }
  }

  Future<String?> generateReferralCode() async {
    state = state.copyWith(isGenerating: true, clearError: true);
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      const mockGeneratedCode = 'CUSTOMER-4-C701F16C';
      state = state.copyWith(
        id: 224,
        referralCode: mockGeneratedCode,
        isActive: true,
        status: ReferralActivationStatus.active,
        isGenerating: false,
      );
      return mockGeneratedCode;
    }

    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.post(ApiEndpoints.referralCodes.generate);
      final body = response.data;
      final rawData = body is Map ? body['data'] : null;

      if (rawData is Map) {
        final id = (rawData['id'] as num?)?.toInt();
        final code = (rawData['referralCode'] ?? rawData['code'])?.toString();
        final isActive = rawData['isActive'] == true;

        if (code != null && code.isNotEmpty) {
          state = state.copyWith(
            id: id,
            referralCode: code,
            isActive: isActive,
            status: isActive
                ? ReferralActivationStatus.active
                : ReferralActivationStatus.inactive,
            isGenerating: false,
          );
          return code;
        }
      }

      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Could not generate referral code. Please try again.',
      );
    } catch (e, stack) {
      AppLogger.e('generateReferralCode error', error: e, stackTrace: stack);
      state = state.copyWith(
        isGenerating: false,
        errorMessage: ApiError.toUserFriendlyMessage(e),
      );
      rethrow;
    }
  }

  static int mapIdentityDocumentType(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('voter')) return 2;
    if (lower.contains('driver')) return 3;
    if (lower.contains('passport')) return 4;
    return 1; // Default: National Identity Number (NIN)
  }

  /// Complete KYC step:
  /// 1. Submit activation documents (`POST /api/v1/kyc/activation-submission`)
  /// 2. Optionally update KYC profile (`PUT /api/v1/kyc/mobile-app/profile`) if not locked/submitted
  /// 3. Submit profile if not yet submitted (`POST /api/v1/kyc/mobile-app/profile/submit`)
  Future<void> submitKyc({
    required String ninNumber,
    required String idType,
    required String idDocumentName,
    required String proofOfAddressName,
    String? dateOfBirth,
    String? nationality,
    String? residentialAddress,
    String? city,
    String? stateName,
    String? lga,
    List<KycUploadDocument>? uploadDocuments,
  }) async {
    final kycService = _ref.read(kycServiceProvider);

    KycProfile? existingProfile;
    try {
      existingProfile = await kycService.getProfile();
    } catch (_) {}

    if (dateOfBirth != null ||
        residentialAddress != null ||
        city != null ||
        stateName != null ||
        lga != null) {
      try {
        await kycService.updateProfile(
          dateOfBirth:
              dateOfBirth ?? existingProfile?.dateOfBirth ?? '1990-04-28',
          nationality:
              nationality ?? existingProfile?.nationality ?? 'Nigerian',
          residentialAddress: residentialAddress ??
              existingProfile?.residentialAddress ??
              '14 Admiralty Way',
          city: city ?? existingProfile?.city ?? 'Aba',
          state: stateName ?? existingProfile?.state ?? 'Abia',
          lga: lga ?? existingProfile?.lga ?? 'Aba North',
        );
      } catch (e) {
        AppLogger.w(
          'KYC profile update skipped or already exists; continuing with activation-submission: $e',
        );
      }
    }

    final docTypeInt = mapIdentityDocumentType(idType);
    final docs = uploadDocuments ??
        [
          KycUploadDocument(fileName: idDocumentName),
          KycUploadDocument(fileName: proofOfAddressName),
        ];

    KycProfile? submittedProfile;
    try {
      submittedProfile = await kycService.submitActivationDocuments(
        identityDocumentType: docTypeInt,
        identityNumber: ninNumber,
        documents: docs,
      );
    } on ApiError catch (e) {
      final msg = e.message.toLowerCase();
      if (e.statusCode == 400 ||
          e.statusCode == 409 ||
          msg.contains('already') ||
          msg.contains('exist') ||
          msg.contains('submitted')) {
        AppLogger.w('KYC documents already submitted; proceeding to payment.');
        submittedProfile = existingProfile;
      } else {
        rethrow;
      }
    }

    if (existingProfile == null || !existingProfile.isSubmitted) {
      try {
        await kycService.submitProfileIfNotSubmitted();
      } catch (_) {}
    }

    _ref.invalidate(kycProfileProvider);
    _ref.invalidate(kycDocumentsProvider);

    state = state.copyWith(
      ninNumber: ninNumber,
      idType: idType,
      idDocumentName: idDocumentName,
      proofOfAddressName: proofOfAddressName,
      isKycCompleted: true,
      status: (submittedProfile?.status ?? 0) >= 2 || state.isFeePaid
          ? ReferralActivationStatus.active
          : ReferralActivationStatus.pending,
    );
  }

  /// Initialize Paystack payment for KYC activation (`POST /api/v1/payments/kyc-activation/paystack/initialize`).
  Future<KycPaymentInitResult> initializeActivationPayment() async {
    final kycService = _ref.read(kycServiceProvider);
    final result = await kycService.initializeKycActivationPayment();
    if (result.amountNaira > 0) {
      state = state.copyWith(feeAmountNaira: result.amountNaira.round());
    }
    return result;
  }

  /// Finalize KYC activation after Paystack payment completes and generate/refresh referral code.
  Future<bool> completeActivationPayment(String reference) async {
    final kycService = _ref.read(kycServiceProvider);
    await kycService.verifyKycActivationPayment(reference);

    if (!state.hasCode) {
      try {
        await generateReferralCode();
      } catch (_) {
        await fetchMyReferralCode();
      }
    } else {
      await fetchMyReferralCode();
    }

    state = state.copyWith(
      isFeePaid: true,
      isActive: true,
      status: ReferralActivationStatus.active,
      activatedAt: DateTime.now(),
    );
    return true;
  }

  Future<bool> payActivationFee() async {
    final init = await initializeActivationPayment();
    return completeActivationPayment(init.reference);
  }

  void resetToInactive() {
    state = const ReferralActivationState(
      referralCode: null,
      status: ReferralActivationStatus.inactive,
      feeAmountNaira: 5000,
      isKycCompleted: false,
      isFeePaid: false,
    );
  }
}

final referralActivationProvider = StateNotifierProvider<
    ReferralActivationNotifier, ReferralActivationState>((ref) {
  return ReferralActivationNotifier(ref);
});

final kycProfileProvider = FutureProvider.autoDispose<KycProfile>((ref) {
  final link = ref.keepAlive();
  final timer = Timer(const Duration(minutes: 5), link.close);
  ref.onDispose(timer.cancel);
  return ref.watch(kycServiceProvider).getProfile();
});

final kycDocumentsProvider =
    FutureProvider.autoDispose<List<KycDocument>>((ref) {
  final link = ref.keepAlive();
  final timer = Timer(const Duration(minutes: 5), link.close);
  ref.onDispose(timer.cancel);
  return ref.watch(kycServiceProvider).getDocuments();
});
