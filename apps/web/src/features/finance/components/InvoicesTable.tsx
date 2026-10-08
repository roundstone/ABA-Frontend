'use client';

import React from 'react';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';

export function InvoicesTable({ data, isLoading }: { data: any[], isLoading: boolean }) {
  const columns = [
    {
      header: 'Invoice #',
      accessorKey: 'invoiceNumber',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    {
      header: 'Party',
      accessorKey: 'partyName',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Date',
      accessorKey: 'date',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy')}</span>
    },
    {
      header: 'Due Date',
      accessorKey: 'dueDate',
      cell: (info: any) => {
        const date = new Date(info.getValue());
        const isOverdue = date < new Date();
        return <span className={`text-sm ${isOverdue ? 'text-error font-medium' : ''}`}>{format(date, 'MMM d, yyyy')}</span>;
      }
    },
    {
      header: 'Amount',
      accessorKey: 'amount',
      cell: (info: any) => <div className="font-medium text-text-muted"><AmountText amountInKobo={info.getValue()} /></div>
    },
    {
      header: 'Balance',
      accessorKey: 'balance',
      cell: (info: any) => <div className="font-medium text-text"><AmountText amountInKobo={info.getValue()} /></div>
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Open') variant = 'default';
        else if (val === 'Partially Paid') variant = 'secondary';
        else if (val === 'Overdue') variant = 'destructive';
        return <Badge variant={variant}>{val}</Badge>;
      }
    }
  ];

  return (
    <DataTable
      data={data || []}
      columns={columns}
      isLoading={isLoading}
    />
  );
}
