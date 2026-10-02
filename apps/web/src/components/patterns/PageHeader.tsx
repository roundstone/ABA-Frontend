import React from 'react';
import Link from 'next/link';
import { ArrowLeft } from 'lucide-react';

export interface PageHeaderProps {
  title: string | React.ReactNode;
  description?: string;
  action?: React.ReactNode;
  backHref?: string;
  badges?: React.ReactNode;
}

export function PageHeader({ title, description, action, backHref, badges }: PageHeaderProps) {
  return (
    <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4 py-6">
      <div className="flex flex-col gap-1">
        {backHref && (
          <Link href={backHref} className="text-sm font-medium text-text-muted hover:text-text flex items-center gap-1 mb-2">
            <ArrowLeft className="w-4 h-4" />
            Back
          </Link>
        )}
        <div className="flex items-center gap-3">
          <h1 className="text-h1 font-semibold text-text">{title}</h1>
          {badges && <div className="flex items-center gap-2 mt-1">{badges}</div>}
        </div>
        {description && (
          <p className="text-sm text-text-muted max-w-2xl mt-1">
            {description}
          </p>
        )}
      </div>
      
      {action && (
        <div className="flex items-center gap-2 shrink-0">
          {action}
        </div>
      )}
    </div>
  );
}
