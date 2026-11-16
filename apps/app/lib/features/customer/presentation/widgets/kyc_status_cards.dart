import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/kyc_models.dart';

class KycStatusCard extends StatelessWidget {
  const KycStatusCard({super.key, required this.profile});
  final KycProfile? profile;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = profile?.status ?? 1;
    final statusLabel = profile?.statusLabel ?? 'Pending';
    final (badgeColor, badgeBg) = switch (status) {
      3 => (AppColors.success, AppColors.success.withAlpha(25)),
      2 => (const Color(0xFFD97706), const Color(0xFFD97706).withAlpha(25)),
      4 => (AppColors.error, AppColors.error.withAlpha(25)),
      _ => (AppColors.grey, isDark ? Colors.white12 : AppColors.surface2),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: AppSpacing.borderRadiusMD,
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedShieldKey,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification status',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (profile?.submittedAt != null)
                      Text(
                        'Submitted ${DateFormat('MMM d, y').format(profile!.submittedAt!.toLocal())}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: AppTypography.caption.copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (profile?.rejectionReason != null &&
              profile!.rejectionReason!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(18),
                borderRadius: AppSpacing.borderRadiusMD,
                border: Border.all(color: AppColors.error.withAlpha(70)),
              ),
              child: Text(
                'Rejection reason: ${profile!.rejectionReason}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class KycActivationPaymentCard extends StatelessWidget {
  const KycActivationPaymentCard({
    super.key,
    required this.payment,
    required this.isShoppingCreditActivated,
    this.onPayFee,
  });

  final KycActivationPayment? payment;
  final bool isShoppingCreditActivated;
  final VoidCallback? onPayFee;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPaid = (payment?.isSuccessful ?? false) || isShoppingCreditActivated;
    final statusText = isPaid
        ? 'Paid'
        : (payment?.status.isNotEmpty == true ? payment!.status : 'Unpaid');
    final statusColor = isPaid
        ? AppColors.success
        : (payment?.isPending == true
            ? const Color(0xFFD97706)
            : AppColors.grey);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedCoins01,
                color: Color(0xFFC28B38),
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Activation Payment',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (isPaid) ...[
            Text(
              '₦${payment?.amount ?? '5,000.00'} settled${payment?.paymentMethod != null ? ' via ${payment!.paymentMethod}' : ''}. No additional payment is needed.',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? Colors.white70 : AppColors.grey,
              ),
            ),
            if (payment?.reference != null) ...[
              const SizedBox(height: 4),
              Text(
                'Ref: ${payment!.reference}',
                style: AppTypography.caption.copyWith(color: AppColors.grey),
              ),
            ],
          ] else ...[
            Text(
              'One-time ₦5,000 activation fee (100% credited to your shopping wallet).',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? Colors.white70 : AppColors.grey,
              ),
            ),
            if (onPayFee != null) ...[
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: onPayFee,
                icon: const Icon(Icons.payment, size: 18),
                label: const Text('Pay ₦5,000 Activation Fee'),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
