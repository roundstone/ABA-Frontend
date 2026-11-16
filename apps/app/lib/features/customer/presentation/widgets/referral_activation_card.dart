import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../wallet/application/wallet_providers.dart';
import '../../application/referral_activation_provider.dart';
import 'referral_activation_sheet.dart';

class ReferralActivationCard extends ConsumerWidget {
  const ReferralActivationCard({super.key, this.showKycProfileLink = true});

  final bool showKycProfileLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(referralActivationProvider);
    final profile = ref.watch(optionalKycProfileProvider).valueOrNull;
    final credit = ref.watch(shoppingCreditsProvider).valueOrNull;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
        ),
        child: const Center(
          child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    final isKycApproved = profile?.isApproved == true;
    final isKycUnderReview = profile?.isUnderReview == true;
    final isKycRejected = profile?.isRejected == true;
    final isActivationPaid =
        (profile?.isActivationPaid ?? false) || (credit?.isActivated ?? false);
    final isActive = isKycApproved && isActivationPaid;

    if (isActive) {
      return _ActiveBanner(referralCode: state.referralCode, isDark: isDark);
    }

    final requirementText = isKycUnderReview
        ? 'KYC review in progress'
        : isKycRejected
            ? 'KYC resubmission required'
            : isKycApproved
                ? 'Pay ₦5,000 Activation Fee'
                : isActivationPaid
                    ? 'Complete KYC Verification'
                    : 'Complete KYC & ₦5,000 Fee';

    final bodyText = isKycUnderReview
        ? 'Your KYC application is being reviewed. You cannot submit another application until a decision is made.'
        : isKycRejected
            ? 'Your KYC application was rejected. Update your details and submit a new application from your KYC profile.'
            : isKycApproved
                ? 'Your KYC is already approved. Complete the one-time ₦5,000 membership fee to activate commission earning.'
                : isActivationPaid
                    ? 'Your ₦5,000 activation fee is paid. Complete and submit your KYC profile for verification.'
                    : 'Every user receives a referral code upon registration, but earning commissions requires completing KYC verification and the one-time ₦5,000 membership fee.';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF241C10) : const Color(0xFFFFFBF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC28B38).withAlpha(isDark ? 90 : 60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFC28B38), borderRadius: BorderRadius.circular(4)),
                child: Text(
                  'COMMISSION INACTIVE',
                  style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10),
                ),
              ),
              if (!isKycUnderReview && !isKycRejected && state.hasCode)
                Text('Code: ${state.referralCode}', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFFC28B38))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const HugeIcon(icon: HugeIcons.strokeRoundedShieldKey, color: Color(0xFFC28B38), size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text('Requirement: $requirementText', style: AppTypography.caption.copyWith(color: AppColors.grey))),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Activate Your Referral Account', style: AppTypography.h5.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.xs),
          Text(bodyText, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.grey, height: 1.4)),
          if (isKycRejected && profile?.rejectionReason?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.xs),
            Text('Reason: ${profile!.rejectionReason}', style: AppTypography.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
          ],
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? Colors.white10 : AppColors.border),
            ),
            child: Row(
              children: [
                const HugeIcon(icon: HugeIcons.strokeRoundedCoins01, color: Color(0xFFC28B38), size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    isActivationPaid
                        ? '₦5,000 activation fee paid and credited to your shopping wallet.'
                        : '100% Credited to Your Shopping Wallet! Use it anytime to shop across BuyNaija.',
                    style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : AppColors.onBackground),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (!isKycUnderReview && !isKycRejected)
            AppButton.primary(
              label: isKycApproved
                  ? 'Pay ₦5,000 Activation Fee'
                  : isActivationPaid
                      ? 'Complete KYC Verification'
                      : 'Activate Earning (KYC & ₦5,000 Fee)',
              onPressed: () {
                if (isKycApproved) {
                  ReferralActivationSheet.show(context, initialStep: 1);
                } else if (isActivationPaid && showKycProfileLink) {
                  context.push('/account/kyc');
                } else {
                  ReferralActivationSheet.show(context);
                }
              },
            ),
          if (showKycProfileLink) ...[
            const SizedBox(height: AppSpacing.xs),
            AppButton.outlined(
              label: isKycRejected
                  ? 'Update KYC Profile'
                  : isKycUnderReview
                      ? 'View KYC Status'
                      : 'View KYC Profile',
              onPressed: () => context.push('/account/kyc'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActiveBanner extends StatelessWidget {
  const _ActiveBanner({required this.referralCode, required this.isDark});
  final String? referralCode;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withAlpha(isDark ? 30 : 18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success.withAlpha(90)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Commission Earning Active', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.success)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.success.withAlpha(30), borderRadius: BorderRadius.circular(4)),
                      child: Text('VERIFIED', style: AppTypography.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.success)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'KYC verified • ₦5,000 shopping credit active in wallet • Earning commissions on all referrals',
                  style: AppTypography.caption.copyWith(color: isDark ? Colors.white70 : AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
