import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/kyc_models.dart';

class KycDocumentsSection extends StatelessWidget {
  const KycDocumentsSection({
    super.key,
    required this.documents,
    required this.isEditable,
    required this.onAddDocuments,
  });

  final List<KycDocument> documents;
  final bool isEditable;
  final VoidCallback onAddDocuments;

  Future<void> _openDocument(BuildContext context, KycDocument doc) async {
    final url = doc.url;
    if (url == null || url.trim().isEmpty) return;
    final isImage = (doc.mimeType ?? '').startsWith('image/') ||
        url.toLowerCase().contains('.png') ||
        url.toLowerCase().contains('.jpg') ||
        url.toLowerCase().contains('.jpeg');
    if (isImage) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        kycDocumentTypeLabel(doc.documentType),
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: AppNetworkImage(imageUrl: url, fit: BoxFit.contain),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KYC Documents',
                      style: AppTypography.h6.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Documents are added through referral activation.',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (isEditable)
                TextButton(
                  onPressed: onAddDocuments,
                  child: const Text('Add documents'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (documents.isEmpty)
            Text(
              'No documents uploaded yet.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
            )
          else
            ...documents.map(
              (doc) => InkWell(
                onTap: () => _openDocument(context, doc),
                borderRadius: AppSpacing.borderRadiusMD,
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : AppColors.surface2,
                    borderRadius: AppSpacing.borderRadiusMD,
                    border: Border.all(
                      color: isDark ? Colors.white12 : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedFile01,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kycDocumentTypeLabel(doc.documentType),
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              doc.originalName ?? 'Uploaded document',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (doc.url != null && doc.url!.isNotEmpty)
                        const Icon(Icons.open_in_new, size: 16),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
