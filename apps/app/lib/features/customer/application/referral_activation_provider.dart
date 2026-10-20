import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_providers.dart';
import '../domain/referral_activation_model.dart';

class ReferralActivationNotifier
    extends StateNotifier<ReferralActivationState> {
  ReferralActivationNotifier(this._ref)
      : super(
          const ReferralActivationState(
            referralCode: 'BN-EMEK-8821',
            status: ReferralActivationStatus.inactive,
            feeAmountNaira: 5000,
            isKycCompleted: false,
            isFeePaid: false,
          ),
        );

  final Ref _ref;

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
    // Simulate payment transaction
    await Future.delayed(const Duration(milliseconds: 700));

    // When paid, fee is credited to user's shopping wallet (non-withdrawable)
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
      referralCode: 'BN-EMEK-8821',
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
