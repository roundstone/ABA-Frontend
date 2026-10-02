'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { PageHeader } from '@/components/patterns/PageHeader';
import { DataTable } from '@/components/patterns/DataTable';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { getBoms } from '@/features/production/api/production.api';
import { Bom } from '@/features/production/types';
import { toast } from 'sonner';
import { AmountText } from '@/components/patterns/AmountText';

export default function BOMsPage() {
    const [boms, setBoms] = useState<Bom[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [search, setSearch] = useState('');

    useEffect(() => {
        const fetchBoms = async () => {
            try {
                const res = await getBoms();
                setBoms(res.data);
            } catch (err) {
                toast.error('Failed to load BOMs');
            } finally {
                setIsLoading(false);
            }
        };
        fetchBoms();
    }, []);

    const filtered = boms.filter(b =>
        b.bomNumber.toLowerCase().includes(search.toLowerCase()) ||
        b.finishedProductName.toLowerCase().includes(search.toLowerCase())
    );

    const columns = [
        {
            accessorKey: 'bomNumber',
            header: 'BOM #',
            cell: (info: any) => <span className="font-mono text-sm font-medium">{info.getValue()}</span>
        },
        {
            accessorKey: 'finishedProductName',
            header: 'Finished Product',
            cell: (info: any) => <span className="font-medium text-text">{info.getValue()}</span>
        },
        {
            accessorKey: 'version',
            header: 'Version',
            cell: (info: any) => <span className="text-text-muted">v{info.getValue()}</span>
        },
        {
            accessorKey: 'yieldQty',
            header: 'Yield Qty',
            cell: (info: any) => (
                <span>{info.getValue()} <span className="text-text-muted text-xs">{info.row.original.yieldUnit}</span></span>
            )
        },
        {
            id: 'components',
            header: 'Components',
            cell: (info: any) => <span>{info.row.original.components.length} items</span>
        },
        {
            accessorKey: 'stdCost',
            header: 'Std Cost',
            cell: (info: any) => <AmountText amountInKobo={info.getValue()} />
        },
        {
            accessorKey: 'status',
            header: 'Status',
            cell: (info: any) => {
                const status = info.getValue();
                const variant = status === 'Active' ? 'success' : status === 'Draft' ? 'warning' : 'neutral';
                return status;
                // return <StatusBadge status={status} variant={variant} />;
            }
        },
        {
            id: 'actions',
            cell: (info: any) => (
                <div className="flex justify-end gap-1">
                    <Button variant="ghost" size="sm">Edit</Button>
                    <Link href={`/erp/production/boms/${info.row.original.id}`}>
                        <Button variant="ghost" size="sm">View</Button>
                    </Link>
                </div>
            )
        }
    ];

    return (
        <div className="space-y-6 pb-20">
            <PageHeader
                title="Bill of Materials"
                description="Manage product recipes, component lists, and standard costs."
                action={
                    <div className="flex gap-2">
                        <Link href="/erp/production/boms/new">
                            <Button>Create BOM</Button>
                        </Link>
                    </div>
                }
            />

            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div className="w-full max-w-md">
                    <Input
                        placeholder="Search by BOM # or product..."
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                    />
                </div>
            </div>

            <div className="bg-surface rounded-xl border border-border overflow-hidden">
                <DataTable
                    data={filtered}
                    columns={columns}
                    isLoading={isLoading}
                    emptyMessage="No Bill of Materials found."
                />
            </div>
        </div>
    );
}
