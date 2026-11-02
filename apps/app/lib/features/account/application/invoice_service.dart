import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../domain/customer_order.dart';

/// Downloads and shares order invoices from the backend endpoint:
/// GET /api/v1/orders/mobile-app/{id}/invoice
class InvoiceService {
  InvoiceService._();

  static Future<void> downloadAndShareInvoice(
    BuildContext context,
    CustomerOrder order, {
    WidgetRef? ref,
    Dio? dioClient,
  }) async {
    try {
      AppSnackbar.show(
        context,
        message: 'Fetching order invoice...',
        type: AppSnackbarType.info,
      );

      final Dio dio;
      if (dioClient != null) {
        dio = dioClient;
      } else if (ref != null) {
        dio = ref.read(dioProvider);
      } else {
        dio = Dio();
      }

      final endpoint = ApiEndpoints.orders.invoice(order.id);
      AppLogger.d('GET $endpoint (download invoice)');

      final response = await dio.get<List<int>>(
        endpoint,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      final rawBytes = response.data;
      if (rawBytes == null || rawBytes.isEmpty) {
        throw Exception('Received empty invoice data from server');
      }

      List<int>? pdfBytes;

      // Handle case where server returns a JSON response containing a download URL
      if (rawBytes.isNotEmpty && rawBytes.first == 123 /* '{' */) {
        try {
          final jsonStr = utf8.decode(rawBytes);
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map) {
            final data = decoded['data'];
            final downloadUrl = data is Map
                ? (data['url'] ??
                    data['invoice_url'] ??
                    data['pdfUrl'] ??
                    data['downloadUrl'])
                : data;

            if (downloadUrl is String && downloadUrl.startsWith('http')) {
              AppLogger.d('Downloading invoice binary from URL: $downloadUrl');
              final fileResponse = await dio.get<List<int>>(
                downloadUrl,
                options: Options(responseType: ResponseType.bytes),
              );
              pdfBytes = fileResponse.data;
            }
          }
        } catch (_) {
          pdfBytes = rawBytes;
        }
      }

      pdfBytes ??= rawBytes;

      final dir = await getApplicationDocumentsDirectory();
      final safeNumber = order.orderNumber.replaceAll(
        RegExp(r'[^a-zA-Z0-9_-]'),
        '_',
      );
      final filename = 'BuyNaija_Invoice_$safeNumber.pdf';
      final file = File('${dir.path}/$filename');

      await file.writeAsBytes(pdfBytes);
      AppLogger.d('Order invoice saved to: ${file.path}');

      if (context.mounted) {
        AppSnackbar.show(
          context,
          message: 'Invoice ready. Opening share/download options...',
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
      AppLogger.e('Failed to download order invoice',
          error: e, stackTrace: stack);
      if (context.mounted) {
        AppSnackbar.show(
          context,
          message:
              'Could not download invoice: ${ApiError.toUserFriendlyMessage(e)}',
          type: AppSnackbarType.error,
        );
      }
    }
  }
}
