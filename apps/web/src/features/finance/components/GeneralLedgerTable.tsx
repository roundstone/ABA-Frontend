'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getGeneralLedger } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';

export function GeneralLedgerTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['general-ledger'],
    queryFn: getGeneralLedger
  });

  const columns = [
    {
      header: 'JE Number',
      accessorKey: 'jeNumber',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    {
      header: 'Date',
      accessorKey: 'date',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy HH:mm')}</span>
    },
    {
      header: 'Description',
      accessorKey: 'description',
    },
    {
      header: 'Source',
      id: 'source',
      cell: (info: any) => {
        const row = info.row.original;
        if (!row.sourceModule) return '-';
        return <span className="text-sm text-text-muted">{row.sourceModule}: {row.sourceId}</span>;
      }
    },
    {
      header: 'Total Amount',
      accessorKey: 'total',
      cell: (info: any) => (
        <div className="font-medium">
          <AmountText amountInKobo={info.getValue()} />
        </div>
      )
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Posted') variant = 'default';
        else if (val === 'Draft' || val === 'Awaiting Approval') variant = 'secondary';
        else if (val === 'Reversed' || val === 'Rejected') variant = 'destructive';
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
