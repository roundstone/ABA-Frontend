'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { useRouter } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createProductSchema, CreateProductInput } from '@/features/products/schemas';
import { createProduct } from '@/features/products/api/products.api';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';
import { getCategories } from '@/features/category/api';
import { getMerchants } from '@/features/merchant/api';
import { useAuthStore } from '@/features/auth/store';

export default function NewProductPage() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const activeRole = useAuthStore((state) => state.activeRole);
  const canSelectVendor = activeRole === 'Admin' || activeRole === 'Super Admin';
  const { data: categoriesData } = useQuery({ queryKey: ['product-categories'], queryFn: getCategories });
  const { data: vendorsData } = useQuery({ queryKey: ['vendors'], queryFn: getMerchants, enabled: canSelectVendor });

  const { register, control, handleSubmit, watch, formState: { errors } } = useForm<CreateProductInput>({
    resolver: zodResolver(createProductSchema) as any,
    defaultValues: {
      type: 'Finished good',
      status: 'Draft',
      cost: 0,
      sellingPrice: 0,
      hasVariants: false,
      trackInventory: true,
      priceIncludesTax: true,
    }
  });

  const { fields: variants, append: appendVariant, remove: removeVariant } = useFieldArray({
    control,
    name: 'variants'
  });

  const type = watch('type');
  const hasVariants = watch('hasVariants');
  const cost = watch('cost');
  const sellingPrice = watch('sellingPrice');

  const margin = sellingPrice > 0 ? ((sellingPrice - cost) / sellingPrice) * 100 : 0;

  const onSubmit = async (data: CreateProductInput) => {
    setIsSubmitting(true);
    try {
      // In a real app, images would be uploaded first and URLs collected.
      const newProduct = await createProduct(data);
      toast.success('Product created successfully');
      router.push(`/products/${newProduct.id}`);
    } catch (err: any) {
      toast.error(err.message || 'Failed to create product');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-5xl pb-20">
      <PageHeader 
        title="Add Product" 
        description="Create a new item in the catalogue."
        backHref="/erp/products"
      />

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
        
        {/* A. Basic Information */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Basic Information</h3>
          </div>
          <div className="p-6 space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Product Type <span className="text-error">*</span></label>
                <select {...register('type')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="Finished good">Finished good</option>
                  <option value="Raw material">Raw material</option>
                  <option value="Service">Service</option>
                  <option value="Bundle">Bundle</option>
                </select>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Status <span className="text-error">*</span></label>
                <select {...register('status')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="Draft">Draft</option>
                  <option value="Active">Active</option>
                </select>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Product Name <span className="text-error">*</span></label>
                <Input {...register('name')} placeholder="e.g. Premium Cotton T-Shirt" error={errors.name?.message} />
              </div>
              {canSelectVendor && <div className="space-y-2">
                <label className="text-sm font-medium">Vendor</label>
                <select {...register('vendorId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm">
                  <option value="">Select a vendor</option>
                  {vendorsData?.data.map((vendor) => <option key={vendor.id} value={vendor.id}>{vendor.name}</option>)}
                </select>
              </div>}
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Category <span className="text-error">*</span></label>
                <select {...register('categoryId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm">
                  <option value="">Select a category</option>
                  {categoriesData?.data.map((category) => <option key={category.id} value={category.id}>{category.name}</option>)}
                </select>
                {errors.categoryId?.message && <p className="text-sm text-error">{errors.categoryId.message}</p>}
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Unit of Measure <span className="text-error">*</span></label>
                <Input {...register('unitOfMeasure')} placeholder="pcs, kg, meters" error={errors.unitOfMeasure?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Brand (Optional)</label>
                <Input {...register('brand')} placeholder="Brand Name" error={errors.brand?.message} />
              </div>
            </div>
          </div>
        </div>

        {/* C. Pricing */}
        {type !== 'Service' && (
          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
              <h3 className="font-medium text-lg">Pricing</h3>
              {type !== 'Raw material' && (
                <span className={`text-sm font-medium px-2 py-1 rounded ${margin < 0 ? 'bg-error-bg text-error' : 'bg-success-bg text-success'}`}>
                  Margin: {margin.toFixed(1)}%
                </span>
              )}
            </div>
            <div className="p-6 space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <label className="text-sm font-medium">Cost Price (₦)</label>
                  <Input type="number" {...register('cost')} min="0" error={errors.cost?.message} />
                </div>
                {type !== 'Raw material' && (
                  <div className="space-y-2">
                    <label className="text-sm font-medium">Selling Price (₦)</label>
                    <Input type="number" {...register('sellingPrice')} min="0" error={errors.sellingPrice?.message} />
                  </div>
                )}
              </div>
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="checkbox" {...register('priceIncludesTax')} className="rounded border-border text-primary focus:ring-primary" />
                <span className="text-sm">Price includes tax</span>
              </label>
            </div>
          </div>
        )}

        {/* D. Variants */}
        {type !== 'Service' && type !== 'Raw material' && (
          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
              <h3 className="font-medium text-lg">Variants</h3>
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="checkbox" {...register('hasVariants')} className="rounded border-border text-primary focus:ring-primary" />
                <span className="text-sm font-medium">Product has variants</span>
              </label>
            </div>
            
            {hasVariants && (
              <div className="p-6 space-y-4">
                {variants.map((field, index) => (
                  <div key={field.id} className="flex gap-4 items-start p-4 border border-border rounded-lg bg-surface-2/30">
                    <div className="flex-1 space-y-4">
                        <div className="grid grid-cols-1 gap-4">
                        <div className="space-y-2">
                          <label className="text-xs font-medium">Variant Name</label>
                          <Input {...register(`variants.${index}.name`)} placeholder="Small / Red" />
                        </div>
                      </div>
                      <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2">
                          <label className="text-xs font-medium">Variant Cost</label>
                          <Input type="number" {...register(`variants.${index}.cost`)} defaultValue={cost} />
                        </div>
                        <div className="space-y-2">
                          <label className="text-xs font-medium">Variant Price</label>
                          <Input type="number" {...register(`variants.${index}.price`)} defaultValue={sellingPrice} />
                        </div>
                      </div>
                    </div>
                    <Button type="button" variant="ghost" onClick={() => removeVariant(index)} className="text-error mt-6">
                      Remove
                    </Button>
                  </div>
                ))}
                
                <Button 
                  type="button" 
                  variant="outline" 
                  onClick={() => appendVariant({ name: '', cost: cost, price: sellingPrice, reorderLevel: 0, isActive: true })}
                >
                  Add Variant
                </Button>
              </div>
            )}
          </div>
        )}

        {/* E. Inventory Settings */}
        {type !== 'Service' && (
          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="bg-surface-2 px-6 py-4 border-b border-border">
              <h3 className="font-medium text-lg">Inventory Settings</h3>
            </div>
            <div className="p-6 space-y-6">
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="checkbox" {...register('trackInventory')} className="rounded border-border text-primary focus:ring-primary" />
                <span className="text-sm font-medium">Track inventory for this product</span>
              </label>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <label className="text-sm font-medium">Reorder Level</label>
                  <Input type="number" {...register('reorderLevel')} min="0" error={errors.reorderLevel?.message} />
                  <p className="text-xs text-text-muted">System will warn when stock drops below this level.</p>
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium">Reorder Quantity</label>
                  <Input type="number" {...register('reorderQuantity')} min="0" error={errors.reorderQuantity?.message} />
                </div>
              </div>
            </div>
          </div>
        )}

        <div className="flex items-center gap-4 border-t border-border pt-6">
          <Button type="button" variant="outline" onClick={() => router.push('/products')} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? 'Saving...' : 'Save Product'}
          </Button>
        </div>

      </form>
    </div>
  );
}
