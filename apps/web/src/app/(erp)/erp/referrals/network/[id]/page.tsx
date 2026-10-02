import React from 'react';
import { NetworkExplorer } from '@/features/referrals/components/NetworkExplorer';

export default async function DownlineExplorerPage({ params }: { params: Promise<{ id: string }> }) {
  const unwrappedParams = await params;
  const decodedId = decodeURIComponent(unwrappedParams.id);
  return <NetworkExplorer initialRootId={decodedId} />;
}
