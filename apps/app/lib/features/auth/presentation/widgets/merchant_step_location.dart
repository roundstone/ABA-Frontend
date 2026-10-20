import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';

class MerchantStepLocation extends StatelessWidget {
  const MerchantStepLocation({
    super.key,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.marketCluster,
    required this.bankController,
    required this.accountController,
    required this.onClusterChanged,
  });

  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final String marketCluster;
  final TextEditingController bankController;
  final TextEditingController accountController;
  final ValueChanged<String> onClusterChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Physical Workshop / Store Address',
          hintText: 'e.g. 14 Faulks Road, Block C Suite 4',
          controller: addressController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedLocation01,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: marketCluster,
          decoration: const InputDecoration(
            labelText: 'Market Hub / Industrial Cluster',
          ),
          items: const [
            DropdownMenuItem(
              value: 'Ariaria International Market',
              child: Text('Ariaria International Market'),
            ),
            DropdownMenuItem(
              value: 'Faulks Road Cluster',
              child: Text('Faulks Road Cluster'),
            ),
            DropdownMenuItem(
              value: 'Eziukwu / Cemetery Market',
              child: Text('Eziukwu / Cemetery Market'),
            ),
            DropdownMenuItem(
              value: 'Shopping Complex / Mall',
              child: Text('Shopping Complex / Mall'),
            ),
            DropdownMenuItem(
              value: 'Independent Workshop / Store',
              child: Text('Independent Workshop / Store'),
            ),
          ],
          onChanged: (v) {
            if (v != null) onClusterChanged(v);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'City / Town',
                hintText: 'e.g. Aba',
                controller: cityController,
                prefixIcon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCity01,
                  color: AppColors.grey,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppTextField(
                label: 'State',
                hintText: 'e.g. Abia',
                controller: stateController,
                prefixIcon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedMapPin,
                  color: AppColors.grey,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Settlement Bank Name',
          hintText: 'e.g. First Bank of Nigeria / GTBank / Zenith',
          controller: bankController,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedBank,
            color: AppColors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: '10-Digit NUBAN Account Number',
          hintText: '0123456789',
          controller: accountController,
          keyboardType: TextInputType.number,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedCreditCard,
            color: AppColors.grey,
            size: 16,
          ),
        ),
      ],
    );
  }
}
