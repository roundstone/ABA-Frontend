'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { useQuery } from '@tanstack/react-query';
import { getExportJobs } from '@/features/reports/api';
import { DataTable } from '@/components/patterns/DataTable';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Download } from 'lucide-react';
import { format } from 'date-fns';

export default function ExportHistoryPage() {
  const { data, isLoading } = useQuery({ queryKey: ['export-jobs'], queryFn: getExportJobs });

  const columns = [
    {
      header: 'Report',
      accessorKey: 'reportName',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Requested At',
      accessorKey: 'requestedAt',
      cell: (info: any) => <span className="text-sm">{format(new Date(info.getValue()), 'MMM d, yyyy HH:mm')}</span>
    },
    {
      header: 'Requested By',
      accessorKey: 'requestedBy',
      cell: (info: any) => <span className="text-sm">{info.getValue()}</span>
    },
    {
      header: 'Format',
      accessorKey: 'format',
      cell: (info: any) => <Badge variant="outline">{info.getValue()}</Badge>
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: (info: any) => {
        const status = info.getValue();
        if (status === 'Ready') return <Badge variant="default">{status}</Badge>;
        if (status === 'Generating') return <Badge variant="secondary" className="animate-pulse">{status}</Badge>;
        if (status === 'Expired') return <Badge variant="outline" className="text-text-muted">{status}</Badge>;
        return <Badge variant="destructive">{status}</Badge>;
      }
    },
    {
      id: 'actions',
      cell: (info: any) => {
        if (info.row.original.status === 'Ready' && info.row.original.downloadUrl) {
          return (
            <div className="flex justify-end">
              <Button variant="ghost" size="sm" title="Download">
                <Download className="w-4 h-4 mr-2" /> Download
              </Button>
            </div>
          );
        }
        return null;
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-7xl">
      <PageHeader 
        title="Export History" 
        description="View and download your recently generated large reports."
        backHref="/erp/reports"
      />
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable data={data?.data || []} columns={columns} isLoading={isLoading} />
      </div>
    </div>
  );
}
