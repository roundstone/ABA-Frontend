'use client';

import React from 'react';
import Link from 'next/link';
import { Trophy, Medal } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';
import { brand } from '@/config/brand';

interface LeaderboardEntry {
  rank: number;
  name: string;
  networkSize: number;
  earned: number;
}

interface PromoterLeaderboardCardProps {
  leaders: LeaderboardEntry[];
}

export function PromoterLeaderboardCard({ leaders }: PromoterLeaderboardCardProps) {
  return (
    <div className="mt-8 bg-linear-to-br from-black to-black/20 rounded-2xl shadow-lg border border-brand-500 overflow-hidden text-white relative">
      <div className="p-6 md:p-8 flex flex-col md:flex-row gap-8 items-center md:items-start relative z-10">
        <div className="flex-1 space-y-4 text-center md:text-left">
          <div className="inline-flex items-center justify-center w-12 h-12 rounded-xl bg-white/20 backdrop-blur-sm mb-2 shadow-inner">
            <Trophy className="w-6 h-6 text-warning-main" />
          </div>
          <h2 className="text-2xl md:text-3xl font-extrabold tracking-tight">Top Promoters Leaderboard</h2>
          <p className="text-brand-100 max-w-md">
            See who is leading the charge in the {brand.name} ecosystem. Top promoters receive bonus commissions and rewards!
          </p>
          <div className="pt-2">
            <Link href="/portal/referrals/leaderboard">
              <Button className="bg-white text-brand-700 hover:bg-brand-50 font-bold rounded-full">
                View Full Rankings
              </Button>
            </Link>
          </div>
        </div>

        <div className="flex-1 w-full bg-white/10 backdrop-blur-md rounded-xl border border-white/20 overflow-hidden">
          <div className="px-6 py-4 border-b border-white/10 flex justify-between items-center bg-black/10">
            <h3 className="font-semibold text-white">This Month&apos;s Leaders</h3>
          </div>
          <div className="divide-y divide-white/10">
            {leaders.map((leader, index) => (
              <div key={leader.rank} className="p-4 flex items-center gap-4 hover:bg-white/5 transition-colors">
                <div className="w-8 flex justify-center">
                  {index === 0 ? <Medal className="w-6 h-6 text-warning-main drop-shadow-md" /> :
                    index === 1 ? <Medal className="w-6 h-6 text-gray-300 drop-shadow-md" /> :
                      index === 2 ? <Medal className="w-6 h-6 text-amber-600 drop-shadow-md" /> :
                        <span className="font-bold text-brand-200">#{leader.rank}</span>}
                </div>
                <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center font-bold text-white shadow-inner">
                  {leader.name.split(' ').map((n) => n[0]).join('')}
                </div>
                <div className="flex-1">
                  <p className="font-bold text-white">{leader.name}</p>
                  <p className="text-xs text-brand-200">{leader.networkSize} Active Referrals</p>
                </div>
                <div className="text-right">
                  <p className="font-extrabold text-warning-main drop-shadow-sm">
                    <AmountText amountInKobo={leader.earned} />
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
