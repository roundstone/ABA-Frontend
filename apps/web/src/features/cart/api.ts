import { ApiError } from '@/lib/api';
import { Cart, CartItem } from './types';
import { mockCart } from './mocks';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function getCart(): Promise<{ data: Cart }> {
  await delay(400);
  return { data: mockCart };
}

export async function addToCart(item: Omit<CartItem, 'id'>): Promise<{ data: Cart }> {
  await delay(500);
  // Simulate adding item
  return { data: mockCart };
}

export async function updateCartItemQuantity(itemId: string, quantity: number): Promise<{ data: Cart }> {
  await delay(300);
  if (quantity < 1) {
    throw new ApiError(400, 'Quantity must be at least 1', 'BAD_REQUEST');
  }
  return { data: mockCart };
}

export async function removeFromCart(itemId: string): Promise<{ data: Cart }> {
  await delay(300);
  return { data: mockCart };
}

export async function clearCart(): Promise<{ data: Cart }> {
  await delay(300);
  return { data: { ...mockCart, items: [], subtotal: 0, deliveryFee: 0, total: 0 } };
}
