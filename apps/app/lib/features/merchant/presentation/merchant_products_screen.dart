import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/merchant_providers.dart';
import 'widgets/merchant_product_card.dart';
import 'widgets/merchant_product_form_sheet.dart';
import 'widgets/merchant_stock_adjust_sheet.dart';

class MerchantProductsScreen extends ConsumerStatefulWidget {
  const MerchantProductsScreen({super.key});

  @override
  ConsumerState<MerchantProductsScreen> createState() =>
      _MerchantProductsScreenState();
}

class _MerchantProductsScreenState
    extends ConsumerState<MerchantProductsScreen> {
  final _searchCtrl = TextEditingController();

  final List<String> _categories = [
    'All',
    'Shoes & Footwear',
    'Bags & Luggage',
    'Fashion & Textiles',
    'Accessories',
  ];

  final List<String> _stockFilters = [
    'All',
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(merchantProductsProvider);
    final notifier = ref.read(merchantProductsProvider.notifier);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => context.popOrGo('/merchant'),
        ),
        title: const Text('Shop & Products'),
        actions: [
          IconButton(
            tooltip: 'Add Product',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _openProductForm(context, null),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openProductForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('New Product'),
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          context.popOrGo('/merchant');
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Column(
                children: [
                  AppTextField(
                    label: '',
                    controller: _searchCtrl,
                    hintText: 'Search product, SKU or category...',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    onChanged: (val) => notifier.setSearchQuery(val),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Category filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = state.selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) => notifier.setCategory(cat),
                            selectedColor: isDark
                                ? AppColors.secondary.withAlpha(60)
                                : AppColors.primary.withAlpha(40),
                            labelStyle: TextStyle(
                              fontSize: 11.5,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Stock filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _stockFilters.map((st) {
                        final isSelected = state.selectedStockFilter == st;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(st),
                            selected: isSelected,
                            onSelected: (_) => notifier.setStockFilter(st),
                            labelStyle: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.isLoading && state.products.isEmpty
                  ? const LoadingState(message: 'Loading products...')
                  : RefreshIndicator(
                      onRefresh: () => notifier.loadProducts(),
                      child: state.products.isEmpty
                          ? ListView(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(AppSpacing.xxl),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: AppSpacing.md),
                                        Text(
                                          'No matching products found.',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              itemCount: state.products.length,
                              itemBuilder: (context, i) {
                                final p = state.products[i];
                                return MerchantProductCard(
                                  product: p,
                                  onEdit: () => _openProductForm(context, p),
                                  onAdjustStock: () {
                                    MerchantStockAdjustSheet.show(
                                      context,
                                      product: p,
                                      onConfirm: (delta, reason) => notifier
                                          .adjustStock(p.id, delta, reason),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openProductForm(BuildContext context, dynamic product) {
    MerchantProductFormSheet.show(
      context,
      existingProduct: product,
      onSave: (saved) {
        if (product == null) {
          return ref.read(merchantProductsProvider.notifier).addProduct(saved);
        } else {
          return ref
              .read(merchantProductsProvider.notifier)
              .updateProduct(saved);
        }
      },
    );
  }
}
