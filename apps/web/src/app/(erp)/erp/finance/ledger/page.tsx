'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';
import { Button } from '@/components/ui/button';
import { CommissionFlowTimeline } from '@/features/finance/components/CommissionFlowTimeline';
import { CommissionLedgerTable } from '@/features/finance/components/CommissionLedgerTable';
import { GeneralLedgerTable } from '@/features/finance/components/GeneralLedgerTable';
import { useQuery } from '@tanstack/react-query';
import { getFinanceKPIs } from '@/features/finance/api';
import { BookOpen, DollarSign, ExternalLink } from 'lucide-react';

export default function FinancialLedgerPage() {
  const [activeTab, setActiveTab] = useState<'commission' | 'general'>('commission');

  const { data: kpis } = useQuery({
    queryKey: ['finance-kpis'],
    queryFn: getFinanceKPIs,
  });

  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader
        title="Financial Ledger & Commission Flow"
        description="Double-entry journal records, commission accruals, wallet transfers, and payout balances."
        backHref="/erp/finance"
        action={
          <div className="flex items-center gap-2">
            <Link href="/erp/finance/chart-of-accounts">
              <Button variant="outline" size="sm" className="gap-1.5">
                <BookOpen className="w-3.5 h-3.5" />
                Chart of Accounts
              </Button>
            </Link>
            <Link href="/erp/commissions/records">
              <Button size="sm" className="gap-1.5">
                <ExternalLink className="w-3.5 h-3.5" />
                Commission Records
              </Button>
            </Link>
          </div>
        }
      />

      {/* Financial KPIs */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <KpiCard
          title="Commissions Payable (2110)"
          value={<AmountText amountInKobo={kpis?.commissionsPayable || 82000000} />}
          supportingText="Accrued referral liability awaiting maturity"
        />
        <KpiCard
          title="Marketer Wallets (2100)"
          value={<AmountText amountInKobo={150000000} />}
          supportingText="Disbursed credits in user accounts"
        />
        <KpiCard
          title="Cash & Bank (1010)"
          value={<AmountText amountInKobo={kpis?.cashAndBank || 1250000000} />}
          supportingText="Liquid reserve for payouts"
        />
        <KpiCard
          title="Operating Expenses (6000)"
          value={<AmountText amountInKobo={kpis?.operatingExpenses || 450000000} />}
          supportingText="Includes referral commissions expense"
        />
      </div>

      {/* Tabs */}
      <div className="border-b border-border flex items-center gap-6">
        <button
          type="button"
          onClick={() => setActiveTab('commission')}
          className={`pb-3 text-sm font-semibold transition-colors border-b-2 flex items-center gap-2 ${
            activeTab === 'commission'
              ? 'border-brand-600 text-brand-600'
              : 'border-transparent text-text-muted hover:text-text'
          }`}
        >
          <DollarSign className="w-4 h-4" />
          Commission Flow Ledger
        </button>
        <button
          type="button"
          onClick={() => setActiveTab('general')}
          className={`pb-3 text-sm font-semibold transition-colors border-b-2 flex items-center gap-2 ${
            activeTab === 'general'
              ? 'border-brand-600 text-brand-600'
              : 'border-transparent text-text-muted hover:text-text'
          }`}
        >
          <BookOpen className="w-4 h-4" />
          All General Journal Entries
        </button>
      </div>

      {/* Tab Panels */}
      {activeTab === 'commission' ? (
        <div className="space-y-6">
          <CommissionFlowTimeline />
          <CommissionLedgerTable />
        </div>
      ) : (
        <div className="space-y-4">
          <div className="p-4 rounded-xl bg-surface-1 border border-border flex items-center justify-between">
            <div>
              <h4 className="text-sm font-bold text-text">General Ledger Journal Entries</h4>
              <p className="text-xs text-text-muted">All automated and manual postings across ERP modules.</p>
            </div>
            <Link href="/erp/finance/ledger/journals">
              <Button variant="outline" size="sm">Journal Detail View</Button>
            </Link>
          </div>
          <GeneralLedgerTable />
        </div>
      )}
    </div>
  );
}
