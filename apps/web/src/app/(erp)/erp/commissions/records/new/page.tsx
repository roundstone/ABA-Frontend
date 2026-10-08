'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';

const formSchema = z.object({
  beneficiary: z.string().min(1, 'Beneficiary is required'),
  type: z.enum(['Bonus', 'Correction', 'Clawback']),
  amount: z.number().min(1, 'Amount must be greater than 0'),
  reason: z.string().min(10, 'Reason must be at least 10 characters')
});

export default function ManualAdjustmentPage() {
  const { register, control, handleSubmit, formState: { errors } } = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      beneficiary: '',
      type: 'Bonus',
      amount: 0,
      reason: ''
    }
  });

  function onSubmit(values: z.infer<typeof formSchema>) {
    console.log(values);
  }

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-2xl">
      <PageHeader 
        title="Manual Adjustment" 
        description="Record a bonus, correction, or clawback to a beneficiary's commission ledger."
        backHref="/erp/commissions/records"
        action={<Button onClick={handleSubmit(onSubmit)}>Submit for Approval</Button>}
      />
      
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="p-6">
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
            
            <div className="space-y-2">
              <label className="text-sm font-medium">Beneficiary *</label>
              <Input placeholder="Search user ID or name..." {...register('beneficiary')} />
              {errors.beneficiary && <p className="text-[10px] text-error">{errors.beneficiary.message}</p>}
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <label className="text-sm font-medium">Adjustment Type *</label>
                <Controller
                  control={control}
                  name="type"
                  render={({ field }) => (
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <SelectTrigger><SelectValue placeholder="Type" /></SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Bonus">Bonus (+)</SelectItem>
                        <SelectItem value="Correction">Correction (±)</SelectItem>
                        <SelectItem value="Clawback">Clawback (-)</SelectItem>
                      </SelectContent>
                    </Select>
                  )}
                />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Amount (₦) *</label>
                <Input type="number" {...register('amount', { valueAsNumber: true })} />
                {errors.amount && <p className="text-[10px] text-error">{errors.amount.message}</p>}
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Reason *</label>
              <Input placeholder="Explain why this adjustment is being made (min 10 chars)..." {...register('reason')} />
              {errors.reason && <p className="text-[10px] text-error">{errors.reason.message}</p>}
            </div>
            
            <div className="pt-4 border-t border-border">
              <Button type="submit" className="w-full">Submit for Approval</Button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
