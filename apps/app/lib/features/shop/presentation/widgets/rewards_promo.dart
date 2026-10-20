import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/config/app_brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Mobile representation of the Web Rewards Program Promo (Doc 06 / Storefront).
/// Highlights "Shop. Refer. Earn. Grow." with 4 clear onboarding steps.
class RewardsPromo extends StatelessWidget {
  const RewardsPromo({super.key});

  static const Color copper = Color(0xFFC28B38);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? Colors.white10 : const Color(0xFFF0EBE1);

    const steps = [
      _RewardStep(
        number: '01',
        title: 'Join',
        desc: 'Create your free account.',
      ),
      _RewardStep(
        number: '02',
        title: 'Share',
        desc: 'Invite shoppers & businesses to ${AppBrand.shortName}.',
      ),
      _RewardStep(
        number: '03',
        title: 'Earn',
        desc: 'Receive commissions on sales from your network.',
      ),
      _RewardStep(
        number: '04',
        title: 'Grow',
        desc: 'Unlock network tiers and leadership bonuses.',
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppSpacing.borderRadiusXL,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag Pill
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF332616) : const Color(0xFFFFF9F0),
              borderRadius: AppSpacing.borderRadiusSM,
              border: Border.all(
                color: isDark ? const Color(0xFF4A3822) : const Color(0xFFF5E6D3),
              ),
            ),
            child: Text(
              'REWARDS PROGRAM',
              style: AppTypography.caption.copyWith(
                color: copper,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Heading
          Text(
            'Shop. Refer. Earn. Grow.',
            style: AppTypography.h4.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Subtitle
          Text(
            'Turn your network into an opportunity. Help verified local businesses reach more buyers and earn commissions.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 4 Steps in 2-column grid
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: steps.map((s) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 32 - 32 - 16) / 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2C2C2C)
                            : const Color(0xFFF5F2EB),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: copper.withAlpha(isDark ? 80 : 120),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        s.number,
                        style: AppTypography.caption.copyWith(
                          color: copper,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.title,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            s.desc,
                            style: AppTypography.caption.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.grey,
                              fontSize: 11,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // CTA Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/community'),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedAward01,
                color: Colors.white,
                size: 18,
              ),
              label: Text(
                'Learn How It Works',
                style: AppTypography.buttonMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: copper,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppSpacing.avatarRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardStep {
  const _RewardStep({
    required this.number,
    required this.title,
    required this.desc,
  });

  final String number;
  final String title;
  final String desc;
}
