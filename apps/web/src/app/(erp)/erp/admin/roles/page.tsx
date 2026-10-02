'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { getRoles } from '@/features/users/api/roles.api';
import { Role } from '@/features/users/types';
import { toast } from 'sonner';

export default function RolesListPage() {
  const [roles, setRoles] = useState<Role[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    getRoles()
      .then(setRoles)
      .catch(() => toast.error('Failed to load roles'))
      .finally(() => setIsLoading(false));
  }, []);

  const columns = [
    { 
      accessorKey: 'name', 
      header: 'Role Name',
      cell: (info: any) => (
        <div>
          <div className="font-medium">{info.getValue()}</div>
          <div className="text-text-muted text-xs">{info.row.original.description}</div>
        </div>
      )
    },
    { 
      accessorKey: 'isSystem', 
      header: 'Type',
      cell: (info: any) => (
        info.getValue() ? 
        <span className="px-2 py-0.5 rounded text-xs bg-surface-2 border border-border">System</span> : 
        <span className="px-2 py-0.5 rounded text-xs bg-primary/10 text-primary border border-primary/20">Custom</span>
      )
    },
    { 
      accessorKey: 'usersCount', 
      header: 'Assigned Users',
      cell: (info: any) => (
        <span className="font-medium">{info.getValue()}</span>
      )
    },
    { 
      accessorKey: 'updatedAt', 
      header: 'Last Updated',
      cell: (info: any) => new Date(info.getValue()).toLocaleDateString()
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        const role = info.row.original as Role;
        return (
          <Link href={`/admin/roles/${role.id}`}>
            <Button variant="ghost" size="sm">Manage Permissions</Button>
          </Link>
        );
      }
    }
  ];

  return (
    <div className="space-y-6">
      <PageHeader 
        title="Roles & Permissions" 
        description="Define roles and their access levels across the system."
        action={
          <Button>Create Custom Role</Button>
        }
      />

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable 
          data={roles} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No roles found."
        />
      </div>
    </div>
  );
}
