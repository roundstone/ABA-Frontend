'use client';

import React from 'react';
import { useForm, Controller } from 'react-hook-form';
import { useRouter } from 'next/navigation';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { createPromotionPackage } from '@/features/promotions/api';
import { PromotionPlacement } from '@/features/promotions/types';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { toast } from 'sonner';

interface FormValues {
  name: string;
  placement: PromotionPlacement;
  durationDays: number;
  priceInKobo: number;
  maxSlots: number;
}

export function CreatePackageForm() {
  const router = useRouter();
  const queryClient = useQueryClient();

  const { register, handleSubmit, formState: { errors } } = useForm<FormValues>({
    defaultValues: {
      name: '',
      placement: 'Shop home',
      durationDays: 7,
      priceInKobo: 0,
      maxSlots: 10
    }
  });

  const { mutate, isPending } = useMutation({
    mutationFn: createPromotionPackage,
    onSuccess: () => {
      toast('Promotion package created');
      queryClient.invalidateQueries({ queryKey: ['promotion-packages'] });
      router.push('/erp/settings/promotions');
    },
    onError: (error) => {
      toast(`Error: ${error.message}`);
    }
  });

  const onSubmit = (data: FormValues) => {
    // In real app, the price input should be converted to Kobo
    // Assuming user inputs Naira, we multiply by 100 for kobo
    mutate({
      name: data.name,
      placement: data.placement,
      durationDays: Number(data.durationDays),
      priceInKobo: Number(data.priceInKobo) * 100,
      maxSlots: Number(data.maxSlots)
    });
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-6 max-w-2xl">
      <div className="space-y-4 bg-white p-6 rounded-xl border">
        <div>
          <label className="text-sm font-medium mb-1 block">Package Name</label>
          <Input {...register('name', { required: 'Name is required' })} placeholder="e.g. Homepage Spotlight" />
          {errors.name && <p className="text-xs text-red-500 mt-1">{errors.name.message}</p>}
        </div>

        <div>
          <label className="text-sm font-medium mb-1 block">Placement</label>
          <select 
            {...register('placement', { required: true })}
            className="w-full flex h-10 rounded-md border border-border bg-surface px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary"
          >
            <option value="Shop home">Shop Home</option>
            <option value="Category page">Category Page</option>
            <option value="Store page">Store Page</option>
          </select>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-sm font-medium mb-1 block">Duration (Days)</label>
            <Input type="number" {...register('durationDays', { required: true, min: 1 })} />
          </div>
          <div>
            <label className="text-sm font-medium mb-1 block">Max Active Slots</label>
            <Input type="number" {...register('maxSlots', { required: true, min: 1 })} />
          </div>
        </div>

        <div>
          <label className="text-sm font-medium mb-1 block">Price (NGN)</label>
          <Input type="number" {...register('priceInKobo', { required: true, min: 0 })} />
        </div>
      </div>

      <div className="flex justify-end gap-3">
        <Button variant="outline" type="button" onClick={() => router.back()}>Cancel</Button>
        <Button type="submit" disabled={isPending}>{isPending ? 'Creating...' : 'Create Package'}</Button>
      </div>
    </form>
  );
}
