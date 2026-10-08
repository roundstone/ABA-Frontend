'use client';

import React from 'react';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { spotlightSettingsSchema, SpotlightSettingsFormData } from '../schemas';
import { useSpotlightSettings, useSpotlightHistory } from '../queries';
import { useUpdateSpotlightSettings, useRunSpotlightRefresh } from '../mutations';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { DataTable } from '@/components/patterns/DataTable';
import { Loader2 } from 'lucide-react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';


export function AdminSpotlightSettings() {
  const { data: settings, isLoading } = useSpotlightSettings();
  const { data: history, isLoading: isHistoryLoading } = useSpotlightHistory();
  const updateSettings = useUpdateSpotlightSettings();
  const refreshSpotlight = useRunSpotlightRefresh();

  const form = useForm<SpotlightSettingsFormData>({
    resolver: zodResolver(spotlightSettingsSchema),
    defaultValues: {
      slots: 4,
      mode: 'Automatic',
      scoreWeights: { sales: 40, rating: 30, fulfilment: 10, returnRateInverse: 10, responseTime: 10 },
      eligibilityThresholds: { minOrders: 10, minRating: 4.0, minProducts: 5 },
      refreshInterval: 'Weekly',
      rotationOption: 'TopN',
      pinnedMerchants: [],
      exclusions: [],
    },
  });

  React.useEffect(() => {
    if (settings) {
      form.reset(settings);
    }
  }, [settings, form]);

  if (isLoading) {
    return <div><Loader2 className="w-6 h-6 animate-spin text-brand-600" /></div>;
  }

  const onSubmit = (data: SpotlightSettingsFormData) => {
    updateSettings.mutate(data);
  };

  const currentMode = form.watch('mode');

  return (
    <Tabs defaultValue="settings" className="space-y-4">
      <TabsList>
        <TabsTrigger value="settings">Settings</TabsTrigger>
        <TabsTrigger value="history">History Log</TabsTrigger>
      </TabsList>

      <TabsContent value="settings">
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
          <div className="flex justify-end gap-4">
            <Button 
              type="button" 
              variant="outline" 
              onClick={() => refreshSpotlight.mutate()}
              disabled={refreshSpotlight.isPending}
            >
              {refreshSpotlight.isPending ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : null}
              Refresh Now
            </Button>
            <Button type="submit" disabled={updateSettings.isPending}>
              {updateSettings.isPending ? 'Saving...' : 'Save Changes'}
            </Button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="rounded-xl border border-border bg-white shadow-sm overflow-hidden">
              <div className="flex flex-col space-y-1.5 p-6 border-b border-border mb-4">
                <h3 className="font-semibold text-lg leading-none tracking-tight">General Config</h3>
                <p className="text-sm text-text-muted mt-2">Configure the behaviour of the spotlight engine</p>
              </div>
              <div className="p-6 pt-0 space-y-4">
                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Slots (Number of Merchants)</label>
                  <Input type="number" {...form.register('slots', { valueAsNumber: true })} />
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Mode</label>
                  <Controller
                    control={form.control}
                    name="mode"
                    render={({ field }) => (
                      <Select onValueChange={field.onChange} defaultValue={field.value}>
                        <SelectTrigger><SelectValue placeholder="Select mode" /></SelectTrigger>
                        <SelectContent>
                          <SelectItem value="Automatic">Automatic</SelectItem>
                          <SelectItem value="Manual">Manual</SelectItem>
                          <SelectItem value="Mixed">Mixed</SelectItem>
                        </SelectContent>
                      </Select>
                    )}
                  />
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Refresh Interval</label>
                  <Controller
                    control={form.control}
                    name="refreshInterval"
                    render={({ field }) => (
                      <Select onValueChange={field.onChange} defaultValue={field.value}>
                        <SelectTrigger><SelectValue placeholder="Interval" /></SelectTrigger>
                        <SelectContent>
                          <SelectItem value="Daily">Daily</SelectItem>
                          <SelectItem value="Weekly">Weekly</SelectItem>
                          <SelectItem value="Custom">Custom</SelectItem>
                        </SelectContent>
                      </Select>
                    )}
                  />
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Rotation Option</label>
                  <Controller
                    control={form.control}
                    name="rotationOption"
                    render={({ field }) => (
                      <Select onValueChange={field.onChange} defaultValue={field.value}>
                        <SelectTrigger><SelectValue placeholder="Rotation option" /></SelectTrigger>
                        <SelectContent>
                          <SelectItem value="TopN">Top N</SelectItem>
                          <SelectItem value="WeightedRandom">Weighted Random</SelectItem>
                        </SelectContent>
                      </Select>
                    )}
                  />
                </div>
              </div>
            </div>

            <div className="rounded-xl border border-border bg-white shadow-sm overflow-hidden">
              <div className="flex flex-col space-y-1.5 p-6 border-b border-border mb-4">
                <h3 className="font-semibold text-lg leading-none tracking-tight">Scoring Engine</h3>
                <p className="text-sm text-text-muted mt-2">Weight distribution for the automatic performance score</p>
              </div>
              <div className="p-6 pt-0 space-y-4">
                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Sales Velocity (%)</label>
                  <Input type="number" {...form.register('scoreWeights.sales', { valueAsNumber: true })} disabled={currentMode === 'Manual'} />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Rating (%)</label>
                  <Input type="number" {...form.register('scoreWeights.rating', { valueAsNumber: true })} disabled={currentMode === 'Manual'} />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Fulfilment Speed (%)</label>
                  <Input type="number" {...form.register('scoreWeights.fulfilment', { valueAsNumber: true })} disabled={currentMode === 'Manual'} />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Return Rate Inverse (%)</label>
                  <Input type="number" {...form.register('scoreWeights.returnRateInverse', { valueAsNumber: true })} disabled={currentMode === 'Manual'} />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Response Time (%)</label>
                  <Input type="number" {...form.register('scoreWeights.responseTime', { valueAsNumber: true })} disabled={currentMode === 'Manual'} />
                </div>
              </div>
            </div>

            <div className="rounded-xl border border-border bg-white shadow-sm overflow-hidden">
              <div className="flex flex-col space-y-1.5 p-6 border-b border-border mb-4">
                <h3 className="font-semibold text-lg leading-none tracking-tight">Eligibility Thresholds</h3>
                <p className="text-sm text-text-muted mt-2">Minimum requirements to be featured automatically</p>
              </div>
              <div className="p-6 pt-0 space-y-4">
                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Minimum Orders</label>
                  <Input type="number" {...form.register('eligibilityThresholds.minOrders', { valueAsNumber: true })} disabled={currentMode === 'Manual'} />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Minimum Rating</label>
                  <Input type="number" step="0.1" {...form.register('eligibilityThresholds.minRating', { valueAsNumber: true })} disabled={currentMode === 'Manual'} />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Minimum Products In Stock</label>
                  <Input type="number" {...form.register('eligibilityThresholds.minProducts', { valueAsNumber: true })} disabled={currentMode === 'Manual'} />
                </div>
              </div>
            </div>
            
            {(currentMode === 'Manual' || currentMode === 'Mixed') && (
              <div className="rounded-xl border border-border bg-white shadow-sm overflow-hidden">
                <div className="flex flex-col space-y-1.5 p-6 border-b border-border mb-4">
                  <h3 className="font-semibold text-lg leading-none tracking-tight">Pinned Merchants</h3>
                  <p className="text-sm text-text-muted mt-2">Specify IDs of merchants to permanently feature</p>
                </div>
                <div className="p-6 pt-0 space-y-4">
                  <div className="space-y-2">
                    <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Pinned Merchant IDs (Comma separated)</label>
                    <Input 
                      placeholder="e.g. M-101, M-205"
                      value={form.watch('pinnedMerchants').join(', ')} 
                      onChange={(e) => {
                        form.setValue('pinnedMerchants', e.target.value.split(',').map(s => s.trim()).filter(Boolean), { shouldDirty: true });
                      }}
                    />
                  </div>
                </div>
              </div>
            )}
          </div>
        </form>
      </TabsContent>

      <TabsContent value="history">
        <div className="rounded-xl border border-border bg-white shadow-sm overflow-hidden">
          <div className="flex flex-col space-y-1.5 p-6 border-b border-border mb-4">
            <h3 className="font-semibold text-lg leading-none tracking-tight">Refresh & Settings Log</h3>
          </div>
          <div className="p-6 pt-0">
             {isHistoryLoading ? (
               <Loader2 className="w-4 h-4 animate-spin" />
             ) : (
               <DataTable
                 columns={[
                   // eslint-disable-next-line @typescript-eslint/no-explicit-any
                   { accessorKey: 'timestamp', header: 'Time', cell: ({ row }: { row: any }) => new Date(row.original.timestamp).toLocaleString() },
                   { accessorKey: 'actor', header: 'Actor' },
                   { accessorKey: 'action', header: 'Action' },
                   { accessorKey: 'details', header: 'Details' },
                 ]}
                 data={history || []}
               />
             )}
          </div>
        </div>
      </TabsContent>
    </Tabs>
  );
}
