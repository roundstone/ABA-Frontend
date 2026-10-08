'use client';

import React, { useMemo, useState } from 'react';
import { useRouter, useSearchParams, usePathname } from 'next/navigation';
import { ChevronRight } from 'lucide-react';
import { cn } from 'cn';
import { Product } from '@/features/products/types';

interface StoreCategoryMenuProps {
  products: Product[];
}

interface CategoryNode {
  name: string;
  slug: string;
  count: number;
  children: Record<string, CategoryNode>;
}

export function StoreCategoryMenu({ products }: StoreCategoryMenuProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const pathname = usePathname();
  
  const currentCategorySlug = searchParams.get('category') || '';
  const [expanded, setExpanded] = useState<Record<string, boolean>>({});

  // Build tree from products
  const categoryTree = useMemo(() => {
    const root: Record<string, CategoryNode> = {};
    
    products.forEach(p => {
      if (p.category?.slug) {
        const slug = p.category.slug;
        const name = p.categoryName || p.category.name || slug;
        // In this mock, we assume simple flat categories for products, 
        // or if it's a path like "fashion/mens", we split it.
        const parts = slug.split('/');
        
        let currentLevel = root;
        let currentSlug = '';
        
        parts.forEach((part, index) => {
          currentSlug = currentSlug ? `${currentSlug}/${part}` : part;
          if (!currentLevel[part]) {
            currentLevel[part] = {
              name: index === parts.length - 1 ? name : part.charAt(0).toUpperCase() + part.slice(1).replace('-', ' '),
              slug: currentSlug,
              count: 0,
              children: {}
            };
          }
          currentLevel[part].count++;
          currentLevel = currentLevel[part].children;
        });
      }
    });
    
    return Object.values(root);
  }, [products]);

  const handleSelect = (slug: string) => {
    const newParams = new URLSearchParams(searchParams.toString());
    if (currentCategorySlug === slug) {
      newParams.delete('category'); // Toggle off
    } else {
      newParams.set('category', slug);
    }
    router.push(`${pathname}?${newParams.toString()}`);
  };

  const renderNodes = (nodes: CategoryNode[]) => {
    return (
      <ul className="space-y-1">
        {nodes.map(node => {
          const isSelected = currentCategorySlug === node.slug || currentCategorySlug.startsWith(node.slug + '/');
          const isExact = currentCategorySlug === node.slug;
          const childNodes = Object.values(node.children);
          const hasChildren = childNodes.length > 0;
          const isExpanded = expanded[node.slug] ?? isSelected;

          return (
            <li key={node.slug} className="text-sm">
              <div className="flex items-center gap-1 py-1 px-2 rounded-md hover:bg-surface-1 transition-colors">
                {hasChildren ? (
                  <button 
                    onClick={() => setExpanded(prev => ({ ...prev, [node.slug]: !isExpanded }))}
                    aria-expanded={isExpanded}
                    className="p-0.5 text-text-muted hover:text-text"
                  >
                    <ChevronRight className={cn('w-4 h-4 transition-transform duration-300', isExpanded && 'rotate-90')} />
                  </button>
                ) : (
                  <div className="w-5" />
                )}
                
                <button
                  onClick={() => handleSelect(node.slug)}
                  className={cn(
                    "flex-1 text-left font-medium",
                    isExact ? "text-brand-600" : "text-text"
                  )}
                >
                  {node.name}
                  <span className="text-text-muted ml-2 text-xs font-normal">({node.count})</span>
                </button>
              </div>
              
              {hasChildren && (
                <div
                  className={cn(
                    'grid transition-[grid-template-rows,opacity] duration-300 ease-in-out',
                    isExpanded ? 'grid-rows-[1fr] opacity-100' : 'grid-rows-[0fr] opacity-0'
                  )}
                >
                  <div className="overflow-hidden">
                    <div className="ml-4 pl-2 border-l border-border mt-1">
                      {renderNodes(childNodes)}
                    </div>
                  </div>
                </div>
              )}
            </li>
          );
        })}
      </ul>
    );
  };

  if (categoryTree.length === 0) return null;

  return (
    <div className="bg-white border border-border rounded-xl p-4 shadow-sm mb-6">
      <h3 className="font-bold text-text mb-4 text-base">Store Categories</h3>
      {renderNodes(categoryTree)}
    </div>
  );
}
