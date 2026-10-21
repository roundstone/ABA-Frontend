'use client';

import React from 'react';
import { UseFormRegister, Control, useFieldArray } from 'react-hook-form';
import { CreateProductInput } from '../schemas';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';

interface ProductVariantsSectionProps {
  type: string;
  hasVariants: boolean;
  cost: number;
  sellingPrice: number;
  register: UseFormRegister<CreateProductInput>;
  control: Control<CreateProductInput>;
}

export function ProductVariantsSection({
  type,
  hasVariants,
  cost,
  sellingPrice,
  register,
  control,
}: ProductVariantsSectionProps) {
  const { fields: variants, append: appendVariant, remove: removeVariant } = useFieldArray({
    control,
    name: 'variants',
  });

  if (type === 'Service' || type === 'Raw material') return null;

  return (
    <div className="bg-surface rounded-xl border border-border overflow-hidden">
      <div className="bg-surface-2 px-6 py-4 border-b border-border flex justify-between items-center">
        <h3 className="font-medium text-lg">Variants</h3>
        <label className="flex items-center gap-2 cursor-pointer">
          <input
            type="checkbox"
            {...register('hasVariants')}
            className="rounded border-border text-primary focus:ring-primary"
          />
          <span className="text-sm font-medium">Product has variants</span>
        </label>
      </div>

      {hasVariants && (
        <div className="p-6 space-y-4">
          {variants.map((field, index) => (
            <div
              key={field.id}
              className="flex gap-4 items-start p-4 border border-border rounded-lg bg-surface-2/30"
            >
              <div className="flex-1 space-y-4">
                <div className="grid grid-cols-1 gap-4">
                  <div className="space-y-2">
                    <label className="text-xs font-medium">Variant Name</label>
                    <Input {...register(`variants.${index}.name`)} placeholder="Small / Red" />
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <label className="text-xs font-medium">Variant Cost</label>
                    <Input
                      type="number"
                      {...register(`variants.${index}.cost`)}
                      defaultValue={cost}
                    />
                  </div>
                  <div className="space-y-2">
                    <label className="text-xs font-medium">Variant Price</label>
                    <Input
                      type="number"
                      {...register(`variants.${index}.price`)}
                      defaultValue={sellingPrice}
                    />
                  </div>
                </div>
              </div>
              <Button
                type="button"
                variant="ghost"
                onClick={() => removeVariant(index)}
                className="text-error mt-6"
              >
                Remove
              </Button>
            </div>
          ))}

          <Button
            type="button"
            variant="outline"
            onClick={() =>
              appendVariant({
                name: '',
                cost: cost,
                price: sellingPrice,
                reorderLevel: 0,
                isActive: true,
              })
            }
          >
            Add Variant
          </Button>
        </div>
      )}
    </div>
  );
}
