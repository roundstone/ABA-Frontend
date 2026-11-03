'use client';

import { useState, useEffect, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createAdjustmentSchema, CreateAdjustmentInput } from '@/features/inventory/schemas';
import { getWarehouses } from '@/features/inventory/api/inventory.api';
import { Warehouse } from '@/features/inventory/types';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';

function NewAdjustmentForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const prefillProductId = searchParams.get('productId') || '';

  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const { register, control, handleSubmit, watch, setValue, formState: { errors } } = useForm<CreateAdjustmentInput>({
    resolver: zodResolver(createAdjustmentSchema) as any,
    defaultValues: {
      type: 'Deduction',
      reason: 'Damage',
      items: [{ productId: prefillProductId, adjustmentQty: 1 }],
    },
  });

  useEffect(() => {
    getWarehouses().then((data) => {
      setWarehouses(data);
      if (data.length > 0) {
        setValue('locationId', data[0].id);
      }
    });
  }, [setValue]);

  useEffect(() => {
    if (prefillProductId) {
      setValue('items.0.productId', prefillProductId);
    }
  }, [prefillProductId, setValue]);

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'items',
  });

  const adjustmentType = watch('type');

  const onSubmit = async (_data: CreateAdjustmentInput) => {
    setIsSubmitting(true);
    try {
      await new Promise((res) => setTimeout(res, 800));
      toast.success('Stock adjustment submitted for approval');
      router.push('/erp/inventory');
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'Failed to submit adjustment';
      toast.error(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
      {/* Core Details */}
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
          <h3 className="font-medium text-lg">Adjustment Details</h3>
          <div className="flex gap-4 items-center">
            <label className="flex items-center gap-2 cursor-pointer">
              <input type="radio" value="Deduction" {...register('type')} className="text-error focus:ring-error" />
              <span className="text-sm font-medium text-error">Deduction (Shrinkage)</span>
            </label>
            <label className="flex items-center gap-2 cursor-pointer">
              <input type="radio" value="Addition" {...register('type')} className="text-success focus:ring-success" />
              <span className="text-sm font-medium text-success">Addition (Found)</span>
            </label>
          </div>
        </div>
        <div className="p-6 space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <label className="text-sm font-medium">Location <span className="text-error">*</span></label>
              <select {...register('locationId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                <option value="">Select location</option>
                {warehouses.map((w) => (
                  <option key={w.id} value={w.id}>{w.name}</option>
                ))}
              </select>
              {errors.locationId && <p className="text-xs text-error">{errors.locationId.message}</p>}
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Reason Code <span className="text-error">*</span></label>
              <select {...register('reason')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                <option value="Damage">Damage</option>
                <option value="Expiry">Expiry</option>
                <option value="Theft/Loss">Theft/Loss</option>
                <option value="Count correction">Count correction</option>
                <option value="Found stock">Found stock</option>
                <option value="Opening balance">Opening balance</option>
                <option value="Other">Other</option>
              </select>
            </div>
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Additional Notes</label>
            <Input {...register('notes')} placeholder="Provide more context for the approver..." />
          </div>
        </div>
      </div>

      {/* Items */}
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
          <h3 className="font-medium text-lg">Items to Adjust</h3>
        </div>
        <div className="p-6 space-y-4">
          {fields.map((field, index) => (
            <div key={field.id} className="flex gap-4 items-start p-4 border border-border rounded-lg bg-surface-2/30">
              <div className="flex-1 grid grid-cols-3 gap-4">
                <div className="col-span-2 space-y-2">
                  <label className="text-xs font-medium">Product ID / SKU</label>
                  <Input {...register(`items.${index}.productId`)} placeholder="Enter Product SKU/ID" />
                </div>
                <div className="space-y-2">
                  <label className="text-xs font-medium">Qty to {adjustmentType === 'Deduction' ? 'Deduct' : 'Add'}</label>
                  <Input type="number" {...register(`items.${index}.adjustmentQty`)} min="1" className={adjustmentType === 'Deduction' ? 'text-error font-medium' : 'text-success font-medium'} />
                </div>
              </div>
              <Button type="button" variant="ghost" onClick={() => remove(index)} className="text-error mt-6">
                Remove
              </Button>
            </div>
          ))}
          {errors.items?.root && <p className="text-sm text-error">{errors.items.root.message}</p>}
          
          <Button 
            type="button" 
            variant="outline" 
            onClick={() => append({ productId: '', adjustmentQty: 1 })}
          >
            Add Item
          </Button>
        </div>
      </div>

      <div className="flex items-center gap-4 border-t border-border pt-6">
        <Button type="button" variant="outline" onClick={() => router.push('/erp/inventory')} disabled={isSubmitting}>
          Cancel
        </Button>
        <Button type="submit" disabled={isSubmitting}>
          {isSubmitting ? 'Submitting...' : 'Submit Adjustment'}
        </Button>
      </div>
    </form>
  );
}

export default function NewAdjustmentPage() {
  return (
    <div className="space-y-6 max-w-4xl pb-20">
      <PageHeader 
        title="Stock Adjustment" 
        description="Record shrinkages, damages, or found items."
        backHref="/erp/inventory"
      />
      <Suspense fallback={<div className="p-8 text-center text-text-muted">Loading adjustment form...</div>}>
        <NewAdjustmentForm />
      </Suspense>
    </div>
  );
}
