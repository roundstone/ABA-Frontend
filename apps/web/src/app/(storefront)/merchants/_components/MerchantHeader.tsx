'use client';

import React from 'react';
import { Store, Star, MapPin, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { MerchantProfile } from '@/features/merchant/types';
import { ShareMenu } from '@/components/patterns/ShareMenu';
import { MessageSellerDialog } from './MessageSellerDialog';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { saveSeller, unsaveSeller } from '@/features/merchant/api';
import { toast } from 'sonner';
// Optionally, if auth is required for saveSeller, check user status.

interface MerchantHeaderProps {
  merchant: MerchantProfile;
}

export function MerchantHeader({ merchant }: MerchantHeaderProps) {
  const queryClient = useQueryClient();

  const { mutate: toggleSave, isPending: isSaving } = useMutation({
    mutationFn: async () => {
      if (merchant.isSaved) {
        return unsaveSeller(merchant.id);
      }
      return saveSeller(merchant.id);
    },
    onSuccess: () => {
      toast.success(merchant.isSaved ? 'Removed from saved sellers' : 'Added to saved sellers');
      queryClient.invalidateQueries({ queryKey: ['merchant', merchant.id] });
      queryClient.invalidateQueries({ queryKey: ['saved_sellers'] });
    },
    onError: () => {
      toast.error('Could not update saved seller status');
    }
  });

  return (
    <div className="bg-brand-700 min-h-[320px] md:min-h-[256px] relative flex flex-col justify-end">
      {merchant.bannerImage ? (
        <img src={merchant.bannerImage} alt="Banner" className="absolute inset-0 w-full h-full object-cover mix-blend-overlay" />
      ) : (
        <div className="absolute inset-0 bg-linear-to-t from-black/60 to-transparent"></div>
      )}
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full pt-16 pb-8 relative z-10 mt-auto">
        <div className="flex flex-col md:flex-row md:items-end gap-4 md:gap-6 w-full">
          <div className="w-24 h-24 md:w-32 md:h-32 bg-white rounded-xl border-4 border-white shadow-lg flex items-center justify-center shrink-0 overflow-hidden">
            {merchant.logoUrl ? (
              <img src={merchant.logoUrl} alt={merchant.name} className="w-full h-full object-cover" />
            ) : (
              <Store className="w-12 h-12 text-brand-300" />
            )}
          </div>
          <div className="flex-1 text-white pb-2">
            <h1 className="text-3xl md:text-4xl font-bold mb-2">{merchant.name}</h1>
            <div className="flex flex-wrap items-center gap-4 text-sm md:text-base text-brand-50">
              <span className="flex items-center gap-1"><MapPin className="w-4 h-4" /> {merchant.location}</span>
              <span className="flex items-center gap-1">
                <Star className="w-4 h-4 text-warning-main fill-warning-main" /> {merchant.rating} ({merchant.reviewCount} Reviews)
              </span>
              {merchant.isVerified && (
                <span className="bg-white/20 px-2 py-0.5 rounded font-medium text-xs uppercase tracking-wide">Verified Merchant</span>
              )}
              <span className="text-sm opacity-90">{merchant.followerCount} Followers</span>
            </div>
          </div>
          <div className="flex flex-wrap gap-3 pb-2 sm:flex">
            <Button 
              onClick={() => toggleSave()}
              disabled={isSaving}
              className="bg-white text-brand-700 hover:bg-brand-50"
            >
              {isSaving && <Loader2 className="w-4 h-4 mr-2 animate-spin" />}
              {merchant.isSaved ? 'Following' : 'Follow Store'}
            </Button>
            <MessageSellerDialog merchantId={merchant.id} merchantName={merchant.name} />
            <ShareMenu 
              title={merchant.name} 
              text={`Check out ${merchant.name} on ABA ERP`}
              url={`/merchants/${merchant.id}`}
            />
          </div>
        </div>
      </div>
    </div>
  );
}
