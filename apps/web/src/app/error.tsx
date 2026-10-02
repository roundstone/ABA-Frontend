'use client';

import { ErrorState } from '@/components/patterns/ErrorState';
import { useEffect } from 'react';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // Log the error to an error reporting service
    console.error(error);
  }, [error]);

  return (
    <div className="flex-1 flex flex-col items-center justify-center min-h-screen p-8">
      <ErrorState 
        title="Something went wrong"
        description="An unexpected error occurred while rendering this page."
        onRetry={() => reset()}
        requestId={error.digest}
      />
    </div>
  );
}
