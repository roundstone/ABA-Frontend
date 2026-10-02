'use client';

import { useState } from 'react';
import { useParams } from 'next/navigation';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { DataTable } from '@/components/patterns/DataTable';
import { Star, Download, Calendar, Filter, FileSpreadsheet, LayoutGrid, FileText, ChevronRight } from 'lucide-react';

// Mock report data structure
const MOCK_REPORT_DATA = {
  columns: [
    { accessorKey: 'metric', header: 'Metric / Dimension' },
    { accessorKey: 'value_previous', header: 'Previous Period' },
    { accessorKey: 'value_current', header: 'Current Period' },
    { accessorKey: 'variance', header: 'Variance' }
  ],
  data: [
    { metric: 'Category A', value_previous: '120', value_current: '150', variance: '+25%' },
    { metric: 'Category B', value_previous: '300', value_current: '280', variance: '-6.6%' },
    { metric: 'Category C', value_previous: '450', value_current: '500', variance: '+11.1%' }
  ]
};

function toTitleCase(str: string) {
  return str.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
}

export default function StandardReportPage() {
  const params = useParams();
  const category = params.category as string;
  const id = params.id as string;

  const [isFavorite, setIsFavorite] = useState(false);
  const [viewMode, setViewMode] = useState<'chart' | 'table'>('table');
  const [isGenerating, setIsGenerating] = useState(false);

  const reportTitle = toTitleCase(id || 'Report');
  const categoryTitle = toTitleCase(category || 'Category');

  return (
    <div className="space-y-6 pb-20 mx-auto">
      {/* Header */}
      <PageHeader
        title={
          <div className="flex items-center gap-3">
            {reportTitle}
            <button
              onClick={() => setIsFavorite(!isFavorite)}
              className={`p-1 rounded hover:bg-surface-2 transition-colors ${isFavorite ? 'text-yellow-400' : 'text-text-muted'}`}
            >
              <Star className="w-5 h-5" fill={isFavorite ? "currentColor" : "none"} />
            </button>
          </div>
        }
        description={`Standard analytics view for ${reportTitle.toLowerCase()}. Data is retrieved in real-time.`}
        action={
          <div className="flex gap-2">
            <Button variant="outline" className="gap-2">
              <Calendar className="w-4 h-4" />
              Schedule
            </Button>
            <div className="relative group">
              <Button className="gap-2">
                <Download className="w-4 h-4" />
                Export
              </Button>
              <div className="absolute right-0 mt-2 w-48 bg-surface border border-border rounded-xl shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all z-50 overflow-hidden">
                <button className="w-full text-left px-4 py-2 hover:bg-surface-2 flex items-center gap-2 text-sm"><FileSpreadsheet className="w-4 h-4" /> Excel (.xlsx)</button>
                <button className="w-full text-left px-4 py-2 hover:bg-surface-2 flex items-center gap-2 text-sm"><LayoutGrid className="w-4 h-4" /> CSV</button>
                <button className="w-full text-left px-4 py-2 hover:bg-surface-2 flex items-center gap-2 text-sm"><FileText className="w-4 h-4" /> PDF Report</button>
              </div>
            </div>
          </div>
        }
      />

      {/* Sticky Filter Bar */}
      <div className="sticky top-0 z-40 bg-surface/90 backdrop-blur-md rounded-xl border border-border p-4 shadow-sm flex flex-col md:flex-row gap-4 items-center justify-between">
        <div className="flex gap-4 items-center flex-wrap flex-1">
          <div className="flex flex-col">
            <span className="text-[10px] font-bold uppercase tracking-wider text-text-muted mb-1">Date Range</span>
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
              <option>Last 7 Days</option>
              <option>This Month</option>
              <option>Last Month</option>
              <option>This Quarter</option>
              <option>Year to Date</option>
              <option>Custom Range...</option>
            </select>
          </div>

          <div className="flex flex-col">
            <span className="text-[10px] font-bold uppercase tracking-wider text-text-muted mb-1">Group By</span>
            <select className="h-9 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
              <option>Day</option>
              <option>Week</option>
              <option>Month</option>
              <option>Merchant</option>
              <option>Product Category</option>
            </select>
          </div>

          <div className="flex flex-col flex-1 min-w-[200px]">
            <span className="text-[10px] font-bold uppercase tracking-wider text-text-muted mb-1">Specific Search / Filter</span>
            <div className="relative">
              <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
              <Input placeholder="Filter by merchant, product, or ID..." className="h-9 pl-9 w-full" />
            </div>
          </div>
        </div>

        <div className="flex items-end h-full mt-4 md:mt-0">
          <Button onClick={() => {
            setIsGenerating(true);
            setTimeout(() => setIsGenerating(false), 800);
          }}>Apply Filters</Button>
        </div>
      </div>

      {/* Report Content */}
      <div className="space-y-6">

        {/* Toggle between Chart & Table */}
        <div className="flex justify-end border-b border-border pb-2">
          <div className="bg-surface-2 p-1 rounded-lg inline-flex">
            <button
              onClick={() => setViewMode('chart')}
              className={`px-4 py-1.5 rounded-md text-sm font-medium transition-colors ${viewMode === 'chart' ? 'bg-white shadow-sm text-brand-700' : 'text-text-muted hover:text-text'}`}
            >
              Chart View
            </button>
            <button
              onClick={() => setViewMode('table')}
              className={`px-4 py-1.5 rounded-md text-sm font-medium transition-colors ${viewMode === 'table' ? 'bg-white shadow-sm text-brand-700' : 'text-text-muted hover:text-text'}`}
            >
              Table View
            </button>
          </div>
        </div>

        {/* Data Visualization Area */}
        <div className="bg-surface border border-border rounded-xl min-h-[400px] flex flex-col overflow-hidden">
          {viewMode === 'chart' ? (
            <div className="flex-1 p-6 flex flex-col items-center justify-center text-text-muted">
              <BarChart4 className="w-16 h-16 mb-4 opacity-20" />
              <p>Chart visualization for <strong>{reportTitle}</strong></p>
              <p className="text-sm mt-2">Grouped by selected dimension.</p>

              {/* Fake Bar Chart Blocks for visual effect */}
              <div className="flex items-end gap-4 h-48 mt-8 border-b border-l border-border w-full max-w-2xl px-6">
                <div className="w-full bg-brand-500/20 hover:bg-brand-500 transition-colors h-[40%] rounded-t-md relative group cursor-pointer">
                  <span className="absolute -top-8 left-1/2 -translate-x-1/2 opacity-0 group-hover:opacity-100 bg-surface border border-border px-2 py-1 text-xs rounded shadow-sm">120</span>
                </div>
                <div className="w-full bg-brand-500/40 hover:bg-brand-500 transition-colors h-[70%] rounded-t-md relative group cursor-pointer">
                  <span className="absolute -top-8 left-1/2 -translate-x-1/2 opacity-0 group-hover:opacity-100 bg-surface border border-border px-2 py-1 text-xs rounded shadow-sm">300</span>
                </div>
                <div className="w-full bg-brand-500/80 hover:bg-brand-500 transition-colors h-[90%] rounded-t-md relative group cursor-pointer">
                  <span className="absolute -top-8 left-1/2 -translate-x-1/2 opacity-0 group-hover:opacity-100 bg-surface border border-border px-2 py-1 text-xs rounded shadow-sm">450</span>
                </div>
                <div className="w-full bg-brand-500/60 hover:bg-brand-500 transition-colors h-[80%] rounded-t-md relative group cursor-pointer">
                  <span className="absolute -top-8 left-1/2 -translate-x-1/2 opacity-0 group-hover:opacity-100 bg-surface border border-border px-2 py-1 text-xs rounded shadow-sm">400</span>
                </div>
              </div>
            </div>
          ) : (
            <DataTable
              data={MOCK_REPORT_DATA.data}
              columns={MOCK_REPORT_DATA.columns}
              isLoading={isGenerating}
            />
          )}
        </div>

      </div>
    </div>
  );
}

// Ensure the icon is imported
import { BarChart4 } from 'lucide-react';
