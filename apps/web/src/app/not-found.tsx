import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { FileQuestion } from 'lucide-react';

export default function NotFound() {
  return (
    <div className="flex-1 flex flex-col items-center justify-center p-8 text-center min-h-screen">
      <div className="w-16 h-16 mb-6 text-text-muted/30 flex items-center justify-center bg-surface-2 rounded-full">
        <FileQuestion className="w-8 h-8" />
      </div>
      <h2 className="text-2xl font-bold text-text mb-3">
        Page Not Found
      </h2>
      <p className="text-base text-text-muted max-w-md mb-8">
        This page doesn't exist or was deleted. If you followed a link, it might be broken or outdated.
      </p>
      
      <div className="flex flex-wrap justify-center gap-3">
        <Link href="/">
          <Button variant="primary">Go Home</Button>
        </Link>
      </div>
    </div>
  );
}
