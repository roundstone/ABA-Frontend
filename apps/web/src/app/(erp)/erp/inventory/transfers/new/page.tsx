'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createTransferSchema, CreateTransferInput } from '@/features/inventory/schemas';
import { getWarehouses } from '@/features/inventory/api/inventory.api';
import { Warehouse } from '@/features/inventory/types';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';

export default function NewTransferPage() {
  const router = useRouter();
  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    getWarehouses().then(setWarehouses);
  }, []);

  const { register, control, handleSubmit, formState: { errors } } = useForm<CreateTransferInput>({
    resolver: zodResolver(createTransferSchema) as any,
    defaultValues: {
      expectedDate: new Date().toISOString().split('T')[0],
      items: [{ productId: '', quantity: 1 }]
    }
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'items'
  });

  const onSubmit = async (data: CreateTransferInput) => {
    setIsSubmitting(true);
    try {
      // Simulate API call
      await new Promise(res => setTimeout(res, 1000));
      toast.success('Stock transfer request submitted for approval');
      router.push('/inventory');
    } catch (err: any) {
      toast.error(err.message || 'Failed to submit transfer');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-4xl pb-20">
      <PageHeader 
        title="Request Stock Transfer" 
        description="Move inventory between warehouses and store locations."
        backHref="/erp/inventory"
      />

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
        
        {/* Locations */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Routing Details</h3>
          </div>
          <div className="p-6 space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">From Warehouse <span className="text-error">*</span></label>
                <select {...register('fromLocationId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="">Select source location</option>
                  {warehouses.map(w => (
                    <option key={w.id} value={w.id}>{w.name}</option>
                  ))}
                </select>
                {errors.fromLocationId && <p className="text-xs text-error">{errors.fromLocationId.message}</p>}
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">To Warehouse <span className="text-error">*</span></label>
                <select {...register('toLocationId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="">Select destination location</option>
                  {warehouses.map(w => (
                    <option key={w.id} value={w.id}>{w.name}</option>
                  ))}
                </select>
                {errors.toLocationId && <p className="text-xs text-error">{errors.toLocationId.message}</p>}
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Expected Date <span className="text-error">*</span></label>
                <Input type="date" {...register('expectedDate')} error={errors.expectedDate?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Reason / Notes</label>
                <Input {...register('reason')} placeholder="e.g. Restocking flagship for weekend sale" />
              </div>
            </div>
          </div>
        </div>

        {/* Items */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
            <h3 className="font-medium text-lg">Items to Transfer</h3>
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
                    <label className="text-xs font-medium">Transfer Qty</label>
                    <Input type="number" {...register(`items.${index}.quantity`)} min="1" />
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
              onClick={() => append({ productId: '', quantity: 1 })}
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
            {isSubmitting ? 'Submitting...' : 'Submit Transfer'}
          </Button>
        </div>

      </form>
    </div>
  );
}
