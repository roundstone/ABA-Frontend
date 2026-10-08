'use client';


import { useRewardRules } from '../queries';
import { useUpdateRewardRule } from '../mutations';
import { DataTable } from '@/components/patterns/DataTable';
import { Switch } from '@/components/ui/switch';
import { usePermission } from '@/lib/auth/permissions';
import { toast } from 'sonner';
import type { RewardRule } from '../types';

export function RewardRulesList() {
  const { data: rules, isLoading } = useRewardRules();
  const { mutate: updateRule } = useUpdateRewardRule();
  const hasPermission = usePermission;

  const canEdit = hasPermission('points.settings');

  const columns = [
    { header: 'Event', accessorKey: 'triggeringEvent' },
    { header: 'Points', accessorKey: 'points' },
    { header: 'Needs Verified Purchase', accessorKey: 'needsVerifiedPurchase', 
      cell: ({ row }: { row: { original: RewardRule } }) => (row.original.needsVerifiedPurchase ? 'Yes' : 'No') 
    },
    { 
      header: 'Active', 
      id: 'active',
      cell: ({ row }: { row: { original: RewardRule } }) => (
        <Switch
          checked={row.original.active}
          disabled={!canEdit}
          onCheckedChange={(checked) => {
            updateRule(
              { id: row.original.id, updates: { active: checked } },
              {
                onSuccess: () => toast('Rule updated successfully'),
                onError: () => toast('Failed to update rule')
              }
            );
          }}
        />
      )
    }
  ];

  return (
    <div className="border rounded-xl bg-white shadow-sm overflow-hidden">
      <div className="p-6 pb-2 border-b border-border">
        <h3 className="text-lg font-semibold">Reward Rules</h3>
      </div>
      <div className="p-6">
        <DataTable
          data={rules || []}
          columns={columns}
          isLoading={isLoading}
        />
      </div>
    </div>
  );
}
