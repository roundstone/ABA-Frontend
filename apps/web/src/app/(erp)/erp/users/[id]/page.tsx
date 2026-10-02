'use client';

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { getUserById, updateUserRoles, suspendUser, activateUser } from '@/features/users/api/users.api';
import { User } from '@/features/auth/types';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { toast } from 'sonner';

export default function UserDetailsPage() {
  const params = useParams();
  const router = useRouter();
  const id = params.id as string;

  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    getUserById(id)
      .then(setUser)
      .catch(() => {
        toast.error('User not found');
        router.push('/users');
      })
      .finally(() => setIsLoading(false));
  }, [id, router]);

  const handleToggleStatus = async () => {
    if (!user) return;
    try {
      if (user.status === 'Active') {
        if (!confirm('Are you sure you want to suspend this user?')) return;
        await suspendUser(user.id, 'Manual suspension');
        setUser({ ...user, status: 'Suspended' });
        toast.success('User suspended');
      } else if (user.status === 'Suspended') {
        await activateUser(user.id);
        setUser({ ...user, status: 'Active' });
        toast.success('User activated');
      }
    } catch (err) {
      toast.error('Failed to change user status');
    }
  };

  if (isLoading) {
    return <div className="p-8 text-center text-text-muted">Loading...</div>;
  }

  if (!user) return null;

  return (
    <div className="space-y-6">
      <PageHeader 
        title={user.name} 
        description={user.email}
        action={
          <div className="flex gap-2">
            <Button variant="outline" onClick={handleToggleStatus}>
              {user.status === 'Active' ? 'Suspend User' : 'Activate User'}
            </Button>
            <Button>Edit Roles</Button>
          </div>
        }
      />

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="md:col-span-1 space-y-6">
          {/* Details Card */}
          <div className="bg-surface p-6 rounded-xl border border-border">
            <h3 className="text-h4 mb-4">Details</h3>
            <dl className="space-y-3 text-sm">
              <div>
                <dt className="text-text-muted">Status</dt>
                <dd className="font-medium mt-1">{user.status}</dd>
              </div>
              <div>
                <dt className="text-text-muted">Phone</dt>
                <dd className="font-medium mt-1">{user.phone || 'Not provided'}</dd>
              </div>
              <div>
                <dt className="text-text-muted">Created</dt>
                <dd className="font-medium mt-1">{new Date(user.createdAt).toLocaleDateString()}</dd>
              </div>
              <div>
                <dt className="text-text-muted">2FA Enabled</dt>
                <dd className="font-medium mt-1">{user.twoFactorEnabled ? 'Yes' : 'No'}</dd>
              </div>
            </dl>
          </div>
        </div>

        <div className="md:col-span-2 space-y-6">
          {/* Roles Card */}
          <div className="bg-surface p-6 rounded-xl border border-border">
            <h3 className="text-h4 mb-4">Assigned Roles</h3>
            <div className="flex flex-wrap gap-2">
              {user.roles.map(r => (
                <span key={r} className="px-3 py-1 bg-surface-2 border border-border rounded-full text-sm">
                  {r}
                </span>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
