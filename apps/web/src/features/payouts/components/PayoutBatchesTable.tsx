'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getPayoutBatches } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

export function PayoutBatchesTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['payout-batches'],
    queryFn: () => getPayoutBatches()
  });

  const columns = [
    {
      header: 'Batch #',
      accessorKey: 'batchNumber',
      cell: (info: any) => (
        <Link href={`/erp/payouts/batches/${info.row.original.id}`} className="font-mono text-sm text-brand-500 hover:underline">
          {info.getValue()}
        </Link>
      )
    },
    {
      header: 'Created Date',
      accessorKey: 'createdDate',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy HH:mm')}</span>
    },
    {
      header: 'Requests',
      accessorKey: 'requestCount',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Total Amount',
      accessorKey: 'totalAmount',
      cell: (info: any) => <span className="font-bold"><AmountText amountInKobo={info.getValue()} /></span>
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Completed') variant = 'default';
        else if (val === 'Processing') variant = 'secondary';
        else if (val === 'Draft') variant = 'outline';
        else if (val === 'Partially Failed') variant = 'destructive';
        
        return <Badge variant={variant}>{val}</Badge>;
      }
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2 justify-end">
          <Link href={`/erp/payouts/batches/${info.row.original.id}`}>
            <Button variant="ghost" size="sm">View Batch</Button>
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
