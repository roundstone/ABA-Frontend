
import React from 'react';
import { PagesEditor } from '../../content/components/PagesEditor';

export function SettingsForm({ section }: { section: string }) { 
  if (section === 'pages') return <PagesEditor />;
  return <div>Form for {section} Settings</div>; 
}
