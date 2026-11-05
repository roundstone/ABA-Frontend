import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/wallet_entities.dart';
import '../domain/wallet_repository.dart';
import 'wallet_bank_payout_service.dart';
import 'wallet_mock_repository.dart';

class WalletRemoteRepository implements WalletRepository {
  WalletRemoteRepository({
    required this.dio,
    WalletMockRepository? mockFallback,
  }) : _mock = mockFallback ?? WalletMockRepository() {
    _payoutService = WalletBankPayoutService(dio: dio, mock: _mock);
  }

  final Dio dio;
  final WalletMockRepository _mock;
  late final WalletBankPayoutService _payoutService;

  @override
  Future<WalletInfo> getWalletInfo() async {
    if (AppConfig.isMockMode) {
      return _mock.getWalletInfo();
    }

    try {
      AppLogger.d('GET ${ApiEndpoints.wallets.me}');
      final response = await dio.get(ApiEndpoints.wallets.me);
      final body = response.data;
      final rawData = body is Map<String, dynamic> ? (body['data'] ?? body) : body;

      if (rawData is List) {
        if (rawData.isEmpty) return const WalletInfo(balance: 0.0, currency: 'NGN');
        Map<String, dynamic>? target;
        for (final item in rawData) {
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            if (map['is_active'] == true) {
              target = map;
              break;
            }
            target ??= map;
          }
        }
        if (target != null) return WalletInfo.fromJson(target);
      } else if (rawData is Map) {
        return WalletInfo.fromJson(Map<String, dynamic>.from(rawData));
      }

      return const WalletInfo(balance: 0.0, currency: 'NGN');
    } catch (e) {
      AppLogger.e('Failed to fetch wallet info', error: e);
      if (AppConfig.isMockMode) return _mock.getWalletInfo();
      if (e is DioException) throw ApiError.fromDio(e);
      rethrow;
    }
  }

  @override
  Future<PaginatedWalletTransactionsResult> getPaginatedTransactions({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    String? orderBy = 'createdAt:DESC',
    int? walletId,
    int? transactionType,
    int? status,
  }) async {
    if (AppConfig.isMockMode) {
      return _mock.getPaginatedTransactions(
        page: page, limit: limit, search: search, startDate: startDate,
        endDate: endDate, orderBy: orderBy, walletId: walletId,
        transactionType: transactionType, status: status,
      );
    }

    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (startDate != null && startDate.isNotEmpty) 'startDate': startDate,
        if (endDate != null && endDate.isNotEmpty) 'endDate': endDate,
        if (orderBy != null && orderBy.isNotEmpty) 'orderBy': orderBy,
        if (walletId != null) 'walletId': walletId,
        if (transactionType != null) 'transactionType': transactionType,
        if (status != null) 'status': status,
      };

      AppLogger.d('GET ${ApiEndpoints.wallets.transactions} with $queryParams');
      final response = await dio.get(
        ApiEndpoints.wallets.transactions,
        queryParameters: queryParams,
      );

      final body = response.data;
      final rawData = body is Map ? body['data'] : null;

      List itemsList = [];
      Map<String, dynamic>? meta;
      if (rawData is Map) {
        if (rawData['data'] is List) itemsList = rawData['data'] as List;
        if (rawData['meta'] is Map) meta = rawData['meta'] as Map<String, dynamic>;
      } else if (rawData is List) {
        itemsList = rawData;
      }

      final transactions = itemsList
          .whereType<Map<String, dynamic>>()
          .map((json) => WalletTransaction.fromJson(json))
          .toList();

      final totalItems = meta?['totalItems'] as int? ?? transactions.length;
      final totalPages = meta?['totalPages'] as int? ?? (totalItems / limit).ceil().clamp(1, 999);
      final currentPage = meta?['currentPage'] as int? ?? page;

      return PaginatedWalletTransactionsResult(
        transactions: transactions,
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: currentPage,
        hasNext: currentPage < totalPages,
      );
    } catch (e) {
      AppLogger.e('Failed to fetch wallet transactions', error: e);
      if (AppConfig.isMockMode) {
        return _mock.getPaginatedTransactions(
          page: page, limit: limit, search: search, startDate: startDate,
          endDate: endDate, orderBy: orderBy, walletId: walletId,
          transactionType: transactionType, status: status,
        );
      }
      if (e is DioException) throw ApiError.fromDio(e);
      rethrow;
    }
  }

  @override
  Future<List<WalletTransaction>> getTransactions({
    int page = 1,
    int limit = 10,
    String? search,
    String? startDate,
    String? endDate,
    String? orderBy = 'createdAt:DESC',
    int? walletId,
    int? transactionType,
    int? status,
  }) async =>
      (await getPaginatedTransactions(
        page: page,
        limit: limit,
        search: search,
        startDate: startDate,
        endDate: endDate,
        orderBy: orderBy,
        walletId: walletId,
        transactionType: transactionType,
        status: status,
      ))
          .transactions;

  @override
  Future<WalletFundInitResult> initializeFundWallet(double amount) =>
      _payoutService.initializeFundWallet(amount);

  @override
  Future<bool> verifyFundWallet(String reference) =>
      _payoutService.verifyFundWallet(reference);

  @override
  Future<WalletPayout> createWithdrawal({
    required double amount,
    required int bankAccountId,
  }) => _payoutService.createWithdrawal(
        amount: amount,
        bankAccountId: bankAccountId,
      );

  @override
  Future<List<WalletPayout>> getMyPayouts() => _payoutService.getMyPayouts();

  @override
  Future<WalletPayout> getPayoutById(String id) =>
      _payoutService.getPayoutById(id);

  @override
  Future<List<BankOption>> getAvailableBanks() =>
      _payoutService.getAvailableBanks();

  @override
  Future<List<UserBankAccount>> getUserBankAccounts() =>
      _payoutService.getUserBankAccounts();

  @override
  Future<UserBankAccount> addBankAccount({
    required String bankName,
    required String bankCode,
    required String accountNumber,
    bool isPrimary = false,
  }) => _payoutService.addBankAccount(
        bankName: bankName,
        bankCode: bankCode,
        accountNumber: accountNumber,
        isPrimary: isPrimary,
      );

  @override
  Future<UserBankAccount> updateBankAccount(
    int id, {
    String? bankName,
    String? bankCode,
    String? accountNumber,
    bool? isPrimary,
  }) => _payoutService.updateBankAccount(
        id,
        bankName: bankName,
        bankCode: bankCode,
        accountNumber: accountNumber,
        isPrimary: isPrimary,
      );

  @override
  Future<void> deleteBankAccount(int id) =>
      _payoutService.deleteBankAccount(id);

  @override
  Future<ShoppingCreditInfo> getShoppingCredits() async {
    if (AppConfig.isMockMode) return _mock.getShoppingCredits();
    try {
      AppLogger.d('GET ${ApiEndpoints.shoppingCredits.me}');
      final response = await dio.get(ApiEndpoints.shoppingCredits.me);
      final body = response.data;
      if (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>) {
        return ShoppingCreditInfo.fromJson(body['data'] as Map<String, dynamic>);
      }
      return const ShoppingCreditInfo(balance: 0.0);
    } catch (e) {
      AppLogger.e('Failed to fetch shopping credits', error: e);
      if (AppConfig.isMockMode) return _mock.getShoppingCredits();
      if (e is DioException) throw ApiError.fromDio(e);
      rethrow;
    }
  }
}
