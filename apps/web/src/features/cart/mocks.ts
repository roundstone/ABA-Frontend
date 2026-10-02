import { Cart } from './types';

export const mockCart: Cart = {
  id: 'cart-1',
  items: [
    {
      id: 'item-1',
      productId: 'prod-1',
      productName: 'Apple Watch Series 9 GPS 45mm',
      productImage: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&w=150&q=80',
      merchantId: 'merch-1',
      merchantName: 'Global Tech Store',
      price: 42000000,
      quantity: 1,
      attributes: { Color: 'Midnight', Size: '45mm' }
    }
  ],
  subtotal: 42000000,
  deliveryFee: 150000,
  total: 42150000
};
