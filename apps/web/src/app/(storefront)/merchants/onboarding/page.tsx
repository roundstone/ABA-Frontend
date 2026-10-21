'use client';

import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { ArrowLeft, ArrowRight, Loader2, Store } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { merchantOnboardingSchema, MerchantOnboardingData, ONBOARDING_STEPS } from './types';
import { OnboardingStepBusiness } from './components/OnboardingStepBusiness';
import { OnboardingStepIdentity } from './components/OnboardingStepIdentity';
import { OnboardingStepLocation } from './components/OnboardingStepLocation';
import { OnboardingStepProducts } from './components/OnboardingStepProducts';
import { OnboardingStepCertifications } from './components/OnboardingStepCertifications';
import { OnboardingSuccess } from './components/OnboardingSuccess';

export default function MerchantOnboardingPage() {
  const [currentStep, setCurrentStep] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);

  const [cacUploaded, setCacUploaded] = useState(true);
  const [idUploaded, setIdUploaded] = useState(true);
  const [certUploaded, setCertUploaded] = useState(false);
  const [photosCount, setPhotosCount] = useState(3);

  const form = useForm<MerchantOnboardingData>({
    resolver: zodResolver(merchantOnboardingSchema),
    mode: 'onTouched',
    defaultValues: {
      businessName: 'Aba Leathercraft Hub',
      businessType: 'Footwear & Leather',
      isProvisional: false,
      rcNumber: 'RC-998822',
      ownerName: 'Emeka Nwosu',
      phone: '+2348031234567',
      email: 'emeka@abaleather.com',
      idType: 'National Identity Number (NIN)',
      ninNumber: '12345678901',
      address: '14 Faulks Road, Block C Suite 4',
      marketCluster: 'Ariaria International Market',
      city: 'Aba',
      state: 'Abia',
      bankName: 'First Bank of Nigeria',
      accountNumber: '0123456789',
      productDescription: 'Handcrafted genuine leather footwear, sandals, and belts',
      capacity: '450 pairs / month',
      samplePhotosCount: 3,
      certificationType: 'None / Artisanal Guild',
      confirmSupplyCapacity: true,
      agreeToFulfillmentSla: true,
    },
  });

  const onSubmit = async () => {
    setIsSubmitting(true);
    await new Promise((resolve) => setTimeout(resolve, 1200));
    setIsSubmitting(false);
    setIsSuccess(true);
  };

  const handleNext = async () => {
    let fields: (keyof MerchantOnboardingData)[] = [];
    if (currentStep === 0) fields = ['businessName', 'businessType'];
    if (currentStep === 1) fields = ['ownerName', 'phone', 'email', 'idType', 'ninNumber'];
    if (currentStep === 2) fields = ['address', 'marketCluster', 'city', 'state', 'bankName', 'accountNumber'];
    if (currentStep === 3) fields = ['productDescription', 'capacity', 'samplePhotosCount'];
    if (currentStep === 4) fields = ['certificationType', 'confirmSupplyCapacity', 'agreeToFulfillmentSla'];

    const valid = await form.trigger(fields);
    if (valid) {
      if (currentStep < ONBOARDING_STEPS.length - 1) {
        setCurrentStep((s) => s + 1);
      } else {
        form.handleSubmit(onSubmit)();
      }
    }
  };

  const handleBack = () => {
    if (currentStep > 0) setCurrentStep((s) => s - 1);
  };

  const handleAddPhoto = () => {
    const nextCount = Math.min(4, photosCount + 1);
    setPhotosCount(nextCount);
    form.setValue('samplePhotosCount', nextCount);
  };

  if (isSuccess) {
    return <OnboardingSuccess isProvisional={form.getValues('isProvisional')} />;
  }

  const activeStepMeta = ONBOARDING_STEPS[currentStep];

  return (
    <div className="min-h-screen bg-surface-1 py-12 mt-20">
      <div className="max-w-2xl mx-auto px-4 sm:px-6">
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-12 h-12 rounded-2xl bg-brand-50 text-brand-700 mb-3">
            <Store className="w-6 h-6" />
          </div>
          <h1 className="text-3xl font-extrabold text-text tracking-tight">Merchant Verification</h1>
          <p className="text-xs text-text-muted mt-1 max-w-md mx-auto">
            Complete the 5-step verification process to become an approved seller on BuyNaija.
          </p>
        </div>

        {/* Linear Progress Indicator */}
        <div className="mb-6 space-y-2">
          <div className="flex justify-between items-center text-xs">
            <span className="font-bold text-brand-700">Step {currentStep + 1} of 5</span>
            <span className="text-text-muted font-medium">{activeStepMeta.title}</span>
          </div>
          <div className="w-full h-2 rounded-full bg-border overflow-hidden">
            <div
              className="h-full bg-brand-600 transition-all duration-300 rounded-full"
              style={{ width: `${((currentStep + 1) / ONBOARDING_STEPS.length) * 100}%` }}
            />
          </div>
        </div>

        {/* Wizard Card */}
        <div className="bg-white rounded-2xl border border-border p-6 sm:p-8 shadow-sm">
          <div className="mb-6 pb-4 border-b border-border">
            <h2 className="text-xl font-bold text-text">{activeStepMeta.title}</h2>
            <p className="text-xs text-text-muted mt-0.5">{activeStepMeta.description}</p>
          </div>

          <form onSubmit={(e) => e.preventDefault()}>
            {currentStep === 0 && (
              <OnboardingStepBusiness
                form={form}
                cacUploaded={cacUploaded}
                onUploadCac={() => setCacUploaded(true)}
              />
            )}
            {currentStep === 1 && (
              <OnboardingStepIdentity
                form={form}
                idUploaded={idUploaded}
                onUploadId={() => setIdUploaded(true)}
              />
            )}
            {currentStep === 2 && (
              <OnboardingStepLocation form={form} />
            )}
            {currentStep === 3 && (
              <OnboardingStepProducts
                form={form}
                photosCount={photosCount}
                onAddPhoto={handleAddPhoto}
              />
            )}
            {currentStep === 4 && (
              <OnboardingStepCertifications
                form={form}
                certUploaded={certUploaded}
                onUploadCert={() => setCertUploaded(true)}
              />
            )}

            <div className="flex items-center justify-between mt-8 pt-6 border-t border-border">
              {currentStep > 0 ? (
                <Button
                  type="button"
                  variant="outline"
                  onClick={handleBack}
                  disabled={isSubmitting}
                  className="rounded-xl px-5"
                >
                  <ArrowLeft className="w-4 h-4 mr-1.5" /> Back
                </Button>
              ) : (
                <div />
              )}

              <Button
                type="button"
                onClick={handleNext}
                disabled={isSubmitting}
                className="font-bold rounded-xl px-7"
              >
                {isSubmitting ? (
                  <>
                    <Loader2 className="w-4 h-4 mr-2 animate-spin" /> Submitting...
                  </>
                ) : currentStep === ONBOARDING_STEPS.length - 1 ? (
                  'Submit for Verification'
                ) : (
                  <>
                    Continue <ArrowRight className="w-4 h-4 ml-1.5" />
                  </>
                )}
              </Button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
