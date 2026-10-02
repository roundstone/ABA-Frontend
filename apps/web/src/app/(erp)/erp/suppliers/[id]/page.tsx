'use client';

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { getSupplierById } from '@/features/suppliers/api/suppliers.api';
import { Supplier } from '@/features/suppliers/types';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';
import { DataTable } from '@/components/patterns/DataTable';
import { toast } from 'sonner';

const TABS = ['Overview', 'Products', 'Purchase Orders', 'Invoices', 'Payments', 'Performance', 'Documents', 'Activity'];

export default function SupplierDetailsPage() {
  const params = useParams();
  const router = useRouter();
  const id = params.id as string;

  const [supplier, setSupplier] = useState<Supplier | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('Overview');

  useEffect(() => {
    getSupplierById(id)
      .then(setSupplier)
      .catch(() => {
        toast.error('Supplier not found');
        router.push('/suppliers');
      })
      .finally(() => setIsLoading(false));
  }, [id, router]);

  if (isLoading) {
    return <div className="p-8 text-center text-text-muted">Loading supplier details...</div>;
  }

  if (!supplier) return null;

  let statusColor = 'bg-surface-2 text-text-muted border-border';
  if (supplier.status === 'Active') statusColor = 'bg-success-bg text-success border-success-border';
  if (supplier.status === 'On hold') statusColor = 'bg-warning-bg text-warning-dark border-warning-border';
  if (supplier.status === 'Blacklisted') statusColor = 'bg-error-bg text-error border-error-border';

  const renderStars = (rating: number) => {
    if (rating === 0) return <span className="text-xs text-text-muted ml-2">Unrated</span>;
    return (
      <div className="flex items-center gap-1 ml-3 px-2 py-0.5 rounded bg-surface-2 border border-border">
        <span className="text-warning-dark text-xs">★</span>
        <span className="text-xs font-medium">{rating.toFixed(1)}</span>
      </div>
    );
  };

  // Mock supplied products
  const mockProducts = [
    { id: '1', sku: 'RAW-COT-01', name: 'Raw Cotton 100%', lastPrice: 150000, currency: supplier.currency, moq: 100, leadTime: supplier.leadTimeDays },
    { id: '2', sku: 'RAW-DYE-BL', name: 'Blue Dye (Industrial)', lastPrice: 45000, currency: supplier.currency, moq: 10, leadTime: supplier.leadTimeDays + 2 },
  ];

  const productColumns = [
    { 
      accessorKey: 'name', 
      header: 'Product',
      cell: (info: any) => (
        <div>
          <div className="font-medium">{info.getValue()}</div>
          <div className="text-xs text-text-muted">{info.row.original.sku}</div>
        </div>
      )
    },
    { 
      accessorKey: 'lastPrice', 
      header: 'Last Purchase Price', 
      cell: (info: any) => <AmountText amountInKobo={info.getValue()} /> 
    },
    { accessorKey: 'moq', header: 'MOQ' },
    { accessorKey: 'leadTime', header: 'Lead Time (Days)' },
    {
      id: 'actions',
      header: '',
      cell: () => <Button variant="ghost" size="sm">Remove Link</Button>
    }
  ];

  return (
    <div className="space-y-6 pb-20">
      
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-start justify-between gap-4">
        <div>
          <div className="flex items-center gap-3 mb-1">
            <h1 className="text-h3">{supplier.companyName}</h1>
            <span className={`px-2 py-0.5 rounded text-xs font-medium border ${statusColor}`}>
              {supplier.status}
            </span>
            <span className="px-2 py-0.5 rounded text-xs bg-primary/10 text-primary border border-primary/20">
              {supplier.type}
            </span>
            {renderStars(supplier.rating)}
          </div>
          <div className="flex items-center gap-4 text-sm text-text-muted">
            <span className="font-mono">{supplier.supplierNo}</span>
            <span>•</span>
            <span>{supplier.city}, {supplier.country}</span>
          </div>
        </div>

        <div className="flex gap-2">
          <Button variant="outline">Statement</Button>
          <Button variant="outline" className="border-primary text-primary hover:bg-primary/5">Record Payment</Button>
          <Button>New PO</Button>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
        <KpiCard title="Outstanding Balance" value={<AmountText amountInKobo={supplier.outstandingBalance} />} />
        <KpiCard 
          title="Overdue Payable" 
          value={<AmountText amountInKobo={supplier.overduePayable} />} 
          className={supplier.overduePayable > 0 ? "text-error" : ""} 
        />
        <KpiCard title="Total Spend (12m)" value={<AmountText amountInKobo={supplier.totalPurchases12m} />} />
        <KpiCard title="On-time Delivery" value={supplier.rating > 0 ? "94%" : "N/A"} />
        <KpiCard title="Open POs" value="0" />
      </div>

      {/* Tabs Navigation */}
      <div className="border-b border-border flex overflow-x-auto no-scrollbar">
        {TABS.map(tab => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-4 py-3 text-sm font-medium whitespace-nowrap border-b-2 transition-colors ${
              activeTab === tab 
                ? 'border-primary text-primary' 
                : 'border-transparent text-text-muted hover:text-text hover:border-border'
            }`}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* Tab Content */}
      <div className="pt-2">
        
        {activeTab === 'Overview' && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            
            <div className="space-y-6">
              {/* Contact & Location */}
              <div className="bg-surface p-6 rounded-xl border border-border">
                <div className="flex justify-between items-center mb-4">
                  <h3 className="text-h4">Contact & Location</h3>
                  <Button variant="ghost" size="sm">Edit</Button>
                </div>
                <dl className="space-y-4 text-sm">
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <dt className="text-text-muted text-xs mb-1">Contact Person</dt>
                      <dd className="font-medium">{supplier.contactPerson}</dd>
                    </div>
                    <div>
                      <dt className="text-text-muted text-xs mb-1">Phone</dt>
                      <dd className="font-medium">{supplier.phone}</dd>
                    </div>
                  </div>
                  <div>
                    <dt className="text-text-muted text-xs mb-1">Email</dt>
                    <dd className="font-medium">{supplier.email || 'N/A'}</dd>
                  </div>
                  <div className="pt-2 border-t border-border">
                    <dt className="text-text-muted text-xs mb-1">Address</dt>
                    <dd className="font-medium">{supplier.address}</dd>
                    <dd className="text-text-muted">{supplier.city}, {supplier.state}</dd>
                    <dd className="text-text-muted">{supplier.country}</dd>
                  </div>
                </dl>
              </div>

              {/* Categories */}
              <div className="bg-surface p-6 rounded-xl border border-border">
                <h3 className="text-h4 mb-4">Categories Supplied</h3>
                <div className="flex flex-wrap gap-2">
                  {supplier.categories.length > 0 ? (
                    supplier.categories.map(cat => (
                      <span key={cat} className="px-2 py-1 rounded-full bg-surface-2 border border-border text-xs font-medium">
                        {cat}
                      </span>
                    ))
                  ) : (
                    <span className="text-text-muted text-sm">No categories assigned.</span>
                  )}
                </div>
              </div>
            </div>
            
            <div className="space-y-6">
              {/* Commercial Terms */}
              <div className="bg-surface p-6 rounded-xl border border-border">
                <h3 className="text-h4 mb-4">Commercial Terms</h3>
                <dl className="space-y-4 text-sm">
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <dt className="text-text-muted text-xs mb-1">Payment Terms</dt>
                      <dd className="font-medium">{supplier.paymentTerms}</dd>
                    </div>
                    <div>
                      <dt className="text-text-muted text-xs mb-1">Currency</dt>
                      <dd className="font-medium">{supplier.currency}</dd>
                    </div>
                    <div>
                      <dt className="text-text-muted text-xs mb-1">Lead Time</dt>
                      <dd className="font-medium">{supplier.leadTimeDays} Days</dd>
                    </div>
                    <div>
                      <dt className="text-text-muted text-xs mb-1">Credit Limit</dt>
                      <dd className="font-medium"><AmountText amountInKobo={supplier.creditLimit} /></dd>
                    </div>
                  </div>
                  {supplier.incoterms && (
                    <div className="pt-2 border-t border-border">
                      <dt className="text-text-muted text-xs mb-1">Incoterms</dt>
                      <dd className="font-medium">{supplier.incoterms}</dd>
                    </div>
                  )}
                </dl>
              </div>

              {/* Bank Details */}
              <div className="bg-surface p-6 rounded-xl border border-border">
                <div className="flex justify-between items-center mb-4">
                  <h3 className="text-h4">Bank Details</h3>
                  <Button variant="ghost" size="sm" className="text-primary">Request Change</Button>
                </div>
                {supplier.bankDetails ? (
                  <dl className="space-y-4 text-sm">
                    <div>
                      <dt className="text-text-muted text-xs mb-1">Bank Name</dt>
                      <dd className="font-medium">{supplier.bankDetails.bankName}</dd>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <dt className="text-text-muted text-xs mb-1">Account Number</dt>
                        <dd className="font-medium font-mono text-text-muted">•••• {supplier.bankDetails.accountNumber.slice(-4)}</dd>
                      </div>
                      <div>
                        <dt className="text-text-muted text-xs mb-1">Account Name</dt>
                        <dd className="font-medium">{supplier.bankDetails.accountName}</dd>
                      </div>
                    </div>
                  </dl>
                ) : (
                  <p className="text-sm text-text-muted">No bank details provided.</p>
                )}
              </div>
            </div>

          </div>
        )}

        {activeTab === 'Products' && (
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <h3 className="text-h4">Supplied Products</h3>
              <Button>Add Product Link</Button>
            </div>
            <div className="bg-surface rounded-xl border border-border overflow-hidden">
              <DataTable 
                data={mockProducts}
                columns={productColumns}
                isLoading={false}
                emptyMessage="No products linked to this supplier."
              />
            </div>
          </div>
        )}

        {activeTab !== 'Overview' && activeTab !== 'Products' && (
          <div className="bg-surface p-12 text-center rounded-xl border border-border">
            <h3 className="font-medium text-lg mb-1">{activeTab}</h3>
            <p className="text-text-muted text-sm mb-4">This section will be implemented in the Procurement phase.</p>
            <Button variant="outline">Learn more</Button>
          </div>
        )}
      </div>

    </div>
  );
}
