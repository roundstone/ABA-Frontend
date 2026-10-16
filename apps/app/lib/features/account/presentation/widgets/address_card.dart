import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../checkout/domain/checkout_entities.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
    required this.isDark,
    required this.onSetDefault,
    required this.onDelete,
  });

  final CheckoutAddress address;
  final bool isDark;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(
          color: address.isDefault
              ? AppColors.primary
              : (isDark ? Colors.white12 : AppColors.border),
          width: address.isDefault ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedLocation01,
                color: address.isDefault ? AppColors.primary : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                address.label,
                style: AppTypography.titleSmall
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (address.isDefault)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Default',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                )
              else
                TextButton(
                  onPressed: onSetDefault,
                  child: const Text('Set Default',
                      style: TextStyle(fontSize: 11)),
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(address.street, style: AppTypography.bodySmall),
          Text('${address.city}, ${address.state} ${address.zipCode}',
              style: AppTypography.caption),
          const SizedBox(height: 4),
          Text(address.phone,
              style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
