'use client';

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { getRoleById, getPermissionsList, updateRolePermissions } from '@/features/users/api/roles.api';
import { Role, Permission } from '@/features/users/types';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { toast } from 'sonner';

export default function RoleDetailsPage() {
  const params = useParams();
  const router = useRouter();
  const id = params.id as string;

  const [role, setRole] = useState<Role | null>(null);
  const [allPermissions, setAllPermissions] = useState<Permission[]>([]);
  const [selectedPermissions, setSelectedPermissions] = useState<Set<string>>(new Set());
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    Promise.all([getRoleById(id), getPermissionsList()])
      .then(([roleData, permsData]) => {
        setRole(roleData);
        setAllPermissions(permsData);
        setSelectedPermissions(new Set(roleData.permissions));
      })
      .catch(() => {
        toast.error('Failed to load role details');
        router.push('/admin/roles');
      })
      .finally(() => setIsLoading(false));
  }, [id, router]);

  const togglePermission = (key: string) => {
    if (role?.isSystem) return;
    const next = new Set(selectedPermissions);
    if (next.has(key)) {
      next.delete(key);
    } else {
      next.add(key);
    }
    setSelectedPermissions(next);
  };

  const handleSave = async () => {
    setIsSaving(true);
    try {
      await updateRolePermissions(id, Array.from(selectedPermissions));
      toast.success('Role permissions updated');
    } catch (err: any) {
      toast.error(err.message || 'Failed to update permissions');
    } finally {
      setIsSaving(false);
    }
  };

  if (isLoading) {
    return <div className="p-8 text-center text-text-muted">Loading...</div>;
  }

  if (!role) return null;

  // Group permissions by module
  const groupedPermissions = allPermissions.reduce((acc, perm) => {
    if (!acc[perm.module]) acc[perm.module] = [];
    acc[perm.module].push(perm);
    return acc;
  }, {} as Record<string, Permission[]>);

  const isDirty = Array.from(selectedPermissions).sort().join(',') !== [...role.permissions].sort().join(',');

  return (
    <div className="space-y-6">
      <PageHeader 
        title={role.name} 
        description={role.description}
        action={
          <div className="flex gap-2">
            {!role.isSystem && (
              <Button onClick={handleSave} disabled={!isDirty || isSaving}>
                {isSaving ? 'Saving...' : 'Save Changes'}
              </Button>
            )}
          </div>
        }
      />

      {role.isSystem && (
        <div className="bg-info-bg border border-info-border text-info px-4 py-3 rounded-lg text-sm">
          This is a system role. Its permissions cannot be modified. You can clone this role to create a custom one.
        </div>
      )}

      <div className="space-y-6 max-w-4xl">
        {Object.entries(groupedPermissions).map(([module, perms]) => (
          <div key={module} className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="bg-surface-2 px-6 py-4 border-b border-border">
              <h3 className="font-medium">{module}</h3>
            </div>
            <div className="p-2">
              {perms.map((perm) => (
                <label 
                  key={perm.id} 
                  className={`flex items-start gap-3 p-4 rounded-lg transition-colors ${role.isSystem ? 'opacity-70 cursor-not-allowed' : 'hover:bg-surface-2 cursor-pointer'}`}
                >
                  <div className="pt-0.5">
                    <Checkbox 
                      checked={selectedPermissions.has(perm.key)}
                      onCheckedChange={() => togglePermission(perm.key)}
                      disabled={role.isSystem}
                    />
                  </div>
                  <div>
                    <div className="font-medium text-sm">{perm.name}</div>
                    <div className="text-text-muted text-xs mt-0.5">{perm.description}</div>
                  </div>
                </label>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
