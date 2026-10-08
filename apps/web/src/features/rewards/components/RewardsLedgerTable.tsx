'use client';


import { useRewardLedger } from '../queries';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { format } from 'date-fns';
import type { RewardLedgerEntry } from '../types';

interface RewardsLedgerTableProps {
  userId: string;
}

export function RewardsLedgerTable({ userId }: RewardsLedgerTableProps) {
  const { data, isLoading } = useRewardLedger(userId);

  const columns = [
    { 
      header: 'Date', 
      accessorKey: 'createdAt',
      cell: ({ row }: { row: { original: RewardLedgerEntry } }) => format(new Date(row.original.createdAt), 'dd MMM yyyy')
    },
    { header: 'Type', accessorKey: 'type' },
    { 
      header: 'Points', 
      accessorKey: 'points',
      cell: ({ row }: { row: { original: RewardLedgerEntry } }) => (
        <span className={row.original.points > 0 ? 'text-green-600' : 'text-red-600'}>
          {row.original.points > 0 ? '+' : ''}{row.original.points}
        </span>
      )
    },
    { header: 'Reference', accessorKey: 'reference' },
    { 
      header: 'Status', 
      accessorKey: 'status',
      cell: ({ row }: { row: { original: RewardLedgerEntry } }) => (
        <Badge variant={row.original.status === 'available' ? 'default' : 'secondary'}>
          {row.original.status}
        </Badge>
      )
    },
    { header: 'Balance After', accessorKey: 'balanceAfter' },
  ];

  return (
    <div className="border rounded-xl bg-white shadow-sm overflow-hidden">
      <div className="p-6 pb-2 border-b border-border">
        <h3 className="text-lg font-semibold">Points History</h3>
      </div>
      <div className="p-6">
        <DataTable
          data={data?.data || []}
          columns={columns}
          isLoading={isLoading}
        />
      </div>
    </div>
  );
}
