'use client';

import React from 'react';
import { NetworkNodeData } from '../types';
import { NetworkTree } from './NetworkTree';
import { KpiCard } from '@/components/patterns/KpiCard';
import { ChartCard } from '@/components/patterns/ChartCard';
import { PageHeader } from '@/components/patterns/PageHeader';
import { brand } from '@/config/brand';
import { Switch } from '@/components/ui/switch';
import { Avatar } from '@/components/ui/avatar';
import { AmountText } from '@/components/patterns/AmountText';

interface MarketerProfileProps {
  profile: NetworkNodeData;
  metrics: {
    teamSizeByLevel: { name: string, size: number }[];
    activeInactive: { name: string, count: number }[];
    salesByLevel: { name: string, sales: number }[];
    growthTrend: { name: string, value: number }[];
    earningsSources: { name: string, value: number }[];
  };
}

export function MarketerProfile({ profile, metrics }: MarketerProfileProps) {
  const [publicProfile, setPublicProfile] = React.useState(false);

  return (
    <div className="space-y-8 max-w-7xl mx-auto pb-20">
      <PageHeader 
        title="Marketer Profile" 
        description="View your performance, earnings, and manage your network."
      />

      {/* Header Profile Section */}
      <div className="bg-white border border-border p-6 rounded-xl shadow-sm flex flex-col md:flex-row gap-6 items-center md:items-start justify-between">
        <div className="flex flex-col md:flex-row items-center md:items-start gap-4">
          <div className="w-20 h-20 bg-brand-100 rounded-full flex items-center justify-center text-3xl font-bold text-brand-700">
            {profile.alias ? profile.alias.charAt(0) : 'A'}
          </div>
          <div className="text-center md:text-left space-y-1">
            <h2 className="text-2xl font-bold">{profile.alias || 'Anonymous User'}</h2>
            <div className="flex items-center gap-2 text-sm text-gray-500 justify-center md:justify-start">
              <span className="bg-brand-50 text-brand-700 px-2 py-0.5 rounded-full font-medium">Level {profile.level}</span>
              <span>•</span>
              <span>Joined {profile.joinedDate ? new Date(profile.joinedDate).toLocaleDateString() : 'N/A'}</span>
            </div>
            {profile.performancePercentile !== undefined && (
              <p className="text-sm font-medium text-green-600 mt-2">
                Top {100 - profile.performancePercentile}% of peers
              </p>
            )}
          </div>
        </div>

        <div className="bg-gray-50 p-4 rounded-lg border text-sm w-full md:w-auto">
          <div className="flex items-center justify-between gap-4 mb-2">
            <span className="font-semibold">Public Profile</span>
            <Switch checked={publicProfile} onCheckedChange={setPublicProfile} />
          </div>
          <p className="text-xs text-gray-500 max-w-xs">
            Show your aggregated stats at <span className="font-mono bg-white px-1 border rounded">/community/{profile.alias || 'user'}</span>. 
            By enabling this, you agree to our NDPR compliant privacy policy.
          </p>
        </div>
      </div>

      {/* KPIs */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <KpiCard title="Network Sales" value={<AmountText amountInKobo={profile.sales} />} trend="+12%" trendType="good" />
        <KpiCard title="Personal Sales" value={<AmountText amountInKobo={profile.personalSales || 0} />} trend="+5%" trendType="good" />
        <KpiCard title="Total Team Size" value={profile.downlineCount} trend="+3 members" trendType="good" />
        <KpiCard title="Active Members" value={metrics.activeInactive.find(m => m.name === 'Active')?.count || 0} />
      </div>

      {/* Network Visualisation */}
      <div className="space-y-4">
        <h3 className="text-xl font-bold">Network Visualisation</h3>
        <NetworkTree data={profile} anonymize={true} />
      </div>

      {/* Performance Metrics */}
      <div className="space-y-4">
        <h3 className="text-xl font-bold">Performance Metrics</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <ChartCard 
            title="Team Size by Level" 
            type="bar" 
            data={metrics.teamSizeByLevel} 
            series={[{ key: 'size', name: 'Size', color: '#3b82f6' }]}
            xAxisKey="name" 
            height={250} 
          />
          <ChartCard 
            title="Sales by Level" 
            type="bar" 
            data={metrics.salesByLevel} 
            series={[{ key: 'sales', name: 'Sales', color: '#10b981' }]}
            xAxisKey="name" 
            height={250} 
            valueFormatter={(val: number) => `₦${(val/100).toLocaleString()}`}
          />
          <ChartCard 
            title="Growth Trend" 
            type="line" 
            data={metrics.growthTrend} 
            series={[{ key: 'value', name: 'Members', color: '#8b5cf6' }]}
            xAxisKey="name" 
            height={250} 
          />
        </div>
      </div>

      {/* Earnings Sources */}
      <div className="space-y-4">
        <h3 className="text-xl font-bold">Earnings Sources</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <ChartCard 
            title="Earnings Breakdown" 
            type="pie" 
            data={metrics.earningsSources} 
            pieDataKey="value" 
            pieNameKey="name"
            xAxisKey="name" 
            height={300} 
          />
          <div className="bg-white border rounded-xl p-6 shadow-sm">
            <h4 className="font-medium text-sm text-gray-500 mb-4">Summary</h4>
            <div className="space-y-3">
              {metrics.earningsSources.map((source, idx) => (
                <div key={idx} className="flex justify-between items-center py-2 border-b last:border-0">
                  <span>{source.name}</span>
                  <span className="font-bold"><AmountText amountInKobo={source.value} /></span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

    </div>
  );
}
