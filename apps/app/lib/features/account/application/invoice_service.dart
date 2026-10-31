import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_error.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../domain/customer_order.dart';
import '../domain/invoice_pdf_generator.dart';

class InvoiceService {
  InvoiceService._();

  static Future<void> downloadAndShareInvoice(
    BuildContext context,
    CustomerOrder order,
  ) async {
    try {
      AppSnackbar.show(
        context,
        message: 'Generating transaction invoice PDF...',
        type: AppSnackbarType.info,
      );

      final pdfBytes = await InvoicePdfGenerator.generate(order);

      final dir = await getApplicationDocumentsDirectory();
      final safeNumber = order.orderNumber.replaceAll(
        RegExp(r'[^a-zA-Z0-9_-]'),
        '_',
      );
      final filename = 'BuyNaija_Invoice_$safeNumber.pdf';
      final file = File('${dir.path}/$filename');

      await file.writeAsBytes(pdfBytes);
      AppLogger.d('Invoice PDF generated at: ${file.path}');

      if (context.mounted) {
        AppSnackbar.show(
          context,
          message: 'Invoice ready. Opening download options...',
          type: AppSnackbarType.success,
        );
      }

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(file.path, mimeType: 'application/pdf', name: filename),
          ],
          text: 'BuyNaija Invoice #${order.orderNumber}',
          subject: 'BuyNaija Invoice #${order.orderNumber}',
          title: 'BuyNaija Invoice #${order.orderNumber}',
        ),
      );
    } catch (e, stack) {
      AppLogger.e('Failed to generate or share invoice PDF', error: e, stackTrace: stack);
      if (context.mounted) {
        AppSnackbar.show(
          context,
          message: 'Could not generate invoice: ${ApiError.toUserFriendlyMessage(e)}',
          type: AppSnackbarType.error,
        );
      }
    }
  }
}
