'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getReferralCodes } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';
import { Copy, QrCode, RefreshCw } from 'lucide-react';

export function ReferralCodesTable() {
  const { data, isLoading } = useQuery({
    queryKey: ['referral-codes'],
    queryFn: () => getReferralCodes()
  });

  const columns = [
    {
      header: 'Code',
      accessorKey: 'code',
      cell: (info: any) => <span className="font-mono text-sm font-bold text-brand-600">{info.getValue()}</span>
    },
    {
      header: 'Owner',
      accessorKey: 'ownerName',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Created',
      accessorKey: 'createdDate',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy')}</span>
    },
    {
      header: 'Clicks',
      accessorKey: 'clicks',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Signups',
      accessorKey: 'signups',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Conversions',
      accessorKey: 'conversions',
      cell: (info: any) => <span className="font-medium text-success-dark">{info.getValue()}</span>
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        return <Badge variant={val === 'Active' ? 'default' : 'secondary'}>{val}</Badge>;
      }
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex gap-2 justify-end">
          <Button variant="ghost" size="sm" title="Copy Link"><Copy className="w-4 h-4" /></Button>
          <Button variant="ghost" size="sm" title="Download QR"><QrCode className="w-4 h-4" /></Button>
          <Button variant="ghost" size="sm" title="Regenerate Code"><RefreshCw className="w-4 h-4" /></Button>
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
