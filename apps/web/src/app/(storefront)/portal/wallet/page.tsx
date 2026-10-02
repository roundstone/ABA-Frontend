'use client';

import React from 'react';
import { Wallet, ArrowDownLeft, ArrowUpRight, Plus, Building2, Search, Filter, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useQuery } from '@tanstack/react-query';
import { getWalletTransactions } from '@/features/portal/api';
import { AmountText } from '@/components/patterns/AmountText';
import { Alert } from '@/components/ui/alert';

export default function PortalWalletPage() {
  const { data: transactions, isLoading, error } = useQuery({
    queryKey: ['portal_wallet_transactions'],
    queryFn: async () => {
      const res = await getWalletTransactions();
      return res.data;
    }
  });

  const availableBalance = 150000000;
  const totalInflow = 245000000;
  const totalOutflow = 95000000;

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-64">
        <Loader2 className="w-8 h-8 animate-spin text-brand-600" />
      </div>
    );
  }

  if (error || !transactions) {
    return (
      <Alert variant="destructive">
        Failed to load wallet data. Please try again.
      </Alert>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <h1 className="text-2xl font-bold text-text">My Wallet</h1>
        <div className="flex gap-3">
          <Button variant="outline" className="flex items-center gap-2">
            <Building2 className="w-4 h-4" /> Withdraw
          </Button>
          <Button className="flex items-center gap-2">
            <Plus className="w-4 h-4" /> Fund Wallet
          </Button>
        </div>
      </div>

      {/* Balance Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-brand-600 rounded-xl p-6 md:p-8 text-white shadow-sm relative overflow-hidden">
          <div className="absolute -right-10 -bottom-10 w-40 h-40 bg-white opacity-10 rounded-full blur-2xl"></div>
          <div className="relative z-10">
            <p className="text-brand-100 font-medium mb-2">Available Balance</p>
            <h2 className="text-4xl md:text-5xl font-bold tracking-tight"><AmountText amountInKobo={availableBalance} /></h2>
            <div className="mt-6 pt-6 border-t border-white/20 flex justify-between items-center text-sm">
              <span className="text-brand-100">Total Inflow: <span className="font-bold text-white"><AmountText amountInKobo={totalInflow} /></span></span>
              <span className="text-brand-100">Total Outflow: <span className="font-bold text-white"><AmountText amountInKobo={totalOutflow} /></span></span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl border border-border p-6 shadow-sm flex flex-col justify-center">
          <h3 className="font-bold text-text mb-4">Linked Bank Account</h3>
          <div className="flex items-start gap-4 p-4 rounded-lg border border-border bg-surface-1">
            <div className="w-10 h-10 rounded-full bg-surface-2 flex items-center justify-center shrink-0">
              <Building2 className="w-5 h-5 text-text-muted" />
            </div>
            <div className="flex-1">
              <p className="font-bold text-text">Guarantee Trust Bank (GTB)</p>
              <p className="text-sm text-text-muted">0123****89</p>
              <p className="text-xs text-text-muted mt-1 uppercase tracking-wider">Jane Doe</p>
            </div>
            <Button variant="ghost" size="sm" className="text-brand-600 hover:bg-brand-50">Edit</Button>
          </div>
        </div>
      </div>

      {/* Transactions */}
      <div className="bg-white rounded-xl border border-border shadow-sm">
        <div className="p-4 sm:p-6 border-b border-border flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <h3 className="font-bold text-text">Transaction History</h3>
          <div className="flex gap-2">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
              <input 
                type="text" 
                placeholder="Search..." 
                className="h-9 pl-9 pr-3 rounded-md border border-border text-sm focus:outline-none focus:ring-2 focus:ring-brand-500 w-full sm:w-48"
              />
            </div>
            <Button variant="outline" size="sm" className="px-2 h-9">
              <Filter className="w-4 h-4" />
            </Button>
          </div>
        </div>
        
        <div className="divide-y divide-border">
          {transactions.map((trx) => {
            const isCredit = trx.amount > 0;
            const Icon = isCredit ? ArrowDownLeft : ArrowUpRight;
            const iconColor = isCredit ? 'text-success-main' : 'text-text-muted';
            const iconBg = isCredit ? 'bg-success-bg' : 'bg-surface-2';
            const amountColor = isCredit ? 'text-success-dark' : 'text-text';

            return (
              <div key={trx.id} className="p-4 sm:p-6 flex items-center gap-4 hover:bg-surface-1 transition-colors">
                <div className={`w-12 h-12 rounded-full flex items-center justify-center shrink-0 ${iconBg}`}>
                  <Icon className={`w-6 h-6 ${iconColor}`} />
                </div>
                
                <div className="flex-1 min-w-0">
                  <p className="font-semibold text-text truncate">{trx.title}</p>
                  <div className="flex items-center gap-2 mt-1 text-sm text-text-muted">
                    <span>{new Date(trx.date).toLocaleDateString()}</span>
                    <span>•</span>
                    <span className="truncate">{trx.id}</span>
                  </div>
                </div>
                
                <div className="text-right shrink-0">
                  <p className={`font-bold ${amountColor}`}>
                    {isCredit ? '+' : ''}<AmountText amountInKobo={Math.abs(trx.amount)} />
                  </p>
                  <p className={`text-xs font-semibold mt-1 ${trx.status === 'Completed' ? 'text-text-muted' : 'text-error'}`}>
                    {trx.status}
                  </p>
                </div>
              </div>
            );
          })}
          {transactions.length === 0 && (
            <div className="p-8 text-center text-sm text-text-muted">No transactions found.</div>
          )}
        </div>
      </div>
    </div>
  );
}
