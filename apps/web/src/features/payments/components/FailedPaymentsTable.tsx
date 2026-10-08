'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getPayments } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';
import { Check, X } from 'lucide-react';

export function FailedPaymentsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['payments'],
    queryFn: () => getPayments()
  });

  const failedOrPending = data?.data.filter(r => r.status === 'Failed' || r.status === 'Pending') || [];

  const columns = [
    {
      header: 'Payment #',
      accessorKey: 'referenceNumber',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    {
      header: 'Date',
      accessorKey: 'paymentDate',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy')}</span>
    },
    {
      header: 'Type / Party',
      accessorKey: 'partyName',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className="font-medium">{info.getValue()}</span>
          <span className="text-[10px] text-text-muted">{info.row.original.type}</span>
        </div>
      )
    },
    {
      header: 'Method',
      accessorKey: 'method',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    {
      header: 'Net Amount',
      accessorKey: 'netAmount',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className={info.row.original.direction === 'In' ? 'text-success-dark font-medium' : 'text-error font-medium'}>
            {info.row.original.direction === 'In' ? '+' : '-'}<AmountText amountInKobo={info.getValue()} />
          </span>
        </div>
      )
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Pending') variant = 'secondary';
        else if (val === 'Failed') variant = 'destructive';
        return <Badge variant={variant}>{val}</Badge>;
      }
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2">
          {info.row.original.status === 'Pending' && <Button variant="primary" size="sm">Confirm Transfer</Button>}
          {info.row.original.status === 'Failed' && <Button variant="outline" size="sm">Retry</Button>}
        </div>
      )
    }
  ];

  return (
    <DataTable
      data={failedOrPending}
      columns={columns}
      isLoading={isLoading}
    />
  );
}
