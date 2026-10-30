import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../shop/domain/shop_entities.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onDecrease,
    required this.onIncrease,
  });

  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = item.product;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusMD,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          AppNetworkImage.product(
            imageUrl: p.imageUrl,
            width: 72,
            height: 72,
            borderRadius: AppSpacing.borderRadiusSM,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (item.selectedColor != null || item.selectedSize != null)
                  Text(
                    [
                      if (item.selectedColor != null) item.selectedColor!,
                      if (item.selectedSize != null) 'Size ${item.selectedSize}',
                    ].join(' · '),
                    style: AppTypography.label.copyWith(color: cs.onSurface.withAlpha(130)),
                  ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      formatNaira(p.discountedPrice),
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    _QtyStepper(
                      quantity: item.quantity,
                      onDecrease: onDecrease,
                      onIncrease: onIncrease,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.xs),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedDelete02,
                size: AppSpacing.iconSizeSM,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : cs.surfaceContainerHighest,
        borderRadius: AppSpacing.borderRadiusSM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(icon: HugeIcons.strokeRoundedMinusSign, onTap: onDecrease),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              '$quantity',
              style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _StepBtn(icon: HugeIcons.strokeRoundedPlusSign, onTap: onIncrease),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final List<List<dynamic>> icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs + 2),
        child: HugeIcon(icon: icon, size: 14, color: cs.primary),
      ),
    );
  }
}

