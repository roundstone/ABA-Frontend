import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_text_field.dart';

class MerchantProductInventoryFields extends StatelessWidget {
  const MerchantProductInventoryFields({
    super.key,
    required this.priceCtrl,
    required this.costCtrl,
    required this.stockCtrl,
    required this.reorderLevelCtrl,
    required this.reorderQtyCtrl,
    required this.unitOfMeasure,
    required this.onUnitChanged,
  });

  final TextEditingController priceCtrl;
  final TextEditingController costCtrl;
  final TextEditingController stockCtrl;
  final TextEditingController reorderLevelCtrl;
  final TextEditingController reorderQtyCtrl;
  final String unitOfMeasure;
  final ValueChanged<String> onUnitChanged;

  static const units = ['piece', 'pair', 'set', 'box', 'kg', 'meter', 'pack'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Base Selling Price (₦) *',
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                hintText: '3500.00',
                validator: (v) => v == null || double.tryParse(v) == null ? 'Valid price required' : null,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppTextField(
                label: 'Base Cost Price (₦)',
                controller: costCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                hintText: '2500.00',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: AppDropdownField<String>(
                label: 'Base Unit',
                value: units.contains(unitOfMeasure) ? unitOfMeasure : units.first,
                items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (v) => onUnitChanged(v ?? 'piece'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppTextField(
                label: 'Stock Quantity',
                controller: stockCtrl,
                keyboardType: TextInputType.number,
                hintText: '10',
                validator: (v) => v == null || int.tryParse(v) == null ? 'Valid integer required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: AppTextField(label: 'Reorder Level', controller: reorderLevelCtrl, keyboardType: TextInputType.number, hintText: '10'),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppTextField(label: 'Reorder Qty', controller: reorderQtyCtrl, keyboardType: TextInputType.number, hintText: '25'),
            ),
          ],
        ),
      ],
    );
  }
}
