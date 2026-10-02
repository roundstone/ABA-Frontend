import { Supplier } from '../types';
import { CreateSupplierInput } from '../schemas';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_SUPPLIERS: Supplier[] = [
  {
    id: 'sup-1',
    supplierNo: 'VEN-2001',
    companyName: 'Lagos Textile Mills',
    type: 'Local',
    taxId: 'TIN-987654321',
    categories: ['Fabric', 'Threads'],
    contactPerson: 'Mrs. Chika Obi',
    phone: '+2348011112222',
    email: 'sales@lagostextiles.com',
    address: 'Plot 4, Industrial Estate',
    city: 'Ikeja',
    state: 'Lagos',
    country: 'Nigeria',
    paymentTerms: 'Net 30',
    currency: 'NGN',
    leadTimeDays: 7,
    creditLimit: 1000000000, // 10m NGN
    bankDetails: { bankName: 'Zenith Bank', accountNumber: '0123456789', accountName: 'Lagos Textile Mills' },
    status: 'Active',
    totalPurchases12m: 4500000000, // 45m NGN
    outstandingBalance: 250000000, // 2.5m NGN
    overduePayable: 0,
    rating: 4.8,
  },
  {
    id: 'sup-2',
    supplierNo: 'VEN-2002',
    companyName: 'Guangzhou Fabrics Co.',
    type: 'International',
    categories: ['Fabric', 'Hardware'],
    contactPerson: 'Li Wei',
    phone: '+8613912345678',
    email: 'export@gzfabrics.cn',
    address: 'No. 8 Textile Road, Haizhu District',
    city: 'Guangzhou',
    state: 'Guangdong',
    country: 'China',
    paymentTerms: 'Immediate',
    currency: 'USD',
    incoterms: 'FOB',
    leadTimeDays: 45,
    creditLimit: 0,
    status: 'Active',
    totalPurchases12m: 1250000000,
    outstandingBalance: 0,
    overduePayable: 0,
    rating: 4.2,
  },
  {
    id: 'sup-3',
    supplierNo: 'VEN-2003',
    companyName: 'Packaging Solutions Ltd',
    type: 'Local',
    categories: ['Packaging'],
    contactPerson: 'David Peters',
    phone: '+2348033334444',
    email: 'hello@packagingsol.com',
    address: '12 Box Street',
    city: 'Apapa',
    state: 'Lagos',
    country: 'Nigeria',
    paymentTerms: 'Net 14',
    currency: 'NGN',
    leadTimeDays: 3,
    creditLimit: 50000000,
    status: 'On hold',
    totalPurchases12m: 150000000,
    outstandingBalance: 50000000,
    overduePayable: 50000000, // Overdue triggers On hold
    rating: 2.5,
  }
];

export const getSuppliers = async (): Promise<Supplier[]> => {
  await delay(800);
  return MOCK_SUPPLIERS;
};

export const getSupplierById = async (id: string): Promise<Supplier> => {
  await delay(500);
  const supplier = MOCK_SUPPLIERS.find(s => s.id === id);
  if (!supplier) throw new Error('Supplier not found');
  return supplier;
};

export const createSupplier = async (data: CreateSupplierInput): Promise<Supplier> => {
  await delay(1000);
  
  let bankDetails;
  if (data.bankName && data.accountNumber && data.accountName) {
    bankDetails = {
      bankName: data.bankName,
      accountNumber: data.accountNumber,
      accountName: data.accountName,
    };
  }
  
  const newSupplier: Supplier = {
    id: `sup-${Date.now()}`,
    supplierNo: `VEN-${Math.floor(Math.random() * 9000) + 2000}`,
    categories: [], // Selected later via category mapper
    ...data,
    bankDetails,
    status: 'Active',
    totalPurchases12m: 0,
    outstandingBalance: 0,
    overduePayable: 0,
    rating: 0, // Unrated initially
  };

  MOCK_SUPPLIERS.unshift(newSupplier);
  return newSupplier;
};
