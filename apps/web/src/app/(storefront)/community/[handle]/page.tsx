import { mockNetworkUsers } from '@/features/referrals/mocks';
import { brand } from '@/config/brand';
import { notFound } from 'next/navigation';
import { PageHeader } from '@/components/patterns/PageHeader';
import { KpiCard } from '@/components/patterns/KpiCard';
import { AmountText } from '@/components/patterns/AmountText';

// In a real implementation, you would lookup the user by their alias/handle
// and check if their public profile is enabled.
export default async function PublicProfilePage({ params }: { params: Promise<{ handle: string }> }) {
  const { handle } = await params;
  
  // Find a matching mock user by alias
  const user = Object.values(mockNetworkUsers).find(u => 
    u.alias?.toLowerCase() === handle.toLowerCase()
  );

  // If no user found, or in a real app if public profile is disabled, return 404
  if (!user) {
    notFound();
  }

  // Only aggregate metrics are shown, no personal data, no real name
  return (
    <div className="container mx-auto py-12 max-w-4xl space-y-8 mt-20">
      <div className="flex flex-col items-center text-center space-y-4">
        <div className="w-24 h-24 bg-brand-100 rounded-full flex items-center justify-center text-4xl font-bold text-brand-700 shadow-sm border-2 border-brand-200">
          {user.alias?.charAt(0) || 'A'}
        </div>
        <div>
          <h1 className="text-3xl font-bold">{user.alias}</h1>
          <p className="text-gray-500 mt-2">Level {user.level} {brand.name} Partner</p>
        </div>
        {user.performancePercentile !== undefined && (
          <div className="bg-green-50 text-green-700 px-3 py-1 rounded-full text-sm font-medium border border-green-200">
            Top {100 - user.performancePercentile}% Performer
          </div>
        )}
      </div>

      <div className="bg-white border rounded-xl p-8 shadow-sm text-center">
        <h2 className="text-xl font-bold mb-6">Network Statistics</h2>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-2xl mx-auto">
          <KpiCard 
            title="Total Team Members" 
            value={user.downlineCount} 
            className="bg-gray-50 shadow-none border"
          />
          <KpiCard 
            title="Total Network Sales" 
            value={<AmountText amountInKobo={user.sales} />} 
            className="bg-gray-50 shadow-none border"
          />
        </div>
      </div>

      <div className="bg-brand-50 border border-brand-100 rounded-xl p-8 text-center space-y-4">
        <h2 className="text-xl font-bold text-brand-900">Join {user.alias}'s Network</h2>
        <p className="text-brand-700 max-w-lg mx-auto">
          Become part of a winning team. Start your journey with {brand.name} today and build your own business under {user.alias}'s guidance.
        </p>
        <button className="bg-brand-600 hover:bg-brand-700 text-white font-medium px-6 py-3 rounded-lg shadow-sm transition-colors">
          Sign Up Now
        </button>
      </div>
    </div>
  );
}
