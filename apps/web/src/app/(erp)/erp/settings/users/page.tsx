'use client';

import React, { useState } from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { DataTable } from '@/components/patterns/DataTable';
// import { StatusBadge } from '@/components/patterns/StatusBadge';
import { Search, UserPlus, MoreHorizontal, ShieldAlert, ShieldCheck } from 'lucide-react';
import { Input } from '@/components/ui/input';
import { 
  DropdownMenu, 
  DropdownMenuContent, 
  DropdownMenuItem, 
  DropdownMenuSeparator, 
  DropdownMenuTrigger 
} from '@/components/ui/dropdown-menu';

// Mock Data for Users
const MOCK_USERS = [
  {
    id: 'USR-001',
    name: 'Admin User',
    email: 'admin@aba-erp.com',
    roles: ['Super Admin'],
    merchantScope: 'All Merchants',
    status: 'active',
    twoFactorEnabled: true,
    lastActive: '2 mins ago',
    created: '2023-01-15',
    avatar: 'A'
  },
  {
    id: 'USR-002',
    name: 'John Sales',
    email: 'john@aba-erp.com',
    roles: ['Sales Mgr'],
    merchantScope: 'All Merchants',
    status: 'active',
    twoFactorEnabled: false,
    lastActive: '1 hr ago',
    created: '2023-02-10',
    avatar: 'J'
  },
  {
    id: 'USR-003',
    name: 'Jane Merchant',
    email: 'jane@merchant1.com',
    roles: ['Merchant Owner'],
    merchantScope: 'Merchant 1 HQ',
    status: 'invited',
    twoFactorEnabled: false,
    lastActive: 'Never',
    created: '2023-08-22',
    avatar: 'JM'
  },
  {
    id: 'USR-004',
    name: 'Bob Suspended',
    email: 'bob@aba-erp.com',
    roles: ['Cashier'],
    merchantScope: 'Merchant 1 HQ',
    status: 'suspended',
    twoFactorEnabled: true,
    lastActive: '30 days ago',
    created: '2023-05-05',
    avatar: 'B'
  }
];

export default function UsersListPage() {
  const [search, setSearch] = useState('');

  const columns = [
    {
      header: 'User',
      accessorKey: 'name',
      cell: ({ row }: any) => (
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-full bg-brand-100 text-brand-700 flex items-center justify-center font-bold text-xs">
            {row.original.avatar}
          </div>
          <div>
            <div className="font-medium text-text">{row.original.name}</div>
            <div className="text-xs text-text-muted">{row.original.email}</div>
          </div>
        </div>
      )
    },
    {
      header: 'Role(s)',
      accessorKey: 'roles',
      cell: ({ row }: any) => (
        <div className="flex gap-1 flex-wrap">
          {row.original.roles?.map((r: string) => (
            <span key={r} className="px-2 py-0.5 rounded-full bg-surface-2 text-xs font-medium border border-border">
              {r}
            </span>
          ))}
        </div>
      )
    },
    {
      header: 'Merchant/Scope',
      accessorKey: 'merchantScope',
      cell: ({ row }: any) => <span className="text-sm">{row.original.merchantScope}</span>
    },
    {
      header: 'Status',
      accessorKey: 'status',
      cell: ({ row }: any) => {
        const toneMap: any = { active: 'success', invited: 'info', suspended: 'error' };
        return <span>{row.original.status}</span>;
        // return <StatusBadge status={row.original.status} tone={toneMap[row.original.status] || 'neutral'} />;
      }
    },
    {
      header: '2FA',
      accessorKey: 'twoFactorEnabled',
      cell: ({ row }: any) => (
        <div className="text-text-muted flex justify-center">
          {row.original.twoFactorEnabled ? <ShieldCheck className="w-4 h-4 text-green-500" /> : <ShieldAlert className="w-4 h-4 text-yellow-500 opacity-50" />}
        </div>
      )
    },
    {
      header: 'Last Active',
      accessorKey: 'lastActive',
      cell: ({ row }: any) => <span className="text-sm text-text-muted">{row.original.lastActive}</span>
    },
    {
      header: 'Actions',
      accessorKey: 'id',
      cell: ({ row }: any) => (
        <DropdownMenu>
          <DropdownMenuTrigger className="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring hover:bg-surface-2 h-8 w-8 p-0">
            <MoreHorizontal className="h-4 w-4" />
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-40">
            <DropdownMenuItem>Edit User</DropdownMenuItem>
            <DropdownMenuItem>Change Role</DropdownMenuItem>
            <DropdownMenuItem>Reset Password</DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem className="text-red-500">
              {row.original.status === 'suspended' ? 'Activate' : 'Suspend'}
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      )
    }
  ];

  return (
    <div className="space-y-6 pb-20 max-w-7xl mx-auto">
      <PageHeader 
        title="Users" 
        description="Manage who can access ABA Online and what they can do."
        action={
          <Button className="gap-2">
            <UserPlus className="w-4 h-4" />
            Invite User
          </Button>
        }
      />

      <div className="bg-surface rounded-xl border border-border p-4 flex gap-4 items-center">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
          <Input 
            placeholder="Search by name, email, or phone..." 
            className="h-10 pl-9 w-full"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <select className="h-10 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
          <option>All Roles</option>
          <option>Super Admin</option>
          <option>Admin</option>
          <option>Merchant Owner</option>
        </select>
        <select className="h-10 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
          <option>All Statuses</option>
          <option>Active</option>
          <option>Invited</option>
          <option>Suspended</option>
        </select>
      </div>

      <div className="bg-surface border border-border rounded-xl">
        <DataTable 
          data={MOCK_USERS.filter(u => u.name.toLowerCase().includes(search.toLowerCase()) || u.email.toLowerCase().includes(search.toLowerCase()))} 
          columns={columns}
        />
      </div>
    </div>
  );
}
