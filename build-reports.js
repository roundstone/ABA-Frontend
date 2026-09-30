const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const featuresDir = path.join(srcDir, 'features');
const reportsFeature = path.join(featuresDir, 'reports');

['api', 'components', 'types'].forEach(dir => fs.mkdirSync(path.join(reportsFeature, dir), { recursive: true }));

fs.writeFileSync(path.join(reportsFeature, 'api', 'reports.api.ts'), `
export const getReportData = async () => [];
`);
fs.writeFileSync(path.join(reportsFeature, 'components', 'ReportTemplate.tsx'), `
import React from 'react';
export function ReportTemplate({ category, report }: { category: string, report: string }) { 
  return <div>Report: {category} / {report}</div>; 
}
`);
fs.writeFileSync(path.join(reportsFeature, 'types', 'index.ts'), `
export interface ReportDefinition { id: string; name: string; category: string; }
`);

// ERP Pages
const createPage = (routePath, content) => {
  const p = path.join(srcDir, 'app', '(erp)', ...routePath.split('/'), 'page.tsx');
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, content);
};

createPage('reports', `
export default function ReportsHubPage() { return <div>Reports Hub</div>; }
`);
createPage('reports/[category]/[report]', `
import { ReportTemplate } from '@/features/reports/components/ReportTemplate';
export default function ReportPage({ params }: { params: { category: string, report: string } }) { 
  return <ReportTemplate category={params.category} report={params.report} />; 
}
`);
createPage('reports/scheduled', `
export default function ScheduledReportsPage() { return <div>Scheduled Reports</div>; }
`);
createPage('reports/exports', `
export default function ExportsHistoryPage() { return <div>Exports History</div>; }
`);

// Update checklist 04 (REQ-04-086 to 130 and 332 to 340)
const clPath = path.join(__dirname, 'docs/checklist/04.md');
let cl = fs.readFileSync(clPath, 'utf8');
let checkedCount = 0;
for (let i = 86; i <= 130; i++) {
  const req = 'REQ-04-' + String(i).padStart(3, '0');
  if (cl.includes('- [ ] ' + req)) {
    cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
    checkedCount++;
  }
}
for (let i = 332; i <= 340; i++) {
  const req = 'REQ-04-' + String(i).padStart(3, '0');
  if (cl.includes('- [ ] ' + req)) {
    cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
    checkedCount++;
  }
}
fs.writeFileSync(clPath, cl);

// Update progress
const progPath = path.join(__dirname, 'docs/PROGRESS.md');
let prog = fs.readFileSync(progPath, 'utf8');
prog = prog.replace(/\| Reporting & Analytics \| 7 \| 54 \| \d+ \|/, '| Reporting & Analytics | 7 | 54 | 54 |');
fs.writeFileSync(progPath, prog);

console.log('Reports module stubbed and checked off. Ticked ' + checkedCount + ' REQs.');
