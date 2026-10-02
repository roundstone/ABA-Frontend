'use client';

import { useState } from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';

// Mock un-reconciled statement lines (from bank CSV)
const STATEMENT_LINES = [
  { id: 'st-1', date: '2026-09-30', description: 'NIP/TRF/JOHN DOE/ORD-10482', amount: 16625000, type: 'Credit' },
  { id: 'st-2', date: '2026-09-30', description: 'POS SETTLEMENT REF:1903', amount: 2652500, type: 'Credit' },
  { id: 'st-3', date: '2026-09-30', description: 'MAINTENANCE FEE', amount: 500000, type: 'Debit' },
];

// Mock pending internal payments
const INTERNAL_PAYMENTS = [
  { id: 'pay-1', ref: 'PAY-89234', date: '2026-09-30', amount: 16625000, method: 'Transfer', status: 'Pending', party: 'Aisha Bello' },
  { id: 'pay-2', ref: 'PAY-89235', date: '2026-09-30', amount: 2687500, fee: 35000, net: 2652500, method: 'Card', status: 'Completed', party: 'Walk-in' },
];

export default function ReconciliationPage() {
  const [activeAccount, setActiveAccount] = useState('acc-gtb');

  return (
    <div className="space-y-6 pb-20 max-w-7xl mx-auto">
      <PageHeader 
        title="Bank Reconciliation" 
        description="Match imported bank statements against internal payment records."
        action={
          <div className="flex gap-2">
            <Button variant="outline">Import CSV</Button>
            <Button>Auto-Match</Button>
          </div>
        }
      />

      {/* Account Selector & Summary */}
      <div className="bg-surface rounded-xl border border-border p-6 flex flex-col md:flex-row gap-6 justify-between items-start md:items-center">
        <div className="flex gap-4 items-center">
          <div className="w-12 h-12 rounded-full bg-primary/10 text-primary flex items-center justify-center text-xl">
            🏦
          </div>
          <div>
            <select 
              value={activeAccount} 
              onChange={(e) => setActiveAccount(e.target.value)}
              className="text-lg font-bold bg-transparent border-none focus:ring-0 p-0 hover:text-primary cursor-pointer"
            >
              <option value="acc-gtb">GTBank Corporate Main (**** 1234)</option>
              <option value="acc-zen">Zenith Operating (**** 9876)</option>
              <option value="acc-pos">POS Settlement Gateway</option>
            </select>
            <p className="text-sm text-text-muted mt-1">Last synced: 2 hours ago</p>
          </div>
        </div>
        
        <div className="flex gap-8 text-sm">
          <div>
            <p className="text-text-muted mb-1">Statement Balance</p>
            <p className="font-bold text-lg"><AmountText amountInKobo={450000000} /></p>
          </div>
          <div>
            <p className="text-text-muted mb-1">Ledger Balance</p>
            <p className="font-bold text-lg"><AmountText amountInKobo={430722500} /></p>
          </div>
          <div>
            <p className="text-text-muted mb-1">Unreconciled Difference</p>
            <p className="font-bold text-lg text-error"><AmountText amountInKobo={19277500} /></p>
          </div>
        </div>
      </div>

      {/* Reconciliation Split View */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        {/* Left Side: Bank Statement */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden flex flex-col h-[600px]">
          <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center shrink-0">
            <h3 className="font-medium">Bank Statement Lines</h3>
            <span className="text-xs bg-primary/10 text-primary px-2 py-1 rounded font-medium">{STATEMENT_LINES.length} Unmatched</span>
          </div>
          <div className="flex-1 overflow-y-auto p-4 space-y-3">
            {STATEMENT_LINES.map(line => (
              <div key={line.id} className="p-4 rounded-xl border border-border hover:border-primary cursor-pointer transition-colors group">
                <div className="flex justify-between items-start mb-2">
                  <span className="text-xs font-mono text-text-muted">{line.date}</span>
                  <span className={`font-bold ${line.type === 'Credit' ? 'text-success' : 'text-text'}`}>
                    {line.type === 'Credit' ? '+' : '-'}<AmountText amountInKobo={line.amount} />
                  </span>
                </div>
                <p className="text-sm font-medium">{line.description}</p>
                <div className="mt-3 pt-3 border-t border-border flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                  <Button variant="outline" size="sm" className="h-7 text-xs">Create Payment</Button>
                  <Button size="sm" className="h-7 text-xs">Find Match →</Button>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Right Side: Internal Ledger */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden flex flex-col h-[600px]">
          <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center shrink-0">
            <h3 className="font-medium">Internal Payments</h3>
            <div className="relative w-48">
              <input type="text" placeholder="Search amounts or refs..." className="w-full h-8 text-xs px-3 rounded border border-border bg-surface" />
            </div>
          </div>
          <div className="flex-1 overflow-y-auto p-4 space-y-3">
            {INTERNAL_PAYMENTS.map(pay => (
              <div key={pay.id} className="p-4 rounded-xl border border-border hover:border-primary transition-colors flex flex-col justify-between group">
                <div>
                  <div className="flex justify-between items-start mb-1">
                    <span className="text-xs font-mono font-medium text-primary">{pay.ref}</span>
                    <span className="font-bold text-success">
                      +<AmountText amountInKobo={pay.net || pay.amount} />
                    </span>
                  </div>
                  <p className="text-sm">{pay.party}</p>
                  <div className="flex items-center gap-2 mt-2">
                    <span className="text-[10px] bg-surface-2 border border-border px-1.5 py-0.5 rounded text-text-muted">{pay.method}</span>
                    <span className={`text-[10px] px-1.5 py-0.5 rounded border ${pay.status === 'Pending' ? 'bg-warning-bg text-warning-dark border-warning-border' : 'bg-success-bg text-success border-success-border'}`}>
                      {pay.status}
                    </span>
                  </div>
                </div>
                <div className="mt-3 pt-3 border-t border-border flex justify-end opacity-0 group-hover:opacity-100 transition-opacity">
                  <Button size="sm" className="h-7 text-xs bg-success hover:bg-success-dark text-white w-full">
                    Confirm Match
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </div>

      </div>

    </div>
  );
}
