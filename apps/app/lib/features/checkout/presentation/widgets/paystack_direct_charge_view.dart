import 'package:flutter/material.dart';
import '../../data/paystack_charge_service.dart';
import 'paystack_sheet_form_steps.dart';

enum _DirectStep { card, pin, otp }

/// Fallback native card, PIN and OTP view when offline or direct card charging is preferred.
class PaystackDirectChargeView extends StatefulWidget {
  const PaystackDirectChargeView({
    super.key,
    required this.amount,
    required this.email,
    required this.service,
    required this.onSuccess,
    this.onError,
  });

  final double amount;
  final String email;
  final PaystackChargeService service;
  final ValueChanged<String> onSuccess;
  final ValueChanged<String>? onError;

  @override
  State<PaystackDirectChargeView> createState() =>
      _PaystackDirectChargeViewState();
}

class _PaystackDirectChargeViewState extends State<PaystackDirectChargeView> {
  final _cardNumberCtrl = TextEditingController(text: '4084 0840 0840 0840');
  final _expiryCtrl = TextEditingController(text: '12/30');
  final _cvvCtrl = TextEditingController(text: '408');
  final _pinCtrl = TextEditingController();
  final _otpCtrl = TextEditingController(text: '1234');

  _DirectStep _step = _DirectStep.card;
  bool _isProcessing = false;
  String? _activeReference;
  String? _displayText;

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _pinCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _handlePay() async {
    final cardNo = _cardNumberCtrl.text.replaceAll(RegExp(r'\s+'), '');
    if (cardNo.length < 13) {
      widget.onError?.call('Please enter a valid card number.');
      return;
    }
    setState(() => _isProcessing = true);

    final res = await widget.service.chargeCard(
      amount: widget.amount,
      email: widget.email,
      cardNumber: _cardNumberCtrl.text,
      expiry: _expiryCtrl.text,
      cvv: _cvvCtrl.text,
    );

    if (!mounted) return;
    _handleResult(res);
  }

  Future<void> _handleSubmitPin() async {
    if (_pinCtrl.text.trim().length < 4) {
      widget.onError?.call('Please enter your 4-digit PIN.');
      return;
    }
    setState(() => _isProcessing = true);

    final res = await widget.service.submitPin(
      reference: _activeReference!,
      pin: _pinCtrl.text,
    );
    if (!mounted) return;
    _handleResult(res);
  }

  Future<void> _handleSubmitOtp() async {
    if (_otpCtrl.text.trim().isEmpty) {
      widget.onError?.call('Please enter the authorization OTP.');
      return;
    }
    setState(() => _isProcessing = true);

    final res = await widget.service.submitOtp(
      reference: _activeReference!,
      otp: _otpCtrl.text,
    );
    if (!mounted) return;
    _handleResult(res);
  }

  void _handleResult(PaystackChargeResult res) {
    setState(() => _isProcessing = false);
    if (res.isSuccess) {
      widget.onSuccess(res.reference);
      return;
    }
    _activeReference =
        res.reference.isNotEmpty ? res.reference : _activeReference;
    if (res.isPinRequired) {
      setState(() {
        _step = _DirectStep.pin;
        _displayText = res.displayText;
      });
    } else if (res.isOtpRequired) {
      setState(() {
        _step = _DirectStep.otp;
        _displayText = res.displayText;
      });
    } else {
      widget.onError?.call(res.message ?? 'Payment failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _step == _DirectStep.card
          ? PaystackCardStepForm(
              cardNumberCtrl: _cardNumberCtrl,
              expiryCtrl: _expiryCtrl,
              cvvCtrl: _cvvCtrl,
              isProcessing: _isProcessing,
              amount: widget.amount,
              onPay: _handlePay,
            )
          : _step == _DirectStep.pin
              ? PaystackPinStepForm(
                  pinCtrl: _pinCtrl,
                  displayText: _displayText,
                  isProcessing: _isProcessing,
                  onSubmit: _handleSubmitPin,
                )
              : PaystackOtpStepForm(
                  otpCtrl: _otpCtrl,
                  displayText: _displayText,
                  isProcessing: _isProcessing,
                  onSubmit: _handleSubmitOtp,
                ),
    );
  }
}

