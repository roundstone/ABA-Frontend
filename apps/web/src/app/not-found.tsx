'use client';

import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { ArrowLeft, FileQuestion, Home } from 'lucide-react';

export default function NotFound() {
  const router = useRouter();

  const handleGoBack = () => {
    // Check whether browser history has a previous entry.
    if (window.history.length > 1) {
      router.back();
    } else {
      // Fallback when the page was opened directly.
      router.push('/');
    }
  };

  return (
    <div className="flex min-h-screen flex-1 flex-col items-center justify-center p-8 text-center">
      <div className="relative mb-6 flex h-16 w-16 items-center justify-center rounded-full bg-surface-2 text-[200px] font-bold text-text-muted/30">
        <span
          className="leading-none"
          style={{
            maskImage: 'linear-gradient(to bottom, black 25%, transparent 100%)',
            WebkitMaskImage: 'linear-gradient(to bottom, black 25%, transparent 100%)',
          }}
        >
          ?
        </span>
      </div>

      <h2 className="mb-3 text-2xl font-bold text-text">
        Page Not Found
      </h2>

      <p className="mb-8 max-w-md text-base text-text-muted">
        This page doesn't exist or was deleted. If you followed
        a link, it might be broken or outdated.
      </p>

      <div className="flex flex-wrap justify-center items-center gap-3">
        <Button variant="outline" onClick={handleGoBack}>
          <ArrowLeft className="mr-2 h-4 w-4" />
          Go Back
        </Button>

        <Button variant="primary">
          <Link href="/" className="flex flex-wrap justify-center items-center">
            <Home className="mr-2 h-4 w-4" />
            Go Home
          </Link>
        </Button>
      </div>
    </div>
  );
}