import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../shop/domain/shop_entities.dart';
import '../../domain/checkout_entities.dart';

class CheckoutSummaryCard extends StatefulWidget {
  const CheckoutSummaryCard({
    super.key,
    required this.cart,
    this.deliveryMethod,
  });

  final Cart cart;
  final DeliveryMethod? deliveryMethod;

  /// Toggleable VAT configuration. Currently disabled: prices already include VAT.
  /// Preserved for future tax system integration.
  static const bool enableVat = false;

  /// Toggleable shipping configuration for this card. Delivery method is selected
  /// during checkout step 2, so shipping is hidden from this generic summary.
  static const bool enableShipping = false;

  @override
  State<CheckoutSummaryCard> createState() => _CheckoutSummaryCardState();
}

class _CheckoutSummaryCardState extends State<CheckoutSummaryCard> {
  bool _expandedItems = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deliveryFee = widget.deliveryMethod?.cost ?? 0.0;
    final shippingAmount = (CheckoutSummaryCard.enableShipping &&
            widget.deliveryMethod != null)
        ? deliveryFee
        : 0.0;
    final vatAmount = CheckoutSummaryCard.enableVat ? widget.cart.tax : 0.0;
    final grandTotal = widget.cart.subtotal + shippingAmount + vatAmount;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedInvoice01,
                    color: isDark ? AppColors.secondary : AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Order Summary',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _expandedItems = !_expandedItems),
                child: Row(
                  children: [
                    Text(
                      '${widget.cart.itemCount} items',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    Icon(
                      _expandedItems
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_expandedItems) ...[
            const SizedBox(height: AppSpacing.sm),
            Divider(color: isDark ? Colors.white10 : AppColors.border),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.cart.items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, index) {
                  final item = widget.cart.items[index];
                  return Row(
                    children: [
                      AppNetworkImage.product(
                        imageUrl: item.product.images.isNotEmpty
                            ? item.product.images.first
                            : null,
                        width: 32,
                        height: 32,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'x${item.quantity}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        formatNaira(item.itemTotal),
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Divider(color: isDark ? Colors.white10 : AppColors.border),
          const SizedBox(height: AppSpacing.xs),
          _SummaryRow(
            label: 'Subtotal',
            value: formatNaira(widget.cart.subtotal),
          ),
          if (CheckoutSummaryCard.enableShipping &&
              widget.deliveryMethod != null) ...[
            const SizedBox(height: 4),
            _SummaryRow(
              label: 'Delivery Fee',
              value: formatNaira(deliveryFee),
            ),
          ],
          if (CheckoutSummaryCard.enableVat) ...[
            const SizedBox(height: 4),
            _SummaryRow(
              label: 'Estimated VAT (7.5%)',
              value: formatNaira(widget.cart.tax),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedInformationCircle,
                size: 14,
                color: isDark ? Colors.white54 : AppColors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                'Prices include VAT.',
                style: AppTypography.caption.copyWith(
                  color: isDark ? Colors.white60 : AppColors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Divider(color: isDark ? Colors.white10 : AppColors.border),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                formatNaira(grandTotal),
                style: AppTypography.h6.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.secondary : AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.grey),
        ),
        Text(
          value,
          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
