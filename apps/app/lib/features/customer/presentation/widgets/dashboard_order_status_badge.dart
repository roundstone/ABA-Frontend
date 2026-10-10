import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../account/domain/customer_order.dart';

class DashboardOrderStatusBadge extends StatelessWidget {
  const DashboardOrderStatusBadge({super.key, required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color fg;

    switch (status) {
      case OrderStatus.processing:
        bg = isDark ? const Color(0xFF4A2B0F) : const Color(0xFFFEF3C7);
        fg = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
        break;
      case OrderStatus.shipped:
        bg = isDark ? const Color(0xFF0F2B2A) : const Color(0xFFE6E1D8);
        fg = isDark ? const Color(0xFF5EEAD4) : const Color(0xFF172A1D);
        break;
      case OrderStatus.delivered:
        bg = isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
        fg = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF15803D);
        break;
      case OrderStatus.pending:
        bg = isDark ? const Color(0xFF3F1B1B) : const Color(0xFFFEE2E2);
        fg = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);
        break;
      case OrderStatus.cancelled:
        bg = isDark ? const Color(0xFF262626) : const Color(0xFFF3F4F6);
        fg = isDark ? const Color(0xFFA3A3A3) : const Color(0xFF4B5563);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
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
