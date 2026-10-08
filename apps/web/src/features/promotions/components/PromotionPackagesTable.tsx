'use client';

import React from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getPromotionPackages, updatePromotionPackageStatus } from '@/features/promotions/api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { Button } from '@/components/ui/button';
import { DropdownMenu, DropdownMenuTrigger, DropdownMenuContent, DropdownMenuItem } from '@/components/ui/dropdown-menu';
import { MoreHorizontal } from 'lucide-react';
import { toast } from 'sonner';

export function PromotionPackagesTable() {
  const queryClient = useQueryClient();

  const { data, isLoading } = useQuery({
    queryKey: ['promotion-packages'],
    queryFn: getPromotionPackages
  });

  const { mutate: changeStatus } = useMutation({
    mutationFn: ({ id, status }: { id: string, status: any }) => updatePromotionPackageStatus(id, status),
    onSuccess: () => {
      toast('Package status updated');
      queryClient.invalidateQueries({ queryKey: ['promotion-packages'] });
    },
    onError: (err) => toast(`Failed: ${err.message}`)
  });

  const columns = [
    {
      header: 'Name',
      accessorKey: 'name',
      cell: (info: any) => <span className="font-semibold">{info.getValue()}</span>
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
      header: 'Placement',
      accessorKey: 'placement',
    },
    {
      header: 'Duration (Days)',
      accessorKey: 'durationDays',
    },
    {
      header: 'Price',
      accessorKey: 'priceInKobo',
      cell: (info: any) => <AmountText amountInKobo={info.getValue()} />
    },
    {
      header: 'Max Slots',
      accessorKey: 'maxSlots',
    },
    {
      id: 'actions',
      cell: (info: any) => {
        const pkg = info.row.original;
        const status = pkg.status;
        return (
          <DropdownMenu>
            <DropdownMenuTrigger render={<Button variant="ghost" size="icon" />}>
              <MoreHorizontal className="h-4 w-4" />
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              {status === 'Active' ? (
                <DropdownMenuItem onClick={() => changeStatus({ id: pkg.id, status: 'Inactive' })} className="text-red-600">Deactivate</DropdownMenuItem>
              ) : (
                <DropdownMenuItem onClick={() => changeStatus({ id: pkg.id, status: 'Active' })}>Activate</DropdownMenuItem>
              )}
            </DropdownMenuContent>
          </DropdownMenu>
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
