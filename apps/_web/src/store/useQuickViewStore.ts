import { create } from 'zustand';
import { Product } from '@/data/products';

interface QuickViewState {
  product: Product | null;
  setProduct: (product: Product | null) => void;
}

export const useQuickViewStore = create<QuickViewState>((set) => ({
  product: null,
  setProduct: (product) => set({ product }),
}));
