'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getReferralFlags } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

export function ReferralFlagsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['referral-flags'],
    queryFn: () => getReferralFlags()
  });

  const columns = [
    {
      header: 'Referral #',
      accessorKey: 'referralNumber',
      cell: (info: any) => (
        <Link href={`/erp/referrals/${info.row.original.referralId}`} className="font-mono text-sm text-brand-500 hover:underline">
          {info.getValue()}
        </Link>
      )
    },
    {
      header: 'Date Flagged',
      accessorKey: 'dateFlagged',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy HH:mm')}</span>
    },
    {
      header: 'Severity',
      accessorKey: 'severity',
      cell: (info: any) => {
        const val = info.getValue();
        let color = 'bg-error-light text-error border-error-muted';
        if (val === 'Med') color = 'bg-warning-light text-warning-dark border-warning-muted';
        if (val === 'Low') color = 'bg-surface-2 text-text-muted border-border';
        return <span className={`px-2 py-0.5 rounded text-[11px] font-medium border ${color}`}>{val}</span>;
      }
    },
    {
      header: 'Reason',
      accessorKey: 'reason',
      cell: (info: any) => <span className="text-sm text-text-muted">{info.getValue()}</span>
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        return <Badge variant={val === 'Open' ? 'destructive' : 'outline'}>{val}</Badge>;
      }
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2 justify-end">
          {info.row.original.status === 'Open' && <Button variant="outline" size="sm" className="text-success border-success hover:bg-success-light">Clear Flag</Button>}
          {info.row.original.status === 'Open' && <Button variant="outline" size="sm" className="text-error border-error hover:bg-error-light">Disqualify</Button>}
        </div>
      )
    }
  ];

  return (
    <DataTable
      data={data?.data || []}
      columns={columns}
      isLoading={isLoading}
    />
  );
}
