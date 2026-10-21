'use client';

import React, { useMemo } from 'react';
import { Users, CheckCircle2, X } from 'lucide-react';
import { brand } from '@/config/brand';

interface ReferralSignupFieldProps {
  value: string;
  onChange: (value: string) => void;
  disabled?: boolean;
}

const KNOWN_REFERRERS: Record<string, { name: string; username: string }> = {
  [`${brand.referralCodePrefix}492`]: { name: 'Aisha Bello', username: 'aishabello' },
  [`${brand.referralCodePrefix}881`]: { name: 'Michael Okon', username: 'mokoloko' },
  '492': { name: 'Aisha Bello', username: 'aishabello' },
  '881': { name: 'Michael Okon', username: 'mokoloko' },
  'AISHABELLO': { name: 'Aisha Bello', username: 'aishabello' },
  'MOKOLOKO': { name: 'Michael Okon', username: 'mokoloko' },
  'JANEDOE': { name: 'Jane Doe', username: 'janedoe' },
};

export function ReferralSignupField({
  value,
  onChange,
  disabled = false,
}: ReferralSignupFieldProps) {
  const normalized = (value || '').trim().toUpperCase().replace(/^@/, '');
  
  const referrerInfo = useMemo(() => {
    if (!normalized) return null;
    if (KNOWN_REFERRERS[normalized]) {
      return KNOWN_REFERRERS[normalized];
    }
    // Clean code with brand prefix
    const prefixed = `${brand.referralCodePrefix}${normalized}`;
    if (KNOWN_REFERRERS[prefixed]) {
      return KNOWN_REFERRERS[prefixed];
    }
    return { name: value.trim(), username: value.trim().toLowerCase().replace(/^@/, '') };
  }, [normalized, value]);

  return (
    <div className="pt-2">
      <div className="flex items-center justify-between mb-1">
        <label htmlFor="referralCode" className="block text-sm font-medium text-text">
          Referral Code or Referrer&apos;s Username (Optional)
        </label>
        <span className="text-[11px] text-text-muted">Earn shopping perks</span>
      </div>

      <div className="relative">
        <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
          <Users className="h-5 w-5 text-brand-500" />
        </div>
        <input
          id="referralCode"
          type="text"
          name="referralCode"
          value={value}
          disabled={disabled}
          onChange={(e) => onChange(e.target.value)}
          className="block w-full pl-10 pr-9 py-2 border border-brand-200 rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-brand-50/50 sm:text-sm uppercase placeholder:normal-case"
          placeholder={`e.g. ${brand.referralCodePrefix}492 or username`}
        />
        {value && !disabled && (
          <button
            type="button"
            onClick={() => onChange('')}
            className="absolute inset-y-0 right-0 pr-3 flex items-center text-text-muted hover:text-text"
            title="Clear referral code"
          >
            <X className="h-4 w-4" />
          </button>
        )}
      </div>

      {referrerInfo && (
        <div className="mt-1.5 flex items-center gap-1.5 text-xs text-success-dark font-medium">
          <CheckCircle2 className="w-3.5 h-3.5 text-success-main shrink-0" />
          <span>
            Referred by <strong className="text-text">{referrerInfo.name}</strong> (@{referrerInfo.username})
          </span>
        </div>
      )}
      <p className="mt-1 text-[11px] text-text-muted">
        Entering your referrer connects you to their community network and unlocks bonus reward points.
      </p>
    </div>
  );
}
