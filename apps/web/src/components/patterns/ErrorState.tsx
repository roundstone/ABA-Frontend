import React, { useState } from 'react';
import { AlertTriangle, RefreshCw, Copy, Check } from 'lucide-react';
import { Button } from '@/components/ui/button';

export interface ErrorStateProps {
  icon?: React.ReactNode;
  title?: string;
  description?: string;
  onRetry?: () => void;
  requestId?: string;
}

export function ErrorState({
  icon,
  title = 'Something went wrong',
  description = "We couldn't load the requested data.",
  onRetry,
  requestId
}: ErrorStateProps) {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    if (requestId) {
      navigator.clipboard.writeText(requestId);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center py-16 px-4 text-center">
      <div className="w-12 h-12 mb-4 text-error flex items-center justify-center">
        {icon || <AlertTriangle className="w-full h-full" />}
      </div>
      <h3 className="text-lg font-semibold text-text mb-2">{title}</h3>
      <p className="text-sm text-text-muted max-w-sm mb-6">{description}</p>
      
      {requestId && (
        <div className="flex items-center gap-2 mb-6 bg-surface-2 px-3 py-1.5 rounded-md text-xs text-text-muted">
          <span>Request ID: <span className="font-mono">{requestId}</span></span>
          <button 
            onClick={handleCopy} 
            className="p-1 hover:bg-border rounded transition-colors text-text"
            title="Copy Request ID"
          >
            {copied ? <Check className="w-3.5 h-3.5 text-success-main" /> : <Copy className="w-3.5 h-3.5" />}
          </button>
        </div>
      )}

      {onRetry && (
        <Button onClick={onRetry} variant="outline" leftIcon={<RefreshCw className="w-4 h-4" />}>
          Retry
        </Button>
      )}
    </div>
  );
}
