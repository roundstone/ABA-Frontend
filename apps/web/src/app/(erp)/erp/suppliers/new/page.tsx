'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createSupplierSchema, CreateSupplierInput } from '@/features/suppliers/schemas';
import { createSupplier } from '@/features/suppliers/api/suppliers.api';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';

export default function NewSupplierPage() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);

  const { register, handleSubmit, watch, formState: { errors } } = useForm<CreateSupplierInput>({
    resolver: zodResolver(createSupplierSchema) as any,
    defaultValues: {
      type: 'Local',
      paymentTerms: 'Net 30',
      currency: 'NGN',
      leadTimeDays: 7,
      creditLimit: 0,
      country: 'Nigeria'
    }
  });

  const type = watch('type');

  const onSubmit = async (data: CreateSupplierInput) => {
    setIsSubmitting(true);
    try {
      const newSupplier = await createSupplier(data);
      toast.success('Supplier successfully registered');
      router.push(`/suppliers/${newSupplier.id}`);
    } catch (err: any) {
      toast.error(err.message || 'Failed to register supplier');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-4xl pb-20">
      <PageHeader 
        title="Add Supplier" 
        description="Register a new vendor for raw materials or goods."
        backHref="/erp/suppliers"
      />

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
        
        {/* Basic Info */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
            <h3 className="font-medium text-lg">Company Profile</h3>
            <div className="flex gap-4 items-center">
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="radio" value="Local" {...register('type')} className="text-primary focus:ring-primary" />
                <span className="text-sm">Local Vendor</span>
              </label>
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="radio" value="International" {...register('type')} className="text-primary focus:ring-primary" />
                <span className="text-sm">International</span>
              </label>
            </div>
          </div>
          <div className="p-6 space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Company Name <span className="text-error">*</span></label>
                <Input {...register('companyName')} placeholder="Company Ltd" error={errors.companyName?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Tax ID / RC Number</label>
                <Input {...register('taxId')} placeholder="Optional" error={errors.taxId?.message} />
              </div>
            </div>
          </div>
        </div>

        {/* Contact & Location */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Contact & Location</h3>
          </div>
          <div className="p-6 space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Contact Person <span className="text-error">*</span></label>
                <Input {...register('contactPerson')} placeholder="Jane Doe" error={errors.contactPerson?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Phone Number <span className="text-error">*</span></label>
                <Input {...register('phone')} placeholder="+234..." error={errors.phone?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Email Address</label>
                <Input type="email" {...register('email')} placeholder="jane@company.com" error={errors.email?.message} />
              </div>
            </div>
            
            <div className="space-y-2 pt-2 border-t border-border">
              <label className="text-sm font-medium">Street Address <span className="text-error">*</span></label>
              <Input {...register('address')} placeholder="123 Warehouse Rd" error={errors.address?.message} />
            </div>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">City <span className="text-error">*</span></label>
                <Input {...register('city')} placeholder="City" error={errors.city?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">State <span className="text-error">*</span></label>
                <Input {...register('state')} placeholder="State" error={errors.state?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Country <span className="text-error">*</span></label>
                <Input {...register('country')} placeholder="Nigeria" error={errors.country?.message} />
              </div>
            </div>
          </div>
        </div>

        {/* Commercial */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Commercial Terms</h3>
          </div>
          <div className="p-6 space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Payment Terms <span className="text-error">*</span></label>
                <select {...register('paymentTerms')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="Immediate">Immediate (CIA)</option>
                  <option value="Net 7">Net 7 Days</option>
                  <option value="Net 14">Net 14 Days</option>
                  <option value="Net 30">Net 30 Days</option>
                  <option value="Net 60">Net 60 Days</option>
                  <option value="Custom">Custom</option>
                </select>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Lead Time (Days)</label>
                <Input type="number" {...register('leadTimeDays')} min="0" error={errors.leadTimeDays?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Credit Limit ({type === 'Local' ? '₦' : '$'})</label>
                <Input type="number" {...register('creditLimit')} min="0" error={errors.creditLimit?.message} />
              </div>
            </div>

            {type === 'International' && (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4 border-t border-border">
                <div className="space-y-2">
                  <label className="text-sm font-medium">Currency <span className="text-error">*</span></label>
                  <select {...register('currency')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                    <option value="USD">USD - US Dollar</option>
                    <option value="EUR">EUR - Euro</option>
                    <option value="GBP">GBP - British Pound</option>
                    <option value="CNY">CNY - Chinese Yuan</option>
                  </select>
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium">Incoterms</label>
                  <select {...register('incoterms')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                    <option value="">Select Terms</option>
                    <option value="FOB">FOB (Free On Board)</option>
                    <option value="CIF">CIF (Cost, Insurance & Freight)</option>
                    <option value="EXW">EXW (Ex Works)</option>
                  </select>
                </div>
              </div>
            )}
          </div>
        </div>
        
        {/* Bank Details */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Bank Details (Optional)</h3>
          </div>
          <div className="p-6 space-y-6">
            <p className="text-sm text-text-muted">You can add these later. Changing bank details after setup requires Admin approval.</p>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Bank Name</label>
                <Input {...register('bankName')} placeholder="Bank Name" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Account Number</label>
                <Input {...register('accountNumber')} placeholder="Account Number" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Account Name</label>
                <Input {...register('accountName')} placeholder="Account Name" />
              </div>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-4 border-t border-border pt-6">
          <Button type="button" variant="outline" onClick={() => router.push('/suppliers')} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? 'Saving...' : 'Save Supplier'}
          </Button>
        </div>

      </form>
    </div>
  );
}
