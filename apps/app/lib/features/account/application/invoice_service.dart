import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../domain/customer_order.dart';
import '../domain/order_invoice_model.dart';

export '../domain/order_invoice_model.dart';

/// Views, downloads, and shares order invoices from the backend endpoints:
/// - View: GET /api/v1/invoices/orders/{orderId}
/// - Download: GET /api/v1/invoices/orders/{orderId}/download
class InvoiceService {
  InvoiceService._();

  static Future<OrderInvoice> fetchOrderInvoice(
    String orderId, {
    WidgetRef? ref,
    Dio? dioClient,
  }) async {
    if (AppConfig.isMockMode && dioClient == null) {
      await Future.delayed(const Duration(milliseconds: 250));
      final parsedId = int.tryParse(orderId) ?? 1814;
      return OrderInvoice(
        id: 1,
        orderId: parsedId,
        customerId: 4,
        invoiceNumber: 'INV-$parsedId-1793838157748',
        status: 'issued',
        subtotal: 0.0,
        discountAmount: 0.0,
        deliveryAmount: 0.0,
        taxAmount: 0.0,
        totalAmount: 26900.0,
        currency: 'NGN',
        customerName: 'Bro David Enabs',
        customerEmail: 'c-davidenabs@gmail.com',
        issuedAt: DateTime.now(),
      );
    }

    final Dio dio = dioClient ?? (ref != null ? ref.read(dioProvider) : Dio());
    final endpoint = ApiEndpoints.invoices.byOrderId(orderId);
    AppLogger.d('GET $endpoint (view order invoice)');

    try {
      final response = await dio.get(endpoint);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return OrderInvoice.fromJson(body);
      }
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Unexpected invoice response format.',
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch order invoice', error: e);
      throw ApiError.fromDio(e);
    }
  }

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

      final endpoint = ApiEndpoints.invoices.downloadByOrderId(order.id);
      AppLogger.d('GET $endpoint (download invoice PDF)');

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
