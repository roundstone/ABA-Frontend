'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createPOSchema, CreatePOInput } from '@/features/procurement/schemas';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { AmountText } from '@/components/patterns/AmountText';
import { toast } from 'sonner';

export default function NewPurchaseOrderPage() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);

  const { register, control, handleSubmit, watch, formState: { errors } } = useForm<CreatePOInput>({
    resolver: zodResolver(createPOSchema) as any,
    defaultValues: {
      orderDate: new Date().toISOString().split('T')[0],
      currency: 'NGN',
      paymentTerms: 'Net 30',
      lines: [{ productId: '', quantity: 1, unitPrice: 0, taxRate: 7.5, discount: 0 }],
      shippingCharge: 0
    }
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'lines'
  });

  const watchLines = watch('lines');
  const watchShipping = watch('shippingCharge') || 0;

  // Calculate totals
  const subtotal = watchLines.reduce((acc, line) => acc + (line.quantity * (line.unitPrice || 0)), 0);
  const taxTotal = watchLines.reduce((acc, line) => acc + (line.quantity * (line.unitPrice || 0) * (line.taxRate / 100)), 0);
  const discountTotal = watchLines.reduce((acc, line) => acc + (line.discount || 0), 0);
  const total = subtotal + taxTotal - discountTotal + Number(watchShipping);

  const onSubmit = async (data: CreatePOInput) => {
    setIsSubmitting(true);
    try {
      await new Promise(res => setTimeout(res, 1000));
      toast.success('Purchase Order created successfully');
      router.push('/erp/procurement/orders');
    } catch (err: any) {
      toast.error('Failed to create PO');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-6xl pb-20">
      <PageHeader 
        title="Create Purchase Order" 
        description="Draft a formal order to a supplier."
        backHref="/erp/procurement/orders"
      />

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
        
        {/* Header Details */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Vendor & Delivery</h3>
          </div>
          <div className="p-6 space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Supplier <span className="text-error">*</span></label>
                <select {...register('supplierId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="">Select supplier</option>
                  <option value="sup-1">Global Textiles Ltd (NGN)</option>
                  <option value="sup-2">Chemicals Plus (NGN)</option>
                </select>
                {errors.supplierId && <p className="text-xs text-error">{errors.supplierId.message}</p>}
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Deliver To <span className="text-error">*</span></label>
                <select {...register('deliverToLocationId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="wh-1">Central Warehouse (Ikeja)</option>
                  <option value="wh-2">Production Floor A</option>
                </select>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Order Date <span className="text-error">*</span></label>
                <Input type="date" {...register('orderDate')} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Expected Delivery <span className="text-error">*</span></label>
                <Input type="date" {...register('expectedDeliveryDate')} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Payment Terms</label>
                <Input {...register('paymentTerms')} />
              </div>
            </div>
          </div>
        </div>

        {/* Financial Lines */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
            <h3 className="font-medium text-lg">Order Lines</h3>
            <span className="text-sm font-medium">Currency: {watch('currency')}</span>
          </div>
          
          <div className="p-6 overflow-x-auto">
            <table className="w-full text-sm text-left whitespace-nowrap">
              <thead>
                <tr className="border-b border-border text-text-muted">
                  <th className="pb-3 font-medium w-[300px]">Product</th>
                  <th className="pb-3 font-medium w-[100px]">Qty</th>
                  <th className="pb-3 font-medium w-[150px]">Unit Price</th>
                  <th className="pb-3 font-medium w-[100px]">Tax %</th>
                  <th className="pb-3 font-medium w-[150px]">Discount</th>
                  <th className="pb-3 font-medium text-right w-[150px]">Line Total</th>
                  <th className="pb-3 w-[50px]"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {fields.map((field, index) => {
                  const qty = watchLines[index]?.quantity || 0;
                  const price = watchLines[index]?.unitPrice || 0;
                  const tax = watchLines[index]?.taxRate || 0;
                  const disc = watchLines[index]?.discount || 0;
                  const lineTotal = (qty * price) + (qty * price * (tax/100)) - disc;

                  return (
                    <tr key={field.id}>
                      <td className="py-3 pr-2">
                        <Input {...register(`lines.${index}.productId`)} placeholder="Search product..." className="h-9" />
                      </td>
                      <td className="py-3 px-2">
                        <Input type="number" {...register(`lines.${index}.quantity`)} min="1" className="h-9" />
                      </td>
                      <td className="py-3 px-2">
                        <Input type="number" {...register(`lines.${index}.unitPrice`)} className="h-9" />
                      </td>
                      <td className="py-3 px-2">
                        <Input type="number" {...register(`lines.${index}.taxRate`)} className="h-9" />
                      </td>
                      <td className="py-3 px-2">
                        <Input type="number" {...register(`lines.${index}.discount`)} className="h-9" />
                      </td>
                      <td className="py-3 pl-2 text-right font-medium">
                        <AmountText amountInKobo={lineTotal} />
                      </td>
                      <td className="py-3 text-right">
                        <Button type="button" variant="ghost" size="sm" onClick={() => remove(index)} className="text-error px-2 h-9">
                          ✕
                        </Button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
            
            <div className="mt-4">
              <Button type="button" variant="outline" size="sm" onClick={() => append({ productId: '', quantity: 1, unitPrice: 0, taxRate: 7.5, discount: 0 })}>
                + Add Line Item
              </Button>
            </div>
          </div>

          <div className="bg-surface-2 p-6 border-t border-border flex justify-end">
            <div className="w-full max-w-xs space-y-3">
              <div className="flex justify-between text-sm">
                <span className="text-text-muted">Subtotal</span>
                <span><AmountText amountInKobo={subtotal} /></span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-text-muted">Tax</span>
                <span><AmountText amountInKobo={taxTotal} /></span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-text-muted">Discount</span>
                <span className="text-error">-<AmountText amountInKobo={discountTotal} /></span>
              </div>
              <div className="flex justify-between text-sm items-center">
                <span className="text-text-muted">Shipping</span>
                <Input type="number" {...register('shippingCharge')} className="w-32 h-8 text-right" />
              </div>
              <div className="flex justify-between font-medium text-lg pt-3 border-t border-border">
                <span>Total</span>
                <span className="text-primary"><AmountText amountInKobo={total} /></span>
              </div>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-4 pt-4">
          <Button type="button" variant="outline" onClick={() => router.push('/erp/procurement/orders')} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button type="button" variant="outline" disabled={isSubmitting}>
            Save Draft
          </Button>
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? 'Submitting...' : 'Issue PO'}
          </Button>
        </div>

      </form>
    </div>
  );
}
