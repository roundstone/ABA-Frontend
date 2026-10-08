"use client";

import React, { useState } from 'react';
import { Review } from '../types';
import { useVoteReviewHelpful, useReportReview } from '../mutations';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Star, ThumbsUp, Flag, CheckCircle } from 'lucide-react';
import { format } from 'date-fns';

interface ReviewCardProps {
  review: Review;
}

export function ReviewCard({ review }: ReviewCardProps) {
  const [reportReason, setReportReason] = useState('');
  const [reportDialogOpen, setReportDialogOpen] = useState(false);
  const voteHelpful = useVoteReviewHelpful();
  const report = useReportReview();

  const handleVote = () => {
    voteHelpful.mutate(review.id);
  };

  const handleReport = () => {
    if (reportReason.length < 10) return;
    report.mutate(
      { reviewId: review.id, data: { reason: reportReason } },
      {
        onSuccess: () => {
          setReportDialogOpen(false);
          setReportReason('');
        },
      }
    );
  };

  return (
    <div className="border rounded-lg p-4 space-y-4 bg-white">
      <div className="flex items-start justify-between">
        <div className="flex items-center gap-3">
          <Avatar>
            <AvatarImage src={review.authorAvatar} />
            <AvatarFallback>{review.authorAlias?.charAt(0).toUpperCase() || 'U'}</AvatarFallback>
          </Avatar>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-medium text-sm">{review.authorAlias}</span>
              {review.verifiedPurchase && (
                <span className="flex items-center text-xs text-green-600 gap-1">
                  <CheckCircle className="w-3 h-3" />
                  Verified Purchase
                </span>
              )}
            </div>
            <div className="flex items-center gap-1 mt-1">
              {Array.from({ length: 5 }).map((_, i) => (
                <Star
                  key={i}
                  className={`w-4 h-4 ${i < review.rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`}
                />
              ))}
              <span className="text-xs text-muted-foreground ml-2">
                {format(new Date(review.createdAt), 'MMM d, yyyy')}
              </span>
            </div>
          </div>
        </div>
      </div>

      <div className="space-y-2">
        {review.title && <h4 className="font-semibold text-sm">{review.title}</h4>}
        <p className="text-sm text-gray-700 whitespace-pre-wrap">{review.body}</p>
        
        {review.variantBought && (
          <p className="text-xs text-muted-foreground">Bought: {review.variantBought}</p>
        )}
      </div>

      {review.photos && review.photos.length > 0 && (
        <div className="flex gap-2 mt-3">
          {review.photos.map((photo, i) => (
            <div key={i} className="relative w-16 h-16 rounded overflow-hidden border">
              <img src={photo} alt="Review attachment" className="object-cover w-full h-full" />
            </div>
          ))}
        </div>
      )}

      {review.merchantReply && (
        <div className="mt-4 p-3 bg-gray-50 rounded-md border-l-2 border-primary ml-4">
          <p className="text-xs font-semibold mb-1">Merchant Reply</p>
          <p className="text-sm text-gray-600">{review.merchantReply.body}</p>
          <p className="text-xs text-muted-foreground mt-2">
            {format(new Date(review.merchantReply.createdAt), 'MMM d, yyyy')}
          </p>
        </div>
      )}

      <div className="flex items-center gap-4 pt-2">
        <Button variant="ghost" size="sm" onClick={handleVote} className="h-8 px-2 text-xs text-muted-foreground hover:text-primary">
          <ThumbsUp className="w-3 h-3 mr-1" />
          Helpful ({review.helpfulVotes})
        </Button>
        
        <Dialog open={reportDialogOpen} onOpenChange={setReportDialogOpen}>
          <DialogTrigger render={
            <Button variant="ghost" size="sm" className="h-8 px-2 text-xs text-muted-foreground hover:text-destructive">
              <Flag className="w-3 h-3 mr-1" />
              Report
            </Button>
          } />
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Report Review</DialogTitle>
            </DialogHeader>
            <div className="space-y-4 pt-4">
              <p className="text-sm text-muted-foreground">Please tell us why you are reporting this review.</p>
              <textarea
                className="w-full min-h-[100px] p-3 text-sm border rounded-md"
                placeholder="Reason for reporting (min 10 characters)..."
                value={reportReason}
                onChange={e => setReportReason(e.target.value)}
              />
              <div className="flex justify-end gap-2">
                <Button variant="outline" onClick={() => setReportDialogOpen(false)}>Cancel</Button>
                <Button onClick={handleReport} disabled={reportReason.length < 10 || report.isPending}>
                  Submit Report
                </Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>
    </div>
  );
}
