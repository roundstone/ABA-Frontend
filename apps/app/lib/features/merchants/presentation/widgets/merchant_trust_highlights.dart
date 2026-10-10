import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MerchantTrustHighlights extends StatelessWidget {
  const MerchantTrustHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        _TrustChip(
          icon: HugeIcons.strokeRoundedTick02,
          label: 'Verified Only',
        ),
        _TrustChip(
          icon: HugeIcons.strokeRoundedStore01,
          label: 'Direct Hubs',
        ),
        _TrustChip(
          icon: HugeIcons.strokeRoundedSecurityCheck,
          label: 'Buyer Protection',
        ),
      ],
    );
  }
}

class _TrustChip extends StatelessWidget {
  const _TrustChip({required this.icon, required this.label});
  final List<List<dynamic>> icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HugeIcon(
          icon: icon,
          color: AppColors.secondary,
          size: 13,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: Colors.white.withAlpha(220),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
