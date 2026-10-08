'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { useQuery } from '@tanstack/react-query';
import { getScheduledReports } from '@/features/reports/api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Switch } from '@/components/ui/switch';
import { format } from 'date-fns';

export default function ScheduledReportsPage() {
  const { data, isLoading } = useQuery({ queryKey: ['scheduled-reports'], queryFn: getScheduledReports });

  const columns = [
    {
      header: 'Report',
      accessorKey: 'reportName',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Frequency',
      accessorKey: 'frequency',
      cell: (info: any) => <Badge variant="outline">{info.getValue()}</Badge>
    },
    {
      header: 'Next Run',
      accessorKey: 'nextRun',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy HH:mm')}</span>
    },
    {
      header: 'Format',
      accessorKey: 'format',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    {
      header: 'Recipients',
      accessorKey: 'recipients',
      cell: (info: any) => (
        <span className="text-sm text-text-muted truncate max-w-[200px] inline-block">
          {info.getValue().join(', ')}
        </span>
      )
    },
    {
      header: 'Active',
      accessorKey: 'active',
      cell: (info: any) => <Switch checked={info.getValue()} />
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex justify-end gap-2">
          <Button variant="ghost" size="sm">Edit</Button>
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-7xl">
      <PageHeader 
        title="Scheduled Reports" 
        description="Manage automated reports delivered via email."
        backHref="/erp/reports"
        action={<Button>Create Schedule</Button>}
      />
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable data={data?.data || []} columns={columns} isLoading={isLoading} />
      </div>
    </div>
  );
}
