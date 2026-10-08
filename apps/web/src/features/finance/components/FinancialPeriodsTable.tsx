'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getFinancialPeriods } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';

export function FinancialPeriodsTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['financial-periods'],
    queryFn: () => getFinancialPeriods()
  });

  const columns = [
    {
      header: 'Period Name',
      accessorKey: 'name',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Start Date',
      accessorKey: 'startDate',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy')}</span>
    },
    {
      header: 'End Date',
      accessorKey: 'endDate',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy')}</span>
    },
    {
      header: 'Closed At',
      accessorKey: 'closedAt',
      cell: (info: any) => info.getValue() ? <span className="text-sm text-text-muted">{format(new Date(info.getValue()), 'MMM d, yyyy HH:mm')}</span> : '-'
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Open') variant = 'default';
        else if (val === 'Closed' || val === 'Locked') variant = 'secondary';
        else if (val === 'Closing') variant = 'destructive';
        return <Badge variant={variant}>{val}</Badge>;
      }
    },
    {
      id: 'actions',
      cell: (info: any) => {
        const isClosed = info.row.original.status === 'Closed' || info.row.original.status === 'Locked';
        return (
          <Button variant="outline" size="sm" disabled={isClosed}>
            {isClosed ? 'Closed' : 'Close Period'}
          </Button>
        );
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
