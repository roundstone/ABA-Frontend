
import { SettingsLayout } from '@/features/settings/components/SettingsLayout';
import { SettingsForm } from '@/features/settings/components/SettingsForm';
export default function SettingsPage() { 
  return <SettingsLayout><SettingsForm section="company" /></SettingsLayout>; 
}
