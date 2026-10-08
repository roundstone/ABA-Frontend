import React from 'react';
import { SlidersHorizontal } from 'lucide-react';

interface ShopFiltersProps {
  merchants: any[];
  selectedMerchant: string | null;
  setSelectedMerchant: (id: string | null) => void;
}

export function ShopFilters({
    merchants,
    selectedMerchant,
    setSelectedMerchant
}: ShopFiltersProps) {
    return (
        <div className="bg-white border border-border rounded-xl p-4">
            <div className="flex items-center justify-between mb-4">
                <h2 className="font-semibold text-lg flex items-center gap-2">
                    <SlidersHorizontal className="w-5 h-5" />
                    Filters
                </h2>
                <button
                    className="text-xs text-brand-600 hover:underline"
                    onClick={() => { setSelectedMerchant(null); }}
                >
                    Clear all
                </button>
            </div>

            <div className="space-y-6">
                {/* Price Filter (Mock) */}
                <div className="border-t border-border pt-4">
                    <h3 className="font-medium text-text mb-3">Price Range</h3>
                    <div className="flex items-center gap-2">
                        <input type="text" placeholder="Min" className="w-full h-8 px-2 rounded border border-border text-sm" />
                        <span>-</span>
                        <input type="text" placeholder="Max" className="w-full h-8 px-2 rounded border border-border text-sm" />
                    </div>
                </div>

                {/* Merchant Filter */}
                <div className="border-t border-border pt-4">
                    <h3 className="font-medium text-text mb-3">Merchant</h3>
                    <div className="space-y-2 text-sm text-text-muted">
                        {merchants?.map((merch: any) => (
                            <label key={merch.id} className="flex items-center gap-2 cursor-pointer hover:text-brand-600">
                                <input
                                    type="radio"
                                    name="merchant"
                                    checked={selectedMerchant === merch.id}
                                    onChange={() => setSelectedMerchant(merch.id)}
                                    className="rounded text-brand-600 focus:ring-brand-500"
                                />
                                {merch.name}
                            </label>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
}
