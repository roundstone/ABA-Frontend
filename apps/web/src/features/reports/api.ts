import { ApiError } from '@/lib/api';
import { mockReportsList, mockReportCategories, mockExportJobs, mockScheduledReports } from './mocks';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function getReportCategories() {
  await delay(300);
  return { data: [...mockReportCategories] };
}

export async function getReportsList() {
  await delay(300);
  return { data: [...mockReportsList] };
}

export async function getExportJobs() {
  await delay(300);
  return { data: [...mockExportJobs] };
}

export async function getScheduledReports() {
  await delay(300);
  return { data: [...mockScheduledReports] };
}
