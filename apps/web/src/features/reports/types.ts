export interface ReportMetadata {
  id: string;
  title: string;
  description: string;
  category: string;
  isFavorite: boolean;
  lastViewed?: string;
  allowedRoles: string[];
}

export interface ReportCategory {
  id: string;
  name: string;
  description: string;
}

export type ExportFormat = 'CSV' | 'Excel' | 'PDF';
export type ExportStatus = 'Ready' | 'Generating' | 'Failed' | 'Expired';

export interface ReportExportJob {
  id: string;
  reportId: string;
  reportName: string;
  format: ExportFormat;
  status: ExportStatus;
  requestedAt: string;
  requestedBy: string;
  downloadUrl?: string;
  filters?: Record<string, any>;
  expiresAt?: string;
}

export interface ScheduledReport {
  id: string;
  reportId: string;
  reportName: string;
  frequency: 'Daily' | 'Weekly' | 'Monthly';
  nextRun: string;
  recipients: string[];
  format: ExportFormat;
  active: boolean;
}
