'use client';

import { AppShell } from '@/components/patterns/AppShell';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Tabs, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { usePathname, useRouter } from 'next/navigation';

export default function AccountLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const router = useRouter();

  // Determine active tab based on current path
  let activeTab = 'profile';
  if (pathname.includes('/security')) activeTab = 'security';
  if (pathname.includes('/sessions')) activeTab = 'sessions';
  if (pathname.includes('/notifications')) activeTab = 'notifications';

  const handleTabChange = (val: string) => {
    router.push(`/account/${val}`);
  };

  return (
    <AppShell>
      <PageHeader 
        title="My Account" 
        description="Manage your profile, security settings, and notifications."
      />
      
      <div className="mt-6 mb-8 border-b border-border">
        <Tabs value={activeTab} onValueChange={handleTabChange}>
          <TabsList className="bg-transparent h-auto p-0 border-b-0 space-x-6">
            <TabsTrigger 
              value="profile" 
              className="data-[state=active]:bg-transparent data-[state=active]:shadow-none data-[state=active]:border-b-2 data-[state=active]:border-primary rounded-none px-1 py-3 text-sm"
            >
              Profile
            </TabsTrigger>
            <TabsTrigger 
              value="security"
              className="data-[state=active]:bg-transparent data-[state=active]:shadow-none data-[state=active]:border-b-2 data-[state=active]:border-primary rounded-none px-1 py-3 text-sm"
            >
              Security
            </TabsTrigger>
            <TabsTrigger 
              value="sessions"
              className="data-[state=active]:bg-transparent data-[state=active]:shadow-none data-[state=active]:border-b-2 data-[state=active]:border-primary rounded-none px-1 py-3 text-sm"
            >
              Sessions
            </TabsTrigger>
            <TabsTrigger 
              value="notifications"
              className="data-[state=active]:bg-transparent data-[state=active]:shadow-none data-[state=active]:border-b-2 data-[state=active]:border-primary rounded-none px-1 py-3 text-sm"
            >
              Notifications
            </TabsTrigger>
          </TabsList>
        </Tabs>
      </div>

      <div className="max-w-4xl pb-16">
        {children}
      </div>
    </AppShell>
  );
}
