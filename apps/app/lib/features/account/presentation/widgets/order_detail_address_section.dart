import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/customer_order.dart';

class OrderDetailAddressSection extends StatelessWidget {
  const OrderDetailAddressSection({super.key, required this.address});

  final ShippingAddress address;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Address',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedLocation01,
                  color: cs.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address.fullName.isNotEmpty)
                      Text(
                        address.fullName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (address.street.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        address.street,
                        style: AppTypography.caption.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (address.city.isNotEmpty || address.state.isNotEmpty) ...[
                      Text(
                        [address.city, address.state, address.zipCode]
                            .where((s) => s.isNotEmpty)
                            .join(', '),
                        style: AppTypography.caption.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (address.phone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        address.phone,
                        style: AppTypography.caption.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

