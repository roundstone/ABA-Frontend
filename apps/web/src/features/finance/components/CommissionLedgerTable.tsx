'use client';

import React, { useState, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import { getCommissionLedger } from '../api';
import { CommissionLedgerEntry } from '../types';
import { AmountText } from '@/components/patterns/AmountText';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { format } from 'date-fns';
import { Search, ArrowUpRight, ArrowDownLeft, RotateCcw } from 'lucide-react';

export function CommissionLedgerTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['commission-ledger'],
    queryFn: getCommissionLedger,
  });

  const [search, setSearch] = useState('');
  const [stageFilter, setStageFilter] = useState<'All' | 'Accrual' | 'Wallet Credited' | 'Payout Disbursed' | 'Reversed'>('All');

  const filteredEntries = useMemo(() => {
    const list = data?.data || [];
    return list.filter((item) => {
      if (stageFilter !== 'All' && item.stage !== stageFilter) return false;
      if (!search.trim()) return true;
      const q = search.toLowerCase();
      return (
        item.commissionNumber.toLowerCase().includes(q) ||
        item.orderNumber.toLowerCase().includes(q) ||
        item.beneficiaryName.toLowerCase().includes(q) ||
        item.journalEntryNumber.toLowerCase().includes(q)
      );
    });
  }, [data?.data, stageFilter, search]);

  const getStageBadge = (stage: CommissionLedgerEntry['stage']) => {
    switch (stage) {
      case 'Accrual':
        return (
          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-200">
            <ArrowUpRight className="w-3 h-3" /> Accrual
          </span>
        );
      case 'Wallet Credited':
        return (
          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
            <ArrowDownLeft className="w-3 h-3" /> Wallet Credited
          </span>
        );
      case 'Payout Disbursed':
        return (
          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-semibold bg-blue-50 text-blue-700 border border-blue-200">
            <ArrowUpRight className="w-3 h-3" /> Bank Payout
          </span>
        );
      case 'Reversed':
        return (
          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-semibold bg-red-50 text-red-700 border border-red-200">
            <RotateCcw className="w-3 h-3" /> Reversed
          </span>
        );
    }
  };

  return (
    <div className="space-y-4">
      {/* Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-surface p-4 rounded-xl border border-border">
        <div className="relative flex-1 max-w-sm">
          <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-text-muted" />
          <Input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search Order, Marketer, or JE..."
            className="pl-9 h-9 text-xs"
          />
        </div>

        <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar">
          {(['All', 'Accrual', 'Wallet Credited', 'Payout Disbursed', 'Reversed'] as const).map((stage) => (
            <button
              key={stage}
              type="button"
              onClick={() => setStageFilter(stage)}
              className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-colors whitespace-nowrap ${
                stageFilter === stage
                  ? 'bg-brand-600 text-white'
                  : 'bg-surface-2 text-text-muted hover:text-text hover:bg-surface-3'
              }`}
            >
              {stage}
            </button>
          ))}
        </div>
      </div>

      {/* Table */}
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-surface-2 border-b border-border text-text-muted font-medium">
                <th className="py-3 px-4">Date</th>
                <th className="py-3 px-4">Stage</th>
                <th className="py-3 px-4">JE Ref</th>
                <th className="py-3 px-4">Order / Marketer</th>
                <th className="py-3 px-4">Debit Account</th>
                <th className="py-3 px-4">Credit Account</th>
                <th className="py-3 px-4 text-right">Amount</th>
                <th className="py-3 px-4 text-right">Payable Balance</th>
                <th className="py-3 px-4">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {isLoading ? (
                <tr>
                  <td colSpan={9} className="py-8 text-center text-text-muted">
                    Loading commission financial ledger...
                  </td>
                </tr>
              ) : filteredEntries.length === 0 ? (
                <tr>
                  <td colSpan={9} className="py-8 text-center text-text-muted">
                    No financial ledger entries found for this filter.
                  </td>
                </tr>
              ) : (
                filteredEntries.map((row) => (
                  <tr key={row.id} className="hover:bg-surface-1/60 transition-colors">
                    <td className="py-3 px-4 whitespace-nowrap">
                      {format(new Date(row.date), 'MMM d, yyyy HH:mm')}
                    </td>
                    <td className="py-3 px-4 whitespace-nowrap">
                      {getStageBadge(row.stage)}
                    </td>
                    <td className="py-3 px-4 font-mono font-medium text-brand-600">
                      {row.journalEntryNumber}
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex flex-col">
                        <span className="font-mono font-semibold text-text">{row.orderNumber}</span>
                        <span className="text-[11px] text-text-muted flex items-center gap-1">
                          {row.beneficiaryName}
                          <Badge variant="outline" className="text-[9px] px-1 py-0 h-4">
                            L{row.level}
                          </Badge>
                        </span>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex flex-col">
                        <span className="font-mono text-[11px] text-text font-medium">{row.debitAccount.code}</span>
                        <span className="text-[10px] text-text-muted truncate max-w-[140px]">{row.debitAccount.name}</span>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex flex-col">
                        <span className="font-mono text-[11px] text-text font-medium">{row.creditAccount.code}</span>
                        <span className="text-[10px] text-text-muted truncate max-w-[140px]">{row.creditAccount.name}</span>
                      </div>
                    </td>
                    <td className="py-3 px-4 text-right font-semibold text-text">
                      <AmountText amountInKobo={row.amountInKobo} />
                    </td>
                    <td className="py-3 px-4 text-right font-mono text-text-muted">
                      <AmountText amountInKobo={row.runningPayableBalanceInKobo} />
                    </td>
                    <td className="py-3 px-4">
                      <Badge variant={row.status === 'Posted' ? 'default' : row.status === 'Reversed' ? 'destructive' : 'secondary'}>
                        {row.status}
                      </Badge>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
