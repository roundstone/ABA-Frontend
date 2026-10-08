'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getRefunds } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';

export function RefundsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['payment-refunds'],
    queryFn: () => getRefunds()
  });

  const columns = [
    {
      header: 'Refund #',
      accessorKey: 'refundNumber',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    {
      header: 'Date',
      accessorKey: 'date',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy')}</span>
    },
    {
      header: 'Customer',
      accessorKey: 'customerName',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className="font-medium">{info.getValue()}</span>
          <span className="font-mono text-xs text-brand-500 cursor-pointer">{info.row.original.orderNumber}</span>
        </div>
      )
    },
    {
      header: 'Amount',
      accessorKey: 'amount',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className="font-medium"><AmountText amountInKobo={info.getValue()} /></span>
          <span className="text-[10px] text-text-muted">{info.row.original.method}</span>
        </div>
      )
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' | 'warning' = 'outline';
        if (val === 'Completed') variant = 'default';
        else if (val === 'Requested' || val === 'Processing') variant = 'secondary';
        else if (val === 'Approved') variant = 'outline'; // Or custom
        else if (val === 'Rejected' || val === 'Failed') variant = 'destructive';
        return <Badge variant={variant as any}>{val}</Badge>;
      }
    },
    {
      header: 'Reason',
      accessorKey: 'reason',
      cell: (info: any) => <span className="text-xs text-text-muted truncate max-w-[150px] inline-block" title={info.getValue()}>{info.getValue()}</span>
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2">
          {info.row.original.status === 'Requested' && <Button variant="primary" size="sm">Approve</Button>}
          <Button variant="ghost" size="sm">View</Button>
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
