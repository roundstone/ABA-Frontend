import React from 'react';
import { LucideIcon } from 'lucide-react';

export interface MetricCardProps {
  title: string;
  value: string | number;
  Icon: LucideIcon;
  colorClass: 'warning' | 'secondary' | 'primary' | 'danger' | 'success' | 'info';
  prefix?: string;
  suffix?: string;
  subtitle?: string;
}

export default function MetricCard({
  title,
  value,
  Icon,
  colorClass,
  prefix = '',
  suffix = '',
  subtitle = '',
}: MetricCardProps) {
  return (
    <div className="col-xxl-3 col-md-6 xl-50">
      <div className="card o-hidden widget-cards">
        <div className={`bg-${colorClass} card-body`}  style={{ padding: '20px' }}>
          <div className="media static-top-widget row">
            <div className="icons-widgets col-2">
              <div className="align-self-center text-center">
                <Icon className={`font-${colorClass} feather`} />
              </div>
            </div>
            <div className="media-body col-10">
              <span className="m-0">{title}</span>
              <h3 className="mb-0">
                {prefix && `${prefix} `}<span className="counter">{value}</span>{suffix}{subtitle && <small> {subtitle}</small>}
              </h3>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
