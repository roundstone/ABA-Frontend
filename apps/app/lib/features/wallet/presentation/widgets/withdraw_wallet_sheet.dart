import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../application/wallet_providers.dart';
import 'add_bank_account_sheet.dart';
import 'bank_account_selector_list.dart';
import 'manage_bank_accounts_sheet.dart';

class WithdrawWalletSheet extends ConsumerStatefulWidget {
  const WithdrawWalletSheet({super.key, this.availableBalance = 0.0});

  final double availableBalance;

  static Future<WalletPayout?> show(
    BuildContext context, {
    double availableBalance = 0.0,
  }) {
    return showModalBottomSheet<WalletPayout>(
      context: rootNavigatorKey.currentContext ?? context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WithdrawWalletSheet(availableBalance: availableBalance),
    );
  }

  @override
  ConsumerState<WithdrawWalletSheet> createState() =>
      _WithdrawWalletSheetState();
}

class _WithdrawWalletSheetState extends ConsumerState<WithdrawWalletSheet> {
  final _amountCtrl = TextEditingController();
  int? _selectedAccountId;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAddAccount() async {
    final added = await AddBankAccountSheet.show(context);
    if (added != null && mounted) {
      setState(() {
        _selectedAccountId = added.id;
        _errorText = null;
      });
    }
  }

  Future<void> _handleWithdraw(List<UserBankAccount> accounts) async {
    final raw = _amountCtrl.text.replaceAll(',', '').trim();
    final amount = double.tryParse(raw);

    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Please enter a valid withdrawal amount.');
      return;
    }
    if (widget.availableBalance > 0 && amount > widget.availableBalance) {
      setState(
        () => _errorText =
            'Insufficient wallet balance (${formatNaira(widget.availableBalance)} available).',
      );
      return;
    }

    final effectiveId = _selectedAccountId ??
        accounts.where((a) => a.isPrimary).firstOrNull?.id ??
        accounts.firstOrNull?.id;

    if (effectiveId == null) {
      setState(() => _errorText = 'Please add or select a bank account first.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      final repo = ref.read(walletRepositoryProvider);
      final payout = await repo.createWithdrawal(
        amount: amount,
        bankAccountId: effectiveId,
      );

      ref.invalidate(walletInfoProvider);
      ref.invalidate(walletTransactionsProvider);
      ref.invalidate(myPayoutsProvider);

      if (!mounted) return;
      Navigator.of(context).pop(payout);
      AppSnackbar.show(
        context,
        message: 'Withdrawal of ${formatNaira(amount)} submitted!',
        type: AppSnackbarType.success,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorText = ApiError.toUserFriendlyMessage(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accountsAsync = ref.watch(userBankAccountsProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: mq.size.height * 0.88),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md + mq.padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Withdraw Funds', style: AppTypography.h4),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  Text(
                    'Available Balance: ${formatNaira(widget.availableBalance)}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildAmountHeader(),
                          const SizedBox(height: AppSpacing.xs),
                          AppTextField(
                            controller: _amountCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            hintText: '5000.00',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(14),
                              child: Text(
                                '₦',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            enabled: !_isSubmitting,
                            onChanged: (_) {
                              if (_errorText != null) {
                                setState(() => _errorText = null);
                              }
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildAccountsHeader(),
                          accountsAsync.when(
                            loading: () => const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                            error: (err, _) => Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ApiError.toUserFriendlyMessage(err),
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      ref.invalidate(userBankAccountsProvider),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                            data: (accounts) => BankAccountSelectorList(
                              accounts: accounts,
                              selectedAccountId: _selectedAccountId,
                              isSubmitting: _isSubmitting,
                              onSelect: (id) =>
                                  setState(() => _selectedAccountId = id),
                              onAddAccount: _handleAddAccount,
                            ),
                          ),
                          if (_errorText != null) _buildErrorBanner(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton.primary(
                    label: _isSubmitting
                        ? 'Processing...'
                        : 'Confirm Withdrawal',
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting
                        ? null
                        : () =>
                              _handleWithdraw(accountsAsync.valueOrNull ?? []),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Withdrawal Amount (NGN)',
          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
        ),
        if (widget.availableBalance > 0)
          GestureDetector(
            onTap: _isSubmitting
                ? null
                : () => setState(() {
                      _amountCtrl.text =
                          widget.availableBalance.toStringAsFixed(2);
                      _errorText = null;
                    }),
            child: Text(
              'Withdraw Max',
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAccountsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Destination Bank Account',
          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: _isSubmitting ? null : _handleAddAccount,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add New'),
            ),
            TextButton(
              onPressed: _isSubmitting
                  ? null
                  : () => ManageBankAccountsSheet.show(context),
              child: const Text('Manage'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: AppSpacing.borderRadiusMD,
        ),
        child: Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert02,
              color: AppColors.error,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorText!,
                style: AppTypography.caption.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
