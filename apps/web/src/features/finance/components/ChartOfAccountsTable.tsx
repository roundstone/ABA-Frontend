'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getChartOfAccounts } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';

export function ChartOfAccountsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['chart-of-accounts'],
    queryFn: getChartOfAccounts
  });

  const columns = [
    {
      header: 'Code',
      accessorKey: 'code',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    {
      header: 'Name',
      accessorKey: 'name',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Type',
      accessorKey: 'type',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'outline' = 'outline';
        if (val === 'Asset') variant = 'default';
        else if (val === 'Liability') variant = 'secondary';
        return <Badge variant={variant}>{val}</Badge>;
      }
    },
    {
      header: 'Normal Balance',
      accessorKey: 'normalBalance',
      cell: (info: any) => <span className="text-sm text-text-muted">{info.getValue()}</span>
    },
    {
      header: 'Balance',
      accessorKey: 'balance',
      cell: (info: any) => (
        <div className="font-medium">
          <AmountText amountInKobo={info.getValue()} />
        </div>
      )
    },
    {
      header: 'Status',
      accessorKey: 'active',
      cell: (info: any) => (
        <Badge variant={info.getValue() ? 'outline' : 'secondary'}>
          {info.getValue() ? 'Active' : 'Inactive'}
        </Badge>
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
