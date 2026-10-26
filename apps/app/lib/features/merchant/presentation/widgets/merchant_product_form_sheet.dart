import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/merchant_product_entities.dart';

class MerchantProductFormSheet extends StatefulWidget {
  const MerchantProductFormSheet({
    super.key,
    this.existingProduct,
    required this.onSave,
  });

  final MerchantProduct? existingProduct;
  final Future<bool> Function(MerchantProduct product) onSave;

  static Future<void> show(
    BuildContext context, {
    MerchantProduct? existingProduct,
    required Future<bool> Function(MerchantProduct product) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MerchantProductFormSheet(
        existingProduct: existingProduct,
        onSave: onSave,
      ),
    );
  }

  @override
  State<MerchantProductFormSheet> createState() =>
      _MerchantProductFormSheetState();
}

class _MerchantProductFormSheetState extends State<MerchantProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _costCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _descCtrl;

  late String _category;
  late MerchantProductStatus _status;
  late String _imageUrl;
  bool _isSaving = false;

  static const _categories = [
    'Shoes & Footwear',
    'Bags & Luggage',
    'Fashion & Textiles',
    'Accessories',
    'Crafts & Gifts',
  ];

  static const _sampleProductImages = [
    'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=600&q=80',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(
      text: p?.sku ?? 'ABA-${DateTime.now().millisecondsSinceEpoch % 10000}',
    );
    _priceCtrl = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(0) : '',
    );
    _costCtrl = TextEditingController(
      text: p != null ? p.costPrice.toStringAsFixed(0) : '',
    );
    _stockCtrl = TextEditingController(
      text: p != null ? p.stock.toString() : '10',
    );
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _category = p?.category ?? _categories.first;
    _status = p?.status ?? MerchantProductStatus.active;
    _imageUrl = p?.imageUrl ?? _sampleProductImages.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _priceCtrl.dispose();
    _costCtrl.dispose();
    _stockCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.existingProduct != null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                isEditing ? 'Edit Product' : 'Add New Product',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),

              // Product Image Upload
              Row(
                children: [
                  AppNetworkImage.product(
                    imageUrl: _imageUrl,
                    width: 72,
                    height: 72,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Cover Image (1:1)',
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Upload photo or pick sample (JPEG, PNG up to 5MB)',
                          style: AppTypography.caption.copyWith(color: AppColors.grey, fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                          label: const Text('Change Photo', style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            final nextIndex = (_sampleProductImages.indexOf(_imageUrl) + 1) % _sampleProductImages.length;
                            setState(() => _imageUrl = _sampleProductImages[nextIndex]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Product Name',
                controller: _nameCtrl,
                hintText: 'e.g. Classic Men Brogue Shoes',
                validator: (v) => v == null || v.trim().isEmpty ? 'Product name is required' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'SKU / Barcode',
                      controller: _skuCtrl,
                      hintText: 'ABA-SH-001',
                      validator: (v) => v == null || v.trim().isEmpty ? 'SKU is required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _category,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Category', contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (val) => setState(() => _category = val ?? _category),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Selling Price (₦)',
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      hintText: '25000',
                      validator: (v) => v == null || double.tryParse(v) == null ? 'Valid price required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Cost Price (₦)',
                      controller: _costCtrl,
                      keyboardType: TextInputType.number,
                      hintText: '16000',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Stock Quantity',
                      controller: _stockCtrl,
                      keyboardType: TextInputType.number,
                      hintText: '10',
                      validator: (v) => v == null || int.tryParse(v) == null ? 'Valid integer required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<MerchantProductStatus>(
                      initialValue: _status,
                      decoration: const InputDecoration(labelText: 'Status', contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
                      items: MerchantProductStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))).toList(),
                      onChanged: (val) => setState(() => _status = val ?? _status),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Description (Optional)',
                controller: _descCtrl,
                maxLines: 2,
                hintText: 'Handmade genuine leather artisan piece...',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: isEditing ? 'Save Changes' : 'Publish Product',
                isLoading: _isSaving,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    setState(() => _isSaving = true);
    final product = MerchantProduct(
      id: widget.existingProduct?.id ?? 'prod-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      category: _category,
      price: double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
      costPrice: double.tryParse(_costCtrl.text.trim()) ?? 0.0,
      stock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
      description: _descCtrl.text.trim(),
      status: _status,
      imageUrl: _imageUrl,
      updatedAt: DateTime.now(),
    );
    final ok = await widget.onSave(product);
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (ok) navigator.pop();
  }
}
