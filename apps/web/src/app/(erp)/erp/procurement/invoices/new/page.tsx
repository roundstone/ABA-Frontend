'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createInvoiceSchema, CreateInvoiceInput } from '@/features/procurement/schemas';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';
import { AmountText } from '@/components/patterns/AmountText';

export default function NewInvoicePage() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [hasVariances, setHasVariances] = useState(false);

  const { register, control, handleSubmit, watch, formState: { errors } } = useForm<CreateInvoiceInput>({
    resolver: zodResolver(createInvoiceSchema) as any,
    defaultValues: {
      invoiceDate: new Date().toISOString().split('T')[0],
      poIds: [],
      lines: []
    }
  });

  const { fields, replace } = useFieldArray({
    control,
    name: 'lines'
  });

  const watchLines = watch('lines');
  const watchTax = watch('taxAmount') || 0;
  const watchAdditional = watch('additionalCharges') || 0;

  const subtotal = watchLines.reduce((acc, line) => acc + (line.quantity * (line.unitPrice || 0)), 0);
  const total = subtotal + Number(watchTax) + Number(watchAdditional);

  const handlePoChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const val = e.target.value;
    
    if (val === 'po-2038') {
      replace([
        { productId: 'prod-3', quantity: 50, unitPrice: 45000 } // Simulate 3-way match pull
      ]);
    } else {
      replace([]);
    }
  };

  const onSubmit = async (data: CreateInvoiceInput) => {
    setIsSubmitting(true);
    try {
      await new Promise(res => setTimeout(res, 1000));
      if (hasVariances) {
        toast.warning('Invoice logged but placed On Hold due to variances');
      } else {
        toast.success('Invoice matched and approved successfully');
      }
      router.push('/procurement/invoices');
    } catch (err: any) {
      toast.error('Failed to log invoice');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-5xl pb-20">
      <PageHeader 
        title="Log Supplier Invoice" 
        description="Perform a 3-way match (PO vs GRN vs Invoice) to approve payment."
        backHref="/erp/procurement/invoices"
      />

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
        
        {/* Header Details */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Invoice Header</h3>
          </div>
          <div className="p-6 space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Supplier <span className="text-error">*</span></label>
                <select {...register('supplierId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="">Select supplier</option>
                  <option value="sup-1">Global Textiles Ltd</option>
                  <option value="sup-2">Chemicals Plus</option>
                </select>
                {errors.supplierId && <p className="text-xs text-error">{errors.supplierId.message}</p>}
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Supplier Invoice No. <span className="text-error">*</span></label>
                <Input {...register('supplierInvoiceNo')} placeholder="e.g. INV-12345" />
                {errors.supplierInvoiceNo && <p className="text-xs text-error">{errors.supplierInvoiceNo.message}</p>}
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Invoice Date <span className="text-error">*</span></label>
                <Input type="date" {...register('invoiceDate')} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Due Date <span className="text-error">*</span></label>
                <Input type="date" {...register('dueDate')} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Match against PO <span className="text-error">*</span></label>
                <select {...register('poIds.0')} onChange={handlePoChange} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="">Select PO</option>
                  <option value="po-2038">PO-2038</option>
                </select>
                {errors.poIds && <p className="text-xs text-error">Required</p>}
              </div>
            </div>
          </div>
        </div>

        {/* 3-way Match Lines */}
        {fields.length > 0 && (
          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
              <h3 className="font-medium text-lg">Invoice Lines (3-Way Match)</h3>
              <div className="flex items-center gap-2">
                <input type="checkbox" id="simulate_variance" onChange={(e) => setHasVariances(e.target.checked)} className="rounded border-border text-primary focus:ring-primary"/>
                <label htmlFor="simulate_variance" className="text-sm cursor-pointer text-text-muted">Simulate Variance</label>
              </div>
            </div>
            
            <div className="p-6 overflow-x-auto">
              <table className="w-full text-sm text-left whitespace-nowrap">
                <thead>
                  <tr className="border-b border-border text-text-muted">
                    <th className="pb-3 font-medium w-[250px]">Product</th>
                    <th className="pb-3 font-medium w-[120px]">PO/GRN Qty</th>
                    <th className="pb-3 font-medium w-[120px]">Invoice Qty</th>
                    <th className="pb-3 font-medium w-[120px]">PO Price</th>
                    <th className="pb-3 font-medium w-[120px]">Invoice Price</th>
                    <th className="pb-3 font-medium text-right w-[150px]">Line Total</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border">
                  {fields.map((field, index) => {
                    const invQty = watchLines[index]?.quantity || 0;
                    const invPrice = watchLines[index]?.unitPrice || 0;
                    const isQtyVar = hasVariances && invQty !== 50;
                    const isPriceVar = hasVariances;

                    return (
                      <tr key={field.id}>
                        <td className="py-4 pr-2 font-medium">Product ID: {field.productId}</td>
                        <td className="py-4 px-2 text-text-muted font-mono">50</td>
                        <td className="py-4 px-2">
                          <Input type="number" {...register(`lines.${index}.quantity`)} className={`h-9 ${isQtyVar ? 'border-error text-error bg-error-bg/20' : ''}`} />
                        </td>
                        <td className="py-4 px-2 text-text-muted font-mono">45,000</td>
                        <td className="py-4 px-2">
                          <Input type="number" {...register(`lines.${index}.unitPrice`)} defaultValue={hasVariances ? 47000 : 45000} className={`h-9 ${isPriceVar ? 'border-error text-error bg-error-bg/20' : ''}`} />
                        </td>
                        <td className="py-4 pl-2 text-right font-medium">
                          <AmountText amountInKobo={invQty * invPrice} />
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
              {hasVariances && (
                <div className="mt-4 p-3 bg-error-bg/50 border border-error-border rounded-lg text-error text-sm font-medium">
                  Warning: Invoice details do not match the Purchase Order / Goods Receipt within allowed tolerance. This invoice will require Manager Approval.
                </div>
              )}
            </div>

            <div className="bg-surface-2 p-6 border-t border-border flex justify-end">
              <div className="w-full max-w-xs space-y-3">
                <div className="flex justify-between text-sm">
                  <span className="text-text-muted">Subtotal</span>
                  <span><AmountText amountInKobo={subtotal} /></span>
                </div>
                <div className="flex justify-between text-sm items-center">
                  <span className="text-text-muted">Tax Amount</span>
                  <Input type="number" {...register('taxAmount')} className="w-32 h-8 text-right" />
                </div>
                <div className="flex justify-between text-sm items-center">
                  <span className="text-text-muted">Additional Charges</span>
                  <Input type="number" {...register('additionalCharges')} className="w-32 h-8 text-right" />
                </div>
                <div className="flex justify-between font-medium text-lg pt-3 border-t border-border">
                  <span>Total</span>
                  <span className="text-primary"><AmountText amountInKobo={total} /></span>
                </div>
              </div>
            </div>
          </div>
        )}

        <div className="flex items-center gap-4 pt-4">
          <Button type="button" variant="outline" onClick={() => router.push('/procurement/invoices')} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button type="submit" disabled={isSubmitting || fields.length === 0}>
            {isSubmitting ? 'Processing...' : 'Submit 3-Way Match'}
          </Button>
        </div>

      </form>
    </div>
  );
}
