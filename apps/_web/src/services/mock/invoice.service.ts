export interface Invoice {
  id: string;
  invoiceId: string;
  date: string;
  shipping: number;
  amount: number;
  tax: number;
  total: number;
}

const STORAGE_KEY = 'aba_mock_invoices';

const defaultInvoices: Invoice[] = [
  { id: '1', invoiceId: '50765', date: '15-03-2021', shipping: 8.4, amount: 146, tax: 70, total: 225.4 },
  { id: '2', invoiceId: '50764', date: '01-01-2021', shipping: 3.62, amount: 816, tax: 65.28, total: 884.16 },
  { id: '3', invoiceId: '50766', date: '28-04-2021', shipping: 7.3, amount: 47, tax: 724, total: 789 },
  { id: '4', invoiceId: '50767', date: '31-04-2021', shipping: 2.00, amount: 478, tax: 35, total: 512 },
  { id: '5', invoiceId: '50768', date: '02-05-2021', shipping: 1.5, amount: 1460, tax: 45.32, total: 1515 },
  { id: '6', invoiceId: '50769', date: '03-05-2021', shipping: 8.45, amount: 768, tax: 17, total: 780 },
];

export const InvoiceService = {
  getInvoices(): Invoice[] {
    if (typeof window === 'undefined') return defaultInvoices;
    const stored = localStorage.getItem(STORAGE_KEY);
    if (!stored) {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(defaultInvoices));
      return defaultInvoices;
    }
    return JSON.parse(stored);
  },

  deleteInvoice(id: string): void {
    if (typeof window === 'undefined') return;
    const invoices = this.getInvoices();
    const updated = invoices.filter(i => i.id !== id);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(updated));
  }
};
