'use client';

import React from 'react';
import { UseFormRegister, FieldErrors } from 'react-hook-form';
import { CreateProductInput } from '../schemas';
import { Input } from '@/components/ui/input';

interface ProductPricingSectionProps {
  type: string;
  cost: number;
  sellingPrice: number;
  register: UseFormRegister<CreateProductInput>;
  errors: FieldErrors<CreateProductInput>;
}

export function ProductPricingSection({
  type,
  cost,
  sellingPrice,
  register,
  errors,
}: ProductPricingSectionProps) {
  if (type === 'Service') return null;

  const margin = sellingPrice > 0 ? ((sellingPrice - cost) / sellingPrice) * 100 : 0;

  return (
    <div className="bg-surface rounded-xl border border-border overflow-hidden">
      <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
        <h3 className="font-medium text-lg">Pricing</h3>
        {type !== 'Raw material' && (
          <span
            className={`text-sm font-medium px-2 py-1 rounded ${
              margin < 0 ? 'bg-error-bg text-error' : 'bg-success-bg text-success'
            }`}
          >
            Margin: {margin.toFixed(1)}%
          </span>
        )}
      </div>
      <div className="p-6 space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-2">
            <label className="text-sm font-medium">Cost Price (₦)</label>
            <Input type="number" {...register('cost')} min="0" error={errors.cost?.message} />
          </div>
          {type !== 'Raw material' && (
            <div className="space-y-2">
              <label className="text-sm font-medium">Selling Price (₦)</label>
              <Input type="number" {...register('sellingPrice')} min="0" error={errors.sellingPrice?.message} />
            </div>
          )}
        </div>
        <label className="flex items-center gap-2 cursor-pointer">
          <input
            type="checkbox"
            {...register('priceIncludesTax')}
            className="rounded border-border text-primary focus:ring-primary"
          />
          <span className="text-sm">Price includes tax</span>
        </label>
      </div>
    </div>
  );
}
