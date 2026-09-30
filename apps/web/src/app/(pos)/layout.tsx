
import { PosShell } from '@/features/pos/components/PosShell';
export default function PosLayout({ children }: { children: React.ReactNode }) {
  return <PosShell>{children}</PosShell>;
}
