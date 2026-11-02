import 'package:app/core/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/customer_order.dart';

class OrderDetailItemsSection extends StatelessWidget {
  const OrderDetailItemsSection({super.key, required this.items});

  final List<OrderItem> items;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat('#,##0.00');

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items in Order',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                  style: AppTypography.caption.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              final totalPrice =
                  item.totalPrice ?? (item.price * item.quantity);
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 60,
                        height: 60,
                        color: cs.surfaceContainerHighest,
                        child: AppNetworkImage.product(
                          imageUrl: item.imageUrl,
                          width: 20,
                          height: 20,
                          borderRadius: AppSpacing.borderRadiusSM,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.productName,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              _ItemStatusBadge(
                                status: item.status,
                                isDark: isDark,
                              ),
                            ],
                          ),
                          if (item.variantName != null &&
                              item.variantName!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.variantName!,
                              style: AppTypography.caption.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                          if (item.attributes != null &&
                              item.attributes!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.attributes!.entries
                                  .map((e) => '${e.key}: ${e.value}')
                                  .join(' • '),
                              style: AppTypography.caption.copyWith(
                                color: cs.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                          if (item.sku != null && item.sku!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'SKU: ${item.sku}',
                              style: AppTypography.caption.copyWith(
                                color: cs.onSurfaceVariant,
                                fontSize: 10,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Qty: ${item.quantity} × ₦${formatter.format(item.price / 100.0)}',
                                style: AppTypography.caption.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '₦${formatter.format(totalPrice / 100.0)}',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ItemStatusBadge extends StatelessWidget {
  const _ItemStatusBadge({required this.status, required this.isDark});

  final String status;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'delivered':
        bg = isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
        fg = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF15803D);
        break;
      case 'shipped':
        bg = isDark ? const Color(0xFF0F2B2A) : const Color(0xFFE6E1D8);
        fg = isDark ? const Color(0xFF5EEAD4) : const Color(0xFF172A1D);
        break;
      case 'processing':
        bg = isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF);
        fg = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);
        break;
      case 'cancelled':
        bg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEF2F2);
        fg = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB42318);
        break;
      default:
        bg = isDark ? const Color(0xFF4A2B0F) : const Color(0xFFFEF3C7);
        fg = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}
