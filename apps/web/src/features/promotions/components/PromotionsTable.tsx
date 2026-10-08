'use client';

import React from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getPromotions, updatePromotionStatus } from '../api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';
import { DropdownMenu, DropdownMenuTrigger, DropdownMenuContent, DropdownMenuItem } from '@/components/ui/dropdown-menu';
import { MoreHorizontal } from 'lucide-react';
import { toast } from 'sonner';

export function PromotionsTable() {
  const queryClient = useQueryClient();

  const { data, isLoading } = useQuery({
    queryKey: ['promotions'],
    queryFn: getPromotions
  });

  const { mutate: changeStatus } = useMutation({
    mutationFn: ({ id, status }: { id: string, status: any }) => updatePromotionStatus(id, status),
    onSuccess: () => {
      toast('Promotion status updated');
      queryClient.invalidateQueries({ queryKey: ['promotions'] });
    },
    onError: (err) => toast(`Failed: ${err.message}`)
  });

  const columns = [
    {
      header: 'Reference',
      accessorKey: 'reference',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue()}</span>
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const val = info.getValue();
        let variant: 'default' | 'secondary' | 'destructive' | 'outline' = 'outline';
        if (val === 'Pending payment' || val === 'Scheduled') variant = 'secondary';
        else if (val === 'Active') variant = 'default';
        else if (val === 'Rejected' || val === 'Cancelled') variant = 'destructive';
        return <Badge variant={variant}>{val}</Badge>;
      }
    },
    {
      header: 'Merchant',
      accessorKey: 'merchantId',
    },
    {
      header: 'Product',
      accessorKey: 'productId',
    },
    {
      header: 'Date Range',
      id: 'dates',
      cell: (info: any) => {
        const p = info.row.original;
        return (
          <div className="text-sm">
            <div>{format(new Date(p.startDate), 'MMM d, yyyy')}</div>
            <div className="text-gray-500">to {format(new Date(p.endDate), 'MMM d, yyyy')}</div>
          </div>
        );
      }
    },
    {
      header: 'Amount Paid',
      accessorKey: 'amountPaidInKobo',
      cell: (info: any) => <div className="font-medium"><AmountText amountInKobo={info.getValue()} /></div>
    },
    {
      header: 'Impressions',
      accessorKey: 'impressions',
      cell: (info: any) => (info.getValue() || 0).toLocaleString()
    },
    {
      id: 'actions',
      cell: (info: any) => {
        const promo = info.row.original;
        const status = promo.status;
        return (
          <DropdownMenu>
            <DropdownMenuTrigger render={<Button variant="ghost" size="icon" />}>
              <MoreHorizontal className="h-4 w-4" />
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              {status === 'Pending approval' && (
                <>
                  <DropdownMenuItem onClick={() => changeStatus({ id: promo.id, status: 'Scheduled' })}>Approve</DropdownMenuItem>
                  <DropdownMenuItem onClick={() => changeStatus({ id: promo.id, status: 'Rejected' })} className="text-red-600">Reject</DropdownMenuItem>
                </>
              )}
              {status === 'Active' && (
                <DropdownMenuItem onClick={() => changeStatus({ id: promo.id, status: 'Paused' })}>Pause</DropdownMenuItem>
              )}
              {status === 'Paused' && (
                <DropdownMenuItem onClick={() => changeStatus({ id: promo.id, status: 'Active' })}>Resume</DropdownMenuItem>
              )}
              {(status === 'Scheduled' || status === 'Active' || status === 'Paused' || status === 'Pending payment') && (
                <DropdownMenuItem onClick={() => changeStatus({ id: promo.id, status: 'Cancelled' })} className="text-red-600">Cancel</DropdownMenuItem>
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
