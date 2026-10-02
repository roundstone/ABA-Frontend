import React from 'react';
import Link from 'next/link';
import { TrendingUp, TrendingDown } from 'lucide-react';

export interface KpiCardProps {
  title: string;
  value: string | number | React.ReactNode;
  trend?: string;
  trendDirection?: 'up' | 'down';
  trendType?: 'good' | 'bad' | 'neutral'; // 'good' means up is green, 'bad' means up is red. Default 'good'.
  supportingText?: string;
  href?: string;
  icon?: React.ElementType;
  className?: string;
}

export function KpiCard({
  title,
  value,
  trend,
  trendDirection = 'up',
  trendType = 'good',
  supportingText,
  href,
  icon: Icon,
  className,
}: KpiCardProps) {
  
  const isPositiveTrend = trendDirection === 'up';
  
  // Determine trend color based on type
  let trendColor = 'text-text-muted bg-surface-2'; // neutral
  let TrendIcon = isPositiveTrend ? TrendingUp : TrendingDown;
  
  if (trend) {
    if (trendType === 'good') {
      trendColor = isPositiveTrend ? 'text-success-dark bg-success-bg' : 'text-error bg-error/10';
    } else if (trendType === 'bad') {
      trendColor = isPositiveTrend ? 'text-error bg-error/10' : 'text-success-dark bg-success-bg';
    }
  }

  const CardContent = (
    <div className={`${className} bg-white border border-border rounded-xl p-5 shadow-sm hover:shadow-md transition-shadow group h-full flex flex-col`}>
      <div className="flex items-start justify-between mb-2">
        <span className="text-[13px] font-medium text-text-muted">{title}</span>
        {Icon && (
          <div className="w-8 h-8 rounded-full bg-brand-50 flex items-center justify-center shrink-0 group-hover:bg-brand-100 transition-colors">
            <Icon className="w-4 h-4 text-brand-600" />
          </div>
        )}
      </div>
      
      <div className="flex items-baseline gap-2 mb-2">
        <h2 className="text-[28px] font-bold text-text leading-tight">{value}</h2>
      </div>

      {(trend || supportingText) && (
        <div className="flex items-center gap-2 mt-auto pt-2">
          {trend && (
            <span className={`inline-flex items-center gap-1 px-1.5 py-0.5 rounded text-xs font-semibold ${trendColor}`}>
              <TrendIcon className="w-3 h-3" />
              {trend}
            </span>
          )}
          {supportingText && (
            <span className="text-xs text-text-subtle truncate">{supportingText}</span>
          )}
        </div>
      )}
    </div>
  );

  if (href) {
    return (
      <Link href={href} className="block h-full outline-none focus-visible:ring-2 focus-visible:ring-brand-500 rounded-xl">
        {CardContent}
      </Link>
    );
  }

  return CardContent;
}
