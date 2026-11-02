import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/customer_order.dart';

class OrderDetailAddressSection extends StatelessWidget {
  const OrderDetailAddressSection({
    super.key,
    required this.address,
    this.deliveryMethod = 'standard',
  });

  final ShippingAddress address;
  final String deliveryMethod;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpress = deliveryMethod.toLowerCase() == 'express';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery & Destination',
                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              if (address.label != null && address.label!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    address.label!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedLocation01,
                  color: cs.onSurfaceVariant,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address.fullName.isNotEmpty)
                      Text(
                        address.fullName,
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                    if (address.street.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        address.street,
                        style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                    if (address.city.isNotEmpty || address.state.isNotEmpty) ...[
                      Text(
                        [address.city, address.state, address.zipCode]
                            .where((s) => s.isNotEmpty)
                            .join(', '),
                        style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                    if (address.phone.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        address.phone,
                        style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : AppColors.surface2,
              borderRadius: AppSpacing.borderRadiusSM,
            ),
            child: Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedDeliveryBox01,
                  size: 16,
                  color: isExpress ? AppColors.secondary : AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    isExpress
                        ? 'Express Dispatch (within 24-48 hours)'
                        : 'Standard Ground Delivery (3-5 business days)',
                    style: AppTypography.caption.copyWith(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
