'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getCommissionRecords } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';

export function CommissionApprovalsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['commission-records'],
    queryFn: () => getCommissionRecords()
  });

  // Filter only pending records
  const pendingRecords = data?.data.filter(r => r.status === 'Pending') || [];

  const columns = [
    {
      header: 'COM #',
      accessorKey: 'commissionNumber',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    {
      header: 'Beneficiary',
      accessorKey: 'beneficiaryName',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Source Order',
      accessorKey: 'sourceOrderNumber',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className="font-mono text-xs text-brand-500 cursor-pointer">{info.getValue()}</span>
          <span className="text-[10px] text-text-muted">{info.row.original.sourceCustomerName}</span>
        </div>
      )
    },
    {
      header: 'Level',
      accessorKey: 'level',
      cell: (info: any) => <Badge variant="outline">L{info.getValue()}</Badge>
    },
    {
      header: 'Commission',
      accessorKey: 'amount',
      cell: (info: any) => (
        <div className="flex flex-col">
          <span className="font-medium text-success-dark"><AmountText amountInKobo={info.getValue()} /></span>
          <span className="text-[10px] text-text-muted">{info.row.original.rate}% of <AmountText amountInKobo={info.row.original.baseAmount} /></span>
        </div>
      )
    },
    {
      header: 'Date',
      accessorKey: 'date',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d')}</span>
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2">
          <Button variant="primary" size="sm">Approve</Button>
          <Button variant="outline" size="sm" className="text-error border-error-muted hover:bg-error-light hover:text-error">Reject</Button>
        </div>
      )
    }
  ];

  return (
    <DataTable
      data={pendingRecords}
      columns={columns}
      isLoading={isLoading}
    />
  );
}
