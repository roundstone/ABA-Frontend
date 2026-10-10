import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Row of marketplace guarantee badges shown on the animated splash screen.
class SplashBadgeRow extends StatelessWidget {
  const SplashBadgeRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        SplashPillBadge(
          icon: HugeIcons.strokeRoundedStore01,
          label: 'Direct Wholesale',
        ),
        SplashPillBadge(
          icon: HugeIcons.strokeRoundedAward01,
          label: '3-Tier Rewards',
        ),
        SplashPillBadge(
          icon: HugeIcons.strokeRoundedShieldCheck,
          label: 'Buyer Escrow',
        ),
      ],
    );
  }
}

class SplashPillBadge extends StatelessWidget {
  const SplashPillBadge({
    super.key,
    required this.icon,
    required this.label,
  });

  final List<List<dynamic>> icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: AppSpacing.avatarRadius,
        border: Border.all(color: Colors.white.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: icon,
            color: AppColors.secondary,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
