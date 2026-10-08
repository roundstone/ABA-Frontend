'use client';
import { brand } from '@/config/brand';


import React from 'react';
import Link from 'next/link';
import { ArrowLeft, Trophy, Medal, Search, Filter } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';

// Expanded mock data for the full leaderboard
const mockLeaderboard = [
  { rank: 1, name: 'Chima Obi', networkSize: 142, earned: 15400000, joined: '2022-01-15' },
  { rank: 2, name: 'Aisha Bello', networkSize: 98, earned: 8900000, joined: '2022-03-22' },
  { rank: 3, name: 'Samuel O.', networkSize: 85, earned: 7600000, joined: '2022-05-10' },
  { rank: 4, name: 'Grace Johnson', networkSize: 72, earned: 5200000, joined: '2022-08-05' },
  { rank: 5, name: 'Tunde A.', networkSize: 64, earned: 4100000, joined: '2022-11-12' },
  { rank: 6, name: 'Femi K.', networkSize: 58, earned: 3800000, joined: '2023-01-20' },
  { rank: 7, name: 'Ngozi E.', networkSize: 51, earned: 3500000, joined: '2023-02-15' },
  { rank: 8, name: 'Ibrahim M.', networkSize: 45, earned: 3100000, joined: '2023-04-02' },
  { rank: 9, name: 'Blessing O.', networkSize: 42, earned: 2900000, joined: '2023-05-18' },
  { rank: 10, name: 'Victor E.', networkSize: 38, earned: 2600000, joined: '2023-06-30' },
  { rank: 11, name: 'Joy N.', networkSize: 35, earned: 2400000, joined: '2023-08-14' },
  { rank: 12, name: 'David B.', networkSize: 31, earned: 2100000, joined: '2023-09-25' },
  { rank: 13, name: 'Mary S.', networkSize: 28, earned: 1900000, joined: '2023-11-05' },
  { rank: 14, name: 'Peter U.', networkSize: 25, earned: 1700000, joined: '2024-01-10' },
  { rank: 15, name: 'Ruth A.', networkSize: 22, earned: 1500000, joined: '2024-02-28' },
];

export default function LeaderboardPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4">
        <Link href="/portal/referrals">
          <Button variant="ghost" size="sm" className="p-2 h-auto text-text-muted hover:text-text">
            <ArrowLeft className="w-5 h-5" />
          </Button>
        </Link>
        <div>
          <h1 className="text-2xl font-bold text-text flex items-center gap-2">
            <Trophy className="w-6 h-6 text-warning-main" /> Promoter Rankings
          </h1>
          <p className="text-sm text-text-muted">Top 50 earners in the {brand.name} ecosystem</p>
        </div>
      </div>

      <div className="bg-white rounded-xl border border-border shadow-sm overflow-hidden">
        <div className="p-4 border-b border-border flex flex-col sm:flex-row justify-between items-center gap-4 bg-surface-1">
          <div className="relative w-full sm:w-64">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <Search className="h-4 w-4 text-text-muted" />
            </div>
            <input
              type="text"
              placeholder="Search promoters..."
              className="block w-full pl-10 pr-3 py-2 border border-border rounded-md leading-5 bg-white placeholder-text-muted focus:outline-none focus:ring-1 focus:ring-brand-500 focus:border-brand-500 sm:text-sm"
            />
          </div>
          <Button variant="outline" size="sm" className="w-full sm:w-auto flex items-center gap-2">
            <Filter className="w-4 h-4" /> Filter by Month
          </Button>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm whitespace-nowrap">
            <thead className="bg-surface-2 text-text-muted uppercase text-xs tracking-wider border-b border-border">
              <tr>
                <th className="px-6 py-4 font-semibold text-center w-20">Rank</th>
                <th className="px-6 py-4 font-semibold">Promoter</th>
                <th className="px-6 py-4 font-semibold text-center">Network Size</th>
                <th className="px-6 py-4 font-semibold">Joined</th>
                <th className="px-6 py-4 font-semibold text-right">Total Earned</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {mockLeaderboard.map((leader, index) => (
                <tr key={leader.rank} className={`hover:bg-surface-1 transition-colors ${index < 3 ? 'bg-brand-50/30' : ''}`}>
                  <td className="px-6 py-4">
                    <div className="flex justify-center items-center">
                      {index === 0 ? <Medal className="w-6 h-6 text-warning-main" /> : 
                       index === 1 ? <Medal className="w-6 h-6 text-gray-400" /> :
                       index === 2 ? <Medal className="w-6 h-6 text-amber-600" /> :
                       <span className="font-bold text-text-muted">#{leader.rank}</span>}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs ${
                        index < 3 ? 'bg-brand-600 text-white shadow-md' : 'bg-surface-2 text-text-muted'
                      }`}>
                        {leader.name.split(' ').map(n => n[0]).join('')}
                      </div>
                      <span className={`font-medium ${index < 3 ? 'text-brand-700 font-bold' : 'text-text'}`}>
                        {leader.name}
                      </span>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-center">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-brand-100 text-brand-800">
                      {leader.networkSize} Active
                    </span>
                  </td>
                  <td className="px-6 py-4 text-text-muted">
                    {new Date(leader.joined).toLocaleDateString('en-US', { month: 'short', year: 'numeric' })}
                  </td>
                  <td className="px-6 py-4 text-right">
                    <span className={`font-bold ${index < 3 ? 'text-success-main' : 'text-text'}`}>
                      <AmountText amountInKobo={leader.earned} />
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        
        <div className="p-4 border-t border-border bg-surface-1 flex justify-between items-center text-sm text-text-muted">
          <span>Showing 1 to 15 of 50 entries</span>
          <div className="flex gap-2">
            <Button variant="outline" size="sm" disabled>Previous</Button>
            <Button variant="outline" size="sm">Next</Button>
          </div>
        </div>
      </div>
    </div>
  );
}
