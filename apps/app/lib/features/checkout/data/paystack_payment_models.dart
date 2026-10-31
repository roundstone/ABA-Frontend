enum PaystackStepStatus {
  success,
  sendOtp,
  sendPin,
  openUrl,
  failed,
}

class PaystackChargeResult {
  const PaystackChargeResult({
    required this.status,
    required this.reference,
    this.message,
    this.displayText,
    this.authUrl,
  });

  final PaystackStepStatus status;
  final String reference;
  final String? message;
  final String? displayText;
  final String? authUrl;

  bool get isSuccess => status == PaystackStepStatus.success;
  bool get isOtpRequired => status == PaystackStepStatus.sendOtp;
  bool get isPinRequired => status == PaystackStepStatus.sendPin;
  bool get isOpenUrl => status == PaystackStepStatus.openUrl;
}

class PaystackInitResult {
  const PaystackInitResult({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  final String authorizationUrl;
  final String accessCode;
  final String reference;
}

