'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';
import { useForm, useFieldArray } from 'react-hook-form';

export default function NewBOMPage() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);

  const { register, control, handleSubmit, formState: { errors } } = useForm({
    defaultValues: {
      finishedProductName: '',
      version: '1.0',
      yieldQty: 1,
      yieldUnit: 'piece',
      components: [
        { productName: '', quantity: 1, unit: 'piece', cost: 0 }
      ]
    }
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'components'
  });

  const onSubmit = async (data: any) => {
    setIsSubmitting(true);
    try {
      // Simulate API call
      await new Promise(r => setTimeout(r, 800));
      toast.success('BOM created successfully');
      router.push('/erp/production/boms');
    } catch (error) {
      toast.error('Failed to create BOM');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Create Bill of Materials" 
        description="Define a new product recipe."
      />

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6 max-w-4xl">
        <div className="bg-surface rounded-xl border border-border shadow-sm p-6">
          <h3 className="font-semibold mb-4 text-lg">General Information</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-2">
              <label className="text-sm font-medium">Finished Product</label>
              <Input {...register('finishedProductName')} placeholder="Select or type product name..." required />
            </div>
            
            <div className="space-y-2">
              <label className="text-sm font-medium">Version</label>
              <Input {...register('version')} placeholder="1.0" required />
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Yield Quantity</label>
              <Input type="number" {...register('yieldQty')} min="1" required />
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Yield Unit</label>
              <Input {...register('yieldUnit')} placeholder="e.g., piece, kg" required />
            </div>
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border shadow-sm overflow-hidden">
          <div className="px-6 py-4 border-b border-border bg-surface-2 flex items-center justify-between">
            <h3 className="font-semibold">Components</h3>
            <Button type="button" variant="outline" size="sm" onClick={() => append({ productName: '', quantity: 1, unit: 'piece', cost: 0 })}>
              + Add Component
            </Button>
          </div>
          
          <div className="p-6 space-y-4">
            {fields.map((field, index) => (
              <div key={field.id} className="grid grid-cols-12 gap-4 items-end bg-surface-2/30 p-4 rounded-lg border border-border/50">
                <div className="col-span-12 md:col-span-5 space-y-2">
                  <label className="text-xs font-medium">Component</label>
                  <Input {...register(`components.${index}.productName` as const)} placeholder="Component name" required />
                </div>
                <div className="col-span-6 md:col-span-2 space-y-2">
                  <label className="text-xs font-medium">Quantity</label>
                  <Input type="number" step="any" {...register(`components.${index}.quantity` as const)} required />
                </div>
                <div className="col-span-6 md:col-span-2 space-y-2">
                  <label className="text-xs font-medium">Unit</label>
                  <Input {...register(`components.${index}.unit` as const)} placeholder="Unit" required />
                </div>
                <div className="col-span-9 md:col-span-2 space-y-2">
                  <label className="text-xs font-medium">Unit Cost (₦)</label>
                  <Input type="number" step="any" {...register(`components.${index}.cost` as const)} required />
                </div>
                <div className="col-span-3 md:col-span-1 flex items-end justify-end h-full">
                  <Button type="button" variant="ghost" onClick={() => remove(index)} className="text-error w-10 h-10 p-0" disabled={fields.length === 1}>
                    ✕
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="flex gap-4">
          <Button type="button" variant="outline" onClick={() => router.back()}>Cancel</Button>
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? 'Saving...' : 'Save BOM'}
          </Button>
        </div>
      </form>
    </div>
  );
}
