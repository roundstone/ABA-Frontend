import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'customer_order.dart';

class InvoicePdfComponents {
  static const PdfColor racingGreen = PdfColor.fromInt(0xFF172A1D);
  static const PdfColor warmLinen = PdfColor.fromInt(0xFFFDFAF1);
  static const PdfColor copper = PdfColor.fromInt(0xFFBD8939);
  static const PdfColor textDark = PdfColor.fromInt(0xFF111827);
  static const PdfColor textMuted = PdfColor.fromInt(0xFF5B6472);
  static const PdfColor borderLight = PdfColor.fromInt(0xFFE3E6EB);

  static pw.Widget buildItemsTable(
    CustomerOrder order,
    NumberFormat formatter,
  ) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(color: borderLight, width: 0.5),
      headerStyle: pw.TextStyle(
        color: textDark,
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: const pw.BoxDecoration(color: warmLinen),
      cellStyle: const pw.TextStyle(color: textDark, fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
      headerAlignment: pw.Alignment.centerLeft,
      columnWidths: {
        0: const pw.FlexColumnWidth(4),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(2),
      },
      headers: ['ITEM DESCRIPTION', 'QTY', 'UNIT PRICE', 'AMOUNT'],
      data: order.items.map((item) {
        final variantSuffix =
            item.variantName != null && item.variantName!.isNotEmpty
                ? ' (${item.variantName})'
                : '';
        final lineTotal = item.totalPrice ?? (item.price * item.quantity);
        return [
          '${item.productName}$variantSuffix',
          '${item.quantity}',
          'NGN ${formatter.format(item.price / 100.0)}',
          'NGN ${formatter.format(lineTotal / 100.0)}',
        ];
      }).toList(),
    );
  }

  static pw.Widget buildSummary(
    CustomerOrder order,
    int subtotal,
    int deliveryFee,
    NumberFormat formatter,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 220,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            border: pw.Border.all(color: borderLight),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildSummaryRow(
                'Subtotal',
                'NGN ${formatter.format(subtotal / 100.0)}',
              ),
              pw.SizedBox(height: 4),
              _buildSummaryRow(
                'Delivery Fee',
                'NGN ${formatter.format(deliveryFee / 100.0)}',
              ),
              pw.Divider(color: borderLight, thickness: 0.5),
              _buildSummaryRow(
                'Total Amount',
                'NGN ${formatter.format(order.total / 100.0)}',
                isBold: true,
                color: racingGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    PdfColor? color,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            color: color ?? (isBold ? textDark : textMuted),
            fontSize: isBold ? 10 : 9,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: color ?? textDark,
            fontSize: isBold ? 11 : 9,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  static pw.Widget buildFooter(CustomerOrder order) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: borderLight, width: 0.5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'Thank you for shopping on BuyNaija!',
            style: pw.TextStyle(
              color: racingGreen,
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'The premier marketplace and community platform connecting buyers and merchants across Nigeria.',
            style: const pw.TextStyle(color: textMuted, fontSize: 8),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Support: support@buynaija.com | (c) 2026 BuyNaija Ltd.',
            style: const pw.TextStyle(color: textMuted, fontSize: 8),
          ),
        ],
      ),
    );
  }
}

