'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { Checkbox } from '@/components/ui/checkbox';

const formSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional(),
  status: z.string(),
  effectiveFrom: z.string().min(1, 'Effective date is required'),
  effectiveTo: z.string().optional(),
  trigger: z.string(),
  minOrderValue: z.number().min(0),
  levels: z.number().min(1).max(10),
  baseAmountNet: z.boolean(),
  approvalMode: z.string(),
  holdingPeriod: z.number().min(0)
});

export default function CreateCommissionPlanPage() {
  const { register, control, handleSubmit, formState: { errors }, watch } = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: '',
      description: '',
      status: 'Draft',
      effectiveFrom: new Date().toISOString().split('T')[0],
      effectiveTo: '',
      trigger: 'Order Paid',
      minOrderValue: 0,
      levels: 1,
      baseAmountNet: true,
      approvalMode: 'Auto-approve',
      holdingPeriod: 7
    }
  });

  function onSubmit(values: z.infer<typeof formSchema>) {
    console.log(values);
  }

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-4xl">
      <PageHeader 
        title="Create Commission Plan" 
        description="Define a new multi-level earning rule."
        backHref="/erp/commissions/rules"
        action={<Button onClick={handleSubmit(onSubmit)}>Save Plan</Button>}
      />
      
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
        
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="p-6 space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2 mb-4">General Settings</h3>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <label className="text-sm font-medium">Plan Name *</label>
                <Input placeholder="e.g. Standard Multi-tier" {...register('name')} />
                {errors.name && <p className="text-[10px] text-error">{errors.name.message}</p>}
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Status</label>
                <Controller
                  control={control}
                  name="status"
                  render={({ field }) => (
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <SelectTrigger><SelectValue placeholder="Status" /></SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Draft">Draft</SelectItem>
                        <SelectItem value="Active">Active</SelectItem>
                      </SelectContent>
                    </Select>
                  )}
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Description</label>
              <Input placeholder="Describe the purpose of this plan..." {...register('description')} />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <label className="text-sm font-medium">Effective From *</label>
                <Input type="date" {...register('effectiveFrom')} />
                {errors.effectiveFrom && <p className="text-[10px] text-error">{errors.effectiveFrom.message}</p>}
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Effective To (Optional)</label>
                <Input type="date" {...register('effectiveTo')} />
              </div>
            </div>
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="p-6 space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2 mb-4">Calculation Engine & Rules</h3>
            
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <label className="text-sm font-medium">Qualification Trigger</label>
                <Controller
                  control={control}
                  name="trigger"
                  render={({ field }) => (
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <SelectTrigger><SelectValue placeholder="Trigger" /></SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Order Paid">Order Paid</SelectItem>
                        <SelectItem value="Order Delivered">Order Delivered</SelectItem>
                        <SelectItem value="First Order Only">First Order Only</SelectItem>
                      </SelectContent>
                    </Select>
                  )}
                />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Network Levels</label>
                <Input type="number" {...register('levels', { valueAsNumber: true })} />
                <p className="text-[10px] text-text-muted">How deep in the upline this rule pays out.</p>
                {errors.levels && <p className="text-[10px] text-error">{errors.levels.message}</p>}
              </div>
            </div>

            <div className="border border-border rounded-lg p-4 bg-surface-2 mt-4 space-y-4">
              <h4 className="font-semibold text-sm">Level Rates configuration</h4>
              <p className="text-xs text-text-muted">Specify the rate for each level up to the configured network levels.</p>
              {Array.from({ length: watch('levels') || 1 }).map((_, i) => (
                <div key={i} className="flex gap-4 items-center">
                  <span className="text-sm font-medium w-16">Level {i + 1}</span>
                  <Input type="number" placeholder="Percentage (%)" className="w-32" />
                  <span className="text-sm text-text-muted">% of base amount</span>
                </div>
              ))}
            </div>

            <div className="grid grid-cols-2 gap-4 pt-4">
              <div className="space-y-2">
                <label className="text-sm font-medium">Approval Mode</label>
                <Controller
                  control={control}
                  name="approvalMode"
                  render={({ field }) => (
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <SelectTrigger><SelectValue placeholder="Approval Mode" /></SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Auto-approve">Auto-approve</SelectItem>
                        <SelectItem value="Manual approval">Manual approval</SelectItem>
                      </SelectContent>
                    </Select>
                  )}
                />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Holding Period (Days)</label>
                <Input type="number" {...register('holdingPeriod', { valueAsNumber: true })} />
                <p className="text-[10px] text-text-muted">Days to hold before making available for payout.</p>
                {errors.holdingPeriod && <p className="text-[10px] text-error">{errors.holdingPeriod.message}</p>}
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  );
}
