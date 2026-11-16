import 'package:app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
export 'app_dropdown_field.dart';
export 'app_network_image.dart';
export 'app_snackbar.dart';
export 'infinite_scroll_listener.dart';
export 'paginated_list_view.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../features/customer/domain/customer_entities.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_snackbar.dart';

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
          const CircularProgressIndicator.adaptive(),
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
            if (onRetry != null) ...[
              AppSpacing.verticalSpaceMD,
              AppButton(onPressed: onRetry, label: 'Retry'),
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
      case OrderStatus.complete:
        return (const Color(0xFFE8F5E9), const Color(0xFF2E7D32), 'Complete');
      case OrderStatus.shippedOrReadyForPickup:
        return (
          const Color(0xFFE3F2FD),
          const Color(0xFF1565C0),
          'Shipped / Ready for Pickup',
        );
      case OrderStatus.pending:
        return (const Color(0xFFFFF8E1), const Color(0xFFF57F17), 'Pending');
      case OrderStatus.refundRequested:
        return (
          const Color(0xFFF3E5F5),
          const Color(0xFF6A1B9A),
          'Refund Requested',
        );
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

String getWhatsAppLink(String phoneNumber, String name) {
  // Remove all non-digit characters
  final cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // Convert Nigerian local numbers to international format
  final formattedNumber = cleanedNumber.startsWith('0')
      ? '234${cleanedNumber.substring(1)}'
      : cleanedNumber;

  final message = "Hello $name, I'm interested in your products";

  final encodedMessage = Uri.encodeComponent(message);

  return 'https://wa.me/$formattedNumber?text=$encodedMessage';
}

/// Launches WhatsApp chat for a seller using [getWhatsAppLink].
Future<bool> launchWhatsAppChat(
  BuildContext context, {
  required String phoneNumber,
  required String sellerName,
}) async {
  final cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
  if (cleaned.isEmpty) {
    AppSnackbar.info(context, 'Seller WhatsApp contact is not available.');
    return false;
  }
  final uri = Uri.parse(getWhatsAppLink(phoneNumber, sellerName));
  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      AppSnackbar.error(context, 'Could not open WhatsApp.');
    }
    return launched;
  } catch (_) {
    if (context.mounted) {
      AppSnackbar.error(context, 'Could not open WhatsApp.');
    }
    return false;
  }
}
