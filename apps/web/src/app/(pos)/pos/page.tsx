'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { getRegisters } from '@/features/pos/api/pos.api';
import { PosRegister } from '@/features/pos/types';

export default function PosGatePage() {
  const router = useRouter();
  const [registers, setRegisters] = useState<PosRegister[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    getRegisters('mer-1').then(data => {
      setRegisters(data);
      setIsLoading(false);
    });
  }, []);

  const handleSelectRegister = (regId: string) => {
    // In a real app, check if there's already an open session for this register.
    // We'll assume no session and route to the opening float screen.
    router.push(`/pos/session/open?register=${regId}`);
  };

  if (isLoading) {
    return <div className="flex-1 flex items-center justify-center text-text-muted">Loading registers...</div>;
  }

  return (
    <div className="flex-1 flex items-center justify-center bg-bg p-6">
      <div className="max-w-md w-full bg-surface rounded-2xl border border-border shadow-sm p-8 space-y-8 text-center">
        
        <div className="space-y-2">
          <div className="w-16 h-16 rounded-2xl bg-primary/10 text-primary mx-auto flex items-center justify-center text-2xl font-bold mb-4">
            ABA
          </div>
          <h1 className="text-2xl font-semibold">Select a Register</h1>
          <p className="text-text-muted text-sm">Choose a point of sale terminal to start your session.</p>
        </div>

        <div className="space-y-3">
          {registers.map(reg => (
            <button
              key={reg.id}
              onClick={() => handleSelectRegister(reg.id)}
              className="w-full flex items-center justify-between p-4 rounded-xl border border-border hover:border-primary hover:bg-primary/5 transition-all group"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-surface-2 flex items-center justify-center group-hover:bg-primary/10 group-hover:text-primary transition-colors">
                  💻
                </div>
                <div className="text-left">
                  <p className="font-medium">{reg.name}</p>
                  <p className="text-xs text-text-muted flex items-center gap-1 mt-0.5">
                    <span className={`w-2 h-2 rounded-full ${reg.status === 'Online' ? 'bg-success' : 'bg-text-muted'}`}></span>
                    {reg.status}
                  </p>
                </div>
              </div>
              <div className="text-primary opacity-0 group-hover:opacity-100 transition-opacity">
                →
              </div>
            </button>
          ))}
        </div>

      </div>
    </div>
  );
}
