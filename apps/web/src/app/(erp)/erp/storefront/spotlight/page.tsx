'use client';

import React from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { AdminSpotlightSettings } from '@/features/spotlight/components/AdminSpotlightSettings';
import { RequirePermission } from '@/lib/auth/permissions';

export default function AdminSpotlightPage() {
  return (
    <div className="flex-1 space-y-4 p-8 pt-6">
      <PageHeader
        title="Merchant Spotlight"
        description="Configure featured merchants across the storefront"
      />
      
      <RequirePermission I="settings:write">
        <AdminSpotlightSettings />
      </RequirePermission>
    </div>
  );
}
