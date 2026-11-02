import 'package:flutter/material.dart';
import '../../domain/customer_order.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status, this.customLabel});

  final OrderStatus status;
  final String? customLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color text;
    Color border;

    switch (status) {
      case OrderStatus.unpaid:
        bg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEF2F2);
        text = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB42318);
        border = isDark ? const Color(0xFFB91C1C) : const Color(0xFFFECACA);
        break;
      case OrderStatus.pending:
        bg = isDark ? const Color(0xFF4A2B0F) : const Color(0xFFFEF3C7);
        text = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
        border = isDark ? const Color(0xFF92400E) : const Color(0xFFFDE68A);
        break;
      case OrderStatus.processing:
        bg = isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF);
        text = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);
        border = isDark ? const Color(0xFF1E40AF) : const Color(0xFFBFDBFE);
        break;
      case OrderStatus.shipped:
        bg = isDark ? const Color(0xFF0F2B2A) : const Color(0xFFE6E1D8);
        text = isDark ? const Color(0xFF5EEAD4) : const Color(0xFF172A1D);
        border = isDark ? const Color(0xFF115E59) : const Color(0xFFD4CEC4);
        break;
      case OrderStatus.delivered:
        bg = isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
        text = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF15803D);
        border = isDark ? const Color(0xFF047857) : const Color(0xFFBBF7D0);
        break;
      case OrderStatus.cancelled:
        bg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEF2F2);
        text = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB42318);
        border = isDark ? const Color(0xFFB91C1C) : const Color(0xFFFECACA);
        break;
    }

    final label = customLabel ?? status.label.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: text,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
