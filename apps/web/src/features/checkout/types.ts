export interface CheckoutSession {
  id: string;
  status: 'active' | 'completed' | 'failed';
  totalAmount: number;
  createdAt: string;
}
