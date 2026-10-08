'use client';

import React, { useEffect, useRef, useState } from 'react';
import Link from 'next/link';
import { ChevronDown } from 'lucide-react';
import { cn } from 'cn';
import { getCategoryMenu } from '@/features/category/api';
import { Category } from '@/features/category/types';

const SUBS_PER_GROUP = 4;

/** "All Categories" trigger for the search bar. Opens a 3-column category picker panel. */
export function CategorySearchSelect() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    getCategoryMenu()
      .then(res => setCategories(res.data))
      .catch(err => console.error('Failed to load categories', err));
  }, []);

  useEffect(() => {
    const onDown = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') setOpen(false);
    };
    document.addEventListener('mousedown', onDown);
    document.addEventListener('keydown', onKey);
    return () => {
      document.removeEventListener('mousedown', onDown);
      document.removeEventListener('keydown', onKey);
    };
  }, []);

  const bySort = (a: Category, b: Category) => a.sortOrder - b.sortOrder;
  const roots = categories.filter(c => !c.parentId).sort(bySort).slice(0, 9);
  const subsOf = (id: string) => categories.filter(c => c.parentId === id).sort(bySort);

  return (
    <div ref={ref} className="absolute left-0 top-0 bottom-0 z-10">
      <button
        type="button"
        aria-haspopup="true"
        aria-expanded={open}
        aria-controls="category-search-panel"
        onClick={() => setOpen(o => !o)}
        className="h-full flex items-center gap-1 pl-3 pr-2 rounded-l-full border-r border-border text-xs text-text-muted hover:text-brand-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-brand-500"
      >
        All Categories
        <ChevronDown className={cn('w-3.5 h-3.5 transition-transform duration-200', open && 'rotate-180')} />
      </button>

      {open && (
        <div
          id="category-search-panel"
          className="absolute left-0 top-full mt-3 w-[min(900px,92vw)] max-h-[75vh] overflow-auto bg-white border border-border rounded-2xl shadow-xl p-6"
        >
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-x-8 gap-y-6">
            {roots.map(root => (
              <div key={root.id}>
                <Link
                  href={`/c/${root.slug}`}
                  onClick={() => setOpen(false)}
                  className="block text-sm font-bold text-text hover:text-brand-600 mb-3"
                >
                  {root.name}
                </Link>
                <ul className="flex flex-col gap-2">
                  {subsOf(root.id).slice(0, SUBS_PER_GROUP).map(sub => (
                    <li key={sub.id}>
                      <Link
                        href={`/c/${root.slug}/${sub.slug}`}
                        onClick={() => setOpen(false)}
                        className="text-sm text-text-muted hover:text-brand-600 hover:underline"
                      >
                        {sub.name}
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
          <div className="mt-6 pt-4 border-t border-border grid grid-cols-1 sm:grid-cols-3 gap-2 text-sm font-bold text-text">
            <Link href="/merchants" onClick={() => setOpen(false)} className="hover:text-brand-600">All Merchants ›</Link>
            <Link href="/categories" onClick={() => setOpen(false)} className="hover:text-brand-600">All Categories ›</Link>
            <Link href="/" onClick={() => setOpen(false)} className="hover:text-brand-600">All Products ›</Link>
          </div>
        </div>
      )}
    </div>
  );
}
