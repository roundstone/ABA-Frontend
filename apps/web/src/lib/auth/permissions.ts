
import React from 'react';

export const PERMISSIONS = {
  VIEW_DASHBOARD: 'view_dashboard',
  MANAGE_USERS: 'manage_users',
};

export const ROLES = {
  ADMIN: [PERMISSIONS.VIEW_DASHBOARD, PERMISSIONS.MANAGE_USERS],
  USER: [PERMISSIONS.VIEW_DASHBOARD],
};

export function usePermission(permission: string) {
  // stub
  return true;
}

export function Can({ I, children }: { I: string, children: React.ReactNode }) {
  const allowed = usePermission(I);
  return allowed ? <>{children}</> : null;
}

export function RequirePermission({ I, children }: { I: string, children: React.ReactNode }) {
  const allowed = usePermission(I);
  if (!allowed) return <div>No Permission</div>;
  return <>{children}</>;
}
