'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useQuery } from '@tanstack/react-query';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { AmountText } from '@/components/patterns/AmountText';
import { ErrorState } from '@/components/patterns/ErrorState';
import { Loader2 } from 'lucide-react';
import { NetworkNodeData } from '../types';
import { getNetworkTree } from '../api';

const NetworkNode = ({ node, isRoot = false, onSearch }: { node: NetworkNodeData, isRoot?: boolean, onSearch: (id: string) => void }) => {
  const router = useRouter();

  const handleViewDownline = () => {
    // Navigate to the downline page for this specific user ID
    router.push(`/erp/referrals/network/${node.id}`);
  };

  return (
    <div className="space-y-2 py-2">
      <div className={`flex items-center gap-4 p-4 rounded-xl border ${isRoot ? 'border-primary bg-primary/5' : 'border-border bg-surface hover:border-primary'} transition-colors`}>
        <div className="relative">
          <div className="w-12 h-12 rounded-full bg-surface-2 flex items-center justify-center text-lg font-bold border border-border">
            {node.name.charAt(0)}
          </div>
          <div className={`absolute bottom-0 right-0 w-3 h-3 rounded-full border-2 border-surface ${node.active ? 'bg-success-main' : 'bg-warning-main'}`} />
        </div>
        
        <div className="flex-1 min-w-[200px]">
          <div className="flex items-center gap-2">
            <h4 className="font-bold cursor-pointer hover:underline" onClick={() => onSearch(node.id)}>{node.name}</h4>
            <span className="text-xs font-mono bg-surface-2 px-1.5 py-0.5 rounded text-text-muted">{node.code}</span>
            {isRoot && <span className="text-[10px] bg-primary text-white px-1.5 py-0.5 rounded uppercase font-bold">Root</span>}
          </div>
          <div className="flex gap-4 mt-1 text-sm text-text-muted">
            <span>Directs: <strong>{node.downlineCount}</strong></span>
            <span>Network Sales: <strong><AmountText amountInKobo={node.sales} /></strong></span>
          </div>
        </div>
        
        <div>
          {!isRoot && node.downlineCount > 0 && (
            <Button variant="ghost" size="sm" className="h-8" onClick={handleViewDownline}>
              View Downline →
            </Button>
          )}
          {isRoot && node.id !== 'ABA-492' && (
            <Button variant="outline" size="sm" className="h-8 border-primary text-primary hover:bg-primary/10" onClick={() => router.back()}>
              ← Go Back
            </Button>
          )}
        </div>
      </div>

      {/* Children Recursion */}
      {node.children && node.children.length > 0 && (
        <div className="border-l-2 border-border ml-6 pl-4 space-y-2">
          {node.children.map(child => (
            <NetworkNode key={child.id} node={child} onSearch={onSearch} />
          ))}
        </div>
      )}
    </div>
  );
};

export function NetworkExplorer({ initialRootId = 'ABA-492' }: { initialRootId?: string }) {
  const router = useRouter();
  const rootId = initialRootId;
  const [searchInput, setSearchInput] = useState('');
  const [maxLevels, setMaxLevels] = useState(999);

  const { data: treeNode, isLoading, error, refetch } = useQuery({
    queryKey: ['referral_network', rootId, maxLevels],
    queryFn: async () => {
      const res = await getNetworkTree(rootId, maxLevels);
      return res.data;
    }
  });

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchInput.trim()) {
      router.push(`/erp/referrals/network/${searchInput.trim()}`);
    }
  };

  const handleLevelChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setMaxLevels(Number(e.target.value));
  };

  // Callback from children nodes clicking names to search quickly
  const handleQuickSearch = (id: string) => {
    router.push(`/erp/referrals/network/${id}`);
  };

  return (
    <div className="space-y-6 pb-20 max-w-5xl mx-auto">
      <PageHeader 
        title="Network Explorer" 
        description="Visualize the upline/downline hierarchy and sales distribution."
        backHref="/erp/referrals"
      />

      <form onSubmit={handleSearch} className="bg-surface rounded-xl border border-border p-4 flex gap-4 items-center">
        <div className="flex-1">
          <Input 
            placeholder="Search user ID to set as Root... (e.g., ABA-881)" 
            className="w-full"
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
          />
        </div>
        <select 
          className="h-10 rounded-md border bg-surface px-3 text-sm focus:ring-primary focus:border-primary"
          value={maxLevels}
          onChange={handleLevelChange}
        >
          <option value={3}>Show: 3 Levels Deep</option>
          <option value={5}>Show: 5 Levels Deep</option>
          <option value={999}>Show: All Levels</option>
        </select>
        <Button type="submit">Search</Button>
      </form>

      {/* Tree Visualization */}
      <div className="bg-surface-2 rounded-xl border border-border p-6 overflow-x-auto min-h-[400px]">
        {isLoading ? (
          <div className="flex justify-center items-center h-full pt-10">
            <Loader2 className="w-8 h-8 animate-spin text-brand-600" />
          </div>
        ) : error || !treeNode ? (
          <ErrorState 
            title="User not found"
            description={error instanceof Error ? error.message : "Could not find the requested user in the network tree."}
            onRetry={() => refetch()}
          />
        ) : (
          <div className="min-w-[600px]">
            <NetworkNode node={treeNode} isRoot={true} onSearch={handleQuickSearch} />
          </div>
        )}
      </div>
    </div>
  );
}
