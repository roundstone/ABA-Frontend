import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_widgets.dart';

class PosCheckoutDrawer extends StatelessWidget {
  const PosCheckoutDrawer({
    super.key,
    required this.subtotal,
    required this.totalItems,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
    required this.onCheckout,
  });

  final double subtotal;
  final int totalItems;
  final String paymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$totalItems items in sale', style: AppTypography.bodySmall),
                Row(
                  children: ['Cash', 'POS Card', 'Transfer'].map((m) {
                    final isSel = paymentMethod == m;
                    return Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: ChoiceChip(
                        label: Text(m, style: const TextStyle(fontSize: 10.5)),
                        selected: isSel,
                        onSelected: (_) => onPaymentMethodChanged(m),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Due', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text(
                      formatNaira(subtotal),
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.secondary : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 170,
                  child: AppButton(
                    label: 'Complete Sale',
                    onPressed: onCheckout,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
