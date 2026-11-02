import 'package:app/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/marketer_entities.dart';

class OnboardingSuccessDialog extends StatelessWidget {
  const OnboardingSuccessDialog({super.key, required this.results});

  final List<OnboardCustomerResult> results;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successful = results.where((r) => r.success).toList();

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXL),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              successful.length > 1
                  ? '${successful.length} Customers Added!'
                  : 'Customer Registered!',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customers are successfully linked under your referral code. Share these login details with them:',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: successful.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final r = successful[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.surface2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Email: ${r.email}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Password: ${r.password}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            final buffer = StringBuffer();
            for (final r in successful) {
              buffer.writeln('Name: ${r.fullName}');
              buffer.writeln('Email: ${r.email}');
              buffer.writeln('Password: ${r.password}');
              buffer.writeln('Login at: BuyNaija Mobile App\n');
            }
            Clipboard.setData(ClipboardData(text: buffer.toString()));
            AppSnackbar.info(context, 'Credentials copied to clipboard!');
          },
          icon: const Icon(Icons.copy_rounded, size: 16),
          label: const Text('Copy Credentials'),
        ),
        AppButton(
          label: 'Done',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
