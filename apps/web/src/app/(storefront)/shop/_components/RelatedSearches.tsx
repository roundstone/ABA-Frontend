import React from 'react';
import Link from 'next/link';

export function RelatedSearches() {
  const searches = [
    "Auto Parts and Accessories",
    "Automotive Parts and Accessories",
    "Car Accessories and Parts",
    "Automobile Parts",
    "Aftermarket Auto Part",
    "Aftermarket Accessories",
    "Automotive Accessories",
    "Cars and Trucks Parts",
    "SUV Parts and Accessories",
    "Car Replacement Parts",
    "Honda Ridgeline Truck Accessories",
    "Car Part"
  ];
  return (
    <div className="mt-16 border-t border-border pt-12">
      <h3 className="text-xl font-bold text-brand-950 mb-6">Related searches</h3>
      <div className="flex flex-wrap gap-3">
        {searches.map(s => (
           <Link key={s} href="#" className="bg-gray-100/80 hover:bg-gray-200 text-gray-800 px-4 py-2 rounded-full text-sm font-medium transition-colors border border-transparent hover:border-gray-300">
             {s}
           </Link>
        ))}
      </div>
    </div>
  );
}
