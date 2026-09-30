
import { ReportTemplate } from '@/features/reports/components/ReportTemplate';
export default function ReportPage({ params }: { params: { category: string, report: string } }) { 
  return <ReportTemplate category={params.category} report={params.report} />; 
}
