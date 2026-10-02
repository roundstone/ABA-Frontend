'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';
import { toast } from 'sonner';

// Mock Data
const CATEGORIES = ['All', 'Chairs', 'Desks', 'Tables', 'Storage', 'Accessories'];

const MOCK_PRODUCTS = [
  { id: 'p1', name: 'Ergo Office Chair', sku: 'FURN-CHR-01', price: 8500000, stock: 12, category: 'Chairs' },
  { id: 'p2', name: 'Executive Leather Chair', sku: 'FURN-CHR-02', price: 15000000, stock: 4, category: 'Chairs' },
  { id: 'p3', name: 'Standing Desk Pro', sku: 'FURN-DSK-01', price: 21000000, stock: 8, category: 'Desks' },
  { id: 'p4', name: 'Basic Office Desk', sku: 'FURN-DSK-02', price: 5500000, stock: 20, category: 'Desks' },
  { id: 'p5', name: 'Meeting Table (6 pax)', sku: 'FURN-TBL-01', price: 18000000, stock: 2, category: 'Tables' },
  { id: 'p6', name: 'Filing Cabinet', sku: 'FURN-STR-01', price: 4200000, stock: 15, category: 'Storage' },
  { id: 'p7', name: 'Monitor Arm', sku: 'FURN-ACC-01', price: 2500000, stock: 30, category: 'Accessories' },
  { id: 'p8', name: 'Desk Mat', sku: 'FURN-ACC-02', price: 800000, stock: 50, category: 'Accessories' },
];

interface CartItem {
  id: string;
  productId: string;
  name: string;
  price: number; // minor units
  quantity: number;
}

