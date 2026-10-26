import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/network/list_query_params.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/paginated_list_view.dart';
import '../application/address_providers.dart';
import '../domain/address_entities.dart';
import 'widgets/add_address_sheet.dart';
import 'widgets/address_card.dart';

class SavedAddressesScreen extends ConsumerStatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  ConsumerState<SavedAddressesScreen> createState() =>
      _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends ConsumerState<SavedAddressesScreen> {
  final _searchCtrl = TextEditingController();
  bool _isLoading = true;
  ListQueryParams _params = const ListQueryParams(
    page: 1,
    limit: 20,
    orderBy: 'createdAt:DESC',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      await ref.read(addressesProvider.notifier).loadAddresses(params: _params);
    } catch (e) {
      debugPrint('Failed to load addresses: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadMore() async {
    try {
      await ref.read(addressesProvider.notifier).loadMore();
    } catch (e) {
      debugPrint('Failed to load more addresses: $e');
    }
  }

  void _onSearch(String term) {
    setState(() => _params = _params.withSearch(term.trim().isEmpty ? null : term.trim()));
    _load();
  }

  void _toggleSort() {
    final next = _params.sortDirection == SortDirection.desc ? SortDirection.asc : SortDirection.desc;
    setState(() => _params = _params.withSort('createdAt', next));
    _load();
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddAddressSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addresses = ref.watch(addressesProvider);
    final notifier = ref.watch(addressesProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSortedAsc = _params.sortDirection == SortDirection.asc;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => context.popOrGo('/home'),
        ),
        title: const Text('Saved Addresses'),
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: isSortedAsc
                  ? HugeIcons.strokeRoundedSorting02
                  : HugeIcons.strokeRoundedSorting01,
              size: 20,
            ),
            tooltip: isSortedAsc ? 'Sort: Oldest first' : 'Sort: Newest first',
            onPressed: _toggleSort,
          ),
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedAdd01,
              size: 20,
            ),
            tooltip: 'Add Address',
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          context.popOrGo('/home');
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: AppTextField(
                controller: _searchCtrl,
                hintText: 'Search by label, street, city...',
                prefixIcon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: AppColors.grey,
                  size: 18,
                ),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedCancel01,
                          color: AppColors.grey,
                          size: 16,
                        ),
                        onPressed: () { _searchCtrl.clear(); _onSearch(''); },
                      )
                    : null,
                onChanged: _onSearch,
              ),
            ),
            Expanded(
              child: PaginatedListView<DeliveryAddress>(
                items: addresses,
                isLoading: _isLoading,
                isLoadingMore: notifier.isLoadingMore,
                hasMore: notifier.hasMore,
                onRefresh: _load,
                onLoadMore: _loadMore,
                prefetchDistance: 250.0,
                showBottomLoader: true,
                padding: const EdgeInsets.all(AppSpacing.md),
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                emptyWidget: _buildEmptyState(isDark),
                itemBuilder: (context, addr, index) {
                  return AddressCard(
                    address: addr.toCheckoutAddress(),
                    isDark: isDark,
                    onSetDefault: () => ref
                        .read(addressesProvider.notifier)
                        .setDefault(addr.id),
                    onDelete: () => ref
                        .read(addressesProvider.notifier)
                        .deleteAddress(addr.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedMapPin,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _params.search != null ? 'No matching addresses' : 'No saved addresses yet',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _params.search != null
                ? 'Try adjusting your search query.'
                : 'Add your delivery address for faster checkout.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_params.search != null)
            AppButton(
              label: 'Clear Search',
              onPressed: () {
                _searchCtrl.clear();
                _onSearch('');
              },
              type: AppButtonType.secondary,
            )
          else
            AppButton(
              label: 'Add New Address',
              onPressed: _showAddDialog,
              type: AppButtonType.secondary,
            ),
        ],
      ),
    );
  }
}
