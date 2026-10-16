import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/merchant_order_entities.dart';
import '../../domain/merchant_product_entities.dart';

class MerchantOrderStatusBadge extends StatelessWidget {
  const MerchantOrderStatusBadge({super.key, required this.status});
  final MerchantOrderStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case MerchantOrderStatus.pending:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        break;
      case MerchantOrderStatus.processing:
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF2563EB);
        break;
      case MerchantOrderStatus.ready:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF9333EA);
        break;
      case MerchantOrderStatus.completed:
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF059669);
        break;
      case MerchantOrderStatus.cancelled:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFDC2626);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.borderRadiusSM,
      ),
      child: Text(
        status.label,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

class MerchantStockBadge extends StatelessWidget {
  const MerchantStockBadge({super.key, required this.product});
  final MerchantProduct product;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    if (product.isOutOfStock) {
      bg = const Color(0xFFFEE2E2);
      fg = const Color(0xFFDC2626);
      label = 'Out of Stock';
    } else if (product.isLowStock) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFD97706);
      label = '${product.stock} left (Low)';
    } else {
      bg = const Color(0xFFD1FAE5);
      fg = const Color(0xFF059669);
      label = '${product.stock} in stock';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.borderRadiusSM,
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

class MerchantPaymentBadge extends StatelessWidget {
  const MerchantPaymentBadge({super.key, required this.status});
  final MerchantPaymentStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case MerchantPaymentStatus.paid:
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF059669);
        break;
      case MerchantPaymentStatus.unpaid:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFDC2626);
        break;
      case MerchantPaymentStatus.partiallyPaid:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        break;
      case MerchantPaymentStatus.refunded:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.borderRadiusSM,
      ),
      child: Text(
        status.label,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 10.5,
        ),
      ),
    );
  }
}
