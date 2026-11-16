import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_text_field.dart';
import 'nigeria_locations_service.dart';

/// Opens a searchable bottom sheet to pick a Nigerian State or LGA.
Future<String?> showNigeriaLocationPicker(
  BuildContext context, {
  required String title,
  required List<String> items,
  String? selectedValue,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _LocationPickerSheet(
      title: title,
      items: items,
      selectedValue: selectedValue,
    ),
  );
}

/// Read-only field that opens a searchable Nigerian State or LGA picker.
class NigeriaLocationField extends StatelessWidget {
  const NigeriaLocationField({
    super.key,
    required this.label,
    required this.controller,
    required this.enabled,
    this.hintText,
    this.stateController,
    this.isLga = false,
    this.onChanged,
  });

  final String label;
  final String? hintText;
  final TextEditingController controller;
  final TextEditingController? stateController;
  final bool enabled;
  final bool isLga;
  final VoidCallback? onChanged;

  Future<void> _openPicker(BuildContext context) async {
    final List<String> items;
    if (isLga) {
      final stateName = stateController?.text.trim() ?? '';
      if (stateName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a state first.')),
        );
        return;
      }
      items = await NigeriaLocationsService.getLgasForState(stateName);
      if (items.isEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No LGAs found for "$stateName".')),
        );
        return;
      }
    } else {
      items = await NigeriaLocationsService.getStates();
    }
    if (!context.mounted) return;
    final picked = await showNigeriaLocationPicker(
      context,
      title: isLga ? 'Select LGA' : 'Select State',
      items: items,
      selectedValue: controller.text.trim(),
    );
    if (picked != null) {
      controller.text = picked;
      onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => _openPicker(context) : null,
      child: AbsorbPointer(
        child: AppTextField(
          label: label,
          hintText: hintText,
          controller: controller,
          enabled: enabled,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        ),
      ),
    );
  }
}

class _LocationPickerSheet extends StatefulWidget {
  const _LocationPickerSheet({
    required this.title,
    required this.items,
    this.selectedValue,
  });

  final String title;
  final List<String> items;
  final String? selectedValue;

  @override
  State<_LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<_LocationPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? widget.items
        : widget.items.where((i) => i.toLowerCase().contains(q)).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.title,
                    style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    autofocus: false,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search, size: 20),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: AppSpacing.borderRadiusMD,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No matches found',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final item = filtered[i];
                        final selected =
                            item.toLowerCase() ==
                            (widget.selectedValue ?? '').toLowerCase();
                        return ListTile(
                          title: Text(item, style: AppTypography.bodyMedium),
                          trailing: selected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 20,
                                )
                              : null,
                          onTap: () => Navigator.of(ctx).pop(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
