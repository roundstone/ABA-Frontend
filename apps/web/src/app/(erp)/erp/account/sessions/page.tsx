'use client';

import { useState, useEffect } from 'react';
import { getSessions, revokeSession, revokeAllOtherSessions } from '@/features/auth/api/profile.api';
import { Session } from '@/features/auth/types';
import { Button } from '@/components/ui/button';
import { DataTable } from '@/components/patterns/DataTable';
import { toast } from 'sonner';

export default function SessionsPage() {
  const [sessions, setSessions] = useState<Session[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  const fetchSessions = async () => {
    setIsLoading(true);
    try {
      const data = await getSessions();
      setSessions(data);
    } catch (err) {
      toast.error('Failed to load sessions');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchSessions();
  }, []);

  const handleRevoke = async (id: string) => {
    try {
      await revokeSession(id);
      setSessions(sessions.filter(s => s.id !== id));
      toast.success('Session revoked');
    } catch (err) {
      toast.error('Failed to revoke session');
    }
  };

  const handleRevokeAllOther = async () => {
    if (!confirm('Are you sure you want to sign out from all other devices?')) return;
    
    try {
      await revokeAllOtherSessions();
      setSessions(sessions.filter(s => s.isCurrentDevice));
      toast.success('Signed out of all other devices');
    } catch (err) {
      toast.error('Failed to sign out of other devices');
    }
  };

  const columns = [
    { 
      accessorKey: 'device', 
      header: 'Device',
      cell: (info: any) => {
        const session = info.row.original as Session;
        return (
          <div>
            <div className="font-medium flex items-center gap-2">
              {session.device}
              {session.isCurrentDevice && (
                <span className="bg-info-bg text-info text-xs px-2 py-0.5 rounded-full border border-info-border">
                  This device
                </span>
              )}
            </div>
            <div className="text-text-muted text-sm">{session.browser}</div>
          </div>
        );
      }
    },
    { accessorKey: 'ip', header: 'IP Address' },
    { 
      accessorKey: 'lastActive', 
      header: 'Last Active',
      cell: (info: any) => new Date(info.getValue()).toLocaleString()
    },
    {
      id: 'actions',
      header: 'Actions',
      cell: (info: any) => {
        const session = info.row.original as Session;
        if (session.isCurrentDevice) return null;
        return (
          <Button variant="ghost" size="sm" onClick={() => handleRevoke(session.id)} className="text-error hover:text-error hover:bg-error-bg">
            Revoke
          </Button>
        );
      }
    }
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <p className="text-body text-text-muted max-w-2xl">
          These are the devices that are currently logged in to your account. Revoke any sessions that you do not recognize.
        </p>
        <Button variant="outline" onClick={handleRevokeAllOther}>
          Sign out all other devices
        </Button>
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable 
          data={sessions} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No active sessions found"
        />
      </div>
    </div>
  );
}
