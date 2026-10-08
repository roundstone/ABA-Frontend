'use client';

import { useState } from 'react';
import { useAdjustRewardPoints } from '../mutations';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';
import { usePermission } from '@/lib/auth/permissions';

export function AdjustPointsModal({ userId }: { userId: string }) {
  const [open, setOpen] = useState(false);
  const [points, setPoints] = useState('');
  const [reason, setReason] = useState('');
  const { mutate: adjustPoints, isPending } = useAdjustRewardPoints();
  const hasPermission = usePermission;

  if (!hasPermission('points.adjust')) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (reason.length < 10) {
      toast('Reason must be at least 10 characters');
      return;
    }
    
    adjustPoints({ userId, points: Number(points), reason }, {
      onSuccess: () => {
        toast('Points adjusted successfully');
        setOpen(false);
        setPoints('');
        setReason('');
      },
      onError: (err) => {
        toast(`Failed to adjust points: ${err.message}`);
      }
    });
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button variant="outline" />}>
        Adjust Points
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Adjust Reward Points</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <label className="text-sm font-medium">Points (positive or negative)</label>
            <Input 
              type="number" 
              value={points} 
              onChange={(e) => setPoints(e.target.value)} 
              required 
            />
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Reason (min 10 chars)</label>
            <Input 
              type="text" 
              value={reason} 
              onChange={(e) => setReason(e.target.value)} 
              required 
              minLength={10}
            />
          </div>
          <div className="flex justify-end gap-2">
            <Button type="button" variant="ghost" onClick={() => setOpen(false)}>Cancel</Button>
            <Button type="submit" disabled={isPending}>Submit</Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}
