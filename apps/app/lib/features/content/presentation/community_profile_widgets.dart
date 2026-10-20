import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/config/app_brand.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/content_entities.dart';

/// Statistical metric box for partner profile.
class CommunityStatBox extends StatelessWidget {
  const CommunityStatBox({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final dynamic icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF282828) : AppColors.surface2,
        borderRadius: AppSpacing.borderRadiusMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(
            icon: icon,
            color: const Color(0xFFC28B38),
            size: 20,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.h5.copyWith(
              fontWeight: FontWeight.w900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Join partner network card with copyable referral code.
class CommunityJoinNetworkCard extends StatelessWidget {
  const CommunityJoinNetworkCard({super.key, required this.partner});
  final CommunityPartnerProfile partner;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2016) : const Color(0xFFFFF9F0),
        borderRadius: AppSpacing.borderRadiusXL,
        border: Border.all(
          color: isDark ? const Color(0xFF4A3822) : const Color(0xFFF5E6D3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Join ${partner.alias}\'s Network',
            style: AppTypography.h4.copyWith(
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Become part of a winning team. Start your journey with ${AppBrand.shortName} and build your own business under ${partner.alias}\'s guidance.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          if (partner.referralCode != null) ...[
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: partner.referralCode!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Referral code copied to clipboard!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppSpacing.borderRadiusMD,
                  border: Border.all(color: const Color(0xFFC28B38)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      partner.referralCode!,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFC28B38),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.copy_rounded,
                      size: 16,
                      color: Color(0xFFC28B38),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => context.push('/register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppSpacing.avatarRadius,
                ),
              ),
              child: const Text('Sign Up Now'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fallback view when partner handle is not found.
class CommunityNotFoundView extends StatelessWidget {
  const CommunityNotFoundView({super.key, required this.handle});
  final String handle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlertCircle,
              color: AppColors.grey,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Partner Not Found',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'No public profile was found for @$handle.',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => context.go('/community'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 44),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppSpacing.avatarRadius,
                ),
              ),
              child: const Text('Back to Community'),
            ),
          ],
        ),
      ),
    );
  }
}
