import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../account/domain/customer_order.dart';
import 'widgets/order_success_timeline.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  const CheckoutSuccessScreen({super.key, this.order});

  final CustomerOrder? order;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orderId = order?.orderNumber.isNotEmpty == true
        ? order!.orderNumber
        : (order?.id.isNotEmpty == true ? order!.id : '-');
    final totalInNaira = (order?.total ?? 0) / 100.0;
    final fullName = order?.shippingAddress.fullName ?? '';
    final street = order?.shippingAddress.street ?? '';
    final city = order?.shippingAddress.city ?? '';
    final state = order?.shippingAddress.state ?? '';
    final addressText =
        [street, city, state].where((s) => s.isNotEmpty).join(', ');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/shop'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(25),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.success.withAlpha(80),
                  width: 3,
                ),
              ),
              child: const Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                  color: AppColors.success,
                  size: 44,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Order Confirmed!',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Thank you for your purchase. Your order has been placed successfully.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: AppSpacing.borderRadiusLG,
                border: Border.all(
                  color: isDark ? Colors.white12 : AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Number',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          Text(
                            orderId,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Paid',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          Text(
                            formatNaira(totalInNaira),
                            style: AppTypography.bodyLarge.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.secondary
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (fullName.isNotEmpty || addressText.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Divider(color: isDark ? Colors.white10 : AppColors.border),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation01,
                          color:
                              isDark ? AppColors.secondary : AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (fullName.isNotEmpty)
                                Text(
                                  fullName,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              if (addressText.isNotEmpty)
                                Text(
                                  addressText,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  const OrderSuccessTimeline(),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              label: 'View Order Details',
              onPressed: () {
                if (order?.id != null && order!.id.isNotEmpty) {
                  context.push('/account/orders/${order!.id}');
                } else {
                  context.go('/account/orders');
                }
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.outlined(
              label: 'Continue Shopping',
              onPressed: () {
                context.go('/shop');
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
