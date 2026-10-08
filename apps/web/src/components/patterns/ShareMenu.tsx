'use client';

import React, { useState } from 'react';
import { Share2, Link as LinkIcon, MessageCircle, Globe } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import { toast } from 'sonner';

interface ShareMenuProps {
  title: string;
  text: string;
  url: string;
  children?: React.ReactNode;
}

export function ShareMenu({ title, text, url, children }: ShareMenuProps) {
  const [isOpen, setIsOpen] = useState(false);
  const fullUrl = typeof window !== 'undefined' ? `${window.location.origin}${url}` : url;

  const handleShare = async () => {
    if (navigator.share) {
      try {
        await navigator.share({
          title,
          text,
          url: fullUrl,
        });
      } catch (err) {
        if ((err as Error).name !== 'AbortError') {
          setIsOpen(true);
        }
      }
    } else {
      setIsOpen(true);
    }
  };

  const handleCopyLink = () => {
    navigator.clipboard.writeText(fullUrl);
    toast.success('Link copied');
    setIsOpen(false);
  };

  const shareWhatsApp = () => {
    window.open(`https://wa.me/?text=${encodeURIComponent(`${text} ${fullUrl}`)}`, '_blank');
    setIsOpen(false);
  };

  const shareFacebook = () => {
    window.open(`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(fullUrl)}`, '_blank');
    setIsOpen(false);
  };

  const shareLinkedIn = () => {
    window.open(`https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(fullUrl)}`, '_blank');
    setIsOpen(false);
  };

  return (
    <Popover open={isOpen} onOpenChange={setIsOpen}>
      {children ? (
        <PopoverTrigger render={<div onClick={(e) => { e.preventDefault(); handleShare(); }} />} nativeButton={false}>
          {children}
        </PopoverTrigger>
      ) : (
        <PopoverTrigger render={<Button variant="outline" className="text-white border-white hover:bg-white/10" onClick={(e) => { e.preventDefault(); handleShare(); }} />}>
          <Share2 className="w-4 h-4 mr-2" /> Share
        </PopoverTrigger>
      )}
      <PopoverContent className="w-56 p-2" align="end">
        <div className="flex flex-col space-y-1">
          <Button variant="ghost" className="justify-start text-sm" onClick={shareWhatsApp}>
            <MessageCircle className="w-4 h-4 mr-2 text-green-600" /> WhatsApp
          </Button>
          <Button variant="ghost" className="justify-start text-sm" onClick={shareFacebook}>
            <Globe className="w-4 h-4 mr-2 text-blue-600" /> Facebook
          </Button>
          <Button variant="ghost" className="justify-start text-sm" onClick={shareLinkedIn}>
            <Globe className="w-4 h-4 mr-2 text-blue-700" /> LinkedIn
          </Button>
          <Button variant="ghost" className="justify-start text-sm" onClick={handleCopyLink}>
            <LinkIcon className="w-4 h-4 mr-2" /> Copy link
          </Button>
        </div>
      </PopoverContent>
    </Popover>
  );
}
