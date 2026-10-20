import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Mobile representation of the "Made in Nigeria" showcase section.
/// Highlights authentic manufacturing, artisan footwear, leather craft & garments.
class MadeInAbaPromo extends StatelessWidget {
  const MadeInAbaPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: AppSpacing.borderRadiusXL,
        border: Border.all(color: Colors.white.withAlpha(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(120),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nigerian Heritage Pill
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                      color: Color(0xFF008751), // Nigerian Green
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'AUTHENTIC CRAFTSMANSHIP',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Title
          Text(
            'Made in Nigeria',
            style: AppTypography.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Paragraph
          Text(
            'Discover authentic products crafted by the people and businesses that make Aba the manufacturing hub of West Africa. From premium leather shoes to expertly tailored garments.',
            style: AppTypography.bodySmall.copyWith(
              color: const Color(0xFFCCCCCC),
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Visual badges row for mobile (Footwear, Garments, Leathercraft)
          const Row(
            children: [
              _CraftHighlight(
                icon: HugeIcons.strokeRoundedShoppingBag01,
                label: 'Leathercraft',
              ),
              SizedBox(width: AppSpacing.sm),
              _CraftHighlight(
                icon: HugeIcons.strokeRoundedScissors,
                label: 'Garments',
              ),
              SizedBox(width: AppSpacing.sm),
              _CraftHighlight(
                icon: HugeIcons.strokeRoundedStore01,
                label: 'Artisan Hub',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // CTA: Shop now
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/shop'),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: Colors.black,
                size: 18,
              ),
              label: Text(
                'Shop Direct from Makers',
                style: AppTypography.buttonMedium.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
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

class _CraftHighlight extends StatelessWidget {
  const _CraftHighlight({required this.icon, required this.label});
  final dynamic icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(15),
          borderRadius: AppSpacing.borderRadiusMD,
          border: Border.all(color: Colors.white.withAlpha(20)),
        ),
        child: Column(
          children: [
            HugeIcon(
              icon: icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
