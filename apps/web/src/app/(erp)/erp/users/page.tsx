'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { getUsers, inviteUser } from '@/features/users/api/users.api';
import { User } from '@/features/auth/types';
import { toast } from 'sonner';

export default function UsersListPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  const fetchUsers = async () => {
    setIsLoading(true);
    try {
      const data = await getUsers();
      setUsers(data);
    } catch (err) {
      toast.error('Failed to load users');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const filteredUsers = users.filter(user => 
    user.name.toLowerCase().includes(search.toLowerCase()) || 
    user.email.toLowerCase().includes(search.toLowerCase())
  );

  const columns = [
    { 
      accessorKey: 'name', 
      header: 'User',
      cell: (info: any) => {
        const user = info.row.original as User;
        return (
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-medium text-xs">
              {user.name.substring(0, 2).toUpperCase()}
            </div>
            <div>
              <div className="font-medium">{user.name}</div>
              <div className="text-text-muted text-xs">{user.email}</div>
            </div>
          </div>
        );
      }
    },
    { 
      accessorKey: 'roles', 
      header: 'Roles',
      cell: (info: any) => {
        const roles = info.getValue() as string[];
        return (
          <div className="flex flex-wrap gap-1">
            {roles.map(r => (
              <span key={r} className="px-2 py-0.5 rounded-full bg-surface-2 text-xs border border-border">
                {r}
              </span>
            ))}
          </div>
        );
      }
    },
    { 
      accessorKey: 'status', 
      header: 'Status',
      cell: (info: any) => {
        const status = info.getValue() as string;
        let color = 'bg-surface-2 text-text';
        if (status === 'Active') color = 'bg-success-bg text-success border-success-border';
        if (status === 'Invited') color = 'bg-info-bg text-info border-info-border';
        if (status === 'Suspended') color = 'bg-error-bg text-error border-error-border';
        
        return (
          <span className={`px-2 py-0.5 rounded text-xs font-medium border ${color}`}>
            {status}
          </span>
        );
      }
    },
    { 
      accessorKey: 'lastActive', 
      header: 'Last Active',
      cell: (info: any) => info.getValue() ? new Date(info.getValue()).toLocaleDateString() : 'Never'
    },
    {
      id: 'actions',
      header: '',
      cell: (info: any) => {
        const user = info.row.original as User;
        return (
          <Link href={`/users/${user.id}`}>
            <Button variant="ghost" size="sm">View</Button>
          </Link>
        );
      }
    }
  ];

  return (
    <div className="space-y-6">
      <PageHeader 
        title="Users" 
        description="Manage system users, roles, and access."
        action={
          <Button>Invite User</Button>
        }
      />

      <div className="flex items-center justify-between gap-4">
        <div className="w-full max-w-sm">
          <Input 
            placeholder="Search users..." 
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable 
          data={filteredUsers} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No users found."
        />
      </div>
    </div>
  );
}
