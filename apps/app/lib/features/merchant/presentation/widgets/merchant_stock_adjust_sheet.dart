import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/merchant_product_entities.dart';

class MerchantStockAdjustSheet extends StatefulWidget {
  const MerchantStockAdjustSheet({
    super.key,
    required this.product,
    required this.onConfirm,
  });

  final MerchantProduct product;
  final Future<bool> Function(int adjustment, String reason) onConfirm;

  static Future<void> show(
    BuildContext context, {
    required MerchantProduct product,
    required Future<bool> Function(int adjustment, String reason) onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MerchantStockAdjustSheet(
        product: product,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<MerchantStockAdjustSheet> createState() =>
      _MerchantStockAdjustSheetState();
}

class _MerchantStockAdjustSheetState extends State<MerchantStockAdjustSheet> {
  int _adjustment = 1;
  bool _isAddition = true;
  String _selectedReason = 'Stock shipment received';
  bool _isSubmitting = false;

  final List<String> _reasons = [
    'Stock shipment received',
    'Customer return restocked',
    'Physical inventory audit count',
    'Damaged / written-off item',
    'POS manual correction',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final currentStock = widget.product.stock;
    final effectiveDelta = _isAddition ? _adjustment : -_adjustment;
    final projectedStock = (currentStock + effectiveDelta).clamp(0, 99999);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Adjust Stock Level',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.product.name,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.lg),
            // Current vs Projected Stock
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8FAFC),
                borderRadius: AppSpacing.borderRadiusMD,
                border: Border.all(
                  color: isDark ? const Color(0xFF333333) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stockCounter(
                    'Current Stock',
                    '$currentStock units',
                    isDark ? Colors.white70 : const Color(0xFF64748B),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  ),
                  _stockCounter(
                    'New Stock',
                    '$projectedStock units',
                    isDark ? AppColors.secondary : AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Direction toggle
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('+ Add Stock')),
                    selected: _isAddition,
                    onSelected: (val) => setState(() => _isAddition = true),
                    selectedColor: const Color(0xFF10B981).withAlpha(40),
                    labelStyle: TextStyle(
                      color: _isAddition
                          ? const Color(0xFF10B981)
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('− Remove Stock')),
                    selected: !_isAddition,
                    onSelected: (val) => setState(() => _isAddition = false),
                    selectedColor: const Color(0xFFEF4444).withAlpha(40),
                    labelStyle: TextStyle(
                      color: !_isAddition
                          ? const Color(0xFFEF4444)
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Stepper Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(
                  onPressed: _adjustment > 1
                      ? () => setState(() => _adjustment--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '$_adjustment',
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                IconButton.outlined(
                  onPressed: () => setState(() => _adjustment++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Reason Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedReason,
              decoration: const InputDecoration(
                labelText: 'Adjustment Reason',
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              items: _reasons.map((r) {
                return DropdownMenuItem(value: r, child: Text(r));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedReason = val);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Confirm Adjustment',
              isLoading: _isSubmitting,
              onPressed: () async {
                final navigator = Navigator.of(context);
                setState(() => _isSubmitting = true);
                final ok = await widget.onConfirm(effectiveDelta, _selectedReason);
                if (!mounted) return;
                setState(() => _isSubmitting = false);
                if (ok) navigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _stockCounter(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
