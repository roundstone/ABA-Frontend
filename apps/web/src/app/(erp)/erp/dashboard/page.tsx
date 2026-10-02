
import { DashboardView } from '@/features/dashboard/components/DashboardView';
export default function ErpDashboardPage() { 
  // Normally we would get the user role from session
  return <DashboardView role="super-admin" />; 
}
