import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// One-tap demo user sign-in shortcut button.
class DemoLoginButton extends StatelessWidget {
  const DemoLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final List<List<dynamic>> icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: HugeIcon(
        icon: icon,
        color: AppColors.primary,
        size: 16,
      ),
      label: Text(
        label,
        style: AppTypography.buttonMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
