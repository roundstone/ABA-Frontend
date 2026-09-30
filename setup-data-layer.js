const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const libDir = path.join(srcDir, 'lib');
const providersDir = path.join(srcDir, 'providers');
const componentsDir = path.join(srcDir, 'components');
const authDir = path.join(libDir, 'auth');

[libDir, providersDir, componentsDir, authDir].forEach(d => {
  if (!fs.existsSync(d)) fs.mkdirSync(d, { recursive: true });
});

// api.ts
fs.writeFileSync(path.join(libDir, 'api.ts'), `
export class ApiError extends Error {
  constructor(public status: number, message: string, public code?: string) {
    super(message);
    this.name = 'ApiError';
  }
}

export const API_MODE = process.env.NEXT_PUBLIC_API_MODE || 'mock';

export async function fetchApi<T>(endpoint: string, options?: RequestInit): Promise<T> {
  // Mock logic placeholder
  if (API_MODE === 'mock') {
    return {} as T;
  }
  const res = await fetch(endpoint, options);
  if (!res.ok) {
    throw new ApiError(res.status, await res.text());
  }
  return res.json();
}
`);

// invalidation.ts
fs.writeFileSync(path.join(libDir, 'invalidation.ts'), `
import { QueryClient } from '@tanstack/react-query';

export const queryKeys = {
  users: ['users'],
  orders: ['orders'],
};

export function invalidateAll(queryClient: QueryClient) {
  queryClient.invalidateQueries();
}
`);

// mockStore.ts
fs.writeFileSync(path.join(libDir, 'mockStore.ts'), `
export const mockStore = {
  db: {
    users: [],
    orders: [],
  },
  delay: 500,
  errorRate: 0,
};
`);

// auth/permissions.ts
fs.writeFileSync(path.join(authDir, 'permissions.ts'), `
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
`);

// Providers
fs.writeFileSync(path.join(providersDir, 'QueryProvider.tsx'), `
'use client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import React, { useState } from 'react';

export function QueryProvider({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient());
  return <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>;
}
`);

fs.writeFileSync(path.join(providersDir, 'AuthProvider.tsx'), `
'use client';
import React from 'react';
export function AuthProvider({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
`);

fs.writeFileSync(path.join(providersDir, 'PermissionProvider.tsx'), `
'use client';
import React from 'react';
export function PermissionProvider({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
`);

// RoleSwitcher
fs.writeFileSync(path.join(componentsDir, 'RoleSwitcher.tsx'), `
import React from 'react';
export function RoleSwitcher() {
  return <div>RoleSwitcher (Dev)</div>;
}
`);

// Middleware
fs.writeFileSync(path.join(srcDir, 'middleware.ts'), `
import { NextResponse } from 'next/server';
export function middleware(request: any) {
  return NextResponse.next();
}
export const config = { matcher: ['/((?!api|_next/static|_next/image|favicon.ico).*)'] };
`);

console.log('Data layer setup completed.');
