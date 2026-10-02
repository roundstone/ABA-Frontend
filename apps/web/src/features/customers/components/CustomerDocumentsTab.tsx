import { Customer } from '../types';
import { Button } from '@/components/ui/button';
import { FileText, CheckCircle2, AlertCircle } from 'lucide-react';

interface Props {
  customer: Customer;
}

export function CustomerDocumentsTab({ customer }: Props) {
  const mockDocs = [
    { id: 'DOC-01', type: 'Government ID', status: 'Verified', date: '2023-11-01', file: 'passport.jpg' },
    { id: 'DOC-02', type: 'Utility Bill', status: 'Pending', date: '2023-11-15', file: 'bill_oct.pdf' },
  ];

  return (
    <div className="bg-surface rounded-xl border border-border overflow-hidden">
      <div className="p-4 border-b border-border bg-surface-2/30 flex justify-between items-center">
        <h3 className="font-medium">KYC Documents</h3>
        <Button variant="outline" size="sm">Request Document</Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 p-6">
        {mockDocs.map(doc => (
          <div key={doc.id} className="flex items-start gap-4 p-4 rounded-lg border border-border bg-surface-2">
            <div className={`p-3 rounded-full ${doc.status === 'Verified' ? 'bg-success/10 text-success' : 'bg-warning-light text-warning-dark'}`}>
              <FileText className="w-6 h-6" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex justify-between items-start mb-1">
                <h4 className="font-medium text-text truncate">{doc.type}</h4>
                {doc.status === 'Verified' ? (
                  <CheckCircle2 className="w-4 h-4 text-success" />
                ) : (
                  <AlertCircle className="w-4 h-4 text-warning-dark" />
                )}
              </div>
              <p className="text-xs text-text-muted font-mono truncate">{doc.file}</p>
              <p className="text-xs text-text-muted mt-2">Uploaded on {new Date(doc.date).toLocaleDateString()}</p>
              
              {doc.status === 'Pending' && (
                <div className="flex gap-2 mt-3">
                  <Button size="sm" className="text-xs bg-success hover:bg-success/90">Verify</Button>
                  <Button variant="outline" size="sm" className="text-xs text-error hover:text-error">Reject</Button>
                </div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
