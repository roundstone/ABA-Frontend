'use client';

import React, { useState } from 'react';
import { UserCheck, Upload, CheckCircle2, FileText } from 'lucide-react';
import { Button } from '@/components/ui/button';

interface ReferralKycStepProps {
  onContinue: (data: {
    idType: string;
    ninNumber: string;
    idDocumentName: string;
    proofOfAddressName: string;
  }) => void;
  onCancel: () => void;
}

export function ReferralKycStep({ onContinue, onCancel }: ReferralKycStepProps) {
  const [idType, setIdType] = useState('National Identity Number (NIN)');
  const [ninNumber, setNinNumber] = useState('12345678901');
  const [idUploaded, setIdUploaded] = useState(true);
  const [addressUploaded, setAddressUploaded] = useState(true);
  const [idFileName, setIdFileName] = useState<string | null>(null);
  const [addressFileName, setAddressFileName] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const idInputRef = React.useRef<HTMLInputElement>(null);
  const addressInputRef = React.useRef<HTMLInputElement>(null);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (ninNumber.trim().length < 11) {
      setError('Please provide a valid 11-digit NIN or ID number.');
      return;
    }
    setError(null);
    onContinue({
      idType,
      ninNumber: ninNumber.trim(),
      idDocumentName: idUploaded ? 'nin_slip_verified.pdf' : 'id_document.pdf',
      proofOfAddressName: addressUploaded ? 'utility_bill_verified.jpg' : 'address_doc.pdf',
    });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="flex items-center gap-3 pb-3 border-b border-border">
        <div className="w-10 h-10 rounded-full bg-brand-50 flex items-center justify-center text-brand-600">
          <UserCheck className="w-5 h-5" />
        </div>
        <div>
          <h3 className="text-lg font-bold text-text">Step 1 of 2: KYC Verification</h3>
          <p className="text-xs text-text-muted">
            Provide identity and address details to activate commission earning.
          </p>
        </div>
      </div>

      <div className="space-y-3">
        <div>
          <label className="block text-xs font-semibold text-text uppercase tracking-wider mb-1">
            Identification Document Type
          </label>
          <select
            value={idType}
            onChange={(e) => setIdType(e.target.value)}
            className="w-full h-10 px-3 rounded-lg border border-border bg-white text-sm focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none"
          >
            <option value="National Identity Number (NIN)">National Identity Number (NIN)</option>
            <option value="Voter's Card">Voter&apos;s Card</option>
            <option value="Driver's License">Driver&apos;s License</option>
            <option value="International Passport">International Passport</option>
          </select>
        </div>

        <div>
          <label className="block text-xs font-semibold text-text uppercase tracking-wider mb-1">
            ID / NIN Number (11 Digits)
          </label>
          <input
            type="text"
            value={ninNumber}
            maxLength={11}
            onChange={(e) => setNinNumber(e.target.value)}
            placeholder="e.g. 12345678901"
            className="w-full h-10 px-3 rounded-lg border border-border bg-white text-sm focus:border-brand-500 focus:ring-1 focus:ring-brand-500 outline-none"
          />
          {error && <p className="text-error text-xs mt-1">{error}</p>}
        </div>

        {/* Proof of Identity Upload */}
        <input
          ref={idInputRef}
          type="file"
          accept=".pdf,.jpg,.jpeg,.png"
          onChange={(e) => {
            const f = e.target.files?.[0];
            if (f) {
              setIdFileName(f.name);
              setIdUploaded(true);
            }
          }}
          className="hidden"
          aria-label="Upload proof of identity"
        />
        <div
          onClick={() => idInputRef.current?.click()}
          className={`p-3 rounded-lg border flex items-center justify-between cursor-pointer transition-colors ${
            idUploaded ? 'bg-success-50 border-success-main/40' : 'bg-surface-1 border-border hover:bg-surface-2'
          }`}
        >
          <div className="flex items-center gap-3">
            <FileText className={`w-5 h-5 ${idUploaded ? 'text-success-main' : 'text-text-muted'}`} />
            <div>
              <p className="text-sm font-semibold text-text">Proof of Identity (Government ID)</p>
              <p className="text-xs text-text-muted">
                {idFileName ? `${idFileName} (Selected)` : idUploaded ? 'nin_slip.pdf (Uploaded)' : 'Click to select document'}
              </p>
            </div>
          </div>
          {idUploaded ? (
            <CheckCircle2 className="w-5 h-5 text-success-main" />
          ) : (
            <Upload className="w-4 h-4 text-text-muted" />
          )}
        </div>

        {/* Proof of Address Upload */}
        <input
          ref={addressInputRef}
          type="file"
          accept=".pdf,.jpg,.jpeg,.png"
          onChange={(e) => {
            const f = e.target.files?.[0];
            if (f) {
              setAddressFileName(f.name);
              setAddressUploaded(true);
            }
          }}
          className="hidden"
          aria-label="Upload proof of address"
        />
        <div
          onClick={() => addressInputRef.current?.click()}
          className={`p-3 rounded-lg border flex items-center justify-between cursor-pointer transition-colors ${
            addressUploaded ? 'bg-success-50 border-success-main/40' : 'bg-surface-1 border-border hover:bg-surface-2'
          }`}
        >
          <div className="flex items-center gap-3">
            <FileText className={`w-5 h-5 ${addressUploaded ? 'text-success-main' : 'text-text-muted'}`} />
            <div>
              <p className="text-sm font-semibold text-text">Proof of Address (Utility Bill)</p>
              <p className="text-xs text-text-muted">
                {addressFileName ? `${addressFileName} (Selected)` : addressUploaded ? 'utility_bill.jpg (Uploaded)' : 'Click to select document'}
              </p>
            </div>
          </div>
          {addressUploaded ? (
            <CheckCircle2 className="w-5 h-5 text-success-main" />
          ) : (
            <Upload className="w-4 h-4 text-text-muted" />
          )}
        </div>
      </div>

      <div className="flex items-center justify-end gap-3 pt-3 border-t border-border">
        <Button type="button" variant="outline" onClick={onCancel}>
          Cancel
        </Button>
        <Button type="submit">
          Continue to Fee Payment
        </Button>
      </div>
    </form>
  );
}
