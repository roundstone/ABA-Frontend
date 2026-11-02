import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';

class PaymentVerifyButton extends StatelessWidget {
  const PaymentVerifyButton({
    super.key,
    required this.reference,
    required this.isDark,
    required this.isVerifying,
    required this.onTap,
    this.tooltip = 'Verify payment with gateway',
  });

  final String reference;
  final bool isDark;
  final bool isVerifying;
  final VoidCallback? onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: isVerifying ? null : onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: isDark ? 0.5 : 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isVerifying)
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.primary,
                  ),
                )
              else ...[
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                  size: 11,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 3),
                const Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
