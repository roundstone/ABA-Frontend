'use client';

import React, { useState } from 'react';
import { usePages } from '../queries';
import { useUpdatePageSection as useUpdateSectionMutation, useUpdateSectionStatus as useUpdateStatusMutation } from '../mutations';
import { Page, PageSection } from '../types';
import { Button } from '@/components/ui/button';
import { PageHeader } from '@/components/patterns/PageHeader';

export function PagesEditor() {
  const { data, isLoading, error } = usePages();
  const [selectedPage, setSelectedPage] = useState<Page | null>(null);
  const [editingSection, setEditingSection] = useState<PageSection | null>(null);

  const updateSection = useUpdateSectionMutation();
  const updateStatus = useUpdateStatusMutation();

  if (isLoading) return <div className="p-8"><div className="animate-pulse h-8 w-48 bg-border rounded mb-4" /><div className="animate-pulse h-64 bg-border rounded" /></div>;
  if (error || !data) return <div className="p-8 text-destructive">Error loading pages.</div>;

  if (editingSection && selectedPage) {
    return (
      <div className="space-y-6">
        <div className="flex items-center gap-4 mb-4">
          <Button variant="outline" onClick={() => setEditingSection(null)}>Back</Button>
          <h1 className="text-2xl font-bold">Edit Section: {editingSection.name}</h1>
        </div>
        <div className="rounded-xl border bg-card text-card-foreground shadow">
          <div className="flex flex-col space-y-1.5 p-6">
            <h3 className="font-semibold leading-none tracking-tight">Content</h3>
          </div>
          <div className="p-6 pt-0">
            <form onSubmit={(e) => {
              e.preventDefault();
              const formData = new FormData(e.currentTarget);
              const content = formData.get('content') as string;
              updateSection.mutate({ 
                pageId: selectedPage.id, 
                sectionId: editingSection.id, 
                content 
              }, {
                onSuccess: () => setEditingSection(null)
              });
            }} className="space-y-4">
              <textarea 
                name="content"
                defaultValue={editingSection.content}
                className="w-full min-h-[300px] p-4 rounded-md border border-input bg-background text-sm"
                required
              />
              <div className="flex justify-end gap-2">
                <Button type="button" variant="outline" onClick={() => setEditingSection(null)}>Cancel</Button>
                <Button type="submit" variant="primary" disabled={updateSection.isPending}>Save</Button>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }

  if (selectedPage) {
    return (
      <div className="space-y-6">
        <div className="flex items-center gap-4 mb-4">
          <Button variant="outline" onClick={() => setSelectedPage(null)}>Back</Button>
          <h1 className="text-2xl font-bold">Page: {selectedPage.title}</h1>
        </div>
        <div className="space-y-4">
          {selectedPage.sections.sort((a, b) => a.order - b.order).map(section => (
            <div key={section.id} className="rounded-xl border bg-card text-card-foreground shadow">
              <div className="flex flex-row items-center justify-between p-6 pb-2">
                <div>
                  <h3 className="text-lg font-semibold leading-none tracking-tight">{section.name}</h3>
                  <p className="text-sm text-muted-foreground mt-1">Version {section.version}</p>
                </div>
                <div className="flex gap-2">
                  <Button 
                    variant={section.status === 'Published' ? 'outline' : 'secondary'}
                    size="sm"
                    onClick={() => updateStatus.mutate({ 
                      pageId: selectedPage.id, 
                      sectionId: section.id, 
                      status: section.status === 'Published' ? 'Draft' : 'Published' 
                    })}
                  >
                    {section.status === 'Published' ? 'Unpublish' : 'Publish'}
                  </Button>
                  <Button variant="primary" size="sm" onClick={() => setEditingSection(section)}>
                    Edit
                  </Button>
                </div>
              </div>
              <div className="p-6">
                <div className="text-sm border-t pt-4 whitespace-pre-wrap">
                  {section.content.substring(0, 200)}{section.content.length > 200 ? '...' : ''}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <PageHeader title="Storefront Pages" />
      <div className="grid gap-4">
        {data.data.map(page => (
          <div key={page.id} className="rounded-xl border bg-card text-card-foreground shadow cursor-pointer hover:bg-accent/50 transition-colors" onClick={() => setSelectedPage(page)}>
            <div className="flex flex-col space-y-1.5 p-6">
              <h3 className="font-semibold leading-none tracking-tight">{page.title}</h3>
              <p className="text-sm text-muted-foreground">/{page.slug} — {page.sections.length} sections</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
