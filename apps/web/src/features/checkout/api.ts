import { ApiError } from '@/lib/api';
import { CheckoutAddressInput, CheckoutPaymentInput } from './schemas';
import { CheckoutSession } from './types';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function initializeCheckout(cartId: string): Promise<{ data: CheckoutSession }> {
  await delay(500);
  return { 
    data: {
      id: `chk_${Math.random().toString(36).substring(2, 9)}`,
      status: 'active',
      totalAmount: 42150000,
      createdAt: new Date().toISOString()
    }
  };
}

export async function processCheckout(
  sessionId: string,
  address: CheckoutAddressInput,
  payment: CheckoutPaymentInput
): Promise<{ data: { orderId: string, status: string } }> {
  await delay(1200);

  if (payment.method === 'wallet') {
    // Mock check for wallet balance
    const userBalance = 150000000; // 150k
    if (42150000 > userBalance) {
      throw new ApiError(400, 'Insufficient wallet balance', 'INSUFFICIENT_FUNDS');
    }
  }

  return {
    data: {
      orderId: `ORD-2026-${Math.random().toString(36).substring(2, 7).toUpperCase()}`,
      status: 'Processing'
    }
  };
}
