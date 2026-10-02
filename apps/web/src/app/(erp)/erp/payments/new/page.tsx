'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { recordPaymentSchema, RecordPaymentInput } from '@/features/payments/schemas';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';

export default function RecordPaymentPage() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);

  const { register, control, handleSubmit, watch, formState: { errors } } = useForm<RecordPaymentInput>({
    resolver: zodResolver(recordPaymentSchema) as any,
    defaultValues: {
      direction: 'In',
      type: 'Order',
      method: 'Transfer',
      paymentDate: new Date().toISOString().split('T')[0],
      amount: 0,
      fee: 0,
      allocations: [{ documentId: '', documentType: 'Order', amountAllocated: 0 }]
    }
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'allocations'
  });

  const watchMethod = watch('method');
  const watchDirection = watch('direction');
  const requiresReference = ['Transfer', 'Card', 'Cheque'].includes(watchMethod);

  const onSubmit = async (data: RecordPaymentInput) => {
    setIsSubmitting(true);
    try {
      await new Promise(res => setTimeout(res, 1000));
      toast.success('Payment recorded successfully');
      router.push('/payments');
    } catch (err: any) {
      toast.error('Failed to record payment');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-4xl mx-auto pb-20">
      <PageHeader 
        title="Record Payment" 
        description="Manually record incoming receipts or outgoing payments."
        backHref="/erp/payments"
      />

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        
        {/* Core Setup */}
        <div className="bg-surface rounded-xl border border-border p-6 space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <label className="text-sm font-medium">Direction</label>
              <select {...register('direction')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                <option value="In">Money In (Receipt)</option>
                <option value="Out">Money Out (Payment)</option>
              </select>
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Payment Type</label>
              <select {...register('type')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                {watchDirection === 'In' ? (
                  <>
                    <option value="Order">Customer Order</option>
                    <option value="Wallet top-up">Wallet Top-up</option>
                  </>
                ) : (
                  <>
                    <option value="Supplier">Supplier Invoice</option>
                    <option value="Refund">Customer Refund</option>
                    <option value="Payout">Partner Payout</option>
                    <option value="Merchant settlement">Merchant Settlement</option>
                  </>
                )}
              </select>
            </div>
            <div className="space-y-2 md:col-span-2">
              <label className="text-sm font-medium">Party (Customer / Supplier / Partner) <span className="text-error">*</span></label>
              <Input {...register('partyId')} placeholder="Search party..." />
              {errors.partyId && <p className="text-xs text-error">{errors.partyId.message}</p>}
            </div>
          </div>
        </div>

        {/* Financials & Method */}
        <div className="bg-surface rounded-xl border border-border p-6 space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="space-y-2">
              <label className="text-sm font-medium">Amount (₦) <span className="text-error">*</span></label>
              <Input type="number" {...register('amount')} placeholder="0.00" />
              {errors.amount && <p className="text-xs text-error">{errors.amount.message}</p>}
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Bank/Gateway Fee (₦)</label>
              <Input type="number" {...register('fee')} placeholder="0.00" />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Payment Date <span className="text-error">*</span></label>
              <Input type="date" {...register('paymentDate')} />
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Method <span className="text-error">*</span></label>
              <select {...register('method')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                <option value="Transfer">Bank Transfer</option>
                <option value="Card">Card / POS</option>
                <option value="Cash">Cash</option>
                <option value="Cheque">Cheque</option>
                <option value="Wallet">Digital Wallet</option>
                <option value="Gateway">Online Gateway</option>
              </select>
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Destination/Source Account <span className="text-error">*</span></label>
              <select {...register('accountId')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                <option value="">Select account...</option>
                <option value="acc-1">GTB Corporate Main</option>
                <option value="acc-2">Zenith Operating</option>
                <option value="acc-3">HQ Cash Safe</option>
              </select>
              {errors.accountId && <p className="text-xs text-error">{errors.accountId.message}</p>}
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Reference {requiresReference && <span className="text-error">*</span>}</label>
              <Input {...register('reference')} placeholder={requiresReference ? "Required for this method" : "Optional"} />
              {errors.reference && <p className="text-xs text-error">{errors.reference.message}</p>}
            </div>
          </div>
        </div>

        {/* Allocations */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
            <h3 className="font-medium">Document Allocations</h3>
            <Button type="button" variant="outline" size="sm" onClick={() => append({ documentId: '', documentType: 'Order', amountAllocated: 0 })}>
              + Add Allocation
            </Button>
          </div>
          <div className="p-6 overflow-x-auto">
            <table className="w-full text-sm text-left whitespace-nowrap">
              <thead>
                <tr className="border-b border-border text-text-muted">
                  <th className="pb-3 font-medium w-[150px]">Doc Type</th>
                  <th className="pb-3 font-medium">Document ID</th>
                  <th className="pb-3 font-medium text-right w-[200px]">Amount Allocated (₦)</th>
                  <th className="pb-3 w-[50px]"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {fields.map((field, index) => (
                  <tr key={field.id}>
                    <td className="py-3 pr-2">
                      <select {...register(`allocations.${index}.documentType`)} className="w-full flex h-9 rounded-md border border-border bg-surface px-3 py-1 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                        <option value="Order">Order</option>
                        <option value="Invoice">Invoice</option>
                        <option value="Wallet">Wallet</option>
                      </select>
                    </td>
                    <td className="py-3 px-2">
                      <Input {...register(`allocations.${index}.documentId`)} placeholder="Search doc..." className="h-9" />
                    </td>
                    <td className="py-3 pl-2">
                      <Input type="number" {...register(`allocations.${index}.amountAllocated`)} className="h-9 text-right" />
                    </td>
                    <td className="py-3 text-right">
                      <Button type="button" variant="ghost" size="sm" onClick={() => remove(index)} className="text-error px-2 h-9">
                        ✕
                      </Button>
                    </td>
                  </tr>
                ))}
                {fields.length === 0 && (
                  <tr>
                    <td colSpan={4} className="py-6 text-center text-text-muted text-xs">
                      No documents selected. Entire amount will be left unallocated (e.g. as account credit).
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        <div className="flex justify-end gap-3">
          <Button type="button" variant="outline" onClick={() => router.back()} disabled={isSubmitting}>Cancel</Button>
          <Button type="submit" disabled={isSubmitting}>{isSubmitting ? 'Saving...' : 'Record Payment'}</Button>
        </div>

      </form>
    </div>
  );
}
