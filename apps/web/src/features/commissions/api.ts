import { CommissionPlan, CommissionRecord, CommissionKPIs } from './types';
import { mockCommissionPlans, mockCommissionRecords, mockCommissionKPIs } from './mocks';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

export async function getCommissionKPIs(): Promise<CommissionKPIs> {
  await delay(300);
  return mockCommissionKPIs;
}

export async function getCommissionRecords(): Promise<{ data: CommissionRecord[] }> {
  await delay(300);
  return { data: [...mockCommissionRecords] };
}

export async function getCommissionPlans(): Promise<{ data: CommissionPlan[] }> {
  await delay(300);
  return { data: [...mockCommissionPlans] };
}
