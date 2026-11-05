import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/wallet_entities.dart';
import 'wallet_mock_repository.dart';

class WalletBankPayoutService {
  WalletBankPayoutService({
    required this.dio,
    required this.mock,
  });

  final Dio dio;
  final WalletMockRepository mock;
  static final List<UserBankAccount> _cachedBankAccounts = [];

  Future<WalletFundInitResult> initializeFundWallet(double amount) async {
    if (AppConfig.isMockMode) return mock.initializeFundWallet(amount);

    try {
      final endpoint = ApiEndpoints.wallets.fundPaystackInitialize;
      final payload = {'amount': amount.toStringAsFixed(2)};
      AppLogger.d('POST $endpoint with $payload');
      final response = await dio.post(endpoint, data: payload);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return WalletFundInitResult.fromJson(body);
      }
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Invalid response when initializing wallet funding.',
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to initialize wallet funding', error: e);
      throw ApiError.fromDio(e);
    }
  }

  Future<bool> verifyFundWallet(String reference) async {
    if (AppConfig.isMockMode) return mock.verifyFundWallet(reference);

    final endpoint = ApiEndpoints.wallets.fundPaystackVerify(reference);
    try {
      AppLogger.d('POST $endpoint');
      final response = await dio.post(endpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map) {
          final status = (data['data']?['status'] ?? data['status'])
              ?.toString()
              .toLowerCase();
          return status == 'successful' ||
              status == 'success' ||
              status == 'completed' ||
              status == 'paid' ||
              data['success'] == true;
        }
        return true;
      }
      return false;
    } on DioException catch (e) {
      AppLogger.e('Failed to verify wallet funding', error: e);
      throw ApiError.fromDio(e);
    }
  }

  Future<WalletPayout> createWithdrawal({
    required double amount,
    required int bankAccountId,
  }) async {
    if (AppConfig.isMockMode) {
      return mock.createWithdrawal(
        amount: amount,
        bankAccountId: bankAccountId,
      );
    }

    try {
      final endpoint = ApiEndpoints.payouts.withdrawals;
      final payload = {'amount': amount, 'bankAccountId': bankAccountId};
      AppLogger.d('POST $endpoint with $payload');
      final response = await dio.post(endpoint, data: payload);
      final body = response.data;
      if (body is Map<String, dynamic>) return WalletPayout.fromJson(body);
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Unexpected response creating withdrawal.',
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to create withdrawal', error: e);
      throw ApiError.fromDio(e);
    }
  }

  Future<List<WalletPayout>> getMyPayouts() async {
    if (AppConfig.isMockMode) return mock.getMyPayouts();

    try {
      final endpoint = ApiEndpoints.payouts.me;
      AppLogger.d('GET $endpoint');
      final response = await dio.get(endpoint);
      return _extractList(response.data)
          .map((m) => WalletPayout.fromJson(m))
          .toList();
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch user payouts', error: e);
      throw ApiError.fromDio(e);
    }
  }

  Future<WalletPayout> getPayoutById(String id) async {
    if (AppConfig.isMockMode) return mock.getPayoutById(id);

    try {
      final endpoint = ApiEndpoints.payouts.byId(id);
      AppLogger.d('GET $endpoint');
      final response = await dio.get(endpoint);
      final body = response.data;
      if (body is Map<String, dynamic>) return WalletPayout.fromJson(body);
      throw const ApiError(
        success: false,
        statusCode: 404,
        message: 'Payout not found.',
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch payout $id', error: e);
      throw ApiError.fromDio(e);
    }
  }

  Future<List<BankOption>> getAvailableBanks() async {
    if (AppConfig.isMockMode) return mock.getAvailableBanks();

    try {
      final endpoint = ApiEndpoints.userBankAccounts.banks;
      AppLogger.d('GET $endpoint');
      final response = await dio.get(endpoint);
      return _extractList(response.data)
          .map((m) => BankOption.fromJson(m))
          .where((b) => b.active && b.name.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch banks list', error: e);
      throw ApiError.fromDio(e);
    }
  }

  Future<List<UserBankAccount>> getUserBankAccounts() async {
    if (AppConfig.isMockMode) return mock.getUserBankAccounts();

    final candidates = [
      ApiEndpoints.userBankAccounts.base,
      '${ApiEndpoints.userBankAccounts.base}/me',
      '/api/v1/user-bank-accounts',
    ];

    DioException? lastError;
    for (final endpoint in candidates) {
      try {
        AppLogger.d('GET $endpoint');
        final response = await dio.get(endpoint);
        final list = _extractList(response.data)
            .map((m) => UserBankAccount.fromJson(m))
            .toList();
        _mergeIntoCache(list);
        return List<UserBankAccount>.unmodifiable(_cachedBankAccounts);
      } on DioException catch (e) {
        lastError = e;
        final msg = e.response?.data?.toString() ?? '';
        final isRouteCollision = e.response?.statusCode == 400 &&
            msg.toLowerCase().contains('numeric string');
        final isNotFound = e.response?.statusCode == 404;
        if (!isRouteCollision && !isNotFound) break;
      }
    }

    if (_cachedBankAccounts.isNotEmpty) {
      return List<UserBankAccount>.unmodifiable(_cachedBankAccounts);
    }
    final errMsg = lastError?.response?.data?.toString() ?? '';
    if (lastError?.response?.statusCode == 400 &&
        errMsg.toLowerCase().contains('numeric string')) {
      AppLogger.w(
        'Backend GET ${ApiEndpoints.userBankAccounts.base} hit :id ParseIntPipe; returning cached accounts.',
      );
      return const [];
    }
    if (lastError != null) throw ApiError.fromDio(lastError);
    return const [];
  }

  Future<UserBankAccount> addBankAccount({
    required String bankName,
    required String bankCode,
    required String accountNumber,
    bool isPrimary = false,
  }) async {
    if (AppConfig.isMockMode) {
      return mock.addBankAccount(
        bankName: bankName,
        bankCode: bankCode,
        accountNumber: accountNumber,
        isPrimary: isPrimary,
      );
    }

    try {
      final endpoint = ApiEndpoints.userBankAccounts.base;
      final payload = {
        'bankName': bankName,
        'bankCode': bankCode,
        'accountNumber': accountNumber,
        'isPrimary': isPrimary,
      };
      AppLogger.d('POST $endpoint with $payload');
      final response = await dio.post(endpoint, data: payload);
      final body = response.data;
      final rawData = body is Map ? (body['data'] ?? body) : body;
      if (rawData is Map) {
        final created =
            UserBankAccount.fromJson(Map<String, dynamic>.from(rawData));
        _upsertCache(created);
        return created;
      }
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Unexpected response adding bank account.',
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to add bank account', error: e);
      throw ApiError.fromDio(e);
    }
  }

  Future<UserBankAccount> updateBankAccount(
    int id, {
    String? bankName,
    String? bankCode,
    String? accountNumber,
    bool? isPrimary,
  }) async {
    if (AppConfig.isMockMode) {
      return mock.updateBankAccount(
        id,
        bankName: bankName,
        bankCode: bankCode,
        accountNumber: accountNumber,
        isPrimary: isPrimary,
      );
    }

    try {
      final endpoint = ApiEndpoints.userBankAccounts.byId(id);
      final payload = <String, dynamic>{
        if (bankName != null) 'bankName': bankName,
        if (bankCode != null) 'bankCode': bankCode,
        if (accountNumber != null) 'accountNumber': accountNumber,
        if (isPrimary != null) 'isPrimary': isPrimary,
      };
      AppLogger.d('PATCH $endpoint with $payload');
      final response = await dio.patch(endpoint, data: payload);
      final body = response.data;
      final rawData = body is Map ? (body['data'] ?? body) : body;
      if (rawData is Map) {
        final updated =
            UserBankAccount.fromJson(Map<String, dynamic>.from(rawData));
        _upsertCache(updated);
        return updated;
      }
      throw const ApiError(
        success: false,
        statusCode: 500,
        message: 'Unexpected response updating bank account.',
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to update bank account $id', error: e);
      throw ApiError.fromDio(e);
    }
  }

  Future<void> deleteBankAccount(int id) async {
    if (AppConfig.isMockMode) return mock.deleteBankAccount(id);

    try {
      final endpoint = ApiEndpoints.userBankAccounts.byId(id);
      AppLogger.d('DELETE $endpoint');
      await dio.delete(endpoint);
      _cachedBankAccounts.removeWhere((a) => a.id == id);
    } on DioException catch (e) {
      AppLogger.e('Failed to delete bank account $id', error: e);
      throw ApiError.fromDio(e);
    }
  }

  List<Map<String, dynamic>> _extractList(dynamic body) {
    final rawData = body is Map ? body['data'] : body;
    List items = [];
    if (rawData is List) {
      items = rawData;
    } else if (rawData is Map && rawData['data'] is List) {
      items = rawData['data'] as List;
    }
    return items
        .whereType<Map>()
        .map((m) => Map<String, dynamic>.from(m))
        .toList();
  }

  void _mergeIntoCache(List<UserBankAccount> fetched) {
    for (final acc in fetched) {
      _upsertCache(acc);
    }
  }

  void _upsertCache(UserBankAccount acc) {
    if (acc.isPrimary) {
      for (var i = 0; i < _cachedBankAccounts.length; i++) {
        _cachedBankAccounts[i] =
            _cachedBankAccounts[i].copyWith(isPrimary: false);
      }
    }
    final idx = _cachedBankAccounts.indexWhere((a) => a.id == acc.id);
    if (idx >= 0) {
      _cachedBankAccounts[idx] = acc;
    } else {
      _cachedBankAccounts.insert(0, acc);
    }
  }
}
