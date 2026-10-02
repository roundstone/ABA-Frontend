'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Store, User, MapPin, Building, ArrowRight, CheckCircle2, Loader2, ArrowLeft } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/alert';

// Using Zod as per rules
const onboardingSchema = z.object({
  businessName: z.string().min(2, "Business name is required"),
  businessType: z.string().min(1, "Business type is required"),
  rcNumber: z.string().optional(),
  ownerName: z.string().min(2, "Owner name is required"),
  phone: z.string().min(11, "Valid phone number is required"),
  email: z.string().email("Valid email is required"),
  address: z.string().min(5, "Address is required"),
  city: z.string().min(2, "City is required"),
  state: z.string().min(2, "State is required"),
  bankName: z.string().min(2, "Bank name is required"),
  accountNumber: z.string().length(10, "Account number must be 10 digits"),
});

type OnboardingData = z.infer<typeof onboardingSchema>;

const STEPS = [
  { id: 'business', title: 'Business Info', icon: Store },
  { id: 'contact', title: 'Contact Details', icon: User },
  { id: 'location', title: 'Location', icon: MapPin },
  { id: 'settlement', title: 'Bank & Settlement', icon: Building },
];

export default function MerchantOnboarding() {
  const [currentStep, setCurrentStep] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);

  const { register, handleSubmit, trigger, formState: { errors } } = useForm<OnboardingData>({
    resolver: zodResolver(onboardingSchema),
    mode: 'onTouched',
  });

  const onSubmit = async (data: OnboardingData) => {
    setIsSubmitting(true);
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000));
    console.log('Submitted merchant onboarding', data);
    setIsSubmitting(false);
    setIsSuccess(true);
  };

  const handleNext = async () => {
    let fieldsToValidate: any[] = [];
    if (currentStep === 0) fieldsToValidate = ['businessName', 'businessType'];
    if (currentStep === 1) fieldsToValidate = ['ownerName', 'phone', 'email'];
    if (currentStep === 2) fieldsToValidate = ['address', 'city', 'state'];
    
    const isStepValid = await trigger(fieldsToValidate);
    if (isStepValid) {
      setCurrentStep(prev => prev + 1);
    }
  };

  const handleBack = () => {
    setCurrentStep(prev => prev - 1);
  };

  if (isSuccess) {
    return (
      <div className="max-w-3xl mx-auto px-4 py-24 text-center">
        <div className="w-24 h-24 bg-success-bg rounded-full flex items-center justify-center mx-auto mb-8">
          <CheckCircle2 className="w-12 h-12 text-success-dark" />
        </div>
        <h1 className="text-4xl font-bold text-text mb-4">Application Submitted!</h1>
        <p className="text-lg text-text-muted mb-8">
          Thank you for applying to become an ABA Online Merchant. Our team will review your application and contact you within 24-48 hours.
        </p>
        <Link href="/">
          <Button size="lg" className="rounded-full px-8">Return Home</Button>
        </Link>
      </div>
    );
  }

  const StepIcon = STEPS[currentStep].icon;

  return (
    <div className="min-h-screen bg-surface-1 py-12 animate-in fade-in duration-700">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-3xl font-bold text-brand-900 mb-4">Become a Merchant</h1>
          <p className="text-text-muted max-w-xl mx-auto">
            Join Aba's largest digital marketplace. Reach more customers, manage your digital storefront, and scale your operations.
          </p>
        </div>

        {/* Progress Bar */}
        <div className="mb-12">
          <div className="flex items-center justify-between relative">
            <div className="absolute left-0 top-5 -translate-y-1/2 w-full h-1 bg-border rounded-full z-0"></div>
            <div 
              className="absolute left-0 top-5 -translate-y-1/2 h-1 bg-brand-600 rounded-full z-0 transition-all duration-500"
              style={{ width: `${(currentStep / (STEPS.length - 1)) * 100}%` }}
            ></div>
            
            {STEPS.map((step, index) => {
              const Icon = step.icon;
              const isActive = index === currentStep;
              const isCompleted = index < currentStep;
              
              return (
                <div key={step.id} className="relative z-10 flex flex-col items-center gap-2">
                  <div className={`w-10 h-10 rounded-full flex items-center justify-center border-2 transition-colors duration-300 ${isActive ? 'bg-brand-600 border-brand-600 text-white' : isCompleted ? 'bg-brand-600 border-brand-600 text-white' : 'bg-white border-border text-text-muted'}`}>
                    {isCompleted ? <CheckCircle2 className="w-5 h-5" /> : <Icon className="w-5 h-5" />}
                  </div>
                  <span className={`text-xs font-semibold ${isActive || isCompleted ? 'text-brand-900' : 'text-text-muted'} hidden sm:block`}>
                    {step.title}
                  </span>
                </div>
              );
            })}
          </div>
        </div>

        {/* Form Card */}
        <div className="bg-white rounded-2xl shadow-sm border border-border p-6 sm:p-10">
          <div className="flex items-center gap-3 mb-8 pb-6 border-b border-border">
            <div className="w-12 h-12 bg-surface-2 rounded-xl flex items-center justify-center text-brand-600">
              <StepIcon className="w-6 h-6" />
            </div>
            <div>
              <h2 className="text-2xl font-bold text-text">{STEPS[currentStep].title}</h2>
              <p className="text-sm text-text-muted">Step {currentStep + 1} of {STEPS.length}</p>
            </div>
          </div>

          <form onSubmit={handleSubmit(onSubmit)}>
            
            {/* Step 1: Business Info */}
            {currentStep === 0 && (
              <div className="space-y-6 animate-in fade-in slide-in-from-right-4 duration-500">
                <div>
                  <label className="block text-sm font-semibold text-text mb-2">Business Name <span className="text-error">*</span></label>
                  <input 
                    {...register('businessName')} 
                    className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all"
                    placeholder="e.g. Aba Leather Works Ltd"
                  />
                  {errors.businessName && <p className="text-error text-xs mt-1">{errors.businessName.message}</p>}
                </div>
                
                <div>
                  <label className="block text-sm font-semibold text-text mb-2">Business Type <span className="text-error">*</span></label>
                  <select 
                    {...register('businessType')}
                    className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all bg-white"
                  >
                    <option value="">Select type...</option>
                    <option value="retail">Retail Shop</option>
                    <option value="wholesale">Wholesale / Distributor</option>
                    <option value="manufacturer">Manufacturer / Artisan</option>
                    <option value="franchise">Franchise Outlet</option>
                  </select>
                  {errors.businessType && <p className="text-error text-xs mt-1">{errors.businessType.message}</p>}
                </div>

                <div>
                  <label className="block text-sm font-semibold text-text mb-2">RC Number / Tax ID <span className="text-text-muted font-normal">(Optional)</span></label>
                  <input 
                    {...register('rcNumber')} 
                    className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all"
                    placeholder="e.g. RC123456"
                  />
                </div>
              </div>
            )}

            {/* Step 2: Contact Info */}
            {currentStep === 1 && (
              <div className="space-y-6 animate-in fade-in slide-in-from-right-4 duration-500">
                <div>
                  <label className="block text-sm font-semibold text-text mb-2">Owner / Contact Name <span className="text-error">*</span></label>
                  <input 
                    {...register('ownerName')} 
                    className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all"
                    placeholder="e.g. John Doe"
                  />
                  {errors.ownerName && <p className="text-error text-xs mt-1">{errors.ownerName.message}</p>}
                </div>

                <div>
                  <label className="block text-sm font-semibold text-text mb-2">Phone Number <span className="text-error">*</span></label>
                  <input 
                    {...register('phone')} 
                    className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all"
                    placeholder="e.g. 08012345678"
                  />
                  {errors.phone && <p className="text-error text-xs mt-1">{errors.phone.message}</p>}
                </div>

                <div>
                  <label className="block text-sm font-semibold text-text mb-2">Email Address <span className="text-error">*</span></label>
                  <input 
                    type="email"
                    {...register('email')} 
                    className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all"
                    placeholder="e.g. contact@business.com"
                  />
                  {errors.email && <p className="text-error text-xs mt-1">{errors.email.message}</p>}
                </div>
              </div>
            )}

            {/* Step 3: Location */}
            {currentStep === 2 && (
              <div className="space-y-6 animate-in fade-in slide-in-from-right-4 duration-500">
                <div>
                  <label className="block text-sm font-semibold text-text mb-2">Store Address <span className="text-error">*</span></label>
                  <textarea 
                    {...register('address')} 
                    className="w-full p-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all resize-none h-24"
                    placeholder="e.g. 15 Ariaria International Market"
                  />
                  {errors.address && <p className="text-error text-xs mt-1">{errors.address.message}</p>}
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-semibold text-text mb-2">City <span className="text-error">*</span></label>
                    <input 
                      {...register('city')} 
                      className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all"
                      placeholder="e.g. Aba"
                    />
                    {errors.city && <p className="text-error text-xs mt-1">{errors.city.message}</p>}
                  </div>
                  <div>
                    <label className="block text-sm font-semibold text-text mb-2">State <span className="text-error">*</span></label>
                    <select 
                      {...register('state')}
                      className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all bg-white"
                    >
                      <option value="">Select state...</option>
                      <option value="Abia">Abia</option>
                      <option value="Imo">Imo</option>
                      <option value="Enugu">Enugu</option>
                      <option value="Anambra">Anambra</option>
                      <option value="Ebonyi">Ebonyi</option>
                      <option value="Rivers">Rivers</option>
                    </select>
                    {errors.state && <p className="text-error text-xs mt-1">{errors.state.message}</p>}
                  </div>
                </div>
              </div>
            )}

            {/* Step 4: Settlement */}
            {currentStep === 3 && (
              <div className="space-y-6 animate-in fade-in slide-in-from-right-4 duration-500">
                <Alert variant="default" className="bg-brand-50 border-brand-200">
                  <Building className="w-4 h-4 text-brand-600" />
                  <p className="text-sm text-brand-800 ml-2">This account will be used to settle your earnings.</p>
                </Alert>

                <div>
                  <label className="block text-sm font-semibold text-text mb-2">Bank Name <span className="text-error">*</span></label>
                  <select 
                    {...register('bankName')} 
                    className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all bg-white"
                  >
                    <option value="">Select a bank...</option>
                    <option value="access">Access Bank</option>
                    <option value="fidelity">Fidelity Bank</option>
                    <option value="firstbank">First Bank of Nigeria</option>
                    <option value="fcmb">First City Monument Bank (FCMB)</option>
                    <option value="gtb">Guarantee Trust Bank (GTB)</option>
                    <option value="stanbic">Stanbic IBTC Bank</option>
                    <option value="uba">United Bank for Africa (UBA)</option>
                    <option value="union">Union Bank</option>
                    <option value="wema">Wema Bank</option>
                    <option value="zenith">Zenith Bank</option>
                  </select>
                  {errors.bankName && <p className="text-error text-xs mt-1">{errors.bankName.message}</p>}
                </div>

                <div>
                  <label className="block text-sm font-semibold text-text mb-2">Account Number <span className="text-error">*</span></label>
                  <input 
                    {...register('accountNumber')} 
                    className="w-full h-12 px-4 rounded-lg border border-border focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none transition-all"
                    placeholder="10 digit account number"
                    maxLength={10}
                  />
                  {errors.accountNumber && <p className="text-error text-xs mt-1">{errors.accountNumber.message}</p>}
                </div>
              </div>
            )}

            {/* Actions */}
            <div className="flex items-center justify-between mt-10 pt-6 border-t border-border">
              {currentStep > 0 ? (
                <Button type="button" variant="outline" onClick={handleBack} disabled={isSubmitting} className="h-12 px-6">
                  <ArrowLeft className="w-4 h-4 mr-2" /> Back
                </Button>
              ) : (
                <div></div> // Placeholder for flex-between
              )}

              {currentStep < STEPS.length - 1 ? (
                <Button type="button" onClick={handleNext} className="h-12 px-8 rounded-full">
                  Continue <ArrowRight className="w-4 h-4 ml-2" />
                </Button>
              ) : (
                <Button type="submit" disabled={isSubmitting} className="h-12 px-8 rounded-full">
                  {isSubmitting ? (
                    <><Loader2 className="w-4 h-4 mr-2 animate-spin" /> Submitting...</>
                  ) : (
                    'Submit Application'
                  )}
                </Button>
              )}
            </div>

          </form>
        </div>

      </div>
    </div>
  );
}
