'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getReferralRecords } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

export function ReferralRecordsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['referral-records'],
    queryFn: () => getReferralRecords()
  });

  const columns = [
    {
      header: 'Referral #',
      accessorKey: 'referralNumber',
      cell: (info: any) => (
        <Link href={`/erp/referrals/${info.row.original.id}`} className="font-mono text-sm text-brand-500 hover:underline">
          {info.getValue()}
        </Link>
      )
    },
    {
      header: 'Date',
      accessorKey: 'dateReferred',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy')}</span>
    },
    {
      header: 'Referrer',
      accessorKey: 'referrerName',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className="font-medium">{info.getValue()}</span>
          <span className="text-[10px] text-text-muted">{info.row.original.referrerCode}</span>
        </div>
      )
    },
    {
      header: 'Referred Customer',
      accessorKey: 'referredCustomerName',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className="font-medium">{info.getValue()}</span>
          <span className="text-[10px] text-text-muted">Level {info.row.original.level}</span>
        </div>
      )
    },
    {
      header: 'Source',
      accessorKey: 'sourceChannel',
      cell: (info: any) => <Badge variant="outline">{info.getValue()}</Badge>
    },
    {
      header: 'Commission',
      accessorKey: 'commissionGenerated',
      cell: (info: any) => info.getValue() ? (
        <span className="font-bold text-success-dark"><AmountText amountInKobo={info.getValue()} /></span>
      ) : (
        <span className="text-text-muted text-xs">-</span>
      )
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Qualified') variant = 'default';
        else if (val === 'Pending Qualification' || val === 'Flagged') variant = 'secondary';
        else if (val === 'Disqualified' || val === 'Expired') variant = 'destructive';
        
        return (
          <div className="flex items-center gap-1">
            <Badge variant={variant}>{val}</Badge>
            {info.row.original.flags > 0 && <span className="text-error" title={`${info.row.original.flags} flags`}>⚠️</span>}
          </div>
        );
      }
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2 justify-end">
          <Link href={`/erp/referrals/${info.row.original.id}`}>
            <Button variant="ghost" size="sm">View</Button>
          </Link>
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
