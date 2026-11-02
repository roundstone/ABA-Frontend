import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/application/auth_providers.dart';
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
        final code = rawData['referralCode']?.toString();
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
        final code = rawData['referralCode']?.toString();
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

  // --- KYC & Fee methods preserved for when KYC flow is restored ---
  Future<void> submitKyc({
    required String ninNumber,
    required String idType,
    required String idDocumentName,
    required String proofOfAddressName,
  }) async {
    state = state.copyWith(
      ninNumber: ninNumber,
      idType: idType,
      idDocumentName: idDocumentName,
      proofOfAddressName: proofOfAddressName,
      isKycCompleted: true,
      status: state.isFeePaid
          ? ReferralActivationStatus.active
          : ReferralActivationStatus.pending,
    );
  }

  Future<bool> payActivationFee() async {
    await Future.delayed(const Duration(milliseconds: 700));
    final currentUser = _ref.read(authStateProvider).user;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        walletBalance: currentUser.walletBalance + state.feeAmountNaira,
      );
      _ref.read(authStateProvider.notifier).loginCustomer(
            identifier: updatedUser.email,
            password: 'mockPassword',
          );
    }

    state = state.copyWith(
      isFeePaid: true,
      status: state.isKycCompleted
          ? ReferralActivationStatus.active
          : ReferralActivationStatus.pending,
      activatedAt: state.isKycCompleted ? DateTime.now() : null,
    );
    return true;
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
