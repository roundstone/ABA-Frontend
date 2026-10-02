import React from 'react';
import { Lock } from 'lucide-react';
import Link from 'next/link';
import { Button } from '@/components/ui/button';

export interface NoPermissionProps {
  module?: string;
  backHref?: string;
}

export function NoPermission({ 
  module = 'this page',
  backHref = '/erp/dashboard'
}: NoPermissionProps) {
  return (
    <div className="flex flex-col items-center justify-center py-16 px-4 text-center">
      <div className="w-12 h-12 mb-4 text-warning-dark flex items-center justify-center">
        <Lock className="w-full h-full" />
      </div>
      <h3 className="text-lg font-semibold text-text mb-2">
        You don't have access to {module}
      </h3>
      <p className="text-sm text-text-muted max-w-sm mb-6">
        Contact your administrator if you believe you should have access to this feature.
      </p>
      
      <div className="flex flex-wrap justify-center gap-3">
        <Link href={backHref}>
          <Button>Back to Dashboard</Button>
        </Link>
      </div>
    </div>
  );
}
