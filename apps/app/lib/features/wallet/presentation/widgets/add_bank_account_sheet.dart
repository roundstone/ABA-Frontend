import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/wallet_providers.dart';

class AddBankAccountSheet extends ConsumerStatefulWidget {
  const AddBankAccountSheet({super.key, this.existingAccount});

  final UserBankAccount? existingAccount;

  static Future<UserBankAccount?> show(
    BuildContext context, {
    UserBankAccount? existingAccount,
  }) {
    return showModalBottomSheet<UserBankAccount>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddBankAccountSheet(existingAccount: existingAccount),
    );
  }

  @override
  ConsumerState<AddBankAccountSheet> createState() =>
      _AddBankAccountSheetState();
}

class _AddBankAccountSheetState extends ConsumerState<AddBankAccountSheet> {
  final _accountNumberCtrl = TextEditingController();
  final _bankSearchCtrl = TextEditingController();
  BankOption? _selectedBank;
  bool _isPrimary = false;
  bool _isSubmitting = false;
  String? _errorText;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final existing = widget.existingAccount;
    if (existing != null) {
      _accountNumberCtrl.text = existing.accountNumber;
      _selectedBank = BankOption(
        name: existing.bankName,
        code: existing.bankCode,
      );
      _isPrimary = existing.isPrimary;
    }
  }

  @override
  void dispose() {
    _accountNumberCtrl.dispose();
    _bankSearchCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final bank = _selectedBank;
    final accNo = _accountNumberCtrl.text.trim();

    if (bank == null) {
      setState(() => _errorText = 'Please select a bank.');
      return;
    }
    if (accNo.length != 10) {
      setState(
        () => _errorText = 'Please enter a valid 10-digit account number.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      final repo = ref.read(walletRepositoryProvider);
      final saved = widget.existingAccount != null
          ? await repo.updateBankAccount(
              widget.existingAccount!.id,
              bankName: bank.name,
              bankCode: bank.code,
              accountNumber: accNo,
              isPrimary: _isPrimary,
            )
          : await repo.addBankAccount(
              bankName: bank.name,
              bankCode: bank.code,
              accountNumber: accNo,
              isPrimary: _isPrimary,
            );

      ref.invalidate(userBankAccountsProvider);

      if (!mounted) return;
      Navigator.of(context).pop(saved);
      AppSnackbar.show(
        context,
        message: widget.existingAccount != null
            ? 'Bank account updated (${saved.accountName})'
            : 'Bank account linked: ${saved.accountName}',
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
    final banksAsync = ref.watch(availableBanksProvider);
    final isEditing = widget.existingAccount != null;

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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
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
                      Text(
                        isEditing ? 'Edit Bank Account' : 'Add Bank Account',
                        style: AppTypography.h4,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Select Bank',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          _buildBankSelector(banksAsync, isDark),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Account Number (10 Digits)',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          AppTextField(
                            controller: _accountNumberCtrl,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            hintText: '0123456789',
                            enabled: !_isSubmitting,
                            onChanged: (_) {
                              if (_errorText != null) {
                                setState(() => _errorText = null);
                              }
                            },
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Set as Primary Payout Account',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            value: _isPrimary,
                            activeTrackColor: AppColors.primary,
                            onChanged: _isSubmitting
                                ? null
                                : (val) => setState(() => _isPrimary = val),
                          ),
                          if (_errorText != null) _buildErrorBanner(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton.primary(
                    label: _isSubmitting
                        ? 'Verifying & Saving...'
                        : (isEditing
                              ? 'Update Bank Account'
                              : 'Verify & Save Account'),
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : _handleSave,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankSelector(
    AsyncValue<List<BankOption>> banksAsync,
    bool isDark,
  ) {
    return banksAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (err, _) => Row(
        children: [
          Expanded(
            child: Text(
              'Could not load banks: ${ApiError.toUserFriendlyMessage(err)}',
              style: AppTypography.caption.copyWith(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(availableBanksProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
      data: (banks) {
        final q = _searchQuery.trim().toLowerCase();
        final filtered = q.isEmpty
            ? banks
            : banks.where((b) => b.name.toLowerCase().contains(q)).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _bankSearchCtrl,
              hintText: _selectedBank != null
                  ? 'Selected: ${_selectedBank!.name}'
                  : 'Search bank name (e.g. Access, OPay, GTB)...',
              prefixIcon: const Icon(Icons.search, size: 18),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
            const SizedBox(height: 6),
            Container(
              constraints: const BoxConstraints(maxHeight: 140),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.white12 : AppColors.border,
                ),
                borderRadius: AppSpacing.borderRadiusMD,
              ),
              child: filtered.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('No matching banks found.'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final b = filtered[i];
                        final isSelected = _selectedBank?.code == b.code &&
                            _selectedBank?.name == b.name;
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: Text(
                            b.name,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? AppColors.primary : null,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 18,
                                )
                              : null,
                          onTap: () => setState(() {
                            _selectedBank = b;
                            _errorText = null;
                          }),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorBanner() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
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
