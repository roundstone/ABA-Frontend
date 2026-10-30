import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/merchant_providers.dart';
import '../../domain/merchant_product_entities.dart';
import 'merchant_product_image_picker.dart';
import 'merchant_product_inventory_fields.dart';
import 'merchant_product_taxonomy_fields.dart';

class MerchantProductFormSheet extends ConsumerStatefulWidget {
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
  ConsumerState<MerchantProductFormSheet> createState() =>
      _MerchantProductFormSheetState();
}

class _MerchantProductFormSheetState
    extends ConsumerState<MerchantProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _costCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _reorderLevelCtrl;
  late final TextEditingController _reorderQtyCtrl;

  int? _selectedCategoryId;
  int? _selectedSubcategoryId;
  int? _selectedBrandId;
  String _categoryName = 'General';
  String _unitOfMeasure = 'piece';
  int _productType = 1;
  bool _isActive = true;
  List<String> _images = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(
      text: p?.sku ?? 'ABA-${DateTime.now().millisecondsSinceEpoch % 10000}',
    );
    _priceCtrl = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(2) : '',
    );
    _costCtrl = TextEditingController(
      text: p != null ? p.costPrice.toStringAsFixed(2) : '',
    );
    _stockCtrl = TextEditingController(
      text: p != null ? p.stock.toString() : '10',
    );
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _reorderLevelCtrl = TextEditingController(
      text: (p?.reorderLevel ?? 10).toString(),
    );
    _reorderQtyCtrl = TextEditingController(
      text: (p?.reorderQuantity ?? 25).toString(),
    );

    _selectedCategoryId = p?.categoryId;
    _selectedSubcategoryId = p?.subcategoryId;
    _selectedBrandId = p?.brandId;
    _categoryName = p?.category ?? 'General';
    _unitOfMeasure = p?.baseUnitOfMeasurement ?? 'piece';
    _productType = p?.type ?? 1;
    _isActive = p?.status != MerchantProductStatus.draft;

    if (p != null && p.productImages.isNotEmpty) {
      _images = List<String>.from(p.productImages);
    } else if (p != null && p.imageUrl.isNotEmpty) {
      _images = [p.imageUrl];
    } else {
      _images = [MerchantProductImagePicker.samplePresets.first];
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _priceCtrl.dispose();
    _costCtrl.dispose();
    _stockCtrl.dispose();
    _descCtrl.dispose();
    _reorderLevelCtrl.dispose();
    _reorderQtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.existingProduct != null;
    final cats = ref.watch(merchantCategoriesProvider).valueOrNull ?? const [];
    final subs =
        ref
            .watch(merchantSubcategoriesProvider(_selectedCategoryId))
            .valueOrNull ??
        const [];
    final brands = ref.watch(merchantBrandsProvider).valueOrNull ?? const [];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
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
                isEditing ? 'Edit Merchant Product' : 'Create Merchant Product',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              MerchantProductImagePicker(
                images: _images,
                onImagesChanged: (imgs) => setState(() => _images = imgs),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Product Name *',
                controller: _nameCtrl,
                hintText: 'e.g. iPhone 17 Pro',
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Product name is required'
                    : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Description',
                controller: _descCtrl,
                maxLines: 2,
                hintText: 'Flagship smartphone with a titanium finish.',
              ),
              const SizedBox(height: AppSpacing.sm),
              MerchantProductTaxonomyFields(
                selectedCategoryId: _selectedCategoryId,
                selectedSubcategoryId: _selectedSubcategoryId,
                selectedBrandId: _selectedBrandId,
                productType: _productType,
                categories: cats,
                subcategories: subs,
                brands: brands,
                onCategoryChanged: (val) {
                  setState(() {
                    _selectedCategoryId = val;
                    _selectedSubcategoryId = null;
                    final match = cats
                        .where((c) => int.tryParse(c.id) == val)
                        .firstOrNull;
                    if (match != null) _categoryName = match.name;
                  });
                },
                onSubcategoryChanged: (val) =>
                    setState(() => _selectedSubcategoryId = val),
                onBrandChanged: (val) => setState(() => _selectedBrandId = val),
                onTypeChanged: (val) => setState(() => _productType = val),
              ),
              const SizedBox(height: AppSpacing.sm),
              MerchantProductInventoryFields(
                priceCtrl: _priceCtrl,
                costCtrl: _costCtrl,
                stockCtrl: _stockCtrl,
                reorderLevelCtrl: _reorderLevelCtrl,
                reorderQtyCtrl: _reorderQtyCtrl,
                unitOfMeasure: _unitOfMeasure,
                onUnitChanged: (v) => setState(() => _unitOfMeasure = v),
              ),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Publish Immediately (Active)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _isActive ? 'Active on store and POS' : 'Draft in inventory',
                  style: const TextStyle(fontSize: 11),
                ),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: isEditing ? 'Save Product Changes' : 'Create Product',
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
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one product image is required.'),
        ),
      );
      return;
    }
    final navigator = Navigator.of(context);
    setState(() => _isSaving = true);

    final product = MerchantProduct(
      id:
          widget.existingProduct?.id ??
          'prod-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      category: _categoryName,
      categoryId: _selectedCategoryId,
      subcategoryId: _selectedSubcategoryId,
      brandId: _selectedBrandId,
      price: double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
      costPrice: double.tryParse(_costCtrl.text.trim()) ?? 0.0,
      stock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
      lowStockThreshold: int.tryParse(_reorderLevelCtrl.text.trim()) ?? 10,
      baseUnitOfMeasurement: _unitOfMeasure,
      type: _productType,
      reorderLevel: int.tryParse(_reorderLevelCtrl.text.trim()) ?? 10,
      reorderQuantity: int.tryParse(_reorderQtyCtrl.text.trim()) ?? 25,
      imageUrl: _images.first,
      productImages: _images,
      description: _descCtrl.text.trim(),
      status: _isActive
          ? MerchantProductStatus.active
          : MerchantProductStatus.draft,
      updatedAt: DateTime.now(),
    );

    final ok = await widget.onSave(product);
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (ok) navigator.pop();
  }
}
