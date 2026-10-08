import React from 'react';
import Link from 'next/link';

export function PopularBrands() {
  const brands = ["Toyota", "Honda", "Ford", "Chevrolet", "BMW", "Mercedes-Benz"];
  return (
    <div className="mt-16 border-t border-border pt-12">
      <h3 className="text-xl font-bold text-brand-950 mb-6">Popular Brands</h3>
      <div className="grid grid-cols-2 md:grid-cols-6 gap-4">
        {brands.map(b => (
           <Link key={b} href="#" className="border border-border rounded-xl h-24 flex items-center justify-center font-bold text-brand-950 hover:border-brand-500 transition-colors bg-white shadow-sm">
             {b}
           </Link>
        ))}
      </div>
    </div>
  );
}
