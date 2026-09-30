
import { SettingsLayout } from '@/features/settings/components/SettingsLayout';
import { SettingsForm } from '@/features/settings/components/SettingsForm';
export default function SettingsSectionPage({ params }: { params: { section: string } }) { 
  return <SettingsLayout><SettingsForm section={params.section} /></SettingsLayout>; 
}
