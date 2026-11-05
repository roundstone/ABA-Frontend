// Payout, withdrawal, and user bank account domain models for the mobile app.

class BankOption {
  const BankOption({
    required this.name,
    required this.code,
    this.active = true,
  });

  final String name;
  final String code;
  final bool active;

  factory BankOption.fromJson(Map<String, dynamic> json) {
    return BankOption(
      name: (json['name'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      active: json['active'] as bool? ?? true,
    );
  }
}

class UserBankAccount {
  const UserBankAccount({
    required this.id,
    this.userId,
    required this.bankName,
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
    this.isVerified = true,
    this.isPrimary = false,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int? userId;
  final String bankName;
  final String bankCode;
  final String accountNumber;
  final String accountName;
  final bool isVerified;
  final bool isPrimary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return '•••• ${accountNumber.substring(accountNumber.length - 4)}';
  }

  factory UserBankAccount.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final parsedId = idRaw is int ? idRaw : (int.tryParse(idRaw?.toString() ?? '') ?? 0);
    final userIdRaw = json['user_id'] ?? json['userId'];
    final parsedUserId = userIdRaw is int
        ? userIdRaw
        : int.tryParse(userIdRaw?.toString() ?? '');

    return UserBankAccount(
      id: parsedId,
      userId: parsedUserId,
      bankName: (json['bank_name'] ?? json['bankName'] ?? '').toString(),
      bankCode: (json['bank_code'] ?? json['bankCode'] ?? '').toString(),
      accountNumber: (json['account_number'] ?? json['accountNumber'] ?? '').toString(),
      accountName: (json['account_name'] ?? json['accountName'] ?? '').toString(),
      isVerified: (json['is_verified'] ?? json['isVerified']) as bool? ?? true,
      isPrimary: (json['is_primary'] ?? json['isPrimary']) as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  UserBankAccount copyWith({
    int? id,
    int? userId,
    String? bankName,
    String? bankCode,
    String? accountNumber,
    String? accountName,
    bool? isVerified,
    bool? isPrimary,
  }) {
    return UserBankAccount(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      isVerified: isVerified ?? this.isVerified,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class WalletFundInitResult {
  const WalletFundInitResult({
    required this.reference,
    required this.email,
    required this.amountInKobo,
    required this.publicKey,
    this.authorizationUrl,
  });

  final String reference;
  final String email;
  final int amountInKobo;
  final String publicKey;
  final String? authorizationUrl;

  double get amountNaira => amountInKobo / 100.0;

  factory WalletFundInitResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final rawAmount = data['amount'];
    final parsedKobo = rawAmount is int
        ? rawAmount
        : (double.tryParse(rawAmount?.toString() ?? '0') ?? 0).round();

    return WalletFundInitResult(
      reference: (data['reference'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      amountInKobo: parsedKobo,
      publicKey: (data['publicKey'] ?? data['public_key'] ?? '').toString(),
      authorizationUrl: (data['authorizationUrl'] ?? data['authorization_url'])?.toString(),
    );
  }
}

class WalletPayout {
  const WalletPayout({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.reference,
    this.bankAccountId,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.currency = 'NGN',
    this.failureReason,
    this.processedAt,
  });

  final String id;
  final double amount;
  final String status;
  final DateTime createdAt;
  final String? reference;
  final int? bankAccountId;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final String currency;
  final String? failureReason;
  final DateTime? processedAt;

  factory WalletPayout.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final rawAmount = data['amount'] ?? data['net_amount'] ?? data['gross_amount'];
    final parsedAmount = rawAmount is num
        ? rawAmount.toDouble()
        : (double.tryParse(rawAmount?.toString() ?? '0') ?? 0.0);

    final bankMap = (data['bankAccount'] ?? data['bank_account']) is Map
        ? Map<String, dynamic>.from((data['bankAccount'] ?? data['bank_account']) as Map)
        : null;

    final rawBankAccountId = data['bank_account_id'] ?? data['bankAccountId'] ?? bankMap?['id'];
    final parsedBankAccountId = rawBankAccountId is int
        ? rawBankAccountId
        : int.tryParse(rawBankAccountId?.toString() ?? '');

    return WalletPayout(
      id: (data['id'] ?? '').toString(),
      amount: parsedAmount,
      status: (data['status'] ?? 'pending').toString().toLowerCase(),
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      reference: (data['reference'] ?? data['payout_number'])?.toString(),
      bankAccountId: parsedBankAccountId,
      bankName: (data['bank_name'] ?? data['bankName'] ?? bankMap?['bank_name'] ?? bankMap?['bankName'])?.toString(),
      accountNumber: (data['account_number'] ?? data['accountNumber'] ?? bankMap?['account_number'] ?? bankMap?['accountNumber'])?.toString(),
      accountName: (data['account_name'] ?? data['accountName'] ?? bankMap?['account_name'] ?? bankMap?['accountName'])?.toString(),
      currency: (data['currency'] ?? 'NGN').toString(),
      failureReason: (data['failure_reason'] ?? data['failureReason'])?.toString(),
      processedAt: data['processed_at'] != null
          ? DateTime.tryParse(data['processed_at'].toString())
          : null,
    );
  }
}

