import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MerchantQuickActions extends StatelessWidget {
  const MerchantQuickActions({
    super.key,
    required this.onAddProduct,
  });

  final VoidCallback onAddProduct;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionButton(
            icon: HugeIcons.strokeRoundedQrCode,
            label: 'POS Register',
            color: const Color(0xFF10B981),
            onTap: () => context.push('/merchant/pos'),
          ),
          _ActionButton(
            icon: HugeIcons.strokeRoundedAddCircle,
            label: 'Add Product',
            color: isDark ? AppColors.secondary : AppColors.primary,
            onTap: onAddProduct,
          ),
          _ActionButton(
            icon: HugeIcons.strokeRoundedShoppingBag01,
            label: 'Orders',
            color: const Color(0xFF2563EB),
            onTap: () => context.push('/merchant/orders'),
          ),
          _ActionButton(
            icon: HugeIcons.strokeRoundedLayers01,
            label: 'Catalog',
            color: const Color(0xFF9333EA),
            onTap: () => context.push('/merchant/products'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final List<List<dynamic>> icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMD,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withAlpha(isDark ? 40 : 20),
                borderRadius: AppSpacing.borderRadiusMD,
              ),
              child: Center(
                child: HugeIcon(
                  icon: icon,
                  size: 20,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
