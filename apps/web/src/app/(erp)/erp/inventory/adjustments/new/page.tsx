'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createAdjustmentSchema, CreateAdjustmentInput } from '@/features/inventory/schemas';
import { getWarehouses } from '@/features/inventory/api/inventory.api';
import { Warehouse } from '@/features/inventory/types';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';

export default function NewAdjustmentPage() {
  const router = useRouter();
  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    getWarehouses().then(setWarehouses);
  }, []);

  const { register, control, handleSubmit, watch, formState: { errors } } = useForm<CreateAdjustmentInput>({
    resolver: zodResolver(createAdjustmentSchema) as any,
    defaultValues: {
      type: 'Deduction',
      reason: 'Damaged',
      items: [{ productId: '', adjustmentQty: 1 }]
    }
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'items'
  });

  const adjustmentType = watch('type');

  const onSubmit = async (data: CreateAdjustmentInput) => {
    setIsSubmitting(true);
    try {
      // Simulate API call
      await new Promise(res => setTimeout(res, 1000));
      toast.success('Stock adjustment submitted for approval');
      router.push('/inventory');
    } catch (err: any) {
      toast.error(err.message || 'Failed to submit adjustment');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-4xl pb-20">
      <PageHeader 
        title="Stock Adjustment" 
        description="Record shrinkages, damages, or found items."
        backHref="/erp/inventory"
      />

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
                  {warehouses.map(w => (
                    <option key={w.id} value={w.id}>{w.name}</option>
                  ))}
                </select>
                {errors.locationId && <p className="text-xs text-error">{errors.locationId.message}</p>}
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Reason Code <span className="text-error">*</span></label>
                <select {...register('reason')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="Damaged">Damaged</option>
                  <option value="Expired">Expired</option>
                  <option value="Found">Found</option>
                  <option value="Written off">Written off</option>
                  <option value="Stock count correction">Stock count correction</option>
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
                    <label className="text-xs font-medium">Product ID</label>
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
          <Button type="button" variant="outline" onClick={() => router.push('/inventory')} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? 'Submitting...' : 'Submit Adjustment'}
          </Button>
        </div>

      </form>
    </div>
  );
}