export default function PosSellPage() {
  const router = useRouter();
  const [search, setSearch] = useState('');
  const [activeCategory, setActiveCategory] = useState('All');

  const [cart, setCart] = useState<CartItem[]>([]);
  const [customer, setCustomer] = useState<{ name: string } | null>(null);

  const filteredProducts = MOCK_PRODUCTS.filter(p => {
    const matchesCat = activeCategory === 'All' || p.category === activeCategory;
    const matchesSearch = p.name.toLowerCase().includes(search.toLowerCase()) || p.sku.toLowerCase().includes(search.toLowerCase());
    return matchesCat && matchesSearch;
  });

  const addToCart = (product: any) => {
    setCart(prev => {
      const existing = prev.find(item => item.productId === product.id);
      if (existing) {
        return prev.map(item => item.productId === product.id ? { ...item, quantity: item.quantity + 1 } : item);
      }
      return [...prev, { id: `ci-${Date.now()}`, productId: product.id, name: product.name, price: product.price, quantity: 1 }];
    });
  };

  const updateQuantity = (id: string, delta: number) => {
    setCart(prev => prev.map(item => {
      if (item.id === id) {
        const newQty = item.quantity + delta;
        return { ...item, quantity: Math.max(0, newQty) };
      }
      return item;
    }).filter(item => item.quantity > 0));
  };

  // Financials
  const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const tax = subtotal * 0.075; // 7.5% VAT
  const total = subtotal + tax;

  const handleCheckout = () => {
    if (cart.length === 0) return;
    toast.info('Opening payment modal...');
    // In a real flow, this opens a modal or navigates to a payment processing view
    setTimeout(() => {
      toast.success('Payment successful!');
      setCart([]);
      setCustomer(null);
    }, 1500);
  };

  return (
    <div className="flex h-full overflow-hidden bg-surface-2">

      {/* Left Pane: Product Browser */}
      <div className="flex-1 flex flex-col min-w-0 border-r border-border">

        {/* Search & Filters */}
        <div className="p-4 bg-surface border-b border-border space-y-3 shrink-0">
          <Input
            placeholder="Search by product name or SKU (or scan barcode)..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full text-lg h-12"
          />
          <div className="flex gap-2 overflow-x-auto no-scrollbar pb-1">
            {CATEGORIES.map(cat => (
              <button
                key={cat}
                onClick={() => setActiveCategory(cat)}
                className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors ${activeCategory === cat
                    ? 'bg-primary text-white'
                    : 'bg-surface-2 text-text-muted hover:bg-border'
                  }`}
              >
                {cat}
              </button>
            ))}
          </div>
        </div>

        {/* Product Grid */}
        <div className="flex-1 overflow-y-auto p-4">
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {filteredProducts.map(p => (
              <button
                key={p.id}
                onClick={() => addToCart(p)}
                className="bg-surface p-4 rounded-xl border border-border text-left hover:border-primary hover:shadow-md transition-all group flex flex-col h-full"
              >
                <div className="w-full aspect-video bg-surface-2 rounded-lg mb-3 flex items-center justify-center text-2xl group-hover:bg-primary/5 transition-colors">
                  📦
                </div>
                <div className="flex-1">
                  <h3 className="font-medium text-sm leading-tight mb-1">{p.name}</h3>
                  <p className="text-xs font-mono text-text-muted mb-2">{p.sku}</p>
                </div>
                <div className="flex items-center justify-between mt-2 pt-2 border-t border-border">
                  <span className="font-medium text-primary"><AmountText amountInKobo={p.price} /></span>
                  <span className={`text-[10px] px-1.5 py-0.5 rounded font-medium ${p.stock > 5 ? 'bg-surface-2 text-text-muted' : 'bg-warning-bg text-warning-dark'}`}>
                    {p.stock} in stock
                  </span>
                </div>
              </button>
            ))}
          </div>
          {filteredProducts.length === 0 && (
            <div className="h-full flex items-center justify-center text-text-muted">
              No products found.
            </div>
          )}
        </div>
      </div>

      {/* Right Pane: Cart & Checkout */}
      <div className="w-[400px] flex flex-col bg-surface shrink-0">

        {/* Customer Header */}
        <div className="p-4 border-b border-border bg-surface-2 flex items-center justify-between shrink-0">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-border flex items-center justify-center text-text-muted">
              👤
            </div>
            <div>
              <p className="text-sm font-medium">{customer ? customer.name : 'Walk-in Customer'}</p>
              <button className="text-xs text-primary hover:underline">
                {customer ? 'Change Customer' : 'Add Customer'}
              </button>
            </div>
          </div>
          <Button variant="ghost" size="sm" className="h-8">Options</Button>
        </div>

        {/* Cart Items */}
        <div className="flex-1 overflow-y-auto p-4 space-y-3">
          {cart.length === 0 ? (
            <div className="h-full flex flex-col items-center justify-center text-text-muted text-center p-6 space-y-4">
              <div className="text-4xl">🛒</div>
              <p>Cart is empty. Tap products to add them to the sale.</p>
            </div>
          ) : (
            cart.map(item => (
              <div key={item.id} className="flex flex-col gap-2 p-3 rounded-lg border border-border bg-surface-2">
                <div className="flex justify-between items-start">
                  <div className="pr-4">
                    <p className="font-medium text-sm leading-tight">{item.name}</p>
                    <p className="text-xs text-text-muted mt-0.5"><AmountText amountInKobo={item.price} /> each</p>
                  </div>
                  <span className="font-medium text-sm"><AmountText amountInKobo={item.price * item.quantity} /></span>
                </div>
                <div className="flex items-center justify-between mt-2">
                  <button className="text-xs text-text-muted hover:text-text hover:underline">Add discount</button>
                  <div className="flex items-center bg-surface rounded border border-border">
                    <button
                      onClick={() => updateQuantity(item.id, -1)}
                      className="w-8 h-8 flex items-center justify-center hover:bg-surface-2 transition-colors border-r border-border text-lg"
                    >
                      -
                    </button>
                    <span className="w-10 h-8 flex items-center justify-center font-medium text-sm">
                      {item.quantity}
                    </span>
                    <button
                      onClick={() => updateQuantity(item.id, 1)}
                      className="w-8 h-8 flex items-center justify-center hover:bg-surface-2 transition-colors border-l border-border text-lg"
                    >
                      +
                    </button>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>

        {/* Financials & Action Block */}
        <div className="p-4 bg-surface border-t border-border shadow-[0_-4px_10px_rgba(0,0,0,0.02)] shrink-0">
          <div className="space-y-2 mb-4">
            <div className="flex justify-between text-sm text-text-muted">
              <span>Subtotal</span>
              <span><AmountText amountInKobo={subtotal} /></span>
            </div>
            <div className="flex justify-between text-sm text-text-muted">
              <span>VAT (7.5%)</span>
              <span><AmountText amountInKobo={tax} /></span>
            </div>
            <div className="flex justify-between text-lg font-bold pt-2 border-t border-border">
              <span>Total</span>
              <span className="text-primary"><AmountText amountInKobo={total} /></span>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-2 mb-2">
            <Button variant="outline" className="h-12" disabled={cart.length === 0}>Hold Sale</Button>
            <Button variant="outline" className="h-12 text-error hover:bg-error-bg hover:text-error hover:border-error-border" onClick={() => setCart([])} disabled={cart.length === 0}>
              Clear
            </Button>
          </div>
          <Button
            size="lg"
            className="w-full h-16 text-lg font-bold"
            disabled={cart.length === 0}
            onClick={handleCheckout}
          >
            Pay <AmountText amountInKobo={total} />
          </Button>
        </div>

      </div>

    </div>
  );
}
