import React from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

export default function GalleryPage() {
  return (
    <div className="p-8 max-w-4xl mx-auto space-y-12">
      <h1 className="text-3xl font-bold mb-8">Component Gallery (Group B)</h1>
      
      <section className="space-y-4">
        <h2 className="text-xl font-semibold border-b pb-2">Button</h2>
        <div className="flex flex-wrap gap-4 items-center">
          <Button variant="primary">Primary</Button>
          <Button variant="secondary">Secondary</Button>
          <Button variant="ghost">Ghost</Button>
          <Button variant="destructive">Destructive</Button>
          <Button variant="link">Link</Button>
        </div>
        <div className="flex flex-wrap gap-4 items-center mt-4">
          <Button size="sm">Small (32px)</Button>
          <Button size="md">Medium (40px)</Button>
          <Button size="lg">Large (48px)</Button>
        </div>
        <div className="flex flex-wrap gap-4 items-center mt-4">
          <Button loading>Loading state</Button>
          <Button disabled>Disabled</Button>
          <Button size="icon" aria-label="Icon only">★</Button>
        </div>
      </section>

      <section className="space-y-4">
        <h2 className="text-xl font-semibold border-b pb-2">Input</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Input label="Text Input" placeholder="Standard text..." />
          <Input label="Email Input" type="email" placeholder="user@example.com" />
          <Input label="Password" type="password" placeholder="Enter password" />
          <Input label="Currency" type="currency" placeholder="0.00" />
          <Input label="Phone" type="phone" placeholder="800 000 0000" />
          <Input label="With Error" error="This field is required" placeholder="Error state" />
        </div>
      </section>

      <section className="space-y-4">
        <h2 className="text-xl font-semibold border-b pb-2">Notice</h2>
        <p className="text-muted-foreground">
          Due to session size constraints, only Button and Input are implemented in this session.
          The remaining components (Select, Combobox, DatePicker, etc.) will be built in subsequent sessions.
        </p>
      </section>
    </div>
  );
}
