import 'package:flutter/material.dart';
import '../../../../core/config/paystack_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/paystack_charge_service.dart';
import '../../domain/payment_gateway.dart';
import 'paystack_direct_charge_view.dart';
import 'paystack_sheet_form_steps.dart';
import 'paystack_webview_container.dart';

/// Modal bottom sheet embedding Paystack's official multi-channel checkout
/// (supporting Card, OPay, Bank Transfer, USSD, Apple Pay) with native fallback.
class PaystackPaymentSheet extends StatefulWidget {
  const PaystackPaymentSheet({
    super.key,
    required this.amount,
    required this.email,
    required this.onSuccess,
    this.onCancelled,
    this.authorizationUrl,
    this.reference,
    this.orderId,
    this.gatewayService,
    this.chargeService,
  });

  final double amount;
  final String email;
  final ValueChanged<String> onSuccess;
  final VoidCallback? onCancelled;
  final String? authorizationUrl;
  final String? reference;
  final dynamic orderId;
  final PaymentGatewayService? gatewayService;
  final PaystackChargeService? chargeService;

  static Future<String?> show(
    BuildContext context, {
    required double amount,
    required String email,
    String? authorizationUrl,
    String? reference,
    dynamic orderId,
    PaymentGatewayService? gatewayService,
    PaystackChargeService? chargeService,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaystackPaymentSheet(
        amount: amount,
        email: email,
        authorizationUrl: authorizationUrl,
        reference: reference,
        orderId: orderId,
        gatewayService: gatewayService,
        chargeService: chargeService,
        onSuccess: (ref) => Navigator.of(ctx).pop(ref),
        onCancelled: () => Navigator.of(ctx).pop(null),
      ),
    );
  }

  @override
  State<PaystackPaymentSheet> createState() => _PaystackPaymentSheetState();
}

class _PaystackPaymentSheetState extends State<PaystackPaymentSheet> {
  late final PaystackChargeService _service;
  bool _isInitializing = true;
  String? _errorMessage;
  String? _authorizationUrl;
  String? _initialReference;

  @override
  void initState() {
    super.initState();
    _service = widget.chargeService ?? PaystackChargeService();
    _initMultiChannelCheckout();
  }

  Future<void> _initMultiChannelCheckout() async {
    // 1. Direct authorizationUrl from backend
    if (widget.authorizationUrl != null &&
        widget.authorizationUrl!.isNotEmpty) {
      setState(() {
        _authorizationUrl = widget.authorizationUrl;
        _initialReference = widget.reference;
        _isInitializing = false;
      });
      return;
    }

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    // 2. Initialize through decoupled backend gateway service
    if (widget.orderId != null && widget.gatewayService != null) {
      try {
        final res = await widget.gatewayService!.initializePayment(
          orderId: widget.orderId,
          amount: widget.amount,
          email: widget.email,
        );
        if (!mounted) return;
        if (res.authorizationUrl.isNotEmpty) {
          setState(() {
            _authorizationUrl = res.authorizationUrl;
            _initialReference = res.reference;
            _isInitializing = false;
          });
          return;
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isInitializing = false;
        });
        return;
      }
    }

    // 3. Direct paystack fallback
    try {
      final init = await _service.initializeTransaction(
        amount: widget.amount,
        email: widget.email,
      );
      if (!mounted) return;
      if (init.authorizationUrl.isNotEmpty) {
        setState(() {
          _authorizationUrl = init.authorizationUrl;
          _initialReference = init.reference;
          _isInitializing = false;
        });
        return;
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isInitializing = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTestMode = PaystackConfig.publicKey.startsWith('pk_test');
    final screenHeight = MediaQuery.of(context).size.height;

    final isMultiChannelActive = _authorizationUrl != null;
    final sheetHeight = isMultiChannelActive ? screenHeight * 0.85 : null;

    return Container(
      height: sheetHeight,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize:
            isMultiChannelActive ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaystackSheetHeader(
            email: widget.email,
            amount: widget.amount,
            isTestMode: isTestMode,
            onCancelled: widget.onCancelled,
          ),
          if (_errorMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ),
          Expanded(
            flex: isMultiChannelActive ? 1 : 0,
            child: _buildBody(),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Center(
            child: Text(
              'Secured by Paystack • 256-bit SSL',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isInitializing) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (_authorizationUrl != null) {
      return PaystackWebviewContainer(
        authorizationUrl: _authorizationUrl!,
        initialReference: _initialReference ?? '',
        onSuccess: widget.onSuccess,
        onClose: widget.onCancelled ?? () => Navigator.of(context).pop(),
        onError: (err) {
          if (mounted) {
            setState(() {
              _authorizationUrl = null;
              _errorMessage =
                  'Web checkout unavailable. You can pay with your card below.';
            });
          }
        },
      );
    }
    return PaystackDirectChargeView(
      amount: widget.amount,
      email: widget.email,
      service: _service,
      onSuccess: widget.onSuccess,
      onError: (msg) => setState(() => _errorMessage = msg),
    );
  }
}
