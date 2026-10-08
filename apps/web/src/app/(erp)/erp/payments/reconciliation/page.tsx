'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { AmountText } from '@/components/patterns/AmountText';
import { useState } from 'react';

export default function BankReconciliationPage() {
  const [step, setStep] = useState(1);
  const [difference] = useState(2500000); // Mock difference

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-6xl">
      <PageHeader 
        title="Bank & Gateway Reconciliation" 
        description="Upload statements and match lines against recorded system payments."
        backHref="/erp/payments"
        action={<Button onClick={() => setStep(prev => Math.min(prev + 1, 3))}>{step === 3 ? 'Complete Reconciliation' : 'Next Step'}</Button>}
      />
      
      {/* Stepper */}
      <div className="flex gap-2 mb-6">
        {[1, 2, 3].map(s => (
          <div key={s} className={`flex-1 h-2 rounded-full ${step >= s ? 'bg-brand-500' : 'bg-border'}`} />
        ))}
      </div>

      {step === 1 && (
        <div className="bg-surface rounded-xl border border-border p-12 text-center max-w-2xl mx-auto space-y-6">
          <h2 className="text-xl font-bold">Select Account & Period</h2>
          <div className="grid grid-cols-2 gap-4 text-left">
            <div className="space-y-2">
              <label className="text-sm font-medium">Bank Account</label>
              <Select defaultValue="gtb-main">
                <SelectTrigger><SelectValue placeholder="Select Account" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="gtb-main">GTBank Main Account</SelectItem>
                  <SelectItem value="paystack">Paystack Gateway</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Period</label>
              <Select defaultValue="sep-2026">
                <SelectTrigger><SelectValue placeholder="Select Period" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="sep-2026">September 2026</SelectItem>
                  <SelectItem value="aug-2026">August 2026</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </div>
      )}

      {step === 2 && (
        <div className="bg-surface rounded-xl border border-border p-12 text-center max-w-2xl mx-auto space-y-6">
          <h2 className="text-xl font-bold">Upload Statement</h2>
          <div className="border-2 border-dashed border-border rounded-xl p-12 hover:bg-surface-2 transition-colors cursor-pointer flex flex-col items-center gap-4">
            <span className="text-4xl text-brand-500">📄</span>
            <div>
              <p className="font-medium text-lg">Click to upload statement file</p>
              <p className="text-sm text-text-muted">Supports CSV, XLSX (Max 10MB)</p>
            </div>
          </div>
          <p className="text-sm text-text-muted">Or fetch automatically via gateway API</p>
          <Button variant="outline" className="w-full">Fetch from Gateway Integration</Button>
        </div>
      )}

      {step === 3 && (
        <div className="space-y-6">
          <div className="grid grid-cols-3 gap-4">
            <div className="bg-surface border border-border p-4 rounded-xl">
              <p className="text-sm text-text-muted">Statement Balance</p>
              <p className="text-2xl font-bold"><AmountText amountInKobo={52500000} /></p>
            </div>
            <div className="bg-surface border border-border p-4 rounded-xl">
              <p className="text-sm text-text-muted">Book Balance</p>
              <p className="text-2xl font-bold"><AmountText amountInKobo={50000000} /></p>
            </div>
            <div className={`border p-4 rounded-xl ${difference === 0 ? 'bg-success-light border-success-dark' : 'bg-error-light border-error'}`}>
              <p className="text-sm font-medium">Difference</p>
              <p className="text-2xl font-bold"><AmountText amountInKobo={difference} /></p>
              {difference !== 0 && <p className="text-xs mt-1">Must be ₦0 to complete</p>}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-6 h-[500px]">
            {/* Statement Lines (Left) */}
            <div className="bg-surface border border-border rounded-xl flex flex-col overflow-hidden">
              <div className="p-4 border-b border-border bg-surface-2 font-bold text-sm">Statement Lines (Bank)</div>
              <div className="flex-1 overflow-y-auto p-4 space-y-2">
                {[1, 2, 3].map(i => (
                  <div key={i} className="p-3 border border-border rounded-lg flex justify-between items-center hover:border-brand-500 cursor-pointer">
                    <div>
                      <p className="font-medium text-sm">Sep 1{i}, 2026</p>
                      <p className="text-xs text-text-muted">TRF/GTB/CUSTOMER {i}</p>
                    </div>
                    <span className="font-bold text-success-dark">+ <AmountText amountInKobo={i * 1000000} /></span>
                  </div>
                ))}
              </div>
            </div>

            {/* System Payments (Right) */}
            <div className="bg-surface border border-border rounded-xl flex flex-col overflow-hidden">
              <div className="p-4 border-b border-border bg-surface-2 font-bold text-sm flex justify-between">
                <span>System Payments (Book)</span>
                <span className="text-brand-500 cursor-pointer">Auto-match ✨</span>
              </div>
              <div className="flex-1 overflow-y-auto p-4 space-y-2">
                {[1, 2].map(i => (
                  <div key={i} className="p-3 border border-border rounded-lg flex justify-between items-center hover:border-brand-500 cursor-pointer">
                    <div>
                      <p className="font-medium text-sm">PAY-2026-00{i}</p>
                      <p className="text-xs text-text-muted">Order ORD-00{i}</p>
                    </div>
                    <span className="font-bold text-success-dark">+ <AmountText amountInKobo={i * 1000000} /></span>
                  </div>
                ))}
                <div className="p-4 border border-dashed border-border rounded-lg text-center text-sm text-text-muted mt-4">
                  Drag statement lines here to match, or select multiple and click "Match".
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
