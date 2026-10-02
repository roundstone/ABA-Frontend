import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { CartItem } from './types';
import * as cartApi from './api';

interface CartState {
  items: CartItem[];
  subtotal: number;
  deliveryFee: number;
  total: number;
  isSyncing: boolean;
  
  // Actions
  addToCart: (item: Omit<CartItem, 'id'>) => Promise<void>;
  removeFromCart: (itemId: string) => Promise<void>;
  updateQuantity: (itemId: string, quantity: number) => Promise<void>;
  clearCart: () => Promise<void>;
  syncWithServer: () => Promise<void>;
  getTotalItems: () => number;
}

const calculateTotals = (items: CartItem[]) => {
  const subtotal = items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const deliveryFee = items.length > 0 ? 150000 : 0; // Flat 1,500 NGN for mock
  const total = subtotal + deliveryFee;
  return { subtotal, deliveryFee, total };
};

export const useCartStore = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],
      subtotal: 0,
      deliveryFee: 0,
      total: 0,
      isSyncing: false,

      getTotalItems: () => {
        return get().items.reduce((total, item) => total + item.quantity, 0);
      },

      addToCart: async (newItem) => {
        set({ isSyncing: true });
        try {
          // Optimistic local update
          const { items } = get();
          const existingItemIndex = items.findIndex(
            i => i.productId === newItem.productId && 
                 JSON.stringify(i.attributes) === JSON.stringify(newItem.attributes)
          );
          
          let updatedItems = [...items];
          if (existingItemIndex >= 0) {
            updatedItems[existingItemIndex].quantity += newItem.quantity;
          } else {
            updatedItems.push({
              ...newItem,
              id: `cart-item-${Date.now()}` // Mock local ID
            });
          }
          
          const totals = calculateTotals(updatedItems);
          set({ items: updatedItems, ...totals });

          // API sync (non-blocking for UI responsiveness)
          cartApi.addToCart(newItem).catch(console.error);
        } finally {
          set({ isSyncing: false });
        }
      },

      removeFromCart: async (itemId) => {
        set({ isSyncing: true });
        try {
          const updatedItems = get().items.filter(i => i.id !== itemId);
          set({ items: updatedItems, ...calculateTotals(updatedItems) });
          cartApi.removeFromCart(itemId).catch(console.error);
        } finally {
          set({ isSyncing: false });
        }
      },

      updateQuantity: async (itemId, quantity) => {
        set({ isSyncing: true });
        try {
           const updatedItems = get().items.map(i => i.id === itemId ? { ...i, quantity } : i);
           set({ items: updatedItems, ...calculateTotals(updatedItems) });
           cartApi.updateCartItemQuantity(itemId, quantity).catch(console.error);
        } finally {
           set({ isSyncing: false });
        }
      },

      clearCart: async () => {
        set({ isSyncing: true });
        try {
          set({ items: [], subtotal: 0, deliveryFee: 0, total: 0 });
          cartApi.clearCart().catch(console.error);
        } finally {
          set({ isSyncing: false });
        }
      },

      syncWithServer: async () => {
        set({ isSyncing: true });
        try {
          const { data } = await cartApi.getCart();
          set({ 
            items: data.items, 
            subtotal: data.subtotal, 
            deliveryFee: data.deliveryFee, 
            total: data.total 
          });
        } catch (error) {
          console.error('Failed to sync cart:', error);
        } finally {
          set({ isSyncing: false });
        }
      }
    }),
    {
      name: 'aba-cart-storage',
    }
  )
);
