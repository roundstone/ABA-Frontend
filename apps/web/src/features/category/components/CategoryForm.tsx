'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form'; // Wait, it's react-hook-form
import { useForm as useReactHookForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { CategoryFormValues, categorySchema } from '../schemas';
import { createCategory } from '../api';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';

export function CategoryForm() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useReactHookForm<CategoryFormValues>({
    resolver: zodResolver(categorySchema),
    defaultValues: {
      name: '',
      slug: '',
      image: '',
    },
  });

  const onSubmit = async (data: CategoryFormValues) => {
    setIsSubmitting(true);
    try {
      await createCategory(data);
      toast.success('Category created successfully');
      router.push('/erp/categories');
    } catch (error: any) {
      toast.error(error.message || 'Failed to create category');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="max-w-2xl">
      <div className="bg-surface border border-border rounded-xl p-6 shadow-sm">
        <h3 className="text-lg font-semibold mb-6">Category Details</h3>
        
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
          <div className="space-y-2">
            <label className="text-sm font-medium">Category Name <span className="text-error">*</span></label>
            <Input {...register('name')} placeholder="e.g., Electronics" className={errors.name ? "border-error" : ""} />
            {errors.name && <p className="text-xs text-error">{errors.name.message}</p>}
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">URL Slug <span className="text-error">*</span></label>
            <Input {...register('slug')} placeholder="e.g., electronics" className={errors.slug ? "border-error" : ""} />
            {errors.slug && <p className="text-xs text-error">{errors.slug.message}</p>}
            <p className="text-xs text-text-muted">Unique identifier used in URLs (e.g. aba.com/categories/electronics)</p>
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Image URL</label>
            <Input {...register('image')} placeholder="https://..." className={errors.image ? "border-error" : ""} />
            {errors.image && <p className="text-xs text-error">{errors.image.message}</p>}
            <p className="text-xs text-text-muted">Direct link to an image for this category</p>
          </div>

          <div className="flex gap-4 pt-4 border-t border-border">
            <Button type="button" variant="outline" onClick={() => router.back()}>Cancel</Button>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? 'Saving...' : 'Save Category'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}
