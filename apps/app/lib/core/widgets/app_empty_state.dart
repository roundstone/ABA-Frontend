import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.iconSize = 72,
    this.action,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.titleStyle,
    this.descriptionStyle,
    this.iconColor,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.gap,
  });

  final String title;
  final String? description;
  final dynamic icon;
  final double iconSize;
  final Widget? action;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Color? iconColor;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (icon != null) ...[
              HugeIcon(
                icon: icon,
                size: iconSize,
                color: iconColor ?? cs.primary.withAlpha(80),
              ),
              SizedBox(height: gap ?? AppSpacing.md),
            ],

            Text(
              title,
              textAlign: TextAlign.center,
              style:
                  titleStyle ??
                  AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
            ),

            if (description != null && description!.isNotEmpty) ...[
              SizedBox(height: gap ?? AppSpacing.xs),
              Text(
                description!,
                textAlign: TextAlign.center,
                style:
                    descriptionStyle ??
                    AppTypography.bodySmall.copyWith(
                      color: cs.onSurface.withAlpha(153),
                    ),
              ),
            ],

            if (action != null) ...[
              SizedBox(height: gap ?? AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
