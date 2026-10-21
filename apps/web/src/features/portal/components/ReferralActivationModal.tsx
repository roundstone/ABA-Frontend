'use client';

import React, { useState } from 'react';
import { Dialog, DialogContent } from '@/components/ui/dialog';
import { useReferralActivationStore } from '../referralActivationStore';
import { ReferralKycStep } from './ReferralKycStep';
import { ReferralPaymentStep } from './ReferralPaymentStep';
import { ReferralSuccessStep } from './ReferralSuccessStep';
import { toast } from 'sonner';

interface ReferralActivationModalProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function ReferralActivationModal({ open, onOpenChange }: ReferralActivationModalProps) {
  const [step, setStep] = useState<0 | 1 | 2>(0);
  const submitKyc = useReferralActivationStore((s) => s.submitKyc);
  const payActivationFee = useReferralActivationStore((s) => s.payActivationFee);

  const handleKycContinue = (data: {
    idType: string;
    ninNumber: string;
    idDocumentName: string;
    proofOfAddressName: string;
  }) => {
    submitKyc(data);
    toast.success('KYC documents submitted successfully.');
    setStep(1);
  };

  const handlePayFee = async () => {
    await payActivationFee();
    toast.success('₦5,000 paid & credited to shopping wallet!');
    setStep(2);
  };

  const handleClose = () => {
    onOpenChange(false);
    // Reset step after closing
    setTimeout(() => setStep(0), 300);
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[480px] p-6 bg-white rounded-2xl shadow-xl">
        {step === 0 && (
          <ReferralKycStep
            onContinue={handleKycContinue}
            onCancel={handleClose}
          />
        )}
        {step === 1 && (
          <ReferralPaymentStep
            onPay={handlePayFee}
            onBack={() => setStep(0)}
          />
        )}
        {step === 2 && (
          <ReferralSuccessStep onClose={handleClose} />
        )}
      </DialogContent>
    </Dialog>
  );
}
