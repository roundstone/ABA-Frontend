import 'package:dio/dio.dart';
import '../../../../core/config/paystack_config.dart';
import '../../../../core/logging/app_logger.dart';
import 'paystack_payment_models.dart';

export 'paystack_payment_models.dart';

class PaystackChargeService {
  PaystackChargeService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.paystack.co',
                headers: {
                  'Authorization': 'Bearer ${PaystackConfig.secretKey}',
                  'Content-Type': 'application/json',
                },
                connectTimeout: const Duration(seconds: 25),
                receiveTimeout: const Duration(seconds: 25),
              ),
            );

  final Dio _dio;

  /// Initializes a Paystack transaction returning an authorization URL
  /// supporting all channels (Card, OPay, Bank Transfer, USSD, etc.).
  Future<PaystackInitResult> initializeTransaction({
    required double amount,
    required String email,
    String? callbackUrl,
    List<String>? channels,
  }) async {
    final amountInKobo = (amount * 100).round();
    final payload = {
      'email': email.trim(),
      'amount': amountInKobo.toString(),
      'currency': 'NGN',
      'callback_url': callbackUrl ?? 'https://standard.paystack.co/close',
      'channels': channels ??
          [
            'card',
            'bank',
            'ussd',
            'qr',
            'mobile_money',
            'bank_transfer',
          ],
    };

    final res = await _dio.post('/transaction/initialize', data: payload);
    final data = (res.data is Map ? res.data['data'] : null) as Map<String, dynamic>? ?? {};
    return PaystackInitResult(
      authorizationUrl: data['authorization_url'] as String? ?? '',
      accessCode: data['access_code'] as String? ?? '',
      reference: data['reference'] as String? ?? '',
    );
  }

  Future<PaystackChargeResult> chargeCard({
    required double amount,
    required String email,
    required String cardNumber,
    required String expiry,
    required String cvv,
  }) async {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    final parts = expiry.split('/');
    final month = parts.isNotEmpty ? parts[0].trim().padLeft(2, '0') : '12';
    var year = parts.length > 1 ? parts[1].trim() : '30';
    if (year.length == 2) year = '20$year';

    final amountInKobo = (amount * 100).round();

    final payload = {
      'email': email.trim(),
      'amount': amountInKobo.toString(),
      'card': {
        'number': cleanNumber,
        'cvv': cvv.trim(),
        'expiry_month': month,
        'expiry_year': year,
      },
    };

    try {
      final res = await _dio.post('/charge', data: payload);
      return _parseChargeResponse(res.data);
    } on DioException catch (e) {
      AppLogger.w('Paystack charge error: ${e.response?.data ?? e.message}');
      final msg = _extractErrorMessage(e);
      return PaystackChargeResult(
        status: PaystackStepStatus.failed,
        reference: '',
        message: msg,
      );
    } catch (e) {
      return PaystackChargeResult(
        status: PaystackStepStatus.failed,
        reference: '',
        message: e.toString(),
      );
    }
  }

  Future<PaystackChargeResult> submitOtp({
    required String reference,
    required String otp,
  }) async {
    try {
      final res = await _dio.post('/charge/submit_otp', data: {
        'reference': reference,
        'otp': otp.trim(),
      });
      return _parseChargeResponse(res.data);
    } on DioException catch (e) {
      final msg = _extractErrorMessage(e);
      return PaystackChargeResult(
        status: PaystackStepStatus.failed,
        reference: reference,
        message: msg,
      );
    } catch (e) {
      return PaystackChargeResult(
        status: PaystackStepStatus.failed,
        reference: reference,
        message: e.toString(),
      );
    }
  }

  Future<PaystackChargeResult> submitPin({
    required String reference,
    required String pin,
  }) async {
    try {
      final res = await _dio.post('/charge/submit_pin', data: {
        'reference': reference,
        'pin': pin.trim(),
      });
      return _parseChargeResponse(res.data);
    } on DioException catch (e) {
      final msg = _extractErrorMessage(e);
      return PaystackChargeResult(
        status: PaystackStepStatus.failed,
        reference: reference,
        message: msg,
      );
    } catch (e) {
      return PaystackChargeResult(
        status: PaystackStepStatus.failed,
        reference: reference,
        message: e.toString(),
      );
    }
  }

  PaystackChargeResult _parseChargeResponse(dynamic raw) {
    if (raw is! Map) {
      return const PaystackChargeResult(
        status: PaystackStepStatus.failed,
        reference: '',
        message: 'Invalid response from payment gateway.',
      );
    }

    final data = raw['data'] as Map<String, dynamic>? ?? {};
    final statusStr = (data['status'] ?? '').toString().toLowerCase();
    final reference = (data['reference'] ?? '').toString();
    final displayText = data['display_text'] as String?;
    final authUrl = data['url'] as String?;
    final message = (raw['message'] ?? data['message'] ?? '').toString();

    if (statusStr == 'success') {
      return PaystackChargeResult(
        status: PaystackStepStatus.success,
        reference: reference,
        message: message,
      );
    } else if (statusStr == 'send_otp') {
      return PaystackChargeResult(
        status: PaystackStepStatus.sendOtp,
        reference: reference,
        displayText: displayText,
        message: message,
      );
    } else if (statusStr == 'send_pin') {
      return PaystackChargeResult(
        status: PaystackStepStatus.sendPin,
        reference: reference,
        displayText: displayText ?? 'Please enter your 4-digit card PIN',
        message: message,
      );
    } else if (statusStr == 'open_url') {
      return PaystackChargeResult(
        status: PaystackStepStatus.openUrl,
        reference: reference,
        authUrl: authUrl,
        message: message,
      );
    } else {
      final gatewayMsg = data['gateway_response'] as String?;
      final fallbackMsg =
          message.isNotEmpty ? message : 'Payment authorization declined.';
      return PaystackChargeResult(
        status: PaystackStepStatus.failed,
        reference: reference,
        message: gatewayMsg ?? fallbackMsg,
      );
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map;
      return (data['message'] ?? data['data']?['message'] ?? e.message)
          .toString();
    }
    return e.message ?? 'Payment request failed. Check your internet connection.';
  }
}
