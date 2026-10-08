'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { useQuery } from '@tanstack/react-query';
import { getReportCategories, getReportsList } from '@/features/reports/api';
import Link from 'next/link';
import { FileBarChart2, Star, Clock } from 'lucide-react';
import { Button } from '@/components/ui/button';

export default function ReportHubPage() {
  const { data: categoriesData } = useQuery({ queryKey: ['report-categories'], queryFn: getReportCategories });
  const { data: reportsData } = useQuery({ queryKey: ['reports-list'], queryFn: getReportsList });

  const favorites = reportsData?.data.filter(r => r.isFavorite) || [];
  const recent = reportsData?.data.filter(r => r.lastViewed).sort((a, b) => new Date(b.lastViewed!).getTime() - new Date(a.lastViewed!).getTime()) || [];

  return (
    <div className="space-y-8 pb-20 mx-auto max-w-7xl">
      <PageHeader 
        title="Reports & Analytics" 
        description="Comprehensive insights across sales, inventory, finance, and operations."
        action={
          <div className="flex gap-2">
            <Link href="/erp/reports/scheduled">
              <Button variant="outline">Scheduled</Button>
            </Link>
            <Link href="/erp/reports/exports">
              <Button variant="outline">Export History</Button>
            </Link>
          </div>
        }
      />

      <div className="space-y-6">
        
        {favorites.length > 0 && (
          <section className="space-y-4">
            <div className="flex items-center gap-2">
              <Star className="w-5 h-5 text-warning" />
              <h2 className="text-xl font-bold">Favorites</h2>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {favorites.map(report => (
                <Link key={report.id} href={`/erp/reports/${report.category}/${report.id}`} className="group p-5 bg-surface rounded-xl border border-border hover:border-brand-300 transition-colors block h-full">
                  <div className="flex justify-between items-start mb-2">
                    <h3 className="font-semibold group-hover:text-brand-600 transition-colors">{report.title}</h3>
                    <Star className="w-4 h-4 text-warning fill-warning" />
                  </div>
                  <p className="text-sm text-text-muted">{report.description}</p>
                </Link>
              ))}
            </div>
          </section>
        )}

        {recent.length > 0 && (
          <section className="space-y-4">
            <div className="flex items-center gap-2">
              <Clock className="w-5 h-5 text-text-muted" />
              <h2 className="text-xl font-bold">Recently Viewed</h2>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              {recent.slice(0, 4).map(report => (
                <Link key={report.id} href={`/erp/reports/${report.category}/${report.id}`} className="p-4 bg-surface rounded-xl border border-border hover:border-brand-300 transition-colors block">
                  <h3 className="font-medium text-sm">{report.title}</h3>
                </Link>
              ))}
            </div>
          </section>
        )}

        <section className="space-y-6 pt-6 border-t border-border">
          <h2 className="text-xl font-bold">Report Catalogue</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {categoriesData?.data.map(category => {
              const catReports = reportsData?.data.filter(r => r.category === category.id) || [];
              if (catReports.length === 0) return null;

              return (
                <div key={category.id} className="space-y-4">
                  <div className="flex items-center gap-2 border-b border-border pb-2">
                    <FileBarChart2 className="w-5 h-5 text-brand-600" />
                    <h3 className="font-bold text-lg">{category.name}</h3>
                  </div>
                  <div className="space-y-2">
                    {catReports.map(report => (
                      <Link key={report.id} href={`/erp/reports/${category.id}/${report.id}`} className="flex justify-between items-center p-3 bg-surface hover:bg-surface-2 rounded-lg border border-transparent hover:border-border transition-colors">
                        <div>
                          <p className="font-medium text-sm">{report.title}</p>
                          <p className="text-xs text-text-muted">{report.description}</p>
                        </div>
                      </Link>
                    ))}
                  </div>
                </div>
              );
            })}
          </div>
        </section>

      </div>
    </div>
  );
}
