'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { useQuery } from '@tanstack/react-query';
import { getReportsList } from '@/features/reports/api';
import { Button } from '@/components/ui/button';
import { Download, Calendar, Filter } from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { DataTable } from '@/components/patterns/DataTable';
import { ChartCard } from '@/components/patterns/ChartCard';
import { useParams } from 'next/navigation';

// Mock report data to show the layout working
const mockReportData = Array.from({ length: 15 }).map((_, i) => ({
  id: `row-${i}`,
  metricName: `Dimension ${i + 1}`,
  value: Math.floor(Math.random() * 5000000),
  trend: Math.floor(Math.random() * 20) - 10,
}));

export default function ReportDetailPage() {
  const params = useParams();
  const category = params.category as string;
  const id = params.id as string;
  const { data: reportsData } = useQuery({ queryKey: ['reports-list'], queryFn: getReportsList });

  const report = reportsData?.data.find(r => r.id === id && r.category === category);

  if (!report) return <div className="p-10 text-center">Loading Report...</div>;

  const columns = [
    {
      header: 'Dimension',
      accessorKey: 'metricName',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      header: 'Value',
      accessorKey: 'value',
      cell: (info: any) => <span className="font-mono text-sm">{info.getValue().toLocaleString()}</span>
    },
    {
      header: 'Trend %',
      accessorKey: 'trend',
      cell: (info: any) => {
        const val = info.getValue();
        return (
          <span className={`text-sm font-medium ${val > 0 ? 'text-success-dark' : val < 0 ? 'text-error' : 'text-text-muted'}`}>
            {val > 0 ? '+' : ''}{val}%
          </span>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-7xl">
      <PageHeader
        title={report.title}
        description={report.description}
        backHref="/erp/reports"
        action={
          <div className="flex gap-2">
            <Button variant="outline"><Calendar className="w-4 h-4 mr-2" /> Schedule</Button>
            <Button variant="primary"><Download className="w-4 h-4 mr-2" /> Export PDF</Button>
          </div>
        }
      />

      <div className="flex items-center gap-4 bg-surface p-4 rounded-xl border border-border">
        <div className="flex items-center gap-2">
          <Filter className="w-4 h-4 text-text-muted" />
          <span className="text-sm font-medium">Filters:</span>
        </div>
        <div className="flex flex-wrap gap-2">
          <Badge variant="outline">Date Range: Last 30 Days</Badge>
          <Badge variant="outline">Merchant: All</Badge>
          <Badge variant="outline">Group By: Daily</Badge>
        </div>
        <Button variant="ghost" size="sm" className="ml-auto text-brand-600">Edit Filters</Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        {[1, 2, 3, 4].map(i => (
          <div key={i} className="p-4 bg-surface rounded-xl border border-border">
            <p className="text-sm text-text-muted">Key Metric {i}</p>
            <p className="text-2xl font-bold mt-1">{(Math.random() * 1000000).toLocaleString(undefined, { maximumFractionDigits: 0 })}</p>
            <p className="text-xs text-success-dark mt-1">+12% vs previous</p>
          </div>
        ))}
      </div>

      <div className="mb-6">
        <ChartCard
          title="Metric Trend"
          subtitle="Trend analysis over the selected dimension"
          type="bar"
          data={mockReportData}
          xAxisKey="metricName"
          series={[{ key: 'value', name: 'Value', color: '#0f172a' }]}
          height={300}
        />
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable data={mockReportData} columns={columns} isLoading={false} />
      </div>
    </div>
  );
}
