import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/checkout/data/paystack_charge_service.dart';
import 'package:app/features/checkout/presentation/widgets/paystack_direct_charge_view.dart';
import 'package:app/features/checkout/presentation/widgets/paystack_payment_sheet.dart';

void main() {
  group('Paystack Direct Charge & Fallback Widget Tests', () {
    testWidgets('PaystackDirectChargeView transitions to OTP and invokes onSuccess', (tester) async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.paystack.co'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/charge') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'status': true,
                    'data': {
                      'status': 'send_otp',
                      'reference': 'pstk_real_ref_999',
                      'display_text': 'Please enter the OTP sent to your phone',
                    },
                  },
                ),
              );
            }
            if (options.path == '/charge/submit_otp') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'status': true,
                    'data': {
                      'status': 'success',
                      'reference': 'pstk_real_ref_999',
                    },
                  },
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      String? capturedRef;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PaystackDirectChargeView(
                amount: 25000,
                email: 'customer@aba.ng',
                service: PaystackChargeService(dio: dio),
                onSuccess: (ref) => capturedRef = ref,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.textContaining('Pay ₦'), findsWidgets);

      // Tap Pay button
      await tester.tap(find.textContaining('Pay ₦').last);
      await tester.pumpAndSettle();

      // Verified transition to OTP step
      expect(find.text('One-Time Password (OTP)'), findsOneWidget);

      // Tap Authorize Payment button
      await tester.tap(find.text('Authorize Payment'));
      await tester.pumpAndSettle();

      // Successfully returned the authentic reference from Paystack
      expect(capturedRef, equals('pstk_real_ref_999'));
    });

    testWidgets('PaystackPaymentSheet falls back to direct card charge on init error', (tester) async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.paystack.co'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/transaction/initialize') {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Connection error',
                  type: DioExceptionType.connectionError,
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PaystackPaymentSheet(
                amount: 15000,
                email: 'buyer@aba.ng',
                chargeService: PaystackChargeService(dio: dio),
                onSuccess: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Verifies fallback renders header and card direct entry form
      expect(find.text('paystack'), findsOneWidget);
      expect(find.textContaining('15,000'), findsWidgets);
      expect(find.text('Card Number'), findsOneWidget);
    });
  });
}
