import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Reusable dropdown form field that strictly matches [AppTextField] design,
/// borders, padding, colors, label placement, and validation behavior.
class AppDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;
  final bool isExpanded;
  final Color? dropdownColor;
  final EdgeInsetsGeometry? contentPadding;

  const AppDropdownField({
    super.key,
    this.label,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.errorText,
    this.autovalidateMode,
    this.isExpanded = true,
    this.dropdownColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final border = OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMD,
      borderSide: BorderSide(color: isDark ? Colors.white24 : AppColors.border),
    );

    const errorBorder = OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMD,
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
    );

    const focusedBorder = OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusMD,
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    );

    // Deduplicate items to prevent Flutter's "length == 1" assertion crash
    final seen = <T?>{};
    final safeItems = items.where((item) => seen.add(item.value)).toList();

    final hasMatchingItem = safeItems.any((item) => item.value == value);
    final effectiveValue = hasMatchingItem ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.label.copyWith(
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        DropdownButtonFormField<T>(
          key: ValueKey('dropdown_${label ?? ''}_$effectiveValue'),
          initialValue: effectiveValue,
          items: safeItems,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          autovalidateMode: autovalidateMode,
          isExpanded: isExpanded,
          dropdownColor: dropdownColor ?? (isDark ? const Color(0xFF2A2A2A) : Colors.white),
          icon: suffixIcon ??
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: enabled ? cs.onSurfaceVariant : cs.onSurfaceVariant.withAlpha(100),
              ),
          style: AppTypography.bodyMedium.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant.withAlpha(153),
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: prefixIcon,
                    ),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
            border: border,
            enabledBorder: border,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            disabledBorder: border.copyWith(
              borderSide: BorderSide(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: AppTypography.label.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}

