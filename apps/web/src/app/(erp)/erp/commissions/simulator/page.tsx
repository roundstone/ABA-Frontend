'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Button } from '@/components/ui/button';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { useState } from 'react';
import { AmountText } from '@/components/patterns/AmountText';

const simulatorSchema = z.object({
  customer: z.string().min(1, 'Select a customer'),
  product: z.string().min(1, 'Select a product'),
  quantity: z.number().min(1),
  price: z.number().min(1),
});

export default function CommissionSimulatorPage() {
  const { register, control, handleSubmit, formState: { errors }, watch } = useForm<z.infer<typeof simulatorSchema>>({
    resolver: zodResolver(simulatorSchema),
    defaultValues: {
      customer: '',
      product: '',
      quantity: 1,
      price: 0,
    }
  });

  const [simulationResult, setSimulationResult] = useState<any[] | null>(null);

  function onSubmit(values: z.infer<typeof simulatorSchema>) {
    // Mock simulation logic
    const totalOrderValue = values.quantity * values.price * 100; // in Kobo
    const results = [
      { level: 1, beneficiary: 'Jane Referrer (Direct)', rate: '5%', amount: totalOrderValue * 0.05, rule: 'Default v3', status: 'Would Qualify' },
      { level: 2, beneficiary: 'Michael Upline', rate: '2%', amount: totalOrderValue * 0.02, rule: 'Default v3', status: 'Would Qualify' },
      { level: 3, beneficiary: 'Sarah Top', rate: '1%', amount: totalOrderValue * 0.01, rule: 'Default v3', status: 'Cap Reached (Adjusted)' },
    ];
    setSimulationResult(results);
  }

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-4xl">
      <PageHeader 
        title="Rule Simulator" 
        description="Test how commission plans affect payouts before making them active."
        backHref="/erp/commissions"
      />
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="p-6">
            <h3 className="font-bold text-lg border-b border-border pb-2 mb-4">Input Parameters</h3>
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
              <div className="space-y-2">
                <label className="text-sm font-medium">Buyer (Customer) *</label>
                <Input placeholder="Search customer..." {...register('customer')} />
                {errors.customer && <p className="text-[10px] text-error">{errors.customer.message}</p>}
              </div>
              
              <div className="border border-border rounded-lg p-4 bg-surface-2 mt-4 space-y-4">
                <h4 className="font-semibold text-sm">Cart Items</h4>
                <div className="space-y-2">
                  <label className="text-sm font-medium">Product</label>
                  <Controller
                    control={control}
                    name="product"
                    render={({ field }) => (
                      <Select onValueChange={field.onChange} defaultValue={field.value}>
                        <SelectTrigger><SelectValue placeholder="Select Product" /></SelectTrigger>
                        <SelectContent>
                          <SelectItem value="prod-1">Basic Plan Subscription</SelectItem>
                          <SelectItem value="prod-2">Premium Hardware Bundle</SelectItem>
                        </SelectContent>
                      </Select>
                    )}
                  />
                  {errors.product && <p className="text-[10px] text-error">{errors.product.message}</p>}
                </div>
                
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <label className="text-sm font-medium">Quantity</label>
                    <Input type="number" {...register('quantity', { valueAsNumber: true })} />
                  </div>
                  <div className="space-y-2">
                    <label className="text-sm font-medium">Unit Price (₦)</label>
                    <Input type="number" {...register('price', { valueAsNumber: true })} />
                  </div>
                </div>
              </div>

              <div className="pt-4 border-t border-border">
                <Button type="submit" className="w-full">Run Simulator</Button>
              </div>
            </form>
          </div>
        </div>

        <div className="bg-surface-2 rounded-xl border border-border overflow-hidden">
          <div className="p-6">
            <h3 className="font-bold text-lg border-b border-border pb-2 mb-4">Simulation Results</h3>
            {!simulationResult ? (
              <div className="text-center text-text-muted py-12">
                <span className="text-4xl mb-4 block">🧪</span>
                <p>Run the simulator to see upline payout breakdowns.</p>
              </div>
            ) : (
              <div className="space-y-4">
                <div className="flex justify-between items-center text-sm bg-surface p-3 rounded-lg border border-border">
                  <span className="text-text-muted">Simulated Order Value</span>
                  <span className="font-bold"><AmountText amountInKobo={watch('quantity') * watch('price') * 100} /></span>
                </div>
                
                <h4 className="font-semibold text-sm mt-6 mb-2">Upline Chain & Payouts</h4>
                <div className="space-y-2">
                  {simulationResult.map((res, i) => (
                    <div key={i} className="bg-surface border border-border rounded-lg p-3 flex justify-between items-center">
                      <div>
                        <div className="font-medium text-sm">{res.beneficiary}</div>
                        <div className="text-[10px] text-text-muted">Level {res.level} • {res.rule} ({res.rate})</div>
                      </div>
                      <div className="text-right flex flex-col items-end">
                        <span className="font-medium text-success-dark"><AmountText amountInKobo={res.amount} /></span>
                        <span className="text-[10px] text-text-muted">{res.status}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
