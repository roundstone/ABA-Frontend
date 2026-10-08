'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Copy, Download, User, Monitor, Clock, MapPin, Activity } from 'lucide-react';
import { useParams } from 'next/navigation';

export default function AuditDetailPage() {
  const params = useParams();
  const id = params.id as string;

  // Mock data for the audit detail
  const mockDetail = {
    id: id || 'EVT-99230',
    timestamp: '2026-09-30 14:22:15',
    user: 'Admin User',
    userId: 'U-001',
    role: 'Super Admin',
    action: 'payouts.approve',
    module: 'Payouts',
    recordId: 'PYT-4029',
    result: 'Success',
    severity: 'High-risk',
    ip: '192.168.1.45',
    location: 'Lagos, Nigeria (Approx)',
    device: 'Chrome 118 on macOS',
    reason: 'Verified manually with bank confirmation',
    changes: [
      { field: 'status', old: 'Pending', new: 'Approved' },
      { field: 'approvedAt', old: 'null', new: '2026-09-30T14:22:15Z' },
      { field: 'approvedBy', old: 'null', new: 'U-001' }
    ]
  };

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-4xl">
      <PageHeader 
        title={`Audit Event: ${mockDetail.id}`} 
        description="Detailed view of a system event and its associated changes."
        backHref="/erp/settings/audit"
        action={
          <div className="flex gap-2">
            <Button variant="outline"><Copy className="w-4 h-4 mr-2" /> Copy Link</Button>
            <Button variant="outline"><Download className="w-4 h-4 mr-2" /> Export JSON</Button>
            <Button variant="primary">Go to Record</Button>
          </div>
        }
      />

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="md:col-span-2 space-y-6">
          <div className="bg-surface rounded-xl border border-border p-6 space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2">Overview</h3>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-text-muted">Action</p>
                <p className="font-mono text-sm text-primary bg-primary/10 inline-block px-2 py-0.5 rounded mt-1">{mockDetail.action}</p>
              </div>
              <div>
                <p className="text-sm text-text-muted">Target Record</p>
                <p className="font-mono text-sm bg-surface-2 border border-border inline-block px-2 py-0.5 rounded mt-1">{mockDetail.recordId}</p>
              </div>
              <div>
                <p className="text-sm text-text-muted">Module</p>
                <Badge variant="outline" className="mt-1">{mockDetail.module}</Badge>
              </div>
              <div>
                <p className="text-sm text-text-muted">Status</p>
                <Badge variant={mockDetail.result === 'Success' ? 'default' : 'destructive'} className="mt-1">{mockDetail.result}</Badge>
              </div>
              <div className="col-span-2">
                <p className="text-sm text-text-muted">Reason / Comment</p>
                <p className="text-sm font-medium mt-1 bg-surface-2 p-3 rounded-lg border border-border">{mockDetail.reason || 'None provided'}</p>
              </div>
            </div>
          </div>

          <div className="bg-surface rounded-xl border border-border p-6 space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2">Data Changes</h3>
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse text-sm">
                <thead>
                  <tr className="border-b border-border text-text-muted">
                    <th className="py-2 px-3 font-medium">Field</th>
                    <th className="py-2 px-3 font-medium">Previous Value</th>
                    <th className="py-2 px-3 font-medium">New Value</th>
                  </tr>
                </thead>
                <tbody>
                  {mockDetail.changes.map((change, idx) => (
                    <tr key={idx} className="border-b border-border last:border-0 hover:bg-surface-2/50 transition-colors">
                      <td className="py-3 px-3 font-mono text-xs">{change.field}</td>
                      <td className="py-3 px-3">
                        <span className="bg-error-light text-error px-2 py-0.5 rounded line-through opacity-80">{change.old}</span>
                      </td>
                      <td className="py-3 px-3">
                        <span className="bg-success-light text-success px-2 py-0.5 rounded">{change.new}</span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div className="space-y-6">
          <div className="bg-surface rounded-xl border border-border p-6 space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2">Context</h3>
            <div className="space-y-4">
              <div className="flex items-start gap-3">
                <User className="w-4 h-4 text-text-muted mt-0.5" />
                <div>
                  <p className="text-sm font-medium">{mockDetail.user}</p>
                  <p className="text-xs text-text-muted">{mockDetail.userId} • {mockDetail.role}</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <Clock className="w-4 h-4 text-text-muted mt-0.5" />
                <div>
                  <p className="text-sm font-medium">{mockDetail.timestamp}</p>
                  <p className="text-xs text-text-muted">UTC Africa/Lagos</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <Monitor className="w-4 h-4 text-text-muted mt-0.5" />
                <div>
                  <p className="text-sm font-medium">{mockDetail.ip}</p>
                  <p className="text-xs text-text-muted">{mockDetail.device}</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <MapPin className="w-4 h-4 text-text-muted mt-0.5" />
                <div>
                  <p className="text-sm font-medium">Location</p>
                  <p className="text-xs text-text-muted">{mockDetail.location}</p>
                </div>
              </div>
            </div>
          </div>

          <div className="bg-surface rounded-xl border border-border p-6 space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2">Related Events</h3>
            <div className="space-y-3">
              <div className="flex gap-2">
                <Activity className="w-4 h-4 text-text-muted shrink-0 mt-0.5" />
                <div>
                  <p className="text-sm font-medium">Payout Request Submitted</p>
                  <p className="text-xs text-text-muted">2 hours prior</p>
                </div>
              </div>
              <div className="flex gap-2">
                <Activity className="w-4 h-4 text-success shrink-0 mt-0.5" />
                <div>
                  <p className="text-sm font-medium">Current Event</p>
                  <p className="text-xs text-text-muted">Payouts.approve</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
