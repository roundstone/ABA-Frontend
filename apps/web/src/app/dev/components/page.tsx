
import React from 'react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { AppShell } from '@/components/patterns/AppShell';

export default function ComponentGallery() {
  return (
    <div className="p-8 max-w-7xl mx-auto space-y-12">
      <a href="#main-content" className="sr-only focus:not-sr-only">Skip to main content</a>
      <h1 id="main-content" className="text-h1">ABA ERP Component Gallery</h1>
      <p className="text-body text-gray-600">A showcase of Phase 0 Foundation primitives and patterns.</p>
      
      <section className="space-y-4">
        <h2 className="text-h2">1. Buttons (Group B)</h2>
        <div className="flex gap-4">
          <Button aria-label="Primary action button">Primary</Button>
          <Button variant="secondary" aria-label="Secondary action button">Secondary</Button>
          <Button variant="outline" aria-label="Outline button">Outline</Button>
          <Button variant="destructive" aria-label="Destructive button">Destructive</Button>
          <Button disabled aria-disabled="true">Disabled</Button>
        </div>
      </section>

      <section className="space-y-4">
        <h2 className="text-h2">2. Status Badges (Group B)</h2>
        <div className="flex gap-4">
          <Badge>Default</Badge>
          <Badge variant="secondary">Secondary</Badge>
          <Badge variant="destructive">Destructive</Badge>
        </div>
      </section>

      <section className="space-y-4">
        <h2 className="text-h2">3. App Shell (Group D)</h2>
        <div className="h-[400px] border border-border rounded-lg overflow-hidden relative">
          <AppShell>
            <div className="p-4">Inner content</div>
          </AppShell>
        </div>
      </section>

      {/* Further components go here... */}
    </div>
  );
}
