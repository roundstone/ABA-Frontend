import { Customer } from '../types';
import { CreateCustomerInput } from '../schemas';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_CUSTOMERS: Customer[] = [
  {
    id: 'cus-1',
    customerNo: 'CUS-1001',
    type: 'Individual',
    firstName: 'John',
    lastName: 'Doe',
    phone: '+2348012345678',
    email: 'john@example.com',
    customerGroup: 'Retail',
    referralCode: 'JD1001',
    addresses: [],
    creditLimit: 0,
    status: 'Active',
    registeredAt: '2026-09-01T10:00:00Z',
    ordersCount: 5,
    totalSpent: 12500000, // In kobo
    walletBalance: 500000,
    referralsCount: 2,
  },
  {
    id: 'cus-2',
    customerNo: 'CUS-1002',
    type: 'Business',
    firstName: 'Jane',
    lastName: 'Smith',
    companyName: 'Smith & Co',
    phone: '+2348087654321',
    customerGroup: 'Wholesale',
    referralCode: 'JS1002',
    addresses: [],
    creditLimit: 50000000,
    status: 'Active',
    registeredAt: '2026-09-10T10:00:00Z',
    ordersCount: 12,
    totalSpent: 450000000,
    walletBalance: 0,
    referralsCount: 0,
  }
];

export const getCustomers = async (): Promise<Customer[]> => {
  await delay(800);
  return MOCK_CUSTOMERS;
};

export const getCustomerById = async (id: string): Promise<Customer> => {
  await delay(500);
  const customer = MOCK_CUSTOMERS.find(c => c.id === id);
  if (!customer) throw new Error('Customer not found');
  return customer;
};

export const createCustomer = async (data: CreateCustomerInput): Promise<Customer> => {
  await delay(1000);
  if (data.phone === '+2348000000000') throw new Error('Customer with this phone exists');

  const newCustomer: Customer = {
    id: `cus-${Date.now()}`,
    customerNo: `CUS-${Math.floor(Math.random() * 9000) + 1000}`,
    type: data.type,
    firstName: data.firstName,
    lastName: data.lastName,
    companyName: data.companyName,
    phone: data.phone,
    email: data.email,
    customerGroup: data.customerGroup,
    merchantId: data.merchantId,
    referredBy: data.referredBy,
    referralCode: `REF-${Math.floor(Math.random() * 9000)}`,
    addresses: data.addresses?.map(a => ({ id: `add-${Date.now()}`, ...a })) || [],
    creditLimit: data.creditLimit,
    notes: data.notes,
    status: 'Active',
    registeredAt: new Date().toISOString(),
    ordersCount: 0,
    totalSpent: 0,
    walletBalance: 0,
    referralsCount: 0,
  };

  MOCK_CUSTOMERS.unshift(newCustomer);
  return newCustomer;
};
