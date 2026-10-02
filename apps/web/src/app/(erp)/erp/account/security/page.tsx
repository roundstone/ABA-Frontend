'use client';

import { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { changePasswordSchema, ChangePasswordInput } from '@/features/auth/schemas';
import { changePassword, getLoginHistory } from '@/features/auth/api/profile.api';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { toast } from 'sonner';
import { DataTable } from '@/components/patterns/DataTable';

export default function SecurityPage() {
  const [isLoading, setIsLoading] = useState(false);
  const [history, setHistory] = useState<any[]>([]);
  const [isHistoryLoading, setIsHistoryLoading] = useState(true);
  const [twoFactorEnabled, setTwoFactorEnabled] = useState(false); // Mock state

  const { register, handleSubmit, formState: { errors }, reset } = useForm<ChangePasswordInput>({
    resolver: zodResolver(changePasswordSchema) as any,
  });

  useEffect(() => {
    getLoginHistory().then((data) => {
      setHistory(data);
      setIsHistoryLoading(false);
    });
  }, []);

  const onPasswordSubmit = async (data: ChangePasswordInput) => {
    setIsLoading(true);
    try {
      await changePassword(data);
      toast.success('Password changed successfully');
      reset();
    } catch (err: any) {
      toast.error(err.message || 'Failed to change password');
    } finally {
      setIsLoading(false);
    }
  };

  const loginHistoryColumns = [
    { accessorKey: 'time', header: 'Time', cell: (info: any) => new Date(info.getValue()).toLocaleString() },
    { accessorKey: 'device', header: 'Device' },
    { accessorKey: 'ip', header: 'IP Address' },
    { accessorKey: 'location', header: 'Location' },
    { 
      accessorKey: 'result', 
      header: 'Result',
      cell: (info: any) => (
        <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${
          info.getValue() === 'Success' ? 'bg-success-bg text-success' : 'bg-error-bg text-error'
        }`}>
          {info.getValue()}
        </span>
      )
    },
  ];

  return (
    <div className="space-y-10">
      {/* Change Password Section */}
      <section>
        <h2 className="text-h2 mb-4">Change Password</h2>
        <div className="max-w-md bg-surface p-6 rounded-xl border border-border">
          <form onSubmit={handleSubmit(onPasswordSubmit)} className="space-y-4">
            <Input
              label="Current password"
              type="password"
              {...register('currentPassword')}
              error={errors.currentPassword?.message}
            />
            <Input
              label="New password"
              type="password"
              {...register('newPassword')}
              error={errors.newPassword?.message}
            />
            <Input
              label="Confirm new password"
              type="password"
              {...register('confirmPassword')}
              error={errors.confirmPassword?.message}
            />
            <div className="pt-2">
              <Button type="submit" disabled={isLoading}>
                {isLoading ? 'Updating...' : 'Update password'}
              </Button>
            </div>
          </form>
        </div>
      </section>

      {/* Two-Factor Authentication Section */}
      <section>
        <h2 className="text-h2 mb-4">Two-Factor Authentication</h2>
        <div className="bg-surface p-6 rounded-xl border border-border flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <h3 className="text-h4">Authenticator App</h3>
            <p className="text-body text-text-muted mt-1">
              Add an extra layer of security to your account by requiring a code from your authenticator app.
            </p>
          </div>
          <Button 
            variant={twoFactorEnabled ? 'outline' : 'primary'}
            onClick={() => setTwoFactorEnabled(!twoFactorEnabled)}
          >
            {twoFactorEnabled ? 'Disable 2FA' : 'Enable 2FA'}
          </Button>
        </div>
      </section>

      {/* Login History Section */}
      <section>
        <h2 className="text-h2 mb-4">Login History</h2>
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <DataTable 
            data={history} 
            columns={loginHistoryColumns} 
            isLoading={isHistoryLoading}
            emptyMessage="No login history found"
          />
        </div>
      </section>
    </div>
  );
}
