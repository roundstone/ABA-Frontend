'use client';

import React from 'react';
import { ArrowRight, ShoppingBag, BookOpen, Clock, Wallet, Banknote, ShieldCheck } from 'lucide-react';

export function CommissionFlowTimeline() {
  const steps = [
    {
      step: '1',
      title: 'Order Completed',
      icon: ShoppingBag,
      accounts: 'Source: Sales Order',
      desc: 'Buyer pays and order is marked fulfilled.',
      statusColor: 'border-blue-400 bg-blue-50 text-blue-700',
    },
    {
      step: '2',
      title: 'Accrual Posted',
      icon: BookOpen,
      accounts: 'Dr. 6000 Expense / Cr. 2110 Payable',
      desc: 'Commission liability recorded against operating expense.',
      statusColor: 'border-amber-400 bg-amber-50 text-amber-700',
    },
    {
      step: '3',
      title: 'Holding / Cool-Off',
      icon: Clock,
      accounts: 'Anti-fraud & Return Window',
      desc: 'Standard 14-day safety buffer before disbursement.',
      statusColor: 'border-purple-400 bg-purple-50 text-purple-700',
    },
    {
      step: '4',
      title: 'Wallet Credited',
      icon: Wallet,
      accounts: 'Dr. 2110 Payable / Cr. 2100 Wallet',
      desc: 'Commissions payable settled into marketer wallet.',
      statusColor: 'border-emerald-400 bg-emerald-50 text-emerald-700',
    },
    {
      step: '5',
      title: 'Bank Payout',
      icon: Banknote,
      accounts: 'Dr. 2100 Wallet / Cr. 1010 Bank',
      desc: 'Marketer withdraws funds to Nigerian commercial bank.',
      statusColor: 'border-brand-500 bg-brand-50 text-brand-700',
    },
  ];

  return (
    <div className="bg-surface rounded-xl border border-border p-5 space-y-4 shadow-2xs">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-border pb-3">
        <div>
          <h3 className="font-semibold text-text text-base flex items-center gap-2">
            <ShieldCheck className="w-4 h-4 text-brand-600" />
            Financial Commission Flow (Double-Entry Accounting)
          </h3>
          <p className="text-xs text-text-muted mt-0.5">
            Trace how every earned referral kobo moves through General Ledger accounts from order capture to bank settlement.
          </p>
        </div>
        <span className="text-[11px] font-medium text-brand-700 bg-brand-50 border border-brand-200 px-2.5 py-1 rounded-full w-fit">
          GAAP & IFRS Compliant
        </span>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-5 gap-3 pt-1">
        {steps.map((st, idx) => {
          const Icon = st.icon;
          return (
            <div
              key={st.step}
              className={`relative rounded-xl border p-3.5 flex flex-col justify-between transition-all hover:shadow-xs ${st.statusColor}`}
            >
              <div>
                <div className="flex items-center justify-between mb-2">
                  <span className="w-5 h-5 rounded-full bg-white/90 border border-current text-[11px] font-bold flex items-center justify-center">
                    {st.step}
                  </span>
                  <Icon className="w-4 h-4" />
                </div>
                <h4 className="text-xs font-bold text-text mb-1">{st.title}</h4>
                <div className="text-[10px] font-mono font-semibold text-text/80 mb-1.5 p-1 rounded bg-white/80 border border-black/5">
                  {st.accounts}
                </div>
                <p className="text-[11px] text-text-muted leading-tight">{st.desc}</p>
              </div>

              {idx < steps.length - 1 && (
                <div className="hidden md:flex absolute -right-3 top-1/2 -translate-y-1/2 z-10 w-6 h-6 rounded-full bg-surface-1 border border-border items-center justify-center text-text-muted shadow-2xs">
                  <ArrowRight className="w-3 h-3" />
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}
