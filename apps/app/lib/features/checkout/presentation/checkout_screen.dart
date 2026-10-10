import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../shop/application/shop_providers.dart';
import '../application/checkout_providers.dart';
import 'checkout_success_screen.dart';
import 'widgets/checkout_progress_bar.dart';
import 'widgets/checkout_referral_section.dart';
import 'widgets/checkout_summary_card.dart';
import 'widgets/step_customer_info.dart';
import 'widgets/step_delivery_address.dart';
import 'widgets/step_delivery_method.dart';
import 'widgets/step_payment_method.dart';
import 'widgets/step_review_order.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

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
      body: cartAsync.when(
        loading: () => const LoadingState(message: 'Loading cart…'),
        error: (e, _) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(cartProvider),
        ),
        data: (cart) {
          if (cart.isEmpty && checkoutState.createdOrderResult == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedShoppingCart01,
                      color: AppColors.grey,
                      size: 56,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Your cart is empty',
                      style: AppTypography.h5.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Add items to your cart before proceeding to checkout.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton.primary(
                      label: 'Explore Shop',
                      isFullWidth: false,
                      onPressed: () => context.go('/shop'),
                    ),
                  ],
                ),
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
                      _buildCurrentStep(context, checkoutState, notifier, cart, ref),
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
        },
      ),
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    checkoutState,
    notifier,
    cart,
    WidgetRef ref,
  ) {
    switch (checkoutState.step) {
      case 1:
        return StepCustomerInfo(
          initialInfo: checkoutState.customerInfo,
          onContinue: (info) {
            notifier.updateCustomerInfo(info);
            notifier.nextStep();
          },
        );
      case 2:
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
      case 3:
        return StepDeliveryMethod(
          methods: checkoutState.deliveryMethods,
          selectedMethod: checkoutState.selectedDeliveryMethod,
          onSelectMethod: notifier.selectDeliveryMethod,
          onBack: notifier.prevStep,
          onContinue: notifier.nextStep,
        );
      case 4:
        return StepPaymentMethod(
          selectedType: checkoutState.paymentType,
          onSelectType: notifier.selectPaymentType,
          onBack: notifier.prevStep,
          onContinue: notifier.nextStep,
        );
      case 5:
      default:
        return StepReviewOrder(
          state: checkoutState,
          cart: cart,
          onEditAddress: () => notifier.goToStep(2),
          onEditPayment: () => notifier.goToStep(4),
          onBack: notifier.prevStep,
          onPlaceOrder: () async {
            final res = await notifier.submitOrder(cart);
            if (res != null && context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => CheckoutSuccessScreen(order: res.order),
                ),
              );
            }
          },
        );
    }
  }
}
