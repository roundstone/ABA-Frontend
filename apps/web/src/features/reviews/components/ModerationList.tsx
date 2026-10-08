"use client";

import { useState } from 'react';
import { useApproveReview, useRejectReview } from '../mutations';
import { useModerationReviews as useModReviews } from '../queries';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Tabs, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ReviewStatus, Review } from '../types';
import { format } from 'date-fns';

export function ModerationList() {
  const [activeTab, setActiveTab] = useState<ReviewStatus | 'All'>('Pending');
  const [page, setPage] = useState(1);
  const { data: response, isLoading } = useModReviews({ status: activeTab }, page, 10);
  
  const approve = useApproveReview();
  const reject = useRejectReview();
  
  const [rejectReason, setRejectReason] = useState('');
  const [rejectDialogOpen, setRejectDialogOpen] = useState(false);
  const [selectedReview, setSelectedReview] = useState<Review | null>(null);

  const handleApprove = (reviewId: string) => {
    approve.mutate(reviewId);
  };

  const handleReject = () => {
    if (selectedReview && rejectReason.length >= 10) {
      reject.mutate({ reviewId: selectedReview.id, data: { reason: rejectReason } }, {
        onSuccess: () => {
          setRejectDialogOpen(false);
          setRejectReason('');
          setSelectedReview(null);
        }
      });
    }
  };

  const columns = [
    {
      header: 'Author',
      accessorKey: 'authorAlias',
    },
    {
      header: 'Rating',
      cell: (row: Review) => `${row.rating} Stars`,
    },
    {
      header: 'Review',
      cell: (row: Review) => (
        <div className="max-w-xs truncate" title={row.body}>
          {row.title && <span className="font-semibold block">{row.title}</span>}
          {row.body}
        </div>
      ),
    },
    {
      header: 'Status',
      cell: (row: Review) => {
        let color = 'secondary';
        if (row.status === 'Published') color = 'success';
        if (row.status === 'Rejected') color = 'destructive';
        if (row.status === 'Reported') color = 'warning';
        return <Badge variant={color as any}>{row.status}</Badge>;
      }
    },
    {
      header: 'Date',
      cell: (row: Review) => {
        try {
          return row.createdAt ? format(new Date(row.createdAt), 'MMM d, yyyy') : 'N/A';
        } catch (e) {
          return 'Invalid Date';
        }
      },
    },
    {
      header: 'Actions',
      cell: (row: Review) => (
        <div className="flex gap-2">
          {row.status !== 'Published' && (
            <Button size="sm" variant="outline" onClick={() => handleApprove(row.id)}>
              Approve
            </Button>
          )}
          {row.status !== 'Rejected' && (
            <Button size="sm" variant="destructive" onClick={() => { setSelectedReview(row); setRejectDialogOpen(true); }}>
              Reject
            </Button>
          )}
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6">
      <Tabs value={activeTab} onValueChange={(v) => { setActiveTab(v as any); setPage(1); }}>
        <TabsList>
          <TabsTrigger value="Pending">Pending</TabsTrigger>
          <TabsTrigger value="Published">Published</TabsTrigger>
          <TabsTrigger value="Rejected">Rejected</TabsTrigger>
          <TabsTrigger value="Reported">Reported</TabsTrigger>
        </TabsList>
      </Tabs>

      <DataTable 
        columns={columns}
        data={response?.data.data || []}
        isLoading={isLoading}
      />

      <Dialog open={rejectDialogOpen} onOpenChange={setRejectDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Reject Review</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-4">
            <p className="text-sm text-muted-foreground">Please provide a reason for rejecting this review. Staff cannot edit reviews, only reject them.</p>
            <textarea
              className="w-full min-h-[100px] p-3 text-sm border rounded-md"
              placeholder="Reason for rejection (min 10 characters)..."
              value={rejectReason}
              onChange={e => setRejectReason(e.target.value)}
            />
            <div className="flex justify-end gap-2">
              <Button variant="outline" onClick={() => setRejectDialogOpen(false)}>Cancel</Button>
              <Button variant="destructive" onClick={handleReject} disabled={rejectReason.length < 10 || reject.isPending}>
                Reject
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
