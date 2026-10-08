'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getExpenses } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';

export function ExpensesTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['expenses'],
    queryFn: () => getExpenses()
  });

  const columns = [
    {
      header: 'Expense #',
      accessorKey: 'expenseNumber',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    {
      header: 'Date',
      accessorKey: 'date',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy')}</span>
    },
    {
      header: 'Payee',
      accessorKey: 'payee',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Amount',
      accessorKey: 'amount',
      cell: (info: any) => <div className="font-medium"><AmountText amountInKobo={info.getValue()} /></div>
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Paid' || val === 'Approved') variant = 'default';
        else if (val === 'Draft' || val === 'Awaiting Approval') variant = 'secondary';
        else if (val === 'Rejected') variant = 'destructive';
        return <Badge variant={variant}>{val}</Badge>;
      }
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
