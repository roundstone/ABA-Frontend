import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../merchants/application/merchant_providers.dart';
import '../../../merchants/presentation/widgets/merchant_card.dart';

/// Horizontal carousel of verified merchants corresponding to Web's "Meet Businesses".
class HomeMeetBusinessesSection extends ConsumerWidget {
  const HomeMeetBusinessesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsync = ref.watch(merchantsDirectoryProvider);

    return merchantsAsync.when(
      loading: () => const _MerchantLoadingList(),
      error: (_, __) => const SizedBox.shrink(),
      data: (result) {
        if (result.merchants.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 290,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: result.merchants.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final merchant = result.merchants[index];
              return SizedBox(
                width: 260,
                child: MerchantCard(merchant: merchant),
              );
            },
          ),
        );
      },
    );
  }
}

class _MerchantLoadingList extends StatelessWidget {
  const _MerchantLoadingList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, __) => Container(
          width: 260,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(20),
            borderRadius: AppSpacing.borderRadiusXL,
          ),
        ),
      ),
    );
  }
}
