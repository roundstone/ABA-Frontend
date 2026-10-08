import { PayoutRequest, PayoutBatch, PayoutSettings } from './types';
import { mockPayouts, mockPayoutBatches, mockPayoutSettings } from './mocks';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

export async function getPayouts() {
  await delay(300);
  return { data: [...mockPayouts] };
}

export async function getPayout(id: string) {
  await delay(300);
  const payout = mockPayouts.find(p => p.id === id || p.payoutNumber === id);
  if (!payout) throw new Error('Payout not found');
  return { data: payout };
}

export async function getPayoutBatches() {
  await delay(300);
  return { data: [...mockPayoutBatches] };
}

export async function getPayoutSettings() {
  await delay(300);
  return { data: mockPayoutSettings };
}
