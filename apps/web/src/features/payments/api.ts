import { Payment } from './types';
import { mockPayments, mockPaymentKPIs, mockRefunds } from './mocks';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

export async function getPayments(): Promise<{ data: Payment[] }> {
  await delay(300);
  return { data: [...mockPayments] };
}

export async function getPaymentKPIs() {
  await delay(300);
  return mockPaymentKPIs;
}

export async function getRefunds() {
  await delay(300);
  return { data: [...mockRefunds] };
}
