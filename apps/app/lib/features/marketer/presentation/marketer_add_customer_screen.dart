import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../auth/application/auth_providers.dart';
import 'widgets/marketer_referral_banner.dart';
import 'widgets/multiple_customer_form.dart';
import 'widgets/single_customer_form.dart';

class MarketerAddCustomerScreen extends ConsumerStatefulWidget {
  const MarketerAddCustomerScreen({super.key});

  @override
  ConsumerState<MarketerAddCustomerScreen> createState() =>
      _MarketerAddCustomerScreenState();
}

class _MarketerAddCustomerScreenState
    extends ConsumerState<MarketerAddCustomerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<MultipleCustomerFormState> _multipleFormKey =
      GlobalKey<MultipleCustomerFormState>();
  bool _isScrolledDown = false;
  int _customerCount = 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isDown =
        _scrollController.hasClients && _scrollController.offset > 140;
    if (isDown != _isScrolledDown) {
      setState(() => _isScrolledDown = isDown);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onAddAnother() {
    _multipleFormKey.currentState?.addRow();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + 220,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final referralCode = user?.referralCode ?? 'REF-MARKETER';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        title: Text(
          'Add Customers',
          style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MarketerReferralBanner(
                  referralCode: referralCode,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTabBar(isDark),
                const SizedBox(height: AppSpacing.lg),
                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) {
                    if (_tabController.index == 0) {
                      return SingleCustomerForm(referralCode: referralCode);
                    } else {
                      return MultipleCustomerForm(
                        key: _multipleFormKey,
                        referralCode: referralCode,
                        onCountChanged: (count) {
                          if (mounted && _customerCount != count) {
                            setState(() => _customerCount = count);
                          }
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
          if (_isScrolledDown && _tabController.index == 1)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildStickyBar(context, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildStickyBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Customers to Onboard ($_customerCount)',
            style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
          ),
          TextButton.icon(
            onPressed: _onAddAnother,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Another'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: isDark
            ? AppColors.darkTextSecondary
            : AppColors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Single Customer'),
          Tab(text: 'Multiple Customers'),
        ],
      ),
    );
  }
}
