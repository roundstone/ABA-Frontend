import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../features/customer/domain/customer_entities.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Formats numbers as Nigerian Naira (₦ 1,500.00).
String formatNaira(double amount) {
  final formatted = amount.toStringAsFixed(2);
  final parts = formatted.split('.');
  final intPart = parts[0];
  final buffer = StringBuffer();
  int count = 0;
  for (int i = intPart.length - 1; i >= 0; i--) {
    if (count != 0 && count % 3 == 0) buffer.write(',');
    buffer.write(intPart[i]);
    count++;
  }
  return '₦ ${buffer.toString().split('').reversed.join()}.${parts[1]}';
}

/// Full-screen shimmer-style loading placeholder.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message = 'Loading…'});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          AppSpacing.verticalSpaceMD,
          Text(message, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

/// Full-screen error state with retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlertCircle,
              size: AppSpacing.iconSizeXXL,
              color: AppColors.error,
            ),
            AppSpacing.verticalSpaceSM,
            Text(message, textAlign: TextAlign.center, style: AppTypography.bodyMedium),
            if (onRetry != null) ...[
              AppSpacing.verticalSpaceMD,
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

/// KPI stat card used on the dashboard overview row.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  });
  final String label;
  final String value;
  final List<List<dynamic>> icon;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? cs.surfaceContainerHighest;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.borderRadiusLG,
      ),
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: AppSpacing.paddingSM,
            decoration: BoxDecoration(
              color: (iconColor ?? cs.primary).withAlpha(25),
              borderRadius: AppSpacing.borderRadiusSM,
            ),
            child: HugeIcon(
              icon: icon,
              color: iconColor ?? cs.primary,
              size: AppSpacing.iconSizeSM,
            ),
          ),
          AppSpacing.verticalSpaceSM,
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTypography.h4.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
          AppSpacing.verticalSpaceXS,
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: cs.onSurface.withAlpha(153),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Order status badge chip.
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});
  final OrderStatus status;

  (Color bg, Color fg, String label) get _style {
    switch (status) {
      case OrderStatus.delivered:
        return (const Color(0xFFE8F5E9), const Color(0xFF2E7D32), 'Delivered');
      case OrderStatus.shipped:
        return (const Color(0xFFE3F2FD), const Color(0xFF1565C0), 'Shipped');
      case OrderStatus.processing:
        return (const Color(0xFFFFF8E1), const Color(0xFFF57F17), 'Processing');
      case OrderStatus.pending:
        return (const Color(0xFFFCE4EC), const Color(0xFFC62828), 'Pending');
      case OrderStatus.cancelled:
        return (const Color(0xFFEEEEEE), const Color(0xFF616161), 'Cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = _style;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + AppSpacing.xs, // 10px
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.avatarRadius,
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
