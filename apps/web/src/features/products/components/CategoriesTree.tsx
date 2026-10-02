'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { getShopCategories } from '@/features/shop/api';
import { Category } from '@/features/category/types';
import { toast } from 'sonner';

export function CategoriesTree() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  useEffect(() => {
    const fetchCategories = async () => {
      try {
        const res = await getShopCategories();
        setCategories(res.data);
      } catch (err) {
        toast.error('Failed to load categories');
      } finally {
        setIsLoading(false);
      }
    };
    fetchCategories();
  }, []);

  const filtered = categories.filter(c => 
    c.name.toLowerCase().includes(search.toLowerCase()) || 
    c.slug.toLowerCase().includes(search.toLowerCase())
  );

  const columns = [
    { 
      accessorKey: 'name', 
      header: 'Category Name',
      cell: (info: any) => (
        <div className="flex items-center gap-3">
          {info.row.original.image ? (
            <img src={info.row.original.image} alt="" className="w-10 h-10 rounded-md object-cover border border-border" />
          ) : (
            <div className="w-10 h-10 rounded-md bg-surface-2 flex items-center justify-center border border-border text-xs text-text-muted">
              IMG
            </div>
          )}
          <Link href={`/erp/categories/${info.row.original.id}`} className="font-medium text-primary hover:underline">
            {info.getValue()}
          </Link>
        </div>
      )
    },
    { 
      accessorKey: 'slug', 
      header: 'Slug',
      cell: (info: any) => <span className="text-text-muted font-mono text-sm">{info.getValue()}</span>
    },
    { 
      accessorKey: 'productCount', 
      header: 'Products',
      cell: (info: any) => <span className="font-medium">{info.getValue()}</span>
    },
    {
      id: 'actions',
      cell: (info: any) => (
        <div className="flex justify-end gap-1">
          <Button variant="ghost" size="sm">Edit</Button>
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      <PageHeader 
        title="Categories" 
        description="Manage product categories and hierarchy."
        action={
          <div className="flex gap-2">
            <Link href="/erp/categories/new">
              <Button>Add Category</Button>
            </Link>
          </div>
        }
      />

      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div className="w-full max-w-md">
          <Input 
            placeholder="Search categories..." 
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <DataTable 
          data={filtered} 
          columns={columns} 
          isLoading={isLoading}
          emptyMessage="No categories found."
        />
      </div>
    </div>
  );
}
