"use client"

import React, { useState, useRef, useEffect } from 'react';
import { useForm as useRHForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { createPromotion, getPromotionPackages } from '../api';
import { getMerchants } from '@/features/merchant/api';
import { getProducts } from '@/features/products/api/products.api';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { useRouter } from 'next/navigation';
import { AmountText } from '@/components/patterns/AmountText';

const schema = z.object({
  merchantId: z.string().min(1, "Merchant ID is required"),
  productId: z.string().min(1, "Product ID is required"),
  packageId: z.string().min(1, "Package is required"),
  startDate: z.string().min(1, "Start Date is required"),
  endDate: z.string().min(1, "End Date is required"),
});

function SearchableSelect({ 
  options, 
  value, 
  onChange, 
  placeholder,
  isLoading 
}: { 
  options: { id: string, label: string }[], 
  value: string, 
  onChange: (val: string) => void, 
  placeholder: string,
  isLoading?: boolean 
}) {
  const [search, setSearch] = useState('');
  const [open, setOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, []);

  const selected = options.find(o => o.id === value);
  const filtered = options.filter(o => o.label.toLowerCase().includes(search.toLowerCase()));

  return (
    <div className="relative" ref={containerRef}>
      <div 
        className="flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm cursor-pointer"
        onClick={() => setOpen(!open)}
      >
        <span className={selected ? 'text-black' : 'text-gray-500'}>
          {selected ? selected.label : placeholder}
        </span>
        <span className="text-gray-500 text-xs">▼</span>
      </div>
      {open && (
        <div className="absolute z-10 mt-1 w-full rounded-md border bg-white shadow-lg max-h-80 flex flex-col">
          <div className="p-2 border-b shrink-0">
            <Input 
              autoFocus
              placeholder="Search..." 
              value={search} 
              onChange={e => setSearch(e.target.value)}
              className="h-8 text-sm"
            />
          </div>
          <div className="overflow-y-auto flex-1">
            {isLoading ? (
              <div className="p-3 text-sm text-gray-500 text-center">Loading...</div>
            ) : filtered.length === 0 ? (
              <div className="p-3 text-sm text-gray-500 text-center">No results found</div>
            ) : (
              filtered.map(opt => (
                <div 
                  key={opt.id} 
                  className={`p-2 text-sm cursor-pointer hover:bg-gray-100 ${opt.id === value ? 'bg-gray-50 font-medium' : ''}`}
                  onClick={() => { onChange(opt.id); setOpen(false); setSearch(''); }}
                >
                  {opt.label}
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}

export function CreatePromotionForm() {
  const router = useRouter();
  const queryClient = useQueryClient();

  const { data: packagesData } = useQuery({
    queryKey: ['promotionPackages'],
    queryFn: getPromotionPackages
  });

  const { data: merchantsData, isLoading: merchantsLoading } = useQuery({
    queryKey: ['merchants'],
    queryFn: getMerchants
  });

  const { data: productsData, isLoading: productsLoading } = useQuery({
    queryKey: ['products'],
    queryFn: getProducts
  });

  const form = useRHForm<z.infer<typeof schema>>({
    resolver: zodResolver(schema),
    defaultValues: {
      merchantId: '',
      productId: '',
      packageId: '',
      startDate: '',
      endDate: ''
    }
  });

  const packages = packagesData?.data || [];
  const selectedPackageId = form.watch('packageId');
  const selectedPackage = packages.find(p => p.id === selectedPackageId);
  const selectedMerchantId = form.watch('merchantId');

  const merchantOptions = (merchantsData?.data || []).map(m => ({ id: m.id, label: `${m.name} (${m.merchantNo || m.id})` }));
  const productOptions = (productsData?.data || [])
    .filter(p => !selectedMerchantId || p.merchant?.id === selectedMerchantId)
    .map(p => ({ id: p.id, label: p.name }));

  const mutation = useMutation({
    mutationFn: (values: z.infer<typeof schema>) => {
      return createPromotion({
        ...values,
        amountPaidInKobo: selectedPackage?.priceInKobo || 0,
        paymentReference: 'PENDING'
      });
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['promotions'] });
      router.push('/erp/promotions');
    }
  });

  const onSubmit = (values: z.infer<typeof schema>) => {
    mutation.mutate(values);
  };

  return (
    <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6 max-w-2xl bg-white p-6 rounded-xl border">
      
      <div className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-1">Merchant</label>
          <Controller
            control={form.control}
            name="merchantId"
            render={({ field }) => (
              <SearchableSelect 
                options={merchantOptions}
                value={field.value}
                onChange={field.onChange}
                placeholder="Search and select a merchant..."
                isLoading={merchantsLoading}
              />
            )}
          />
          {form.formState.errors.merchantId && <p className="text-red-500 text-xs mt-1">{form.formState.errors.merchantId.message}</p>}
        </div>

        <div>
          <label className="block text-sm font-medium mb-1">Product</label>
          <Controller
            control={form.control}
            name="productId"
            render={({ field }) => (
              <SearchableSelect 
                options={productOptions}
                value={field.value}
                onChange={field.onChange}
                placeholder={selectedMerchantId ? "Search products..." : "Select a merchant first"}
                isLoading={productsLoading}
              />
            )}
          />
          {form.formState.errors.productId && <p className="text-red-500 text-xs mt-1">{form.formState.errors.productId.message}</p>}
        </div>

        <div>
          <label className="block text-sm font-medium mb-1">Promotion Package</label>
          <select 
            {...form.register('packageId')}
            className="flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm"
          >
            <option value="">Select a package...</option>
            {packages.map(pkg => (
              <option key={pkg.id} value={pkg.id}>
                {pkg.name} ({pkg.placement}) - {pkg.priceInKobo / 100} NGN
              </option>
            ))}
          </select>
          {form.formState.errors.packageId && <p className="text-red-500 text-xs mt-1">{form.formState.errors.packageId.message}</p>}
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">Start Date</label>
            <Input type="date" {...form.register('startDate')} />
            {form.formState.errors.startDate && <p className="text-red-500 text-xs mt-1">{form.formState.errors.startDate.message}</p>}
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">End Date</label>
            <Input type="date" {...form.register('endDate')} />
            {form.formState.errors.endDate && <p className="text-red-500 text-xs mt-1">{form.formState.errors.endDate.message}</p>}
          </div>
        </div>
      </div>

      {selectedPackage && (
        <div className="bg-gray-50 p-4 rounded-lg border flex justify-between items-center">
          <div>
            <div className="text-sm text-gray-500">Amount Due</div>
            <div className="font-bold text-xl"><AmountText amountInKobo={selectedPackage.priceInKobo} /></div>
          </div>
          <div className="text-right">
            <div className="text-sm text-gray-500">Duration</div>
            <div className="font-medium">{selectedPackage.durationDays} days</div>
          </div>
        </div>
      )}

      <div className="pt-4 flex justify-end gap-3 border-t">
        <Button variant="outline" type="button" onClick={() => router.back()}>Cancel</Button>
        <Button type="submit" disabled={mutation.isPending}>
          {mutation.isPending ? 'Creating...' : 'Create Promotion'}
        </Button>
      </div>
    </form>
  );
}
