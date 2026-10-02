"use client";
import React from 'react';
import {
  ResponsiveContainer,
  BarChart,
  Bar,
  LineChart,
  Line,
  AreaChart,
  Area,
  PieChart,
  Pie,
  Cell,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
} from 'recharts';
import { MoreHorizontal } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Skeleton } from '@/components/ui/skeleton';
import { ErrorState } from './ErrorState';
import { EmptyState } from './EmptyState';

export type ChartType = 'bar' | 'line' | 'area' | 'pie';

export interface ChartSeries {
  key: string;
  name: string;
  color: string;
  type?: 'monotone' | 'linear' | 'step';
}

export interface ChartCardProps {
  title: string;
  subtitle?: string;
  type: ChartType;
  data: any[];
  xAxisKey?: string;
  series?: ChartSeries[];
  pieDataKey?: string;
  pieNameKey?: string;
  
  height?: number | string;
  isLoading?: boolean;
  error?: Error | null;
  onRetry?: () => void;
  
  ranges?: string[];
  activeRange?: string;
  onRangeChange?: (range: string) => void;
  
  valueFormatter?: (value: number) => string;
}

export function ChartCard({
  title,
  subtitle,
  type,
  data,
  xAxisKey = 'name',
  series = [],
  pieDataKey = 'value',
  pieNameKey = 'name',
  height = 320,
  isLoading = false,
  error = null,
  onRetry,
  ranges,
  activeRange,
  onRangeChange,
  valueFormatter
}: ChartCardProps) {
  
  const hasData = data && data.length > 0;
  
  const renderChart = () => {
    if (type === 'bar') {
      return (
        <BarChart data={data} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E2E8F0" />
          <XAxis dataKey={xAxisKey} axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#64748b' }} dy={10} />
          <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#64748b' }} tickFormatter={valueFormatter} />
          <Tooltip 
            cursor={{ fill: '#f1f5f9' }} 
            contentStyle={{ borderRadius: '8px', border: '1px solid #e2e8f0', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
            formatter={(val: any) => valueFormatter ? [valueFormatter(Number(val)), ''] : [val, '']}
          />
          {series.length > 1 && <Legend iconType="circle" wrapperStyle={{ fontSize: 12, paddingTop: 10 }} />}
          {series.map((s) => (
            <Bar key={s.key} dataKey={s.key} name={s.name} fill={s.color} radius={[4, 4, 0, 0]} />
          ))}
        </BarChart>
      );
    }
    
    if (type === 'line') {
      return (
        <LineChart data={data} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E2E8F0" />
          <XAxis dataKey={xAxisKey} axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#64748b' }} dy={10} />
          <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#64748b' }} tickFormatter={valueFormatter} />
          <Tooltip 
            contentStyle={{ borderRadius: '8px', border: '1px solid #e2e8f0', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
            formatter={(val: any) => valueFormatter ? [valueFormatter(Number(val)), ''] : [val, '']}
          />
          {series.length > 1 && <Legend iconType="circle" wrapperStyle={{ fontSize: 12, paddingTop: 10 }} />}
          {series.map((s) => (
            <Line 
              key={s.key} 
              type={s.type || 'monotone'} 
              dataKey={s.key} 
              name={s.name} 
              stroke={s.color} 
              strokeWidth={2}
              dot={{ r: 4, fill: s.color, strokeWidth: 0 }}
              activeDot={{ r: 6, strokeWidth: 0 }}
            />
          ))}
        </LineChart>
      );
    }
    
    if (type === 'area') {
      return (
        <AreaChart data={data} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
          <defs>
            {series.map((s) => (
              <linearGradient key={`color-${s.key}`} id={`color-${s.key}`} x1="0" y1="0" x2="0" y2="1">
                <stop offset="5%" stopColor={s.color} stopOpacity={0.3}/>
                <stop offset="95%" stopColor={s.color} stopOpacity={0}/>
              </linearGradient>
            ))}
          </defs>
          <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E2E8F0" />
          <XAxis dataKey={xAxisKey} axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#64748b' }} dy={10} />
          <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#64748b' }} tickFormatter={valueFormatter} />
          <Tooltip 
            contentStyle={{ borderRadius: '8px', border: '1px solid #e2e8f0', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
            formatter={(val: any) => valueFormatter ? [valueFormatter(Number(val)), ''] : [val, '']}
          />
          {series.length > 1 && <Legend iconType="circle" wrapperStyle={{ fontSize: 12, paddingTop: 10 }} />}
          {series.map((s) => (
            <Area 
              key={s.key} 
              type={s.type || 'monotone'} 
              dataKey={s.key} 
              name={s.name} 
              stroke={s.color} 
              fillOpacity={1} 
              fill={`url(#color-${s.key})`}
            />
          ))}
        </AreaChart>
      );
    }

    if (type === 'pie') {
      // Default colors if not provided in data
      const defaultColors = ['#0f172a', '#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899', '#06b6d4'];
      return (
        <PieChart>
          <Tooltip 
            contentStyle={{ borderRadius: '8px', border: '1px solid #e2e8f0', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
            formatter={(val: any) => valueFormatter ? [valueFormatter(Number(val)), ''] : [val, '']}
          />
          <Legend iconType="circle" layout="vertical" verticalAlign="middle" align="right" wrapperStyle={{ fontSize: 12 }} />
          <Pie
            data={data}
            cx="40%"
            cy="50%"
            innerRadius={60}
            outerRadius={80}
            paddingAngle={5}
            dataKey={pieDataKey}
            nameKey={pieNameKey}
          >
            {data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={entry.color || defaultColors[index % defaultColors.length]} />
            ))}
          </Pie>
        </PieChart>
      );
    }

    return null;
  };

  return (
    <div className="bg-surface rounded-xl border border-border flex flex-col overflow-hidden">
      <div className="flex items-center justify-between p-5 border-b border-border/50">
        <div>
          <h3 className="font-semibold text-text">{title}</h3>
          {subtitle && <p className="text-xs text-text-muted mt-1">{subtitle}</p>}
        </div>
        
        <div className="flex items-center gap-2">
          {ranges && ranges.length > 0 && onRangeChange && (
            <div className="flex bg-surface-2 rounded-md p-0.5 border border-border">
              {ranges.map(range => (
                <button
                  key={range}
                  onClick={() => onRangeChange(range)}
                  className={`px-2.5 py-1 text-xs font-medium rounded-sm transition-colors ${
                    activeRange === range 
                      ? 'bg-white shadow-sm text-text' 
                      : 'text-text-muted hover:text-text'
                  }`}
                >
                  {range}
                </button>
              ))}
            </div>
          )}
          
          <Button variant="ghost" size="icon" className="h-8 w-8 text-text-muted">
            <MoreHorizontal className="h-4 w-4" />
          </Button>
        </div>
      </div>
      
      <div className="p-5 flex-1 relative">
        {isLoading ? (
          <div className="absolute inset-0 flex items-center justify-center bg-surface/50 z-10 p-5">
            <Skeleton className="w-full h-full rounded-lg" />
          </div>
        ) : error ? (
          <div className="flex-1 flex items-center justify-center h-full min-h-[200px]">
            <ErrorState title="Failed to load chart" description={error.message} onRetry={onRetry} />
          </div>
        ) : !hasData ? (
          <div className="flex-1 flex items-center justify-center h-full min-h-[200px]">
            <EmptyState title="No data available" description="There is no data to display for the selected period." />
          </div>
        ) : (
          <div style={{ height: typeof height === 'number' ? `${height}px` : height }} className="w-full">
            <ResponsiveContainer width="100%" height="100%">
              {renderChart()}
            </ResponsiveContainer>
          </div>
        )}
      </div>
    </div>
  );
}
