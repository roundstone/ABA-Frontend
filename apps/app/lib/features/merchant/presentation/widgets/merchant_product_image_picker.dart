import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';

class MerchantProductImagePicker extends StatelessWidget {
  const MerchantProductImagePicker({
    super.key,
    required this.images,
    required this.onImagesChanged,
  });

  final List<String> images;
  final ValueChanged<List<String>> onImagesChanged;

  static const List<String> samplePresets = [
    'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cover = images.isNotEmpty ? images.first : samplePresets.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Stack(
              children: [
                AppNetworkImage.product(
                  imageUrl: cover,
                  width: 76,
                  height: 76,
                  borderRadius: BorderRadius.circular(12),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(190),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Cover',
                      style: AppTypography.caption.copyWith(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product Images *', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    'At least 1 PNG/JPEG image required (max 12 MB total)',
                    style: AppTypography.caption.copyWith(color: AppColors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        ),
                        icon: const Icon(Icons.shuffle, size: 14),
                        label: const Text('Cycle Preset', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          final currentIdx = samplePresets.indexOf(cover);
                          final next = samplePresets[(currentIdx + 1) % samplePresets.length];
                          final updated = List<String>.from(images);
                          if (updated.isEmpty) {
                            updated.add(next);
                          } else {
                            updated[0] = next;
                          }
                          onImagesChanged(updated);
                        },
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        ),
                        icon: const Icon(Icons.add_link, size: 14),
                        label: const Text('Add URL', style: TextStyle(fontSize: 11)),
                        onPressed: () => _showAddUrlDialog(context, isDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddUrlDialog(BuildContext context, bool isDark) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Image URL', style: TextStyle(fontSize: 15)),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'https://example.com/product.jpg',
            isDense: true,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final url = ctrl.text.trim();
              if (url.isNotEmpty) {
                final list = List<String>.from(images)..add(url);
                onImagesChanged(list);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

