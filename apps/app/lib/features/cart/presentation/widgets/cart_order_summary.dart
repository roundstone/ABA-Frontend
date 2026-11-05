import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../shop/domain/shop_entities.dart';

class CartOrderSummary extends StatelessWidget {
  const CartOrderSummary({
    super.key,
    required this.cart,
    required this.onCheckout,
    required this.onClear,
  });

  final Cart cart;
  final VoidCallback onCheckout;
  final VoidCallback onClear;

  /// Toggleable VAT configuration. Currently disabled: prices already include VAT.
  static const bool enableVat = false;

  /// Toggleable shipping configuration. Shipping method is selected during checkout.
  static const bool enableShipping = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shippingAmount = enableShipping ? cart.shipping : 0.0;
    final vatAmount = enableVat ? cart.tax : 0.0;
    final total = cart.subtotal + shippingAmount + vatAmount;

    Widget row(String label, double value, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: bold
                    ? AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)
                    : AppTypography.bodySmall.copyWith(color: cs.onSurface.withAlpha(160)),
              ),
              Text(
                formatNaira(value),
                style: bold
                    ? AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: cs.primary)
                    : AppTypography.bodySmall,
              ),
            ],
          ),
        );

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 60 : 12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          row('Subtotal (${cart.itemCount} items)', cart.subtotal),
          if (enableShipping) ...[
            row('Shipping', cart.shipping),
            if (cart.shipping == 0)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Free!',
                  style: AppTypography.label.copyWith(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
          if (enableVat)
            row('VAT (7.5%)', cart.tax)
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    size: 14,
                    color: isDark ? Colors.white54 : AppColors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Prices include VAT.',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? Colors.white60 : AppColors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: AppSpacing.md),
          row('Total', total, bold: true),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              OutlinedButton(
                onPressed: onClear,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  size: AppSpacing.iconSizeSM,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: onCheckout,
                  child: const Text('Checkout'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

