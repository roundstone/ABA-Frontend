'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createGRNSchema, CreateGRNInput } from '@/features/procurement/schemas';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';

export default function NewGRNPage() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [selectedPo, setSelectedPo] = useState<string>('');

  const { register, control, handleSubmit, watch, formState: { errors } } = useForm<CreateGRNInput>({
    resolver: zodResolver(createGRNSchema) as any,
    defaultValues: {
      receivedDate: new Date().toISOString().split('T')[0],
      lines: []
    }
  });

  const { fields, replace } = useFieldArray({
    control,
    name: 'lines'
  });

  const watchLines = watch('lines');

  // Mock fetching PO lines when PO is selected
  const handlePoChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const val = e.target.value;
    setSelectedPo(val);
    
    if (val === 'po-2038') {
      replace([
        { poLineId: 'line-1', productId: 'prod-3', receivedNow: 50, acceptedQty: 50, rejectedQty: 0 }
      ]);
    } else {
      replace([]);
    }
  };

  const onSubmit = async (data: CreateGRNInput) => {
    setIsSubmitting(true);
    try {
      await new Promise(res => setTimeout(res, 1000));
      toast.success('Goods Receipt Note posted successfully');
      router.push('/procurement/receiving');
    } catch (err: any) {
      toast.error('Failed to post GRN');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-6xl pb-20">
      <PageHeader 
        title="Receive Goods (GRN)" 
        description="Log items received into the warehouse against a PO."
        backHref="/erp/procurement/receiving"
      />

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
        
        {/* Header Details */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Receipt Details</h3>
          </div>
          <div className="p-6 space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Purchase Order <span className="text-error">*</span></label>
                <select {...register('poId')} onChange={(e) => { register('poId').onChange(e); handlePoChange(e); }} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="">Select Open PO</option>
                  <option value="po-2038">PO-2038 (Chemicals Plus)</option>
                  <option value="po-2041">PO-2041 (Global Textiles Ltd)</option>
                </select>
                {errors.poId && <p className="text-xs text-error">{errors.poId.message}</p>}
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Receiving Warehouse <span className="text-error">*</span></label>
                <select {...register('receivingWarehouseId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="">Select location</option>
                  <option value="wh-1">Central Warehouse (Ikeja)</option>
                  <option value="wh-2">Production Floor A</option>
                </select>
                {errors.receivingWarehouseId && <p className="text-xs text-error">{errors.receivingWarehouseId.message}</p>}
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Received Date <span className="text-error">*</span></label>
                <Input type="date" {...register('receivedDate')} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Delivery Note No.</label>
                <Input {...register('deliveryNoteNo')} placeholder="From supplier" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Vehicle / Driver</label>
                <Input {...register('vehicleDriver')} placeholder="Optional" />
              </div>
            </div>
          </div>
        </div>

        {/* Line Items */}
        {fields.length > 0 && (
          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="bg-surface-2 px-6 py-4 border-b border-border">
              <h3 className="font-medium text-lg">Inspection & Quantities</h3>
            </div>
            
            <div className="p-6 overflow-x-auto">
              <table className="w-full text-sm text-left whitespace-nowrap">
                <thead>
                  <tr className="border-b border-border text-text-muted">
                    <th className="pb-3 font-medium w-[250px]">Product</th>
                    <th className="pb-3 font-medium w-[120px]">Received Now</th>
                    <th className="pb-3 font-medium w-[120px]">Accepted (Pass)</th>
                    <th className="pb-3 font-medium w-[120px]">Rejected (Fail)</th>
                    <th className="pb-3 font-medium w-[150px]">Rejection Reason</th>
                    <th className="pb-3 font-medium w-[150px]">Batch No (Opt)</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border">
                  {fields.map((field, index) => {
                    const rejectedQty = watchLines[index]?.rejectedQty || 0;
                    
                    return (
                      <tr key={field.id}>
                        <td className="py-4 pr-2 font-medium">
                          Product ID: {field.productId}
                        </td>
                        <td className="py-4 px-2">
                          <Input type="number" {...register(`lines.${index}.receivedNow`)} min="0" className="h-9" />
                        </td>
                        <td className="py-4 px-2">
                          <Input type="number" {...register(`lines.${index}.acceptedQty`)} min="0" className="h-9 font-medium text-success" />
                        </td>
                        <td className="py-4 px-2">
                          <Input type="number" {...register(`lines.${index}.rejectedQty`)} min="0" className="h-9 font-medium text-error" />
                        </td>
                        <td className="py-4 px-2">
                          <select {...register(`lines.${index}.rejectionReason`)} disabled={rejectedQty === 0} className="w-full flex h-9 rounded-md border border-border bg-surface px-3 py-1 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary disabled:opacity-50">
                            <option value="">Select reason...</option>
                            <option value="Damaged">Damaged</option>
                            <option value="Wrong item">Wrong item</option>
                            <option value="Quality fail">Quality fail</option>
                            <option value="Short">Short (Missing)</option>
                          </select>
                        </td>
                        <td className="py-4 pl-2">
                          <Input {...register(`lines.${index}.batchNo`)} placeholder="Batch..." className="h-9" />
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
              {errors.lines && <p className="text-sm text-error mt-4">Please fix errors in the inspection table.</p>}
            </div>
          </div>
        )}

        {fields.length === 0 && selectedPo && (
          <div className="bg-surface p-12 text-center rounded-xl border border-border">
            <p className="text-text-muted">Loading PO lines...</p>
          </div>
        )}

        <div className="flex items-center gap-4 pt-4">
          <Button type="button" variant="outline" onClick={() => router.push('/procurement/receiving')} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button type="submit" disabled={isSubmitting || fields.length === 0}>
            {isSubmitting ? 'Posting...' : 'Post GRN to Inventory'}
          </Button>
        </div>

      </form>
    </div>
  );
}
