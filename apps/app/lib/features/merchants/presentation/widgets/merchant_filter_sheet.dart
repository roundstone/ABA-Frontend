import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/merchant_entities.dart';
import 'merchant_filter_controls.dart';

void showMerchantFilterSheet({
  required BuildContext context,
  required MerchantFilterParams initialParams,
  required ValueChanged<MerchantFilterParams> onApply,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => MerchantFilterSheet(
      initialParams: initialParams,
      onApply: (params) {
        Navigator.of(ctx).pop();
        onApply(params);
      },
    ),
  );
}

class MerchantFilterSheet extends StatefulWidget {
  const MerchantFilterSheet({
    super.key,
    required this.initialParams,
    required this.onApply,
  });

  final MerchantFilterParams initialParams;
  final ValueChanged<MerchantFilterParams> onApply;

  @override
  State<MerchantFilterSheet> createState() => _MerchantFilterSheetState();
}

class _MerchantFilterSheetState extends State<MerchantFilterSheet> {
  late String _state;
  late double? _minRating;
  late bool _verifiedOnly;

  @override
  void initState() {
    super.initState();
    _state = widget.initialParams.state;
    _minRating = widget.initialParams.minRating;
    _verifiedOnly = widget.initialParams.verifiedOnly;
  }

  void _reset() {
    setState(() {
      _state = '';
      _minRating = null;
      _verifiedOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: AppSpacing.avatarRadius,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Businesses',
                style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: _reset,
                child: Text(
                  'Reset',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'State / Hub',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      MerchantStateChip(
                        label: 'All States',
                        isSelected: _state.isEmpty,
                        onTap: () => setState(() => _state = ''),
                      ),
                      ...kAvailableStates.map(
                        (st) => MerchantStateChip(
                          label: st,
                          isSelected: _state == st,
                          onTap: () => setState(() => _state = st),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Minimum Rating',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      MerchantRatingOption(
                        stars: 'Any',
                        isSelected: _minRating == null,
                        onTap: () => setState(() => _minRating = null),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      MerchantRatingOption(
                        stars: '4.0+ ★',
                        isSelected: _minRating == 4.0,
                        onTap: () => setState(() => _minRating = 4.0),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      MerchantRatingOption(
                        stars: '4.5+ ★',
                        isSelected: _minRating == 4.5,
                        onTap: () => setState(() => _minRating = 4.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Verified Vendors Only',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Only show businesses vetted with genuine physical workshops or stores.',
                      style: AppTypography.caption.copyWith(color: AppColors.grey),
                    ),
                    value: _verifiedOnly,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) => setState(() => _verifiedOnly = val),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final updated = widget.initialParams.copyWith(
                  state: _state,
                  minRating: _minRating,
                  verifiedOnly: _verifiedOnly,
                );
                widget.onApply(updated);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppSpacing.borderRadiusMD,
                ),
              ),
              child: Text(
                'Apply Filters',
                style: AppTypography.buttonLarge.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
