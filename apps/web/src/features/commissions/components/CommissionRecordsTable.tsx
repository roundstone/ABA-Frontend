'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getCommissionRecords } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';

export function CommissionRecordsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['commission-records'],
    queryFn: () => getCommissionRecords()
  });

  const columns = [
    {
      header: 'COM #',
      accessorKey: 'commissionNumber',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    {
      header: 'Date',
      accessorKey: 'date',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy')}</span>
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
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Approved' || val === 'Paid') variant = 'default';
        else if (val === 'Pending') variant = 'secondary';
        else if (val === 'Reversed' || val === 'Clawback') variant = 'destructive';
        return <Badge variant={variant}>{val}</Badge>;
      }
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2">
          {info.row.original.status === 'Pending' && <Button variant="outline" size="sm">Approve</Button>}
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
