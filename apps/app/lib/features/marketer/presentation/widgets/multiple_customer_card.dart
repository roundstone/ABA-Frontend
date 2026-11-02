import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';

class CustomerRowData {
  CustomerRowData({required this.id, required this.defaultPassword})
    : nameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneController = TextEditingController();

  final int id;
  final String defaultPassword;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }
}

class MultipleCustomerCard extends StatelessWidget {
  const MultipleCustomerCard({
    super.key,
    required this.index,
    required this.row,
    required this.canDelete,
    required this.onDelete,
    required this.isDark,
  });

  final int index;
  final CustomerRowData row;
  final bool canDelete;
  final VoidCallback onDelete;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary.withAlpha(20),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Customer #${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (canDelete)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  color: AppColors.error,
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Full Name',
            hintText: 'Customer full name',
            controller: row.nameController,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Name required' : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Email',
            hintText: 'customer@email.com',
            keyboardType: TextInputType.emailAddress,
            controller: row.emailController,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email required';
              if (!v.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Phone Number',
            hintText: 'Phone number',
            keyboardType: TextInputType.phone,
            controller: row.phoneController,
            validator: (v) =>
                (v == null || v.trim().length < 9) ? 'Valid phone required' : null,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Auto-generated password: ${row.defaultPassword}',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSubtle,
            ),
          ),
        ],
      ),
    );
  }
}

