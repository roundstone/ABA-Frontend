'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getPayouts } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

export function PayoutsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['payouts'],
    queryFn: () => getPayouts()
  });

  const columns = [
    {
      header: 'Payout #',
      accessorKey: 'payoutNumber',
      cell: (info: any) => (
        <Link href={`/erp/payouts/${info.row.original.id}`} className="font-mono text-sm text-brand-500 hover:underline">
          {info.getValue()}
        </Link>
      )
    },
    {
      header: 'Requested Date',
      accessorKey: 'requestedDate',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy HH:mm')}</span>
    },
    {
      header: 'Payee',
      accessorKey: 'payeeName',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className="font-medium">{info.getValue()}</span>
          <span className="text-[10px] text-text-muted">{info.row.original.payeeType}</span>
        </div>
      )
    },
    {
      header: 'Source',
      accessorKey: 'source',
      cell: (info: any) => <Badge variant="outline">{info.getValue()}</Badge>
    },
    {
      header: 'Net Amount',
      accessorKey: 'netAmount',
      cell: (info: any) => <span className="font-bold"><AmountText amountInKobo={info.getValue()} /></span>
    },
    {
      header: 'Destination',
      accessorKey: 'destinationAccount',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className="font-mono text-xs">{info.getValue()}</span>
          <span className="text-[10px] text-text-muted">{info.row.original.destinationBank}</span>
        </div>
      )
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Paid') variant = 'default';
        else if (val === 'Pending') variant = 'secondary';
        else if (val === 'Processing') variant = 'outline';
        else if (val === 'Failed' || val === 'Rejected') variant = 'destructive';
        
        return <Badge variant={variant}>{val}</Badge>;
      }
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2 justify-end">
          <Link href={`/erp/payouts/${info.row.original.id}`}>
            <Button variant="ghost" size="sm">Review</Button>
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
