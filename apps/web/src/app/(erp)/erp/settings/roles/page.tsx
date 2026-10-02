'use client';

import React, { useState } from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { DataTable } from '@/components/patterns/DataTable';
import { Search, Plus, MoreHorizontal, Copy, Pencil, Trash2 } from 'lucide-react';
import { Input } from '@/components/ui/input';
import { 
  DropdownMenu, 
  DropdownMenuContent, 
  DropdownMenuItem, 
  DropdownMenuSeparator, 
  DropdownMenuTrigger 
} from '@/components/ui/dropdown-menu';
import Link from 'next/link';

const MOCK_ROLES = [
  {
    id: 'ROLE-001',
    name: 'Super Admin',
    description: 'Full system access with no restrictions.',
    usersCount: 2,
    type: 'System',
    updated: '2023-01-10'
  },
  {
    id: 'ROLE-002',
    name: 'Admin',
    description: 'General administration without access to security settings.',
    usersCount: 5,
    type: 'System',
    updated: '2023-02-14'
  },
  {
    id: 'ROLE-003',
    name: 'Sales Mgr',
    description: 'Manage sales, customers, and referrers.',
    usersCount: 12,
    type: 'System',
    updated: '2023-05-20'
  },
  {
    id: 'ROLE-004',
    name: 'Merchant Owner',
    description: 'Full access to own merchant scoped data.',
    usersCount: 45,
    type: 'System',
    updated: '2023-07-01'
  },
  {
    id: 'ROLE-005',
    name: 'Cashier',
    description: 'Point of sale access only.',
    usersCount: 120,
    type: 'System',
    updated: '2023-08-15'
  },
  {
    id: 'ROLE-006',
    name: 'Weekend Support',
    description: 'Limited read-only access for weekend support staff.',
    usersCount: 8,
    type: 'Custom',
    updated: '2023-11-05'
  }
];

export default function RolesListPage() {
  const [search, setSearch] = useState('');

  const columns = [
    {
      header: 'Role Name',
      accessorKey: 'name',
      cell: ({ row }: any) => (
        <div className="font-medium text-text">
          {row.original.name}
        </div>
      )
    },
    {
      header: 'Description',
      accessorKey: 'description',
      cell: ({ row }: any) => (
        <div className="text-sm text-text-muted truncate max-w-[300px]">
          {row.original.description}
        </div>
      )
    },
    {
      header: 'Users',
      accessorKey: 'usersCount',
      cell: ({ row }: any) => (
        <div className="text-sm font-medium">
          {row.original.usersCount} <span className="text-text-muted font-normal">users</span>
        </div>
      )
    },
    {
      header: 'Type',
      accessorKey: 'type',
      cell: ({ row }: any) => (
        <span className={`px-2 py-0.5 rounded-full text-xs font-medium border ${
          row.original.type === 'System' 
            ? 'bg-blue-50 text-blue-700 border-blue-200' 
            : 'bg-surface-2 text-text-muted border-border'
        }`}>
          {row.original.type}
        </span>
      )
    },
    {
      header: 'Last Updated',
      accessorKey: 'updated',
      cell: ({ row }: any) => <span className="text-sm text-text-muted">{row.original.updated}</span>
    },
    {
      header: 'Actions',
      accessorKey: 'id',
      cell: ({ row }: any) => {
        const isSystem = row.original.type === 'System';
        return (
          <DropdownMenu>
            <DropdownMenuTrigger className="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring hover:bg-surface-2 h-8 w-8 p-0">
              <MoreHorizontal className="h-4 w-4" />
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-40">
              <DropdownMenuItem>
                <Link href={`/erp/settings/roles/${row.original.id}`} className="flex items-center gap-2 cursor-pointer">
                  <Pencil className="w-4 h-4" /> Edit Matrix
                </Link>
              </DropdownMenuItem>
              <DropdownMenuItem className="flex items-center gap-2 cursor-pointer">
                <Copy className="w-4 h-4" /> Clone Role
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem 
                disabled={isSystem}
                className={`flex items-center gap-2 ${isSystem ? 'opacity-50' : 'text-red-500 cursor-pointer'}`}
              >
                <Trash2 className="w-4 h-4" /> Delete Role
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        );
      }
    }
  ];

  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Roles & Permissions" 
        description="Define access matrices and approval limits for user groups."
        action={
          <Link href="/erp/settings/roles/new">
            <Button className="gap-2">
              <Plus className="w-4 h-4" />
              Create Custom Role
            </Button>
          </Link>
        }
      />

      <div className="bg-surface rounded-xl border border-border p-4 flex gap-4 items-center">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
          <Input 
            placeholder="Search roles..." 
            className="h-10 pl-9 w-full"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <select className="h-10 rounded-md border border-border bg-surface px-3 text-sm focus:ring-primary focus:border-primary">
          <option>All Types</option>
          <option>System Roles</option>
          <option>Custom Roles</option>
        </select>
      </div>

      <div className="bg-surface border border-border rounded-xl">
        <DataTable 
          data={MOCK_ROLES.filter(r => r.name.toLowerCase().includes(search.toLowerCase()) || r.description.toLowerCase().includes(search.toLowerCase()))} 
          columns={columns}
        />
      </div>
    </div>
  );
}
