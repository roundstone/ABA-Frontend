import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_spacing.dart';
import '../../shop/domain/shop_entities.dart';
import '../application/merchant_providers.dart';
import '../domain/merchant_order_entities.dart';
import '../domain/merchant_product_entities.dart';
import 'widgets/pos_category_filter_bar.dart';
import 'widgets/pos_checkout_drawer.dart';
import 'widgets/pos_products_grid.dart';

class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  final Map<String, int> _cart = {}; // productId -> quantity
  ShopCategory? _selectedCategory;
  ShopCategory? _selectedSubcategory;
  String _searchQuery = '';
  String _paymentMethod = 'Cash';

  bool _matchesFilter(MerchantProduct p) {
    if (_selectedCategory != null) {
      final catId = int.tryParse(_selectedCategory!.id);
      final matchId = catId != null && p.categoryId == catId;
      final matchName =
          p.category.toLowerCase() == _selectedCategory!.name.toLowerCase();
      if (!matchId && !matchName) return false;
    }
    if (_selectedSubcategory != null) {
      final subId = int.tryParse(_selectedSubcategory!.id);
      final matchId = subId != null && p.subcategoryId == subId;
      final matchName =
          p.category.toLowerCase() ==
              _selectedSubcategory!.name.toLowerCase() ||
          p.name.toLowerCase().contains(
            _selectedSubcategory!.name.toLowerCase(),
          );
      if (!matchId && !matchName) return false;
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      if (!p.name.toLowerCase().contains(q) && !p.sku.toLowerCase().contains(q)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsState = ref.watch(merchantProductsProvider);
    final products = productsState.products;
    final categoriesAsync = ref.watch(merchantCategoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? const <ShopCategory>[];
    final filtered = products.where(_matchesFilter).toList();

    double subtotal = 0;
    int totalItems = 0;
    _cart.forEach((id, qty) {
      final p = products.where((item) => item.id == id).firstOrNull;
      if (p != null) {
        subtotal += p.price * qty;
        totalItems += qty;
      }
    });

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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register Counter 1',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Walk-in POS Session • Online',
              style: TextStyle(fontSize: 11, color: Color(0xFF10B981)),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Products',
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () =>
                ref.read(merchantProductsProvider.notifier).loadProducts(),
          ),
          if (_cart.isNotEmpty)
            IconButton(
              tooltip: 'Clear Cart',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => setState(() => _cart.clear()),
            ),
        ],
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 8,
              ),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search product or barcode...',
                      prefixIcon: Icon(Icons.search, size: 20),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                  const SizedBox(height: 8),
                  PosCategoryFilterBar(
                    categories: categories,
                    selectedCategory: _selectedCategory,
                    selectedSubcategory: _selectedSubcategory,
                    isLoading: categoriesAsync.isLoading && categories.isEmpty,
                    onSelectCategory: (cat) => setState(() {
                      _selectedCategory = cat;
                      _selectedSubcategory = null;
                    }),
                    onSelectSubcategory: (sub) =>
                        setState(() => _selectedSubcategory = sub),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(merchantProductsProvider.notifier).loadProducts(),
                child: PosProductsGrid(
                  products: filtered,
                  cart: _cart,
                  isLoading: productsState.isLoading,
                  errorMessage: productsState.errorMessage,
                  onAddToCart: (p) {
                    if (p.isOutOfStock) return;
                    setState(() => _cart[p.id] = (_cart[p.id] ?? 0) + 1);
                  },
                  onRetry: () => ref
                      .read(merchantProductsProvider.notifier)
                      .loadProducts(),
                ),
              ),
            ),
            if (_cart.isNotEmpty)
              PosCheckoutDrawer(
                subtotal: subtotal,
                totalItems: totalItems,
                paymentMethod: _paymentMethod,
                onPaymentMethodChanged: (m) =>
                    setState(() => _paymentMethod = m),
                onCheckout: () => _handleCompleteSale(context, ref, subtotal),
              ),
          ],
        ),
      ),
    );
  }

  void _handleCompleteSale(
    BuildContext context,
    WidgetRef ref,
    double subtotal,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final products = ref.read(merchantProductsProvider).products;
    final order = MerchantOrder(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch % 100000}',
      customerName: 'Walk-in Customer',
      customerPhone: '+2348000000000',
      isWalkIn: true,
      channel: OrderChannel.pos,
      status: MerchantOrderStatus.completed,
      paymentStatus: MerchantPaymentStatus.paid,
      paymentMethod: _paymentMethod,
      items: _cart.entries.map((e) {
        final p = products.firstWhere((item) => item.id == e.key);
        return MerchantOrderItem(
          id: 'item-${e.key}',
          productId: p.id,
          productName: p.name,
          sku: p.sku,
          price: p.price,
          quantity: e.value,
        );
      }).toList(),
      subtotal: subtotal,
      total: subtotal,
      createdAt: DateTime.now(),
      notes: 'Counter 1 POS Sale',
    );

    for (final entry in _cart.entries) {
      await ref
          .read(merchantProductsProvider.notifier)
          .adjustStock(entry.key, -entry.value, 'POS Sale');
    }
    await ref.read(merchantRepositoryProvider).recordOrder('merch-001', order);
    await ref.read(merchantOrdersProvider.notifier).loadOrders();
    ref.read(merchantDashboardProvider.notifier).refresh();

    if (!mounted) return;
    setState(() => _cart.clear());
    messenger.showSnackBar(
      SnackBar(
        content: Text('Sale completed! ${order.id} recorded with $_paymentMethod.'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }
}
