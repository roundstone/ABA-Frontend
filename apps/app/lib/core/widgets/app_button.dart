import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonType { primary, secondary, outlined, text, destructive }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? borderSide;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
  }) : type = AppButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
  }) : type = AppButtonType.secondary;

  const AppButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
  }) : type = AppButtonType.outlined;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
  }) : type = AppButtonType.text;

  const AppButton.destructive({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
  }) : type = AppButtonType.destructive;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buttonChild = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foregroundColor ??
                  (type == AppButtonType.primary ||
                          type == AppButtonType.secondary ||
                          type == AppButtonType.destructive
                      ? Colors.white
                      : cs.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.label.copyWith(
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          ),
        ),
      ],
    );

    Widget button;
    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary,
            foregroundColor: foregroundColor ?? Colors.white,
            elevation: 0,
            padding: padding ??
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusLG,
            ),
          ),
          child: buttonChild,
        );
        break;
      case AppButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ??
                (isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0)),
            foregroundColor: foregroundColor ?? cs.onSurface,
            elevation: 0,
            padding: padding ??
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusLG,
            ),
          ),
          child: buttonChild,
        );
        break;
      case AppButtonType.destructive:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.error,
            foregroundColor: foregroundColor ?? Colors.white,
            disabledBackgroundColor: AppColors.error.withAlpha(128),
            elevation: 0,
            padding: padding ??
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusLG,
            ),
          ),
          child: buttonChild,
        );
        break;
      case AppButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? cs.onSurface,
            backgroundColor: backgroundColor,
            side: borderSide ??
                BorderSide(color: isDark ? Colors.white24 : AppColors.border),
            padding: padding ??
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusLG,
            ),
          ),
          child: buttonChild,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? cs.primary,
            backgroundColor: backgroundColor,
            padding: padding ??
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMD,
            ),
          ),
          child: buttonChild,
        );
        break;
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
