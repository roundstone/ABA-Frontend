
import { AppShell } from '@/components/patterns/AppShell';

export default function ErpLayout({ children }: { children: React.ReactNode }) {
  return <AppShell>{children}</AppShell>;
}
