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

export function PaymentsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['payments'],
    queryFn: () => getPayments()
  });

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
        if (val === 'Completed') variant = 'default';
        else if (val === 'Pending') variant = 'secondary';
        else if (val === 'Failed' || val === 'Voided') variant = 'destructive';
        return <Badge variant={variant}>{val}</Badge>;
      }
    },
    {
      header: 'Reconciled',
      accessorKey: 'isReconciled',
      cell: (info: any) => (
        info.getValue() ? <Check className="h-4 w-4 text-success" /> : <X className="h-4 w-4 text-text-muted" />
      )
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2">
          {info.row.original.status === 'Pending' && <Button variant="outline" size="sm">Confirm</Button>}
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
