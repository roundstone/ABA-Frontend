'use client';

import React from 'react';
import type { MerchantSort } from '@/features/merchants/types';

export interface DirectoryFilterValues {
  state: string;
  minRating: string;
  verified: boolean;
}

export const SORT_OPTIONS: { value: MerchantSort; label: string }[] = [
  { value: 'recommended', label: 'Recommended' },
  { value: 'newest', label: 'Newest' },
  { value: 'rating', label: 'Rating' },
  { value: 'orders', label: 'Most orders' },
];

const RATING_OPTIONS = [
  { value: '', label: 'Any rating' },
  { value: '4.5', label: '4.5 & up' },
  { value: '4', label: '4.0 & up' },
  { value: '3.5', label: '3.5 & up' },
];

const fieldClass =
  'h-10 w-full rounded-md border border-border bg-white px-3 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500';

interface Props {
  values: DirectoryFilterValues;
  states: string[];
  onChange: (patch: Partial<DirectoryFilterValues>) => void;
  onClear: () => void;
  hasActive: boolean;
}

/** State, rating and verified filters for the merchants directory (REQ-06-677 to 679). */
export function MerchantFilters({ values, states, onChange, onClear, hasActive }: Props) {
  return (
    <div className="bg-white border border-border rounded-xl p-4 space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="font-bold text-text text-base">Filters</h3>
        {hasActive && (
          <button type="button" onClick={onClear} className="text-xs text-brand-600 hover:underline">
            Clear all
          </button>
        )}
      </div>

      <div>
        <label htmlFor="merchant-filter-state" className="block text-sm font-medium text-text mb-1">State</label>
        <select id="merchant-filter-state" className={fieldClass} value={values.state} onChange={e => onChange({ state: e.target.value })}>
          <option value="">All states</option>
          {states.map(s => <option key={s} value={s}>{s}</option>)}
        </select>
      </div>

      <div>
        <label htmlFor="merchant-filter-rating" className="block text-sm font-medium text-text mb-1">Rating</label>
        <select id="merchant-filter-rating" className={fieldClass} value={values.minRating} onChange={e => onChange({ minRating: e.target.value })}>
          {RATING_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
        </select>
      </div>

      <label className="flex items-center gap-2 text-sm text-text cursor-pointer">
        <input
          type="checkbox"
          checked={values.verified}
          onChange={e => onChange({ verified: e.target.checked })}
          className="h-4 w-4 rounded border-border text-brand-600 focus:ring-brand-500"
        />
        Verified merchants only
      </label>
    </div>
  );
}
