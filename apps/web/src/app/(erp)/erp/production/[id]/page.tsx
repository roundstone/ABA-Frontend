'use client';

import { useParams } from 'next/navigation';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

export default function ProductionDetailPage() {
  const params = useParams();
  const id = params.id as string;

  return (
    <div className="space-y-6 pb-20 max-w-5xl mx-auto">
      <div className="flex items-center justify-between">
        <div>
          <div className="flex items-center gap-3 mb-1">
            <h1 className="text-h3 font-mono">{id || 'MFG-2003'}</h1>
            <span className="bg-warning-bg text-warning-dark border-warning-border border px-2 py-0.5 rounded text-xs font-medium">
              In Progress
            </span>
          </div>
          <p className="text-sm text-text-muted">Started Sept 30, 2026 • Target: 500 Bags of Parboiled Rice 25kg</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline">Pause Run</Button>
          <Button className="bg-success hover:bg-success-dark text-white">Complete & Yield</Button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        {/* Main Content */}
        <div className="md:col-span-2 space-y-6">
          
          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="px-6 py-4 border-b border-border bg-surface-2 flex justify-between items-center">
              <h3 className="font-medium">Raw Material Consumption</h3>
              <Button variant="outline" size="sm" className="h-7 text-xs">Record Consumption</Button>
            </div>
            <table className="w-full text-sm text-left">
              <thead className="bg-surface text-text-muted border-b border-border">
                <tr>
                  <th className="px-6 py-3 font-medium">Material</th>
                  <th className="px-6 py-3 font-medium text-right">Target</th>
                  <th className="px-6 py-3 font-medium text-right">Consumed</th>
                  <th className="px-6 py-3 font-medium text-right">Variance</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                <tr>
                  <td className="px-6 py-4 font-medium">Raw Paddy Rice (Tons)</td>
                  <td className="px-6 py-4 text-right text-text-muted">14.50</td>
                  <td className="px-6 py-4 text-right font-medium">12.00</td>
                  <td className="px-6 py-4 text-right"></td>
                </tr>
                <tr>
                  <td className="px-6 py-4 font-medium">Packaging Sacks 25kg</td>
                  <td className="px-6 py-4 text-right text-text-muted">505</td>
                  <td className="px-6 py-4 text-right font-medium">250</td>
                  <td className="px-6 py-4 text-right"></td>
                </tr>
              </tbody>
            </table>
          </div>

          <div className="bg-surface rounded-xl border border-border overflow-hidden">
            <div className="px-6 py-4 border-b border-border bg-surface-2 flex justify-between items-center">
              <h3 className="font-medium">Finished Goods Yield</h3>
              <Button variant="outline" size="sm" className="h-7 text-xs">Record Output</Button>
            </div>
            <div className="p-6">
              <div className="flex justify-between items-center p-4 border border-success-border bg-success-bg rounded-lg">
                <div>
                  <p className="font-medium text-success-dark">Parboiled Rice 25kg</p>
                  <p className="text-xs text-success-dark/80 mt-1">Current total yield from this run</p>
                </div>
                <div className="text-right">
                  <span className="text-2xl font-bold text-success-dark">240</span>
                  <span className="text-success-dark/80 text-sm ml-1">/ 500 target</span>
                </div>
              </div>
            </div>
          </div>

        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          <div className="bg-surface rounded-xl border border-border p-6">
            <h3 className="font-medium mb-4">Run Details</h3>
            <dl className="space-y-4 text-sm">
              <div>
                <dt className="text-text-muted text-xs mb-1">Location</dt>
                <dd className="font-medium">HQ Mill (Lagos)</dd>
              </div>
              <div>
                <dt className="text-text-muted text-xs mb-1">Supervisor</dt>
                <dd className="font-medium">David Mark</dd>
              </div>
              <div>
                <dt className="text-text-muted text-xs mb-1">Formula (BOM)</dt>
                <dd className="font-mono text-xs text-primary cursor-pointer hover:underline">BOM-PB25-V2</dd>
              </div>
            </dl>
          </div>
        </div>

      </div>
    </div>
  );
}
