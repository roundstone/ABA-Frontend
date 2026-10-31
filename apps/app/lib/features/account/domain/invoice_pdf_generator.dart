import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'customer_order.dart';
import 'invoice_pdf_components.dart';

class InvoicePdfGenerator {
  static const PdfColor racingGreen = InvoicePdfComponents.racingGreen;
  static const PdfColor warmLinen = InvoicePdfComponents.warmLinen;
  static const PdfColor copper = InvoicePdfComponents.copper;
  static const PdfColor textDark = InvoicePdfComponents.textDark;
  static const PdfColor textMuted = InvoicePdfComponents.textMuted;
  static const PdfColor borderLight = InvoicePdfComponents.borderLight;
  static const PdfColor successGreen = PdfColor.fromInt(0xFF15803D);

  static Future<Uint8List> generate(CustomerOrder order) async {
    final pdf = pw.Document();
    final formatter = NumberFormat('#,##0.00');
    final formattedDate = DateFormat('MMMM d, yyyy h:mm a').format(order.date);

    final subtotal = order.items.fold<int>(
      0,
      (acc, item) => acc + (item.price * item.quantity),
    );
    final deliveryFee = (order.total - subtotal).clamp(0, 999999999);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildHeader(order),
              pw.SizedBox(height: 16),
              _buildOrderInfoCard(order, formattedDate),
              pw.SizedBox(height: 16),
              InvoicePdfComponents.buildItemsTable(order, formatter),
              pw.SizedBox(height: 16),
              InvoicePdfComponents.buildSummary(
                order,
                subtotal,
                deliveryFee,
                formatter,
              ),
              pw.Spacer(),
              InvoicePdfComponents.buildFooter(order),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(CustomerOrder order) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const pw.BoxDecoration(
        color: racingGreen,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'BUYNAIJA',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Shop Local, BuyNaija - Official Order Invoice',
                style: const pw.TextStyle(
                  color: warmLinen,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: const pw.BoxDecoration(
                  color: warmLinen,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(12)),
                ),
                child: pw.Text(
                  order.isUnpaid ? 'UNPAID' : order.status.label.toUpperCase(),
                  style: pw.TextStyle(
                    color: order.isUnpaid ? copper : successGreen,
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Order #${order.orderNumber}',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildOrderInfoCard(
    CustomerOrder order,
    String formattedDate,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: warmLinen,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: borderLight),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DELIVERY ADDRESS',
                  style: pw.TextStyle(
                    color: textMuted,
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  order.shippingAddress.fullName.isNotEmpty
                      ? order.shippingAddress.fullName
                      : 'Customer',
                  style: pw.TextStyle(
                    color: textDark,
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (order.shippingAddress.street.isNotEmpty)
                  pw.Text(
                    order.shippingAddress.street,
                    style: const pw.TextStyle(color: textMuted, fontSize: 9),
                  ),
                pw.Text(
                  [
                    order.shippingAddress.city,
                    order.shippingAddress.state,
                    order.shippingAddress.zipCode,
                  ].where((s) => s.isNotEmpty).join(', '),
                  style: const pw.TextStyle(color: textMuted, fontSize: 9),
                ),
                if (order.shippingAddress.phone.isNotEmpty)
                  pw.Text(
                    'Tel: ${order.shippingAddress.phone}',
                    style: const pw.TextStyle(color: textMuted, fontSize: 9),
                  ),
              ],
            ),
          ),
          pw.SizedBox(width: 16),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'TRANSACTION DETAILS',
                  style: pw.TextStyle(
                    color: textMuted,
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Placed: $formattedDate',
                  style: const pw.TextStyle(color: textDark, fontSize: 9),
                ),
                pw.Text(
                  'Payment Method: ${order.paymentMethod}',
                  style: const pw.TextStyle(color: textDark, fontSize: 9),
                ),
                if (order.payments.isNotEmpty &&
                    order.payments.first.reference != null)
                  pw.Text(
                    'Ref: ${order.payments.first.reference}',
                    style: const pw.TextStyle(color: textMuted, fontSize: 9),
                  ),
                pw.Text(
                  'Payment State: ${order.paymentState.toUpperCase()}',
                  style: pw.TextStyle(
                    color: order.isUnpaid ? copper : successGreen,
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
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
