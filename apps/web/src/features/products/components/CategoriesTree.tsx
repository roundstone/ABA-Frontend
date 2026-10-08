'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { getCategories } from '@/features/category/api';
import { Category } from '@/features/category/types';
import { toast } from 'sonner';
import { GripVertical, Edit } from 'lucide-react';

export function CategoriesTree() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  // Local state for drag and drop
  const [draggedId, setDraggedId] = useState<string | null>(null);

  useEffect(() => {
    const fetchCategories = async () => {
      try {
        const res = await getCategories();
        setCategories(res.data);
      } catch (err) {
        toast.error('Failed to load categories');
      } finally {
        setIsLoading(false);
      }
    };
    fetchCategories();
  }, []);

  const buildTree = (cats: Category[]) => {
    const map = new Map<string, Category>();
    const roots: Category[] = [];
    cats.forEach(c => map.set(c.id, { ...c, children: [] }));
    cats.forEach(c => {
      if (c.parentId) {
        map.get(c.parentId)?.children?.push(map.get(c.id)!);
      } else {
        roots.push(map.get(c.id)!);
      }
    });
    
    const sortFn = (a: Category, b: Category) => a.sortOrder - b.sortOrder;
    roots.sort(sortFn);
    roots.forEach(r => {
      r.children?.sort(sortFn);
      r.children?.forEach(c => c.children?.sort(sortFn));
    });
    return roots;
  };

  const handleDragStart = (e: React.DragEvent, id: string) => {
    setDraggedId(id);
    e.dataTransfer.effectAllowed = 'move';
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
  };

  const handleDrop = (e: React.DragEvent, targetId: string) => {
    e.preventDefault();
    if (!draggedId || draggedId === targetId) return;
    
    // Simple simulated swap for now
    const newCats = [...categories];
    const draggedIdx = newCats.findIndex(c => c.id === draggedId);
    const targetIdx = newCats.findIndex(c => c.id === targetId);
    
    if (draggedIdx > -1 && targetIdx > -1) {
      // Just swap sort orders
      const tempSort = newCats[draggedIdx].sortOrder;
      newCats[draggedIdx].sortOrder = newCats[targetIdx].sortOrder;
      newCats[targetIdx].sortOrder = tempSort;
      
      setCategories(newCats);
      toast.success('Categories reordered');
    }
    setDraggedId(null);
  };

  const filtered = search 
    ? categories.filter(c => c.name.toLowerCase().includes(search.toLowerCase()))
    : categories;

  const tree = buildTree(filtered);

  const renderNode = (node: Category, depth = 0) => {
    return (
      <div key={node.id}>
        <div 
          className="flex items-center justify-between p-3 border-b border-border bg-white hover:bg-surface-1 transition-colors"
          style={{ paddingLeft: `${(depth * 24) + 12}px` }}
          draggable
          onDragStart={(e) => handleDragStart(e, node.id)}
          onDragOver={handleDragOver}
          onDrop={(e) => handleDrop(e, node.id)}
        >
          <div className="flex items-center gap-3">
            <button className="cursor-grab text-text-muted hover:text-text">
              <GripVertical className="w-4 h-4" />
            </button>
            {node.image ? (
              <img src={node.image} alt="" className="w-8 h-8 rounded object-cover border border-border" />
            ) : (
              <div className="w-8 h-8 rounded bg-surface-2 flex items-center justify-center border border-border text-[10px] text-text-muted">
                IMG
              </div>
            )}
            <div>
              <Link href={`/erp/categories/${node.id}`} className="font-medium text-text hover:text-brand-600">
                {node.name}
              </Link>
              <div className="text-xs text-text-muted font-mono">{node.slug}</div>
            </div>
          </div>
          
          <div className="flex items-center gap-6">
            <div className="text-sm text-text-muted hidden sm:block">
              {node.productCount} products
            </div>
            <div className="text-xs">
              {node.status === 'active' ? (
                <span className="px-2 py-1 bg-green-50 text-green-700 rounded-full font-medium">Active</span>
              ) : (
                <span className="px-2 py-1 bg-surface-2 text-text-muted rounded-full font-medium">Inactive</span>
              )}
            </div>
            <Button variant="ghost" size="sm" className="h-8 px-2">
              <Edit className="w-4 h-4 text-text-muted" />
            </Button>
          </div>
        </div>
        
        {node.children && node.children.length > 0 && (
          <div className="flex flex-col">
            {node.children.map(child => renderNode(child, depth + 1))}
          </div>
        )}
      </div>
    );
  };

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

      <div className="bg-surface rounded-xl border border-border overflow-hidden shadow-sm">
        {isLoading ? (
          <div className="p-8 text-center text-text-muted">Loading categories...</div>
        ) : tree.length > 0 ? (
          <div className="flex flex-col">
            {tree.map(root => renderNode(root, 0))}
          </div>
        ) : (
          <div className="p-8 text-center text-text-muted">No categories found.</div>
        )}
      </div>
    </div>
  );
}
