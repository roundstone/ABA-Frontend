'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createCustomerSchema, CreateCustomerInput } from '@/features/customers/schemas';
import { createCustomer } from '@/features/customers/api/customers.api';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';

export default function NewCustomerPage() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);

  const { register, handleSubmit, watch, formState: { errors } } = useForm<CreateCustomerInput>({
    resolver: zodResolver(createCustomerSchema) as any,
    defaultValues: {
      type: 'Individual',
      customerGroup: 'Retail',
      creditLimit: 0,
    }
  });

  const type = watch('type');

  const onSubmit = async (data: CreateCustomerInput) => {
    setIsSubmitting(true);
    try {
      const newCustomer = await createCustomer(data);
      toast.success('Customer created successfully');
      router.push(`/erp/customers/${newCustomer.id}`);
    } catch (err: any) {
      toast.error(err.message || 'Failed to create customer');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 max-w-4xl pb-20">
      <PageHeader 
        title="Add Customer" 
        description="Create a new individual or business customer record."
        backHref="/erp/customers"
      />

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
        
        {/* Basic Information */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Basic Information</h3>
          </div>
          <div className="p-6 space-y-6">
            
            <div className="flex gap-4">
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="radio" value="Individual" {...register('type')} className="text-primary focus:ring-primary" />
                <span>Individual</span>
              </label>
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="radio" value="Business" {...register('type')} className="text-primary focus:ring-primary" />
                <span>Business</span>
              </label>
            </div>

            {type === 'Business' && (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <label className="text-sm font-medium">Company Name <span className="text-error">*</span></label>
                  <Input {...register('companyName')} placeholder="Acme Corp" error={errors.companyName?.message} />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium">RC Number (Optional)</label>
                  <Input {...register('rcNumber')} placeholder="RC123456" error={errors.rcNumber?.message} />
                </div>
              </div>
            )}

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">First Name <span className="text-error">*</span></label>
                <Input {...register('firstName')} placeholder="John" error={errors.firstName?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Last Name <span className="text-error">*</span></label>
                <Input {...register('lastName')} placeholder="Doe" error={errors.lastName?.message} />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Phone Number <span className="text-error">*</span></label>
                <Input {...register('phone')} placeholder="+2348000000000" error={errors.phone?.message} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Email Address (Optional)</label>
                <Input type="email" {...register('email')} placeholder="john@example.com" error={errors.email?.message} />
              </div>
            </div>
            
          </div>
        </div>

        {/* Classification */}
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          <div className="bg-surface-2 px-6 py-4 border-b border-border">
            <h3 className="font-medium text-lg">Classification & Credit</h3>
          </div>
          <div className="p-6 space-y-6">
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <label className="text-sm font-medium">Customer Group</label>
                <select {...register('customerGroup')} className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                  <option value="Retail">Retail</option>
                  <option value="Wholesale">Wholesale</option>
                  <option value="VIP">VIP</option>
                </select>
                {errors.customerGroup && <p className="text-xs text-error">{errors.customerGroup.message}</p>}
              </div>

              <div className="space-y-2">
                <label className="text-sm font-medium">Referred By (Optional)</label>
                <Input {...register('referredBy')} placeholder="Referral Code or Phone" error={errors.referredBy?.message} />
              </div>
              
              <div className="space-y-2">
                <label className="text-sm font-medium">Credit Limit (₦)</label>
                <Input type="number" {...register('creditLimit')} min="0" error={errors.creditLimit?.message} />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Internal Notes</label>
              <textarea 
                {...register('notes')} 
                className="w-full flex min-h-[100px] rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary"
                placeholder="Add any internal notes about this customer..."
              />
              {errors.notes && <p className="text-xs text-error">{errors.notes.message}</p>}
            </div>

          </div>
        </div>

        <div className="flex items-center gap-4 border-t border-border pt-6">
          <Button type="button" variant="outline" onClick={() => router.push('/customers')} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? 'Saving...' : 'Save Customer'}
          </Button>
        </div>

      </form>
    </div>
  );
}
