
import React from 'react';
export function ReportTemplate({ category, report }: { category: string, report: string }) { 
  return <div>Report: {category} / {report}</div>; 
}
