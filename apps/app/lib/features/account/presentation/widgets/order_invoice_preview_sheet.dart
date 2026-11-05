import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../application/invoice_service.dart';
import '../../domain/customer_order.dart';

class OrderInvoicePreviewSheet extends ConsumerStatefulWidget {
  const OrderInvoicePreviewSheet({super.key, required this.order});

  final CustomerOrder order;

  static Future<void> show(BuildContext context, CustomerOrder order) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderInvoicePreviewSheet(order: order),
    );
  }

  @override
  ConsumerState<OrderInvoicePreviewSheet> createState() =>
      _OrderInvoicePreviewSheetState();
}

class _OrderInvoicePreviewSheetState
    extends ConsumerState<OrderInvoicePreviewSheet> {
  OrderInvoice? _invoice;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  static final Map<String, OrderInvoice> _invoiceCache = {};

  Future<void> _loadInvoice({bool forceRefresh = false}) async {
    final cached = _invoiceCache[widget.order.id];
    if (!forceRefresh && cached != null) {
      setState(() {
        _invoice = cached;
        _isLoading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final inv = await InvoiceService.fetchOrderInvoice(
        widget.order.id,
        ref: ref,
      );
      _invoiceCache[widget.order.id] = inv;
      if (mounted) {
        setState(() {
          _invoice = inv;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = ApiError.toUserFriendlyMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order Invoice', style: AppTypography.h4),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator.adaptive()),
              )
            else if (_error != null)
              ErrorState(
                message: _error!,
                onRetry: () => _loadInvoice(forceRefresh: true),
              )
            else if (_invoice != null)
              _buildInvoiceContent(context, _invoice!, cs),
            const SizedBox(height: AppSpacing.md),
            AppButton.primary(
              label: 'Download PDF Invoice',
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedDownload01,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                InvoiceService.downloadAndShareInvoice(
                  context,
                  widget.order,
                  ref: ref,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceContent(
    BuildContext context,
    OrderInvoice inv,
    ColorScheme cs,
  ) {
    final dateFmt = DateFormat('MMM d, y • h:mm a');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                inv.invoiceNumber,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                inv.status.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
        if (inv.issuedAt != null) ...[
          const SizedBox(height: 4),
          Text(
            'Issued: ${dateFmt.format(inv.issuedAt!)}',
            style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (inv.customerName != null || inv.customerEmail != null) ...[
          Text(
            'Billed To',
            style: AppTypography.caption.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (inv.customerName != null)
            Text(
              inv.customerName!,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          if (inv.customerEmail != null)
            Text(
              inv.customerEmail!,
              style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
            ),
          if (inv.deliveryAddress != null)
            Text(
              '${inv.deliveryAddress!.street}, ${inv.deliveryAddress!.city}, ${inv.deliveryAddress!.state}',
              style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.sm),
        _row('Subtotal', formatNaira(inv.subtotal), cs),
        if (inv.discountAmount > 0)
          _row('Discount', '-${formatNaira(inv.discountAmount)}', cs),
        _row('Delivery', formatNaira(inv.deliveryAmount), cs),
        _row('Tax', formatNaira(inv.taxAmount), cs),
        const Divider(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formatNaira(inv.totalAmount),
              style: AppTypography.h4.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _row(String label, String value, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
          ),
          Text(value, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

