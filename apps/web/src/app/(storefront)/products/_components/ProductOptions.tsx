'use client';

import React from 'react';
import { useRouter, useSearchParams, usePathname } from 'next/navigation';
import { ProductVariant } from '@/features/products/types';
import { cn } from '@/lib/utils';
import { Tooltip, TooltipProvider, TooltipTrigger, TooltipContent } from '@/components/ui/tooltip';

interface ProductOptionsProps {
  variants: ProductVariant[];
  selectedVariant: ProductVariant | undefined;
  onVariantSelect: (variant: ProductVariant) => void;
}

export function ProductOptions({ variants, selectedVariant, onVariantSelect }: ProductOptionsProps) {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();

  if (!variants || variants.length === 0) return null;

  // Extract all unique color attributes from variants
  const colorOptions = variants.reduce((acc, variant) => {
    const colorAttr = variant.attributes?.find(a => a.type === 'colour' || a.name.toLowerCase() === 'color' || a.name.toLowerCase() === 'colour');
    if (colorAttr) {
      if (!acc.some(opt => opt.value === colorAttr.value)) {
        acc.push({
          value: colorAttr.value,
          swatch: colorAttr.swatch || colorAttr.value,
          variants: [variant],
        });
      } else {
        const existing = acc.find(opt => opt.value === colorAttr.value);
        if (existing) existing.variants.push(variant);
      }
    }
    return acc;
  }, [] as Array<{ value: string; swatch: string; variants: ProductVariant[] }>);

  // Extract all unique size or text attributes (for simplicity, anything not color)
  const textOptions = variants.reduce((acc, variant) => {
    const textAttrs = variant.attributes?.filter(a => a.type === 'text' || (a.name.toLowerCase() !== 'color' && a.name.toLowerCase() !== 'colour'));
    if (textAttrs) {
      textAttrs.forEach(attr => {
        if (!acc[attr.name]) {
          acc[attr.name] = [];
        }
        if (!acc[attr.name].some(opt => opt.value === attr.value)) {
          acc[attr.name].push({
            value: attr.value,
            variants: [variant],
          });
        } else {
          const existing = acc[attr.name].find(opt => opt.value === attr.value);
          if (existing) existing.variants.push(variant);
        }
      });
    }
    return acc;
  }, {} as Record<string, Array<{ value: string; variants: ProductVariant[] }>>);

  const handleColorSelect = (colorValue: string) => {
    // Find the first variant with this color that is active and in stock (or just active)
    const matchingVariants = variants.filter(v => 
      v.attributes?.some(a => (a.name.toLowerCase() === 'color' || a.name.toLowerCase() === 'colour') && a.value === colorValue)
    );
    
    // Attempt to keep other text attributes if possible, else pick first available
    let newVariant = matchingVariants.find(v => v.stockCount > 0 && v.isActive) || matchingVariants[0];

    if (newVariant) {
      onVariantSelect(newVariant);
      const params = new URLSearchParams(searchParams);
      params.set('color', colorValue.toLowerCase());
      router.replace(`${pathname}?${params.toString()}`, { scroll: false });
    }
  };

  const selectedColorValue = selectedVariant?.attributes?.find(a => a.name.toLowerCase() === 'color' || a.name.toLowerCase() === 'colour')?.value;

  return (
    <div className="space-y-6">
      {colorOptions.length > 0 && (
        <div>
          <div className="flex items-center gap-2 mb-3">
            <span className="text-sm font-semibold text-text">Colour:</span>
            <span className="text-sm text-text-muted">{selectedColorValue || 'Select a colour'}</span>
          </div>
          <div className="flex flex-wrap gap-3">
            {colorOptions.map((opt) => {
              const isSelected = selectedColorValue === opt.value;
              const hasStock = opt.variants.some(v => v.stockCount > 0 && v.isActive);
              
              return (
                <TooltipProvider key={opt.value}>
                  <Tooltip>
                    <TooltipTrigger render={
                      <button
                        onClick={() => handleColorSelect(opt.value)}
                        disabled={!hasStock}
                        className={cn(
                          "relative w-10 h-10 rounded-full border-2 p-0.5 transition-all focus-visible:outline-brand-500",
                          isSelected ? "border-brand-600" : "border-transparent hover:border-border",
                          !hasStock && "opacity-50 cursor-not-allowed"
                        )}
                      />
                    }>
                      <span 
                        className="block w-full h-full rounded-full border border-border"
                        style={{ 
                          backgroundColor: opt.swatch.startsWith('#') || opt.swatch.match(/^[a-z]+$/i) ? opt.swatch : undefined,
                          backgroundImage: opt.swatch.includes('/') ? `url(${opt.swatch})` : undefined,
                          backgroundSize: 'cover'
                        }}
                      />
                      {!hasStock && (
                        <span className="absolute inset-0 flex items-center justify-center">
                          <span className="w-full h-[2px] bg-error rotate-45 transform" />
                        </span>
                      )}
                    </TooltipTrigger>
                    <TooltipContent className="z-[100] bg-text text-white px-2 py-1 rounded text-xs">
                      {!hasStock ? 'Out of stock' : opt.value}
                    </TooltipContent>
                  </Tooltip>
                </TooltipProvider>
              );
            })}
          </div>
        </div>
      )}

      {Object.entries(textOptions).map(([attrName, options]) => (
        <div key={attrName}>
          <div className="flex items-center gap-2 mb-3">
            <span className="text-sm font-semibold text-text">{attrName}:</span>
            <span className="text-sm text-text-muted">
              {selectedVariant?.attributes?.find(a => a.name === attrName)?.value || `Select ${attrName}`}
            </span>
          </div>
          <div className="flex flex-wrap gap-2">
            {options.map((opt) => {
              const isSelected = selectedVariant?.attributes?.some(a => a.name === attrName && a.value === opt.value);
              const hasStock = opt.variants.some(v => v.stockCount > 0 && v.isActive);
              
              // Find the variant matching selected color AND this text option
              const matchingVariant = opt.variants.find(v => {
                if (!selectedColorValue) return true;
                return v.attributes?.some(a => (a.name.toLowerCase() === 'color' || a.name.toLowerCase() === 'colour') && a.value === selectedColorValue);
              });

              return (
                <button
                  key={opt.value}
                  onClick={() => {
                    if (matchingVariant) {
                      onVariantSelect(matchingVariant);
                    }
                  }}
                  disabled={!hasStock || !matchingVariant}
                  className={cn(
                    "px-4 py-2 border rounded-md text-sm font-medium transition-all focus-visible:outline-brand-500",
                    isSelected ? "border-brand-600 bg-brand-50 text-brand-700" : "border-border hover:border-brand-300 text-text",
                    (!hasStock || !matchingVariant) && "opacity-50 cursor-not-allowed bg-surface-2 line-through text-text-muted hover:border-border"
                  )}
                >
                  {opt.value}
                </button>
              );
            })}
          </div>
        </div>
      ))}
    </div>
  );
}
