import 'package:app/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../cart/domain/entities/cart_entities.dart';
import '../../shop/application/shop_providers.dart';
import '../application/checkout_notifier.dart';
import '../application/checkout_providers.dart';
import '../application/checkout_state.dart';
import 'checkout_order_handler.dart';
import 'widgets/checkout_progress_bar.dart';
import 'widgets/checkout_referral_section.dart';
import 'widgets/checkout_summary_card.dart';
import 'widgets/step_delivery_address.dart';
import 'widgets/step_delivery_method.dart';
import 'widgets/step_payment_method.dart';
import 'widgets/step_review_order.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key, this.directCart});

  final Cart? directCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider);
    final notifier = ref.read(checkoutProvider.notifier);
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: AppSpacing.iconSizeSM,
          ),
          onPressed: () {
            if (checkoutState.step > 1) {
              notifier.prevStep();
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: directCart != null
          ? _buildCartBody(
              context,
              checkoutState,
              notifier,
              directCart!,
              ref,
              isDirectBuy: true,
            )
          : cartAsync.when(
              loading: () => const LoadingState(message: 'Loading cart…'),
              error: (e, _) => ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(cartProvider),
              ),
              data: (cart) => _buildCartBody(
                context,
                checkoutState,
                notifier,
                cart,
                ref,
                isDirectBuy: false,
              ),
            ),
    );
  }

  Widget _buildCartBody(
    BuildContext context,
    CheckoutState checkoutState,
    CheckoutNotifier notifier,
    Cart cart,
    WidgetRef ref, {
    required bool isDirectBuy,
  }) {
    if (cart.isEmpty && checkoutState.createdOrderResult == null) {
      return AppEmptyState(
        icon: HugeIcons.strokeRoundedShoppingCart01,
        title: 'Your cart is empty',
        description: 'Add items to your cart before proceeding to checkout.',
        action: FilledButton.icon(
          onPressed: () => context.go('/shop'),
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedShoppingBag01,
            size: AppSpacing.iconSizeSM,
            color: Colors.white,
          ),
          label: const Text('Explore Shop'),
        ),
      );
    }

    if (checkoutState.isLoadingInit) {
      return const LoadingState(message: 'Preparing checkout…');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CheckoutProgressBar(
            currentStep: checkoutState.step,
            onStepTapped: notifier.goToStep,
          ),
          if (checkoutState.errorMessage != null)
            Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(20),
                borderRadius: AppSpacing.borderRadiusMD,
                border: Border.all(color: AppColors.error),
              ),
              child: Row(
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedAlertCircle,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      checkoutState.errorMessage!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                _buildCurrentStep(
                  context,
                  checkoutState,
                  notifier,
                  cart,
                  ref,
                  isDirectBuy: isDirectBuy,
                ),
                const SizedBox(height: AppSpacing.md),
                if (checkoutState.step < 5) ...[
                  CheckoutReferralSection(
                    appliedReferral: checkoutState.appliedReferral,
                    searchQuery: checkoutState.referralQuery,
                    searchResults: checkoutState.referralSearchResults,
                    isSearching: checkoutState.isSearchingReferral,
                    onQueryChanged: notifier.searchReferrals,
                    onApplyCandidate: notifier.applyReferral,
                    onRemove: notifier.removeReferral,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                CheckoutSummaryCard(
                  cart: cart,
                  deliveryMethod: checkoutState.selectedDeliveryMethod,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    CheckoutState checkoutState,
    CheckoutNotifier notifier,
    Cart cart,
    WidgetRef ref, {
    required bool isDirectBuy,
  }) {
    switch (checkoutState.step) {
      case 1:
        return StepDeliveryAddress(
          savedAddresses: checkoutState.savedAddresses,
          selectedAddress: checkoutState.selectedAddress,
          isNewAddressMode: checkoutState.isNewAddressMode,
          onSelectAddress: notifier.selectAddress,
          onCustomAddressChanged: notifier.updateCustomAddress,
          onToggleNewAddress: notifier.toggleNewAddressMode,
          onBack: notifier.prevStep,
          onContinue: notifier.nextStep,
        );
      case 2:
        return StepDeliveryMethod(
          methods: checkoutState.deliveryMethods,
          selectedMethod: checkoutState.selectedDeliveryMethod,
          onSelectMethod: notifier.selectDeliveryMethod,
          onBack: notifier.prevStep,
          onContinue: notifier.nextStep,
        );
      case 3:
        return StepPaymentMethod(
          selectedType: checkoutState.paymentType,
          onSelectType: notifier.selectPaymentType,
          onBack: notifier.prevStep,
          onContinue: notifier.nextStep,
        );
      case 4:
      default:
        return StepReviewOrder(
          state: checkoutState,
          cart: cart,
          onEditAddress: () => notifier.goToStep(1),
          onEditPayment: () => notifier.goToStep(3),
          onBack: notifier.prevStep,
          onPlaceOrder: () => CheckoutOrderHandler.handlePlaceOrder(
            context: context,
            ref: ref,
            checkoutState: checkoutState,
            notifier: notifier,
            cart: cart,
            isDirectBuy: isDirectBuy,
          ),
        );
    }
  }
}
