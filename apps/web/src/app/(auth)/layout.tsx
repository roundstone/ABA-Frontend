import Link from 'next/link';

export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-background flex flex-col items-center justify-center p-4">
      <div className="mb-8">
        <Link href="/" className="flex items-center gap-2">
          <div className="w-8 h-8 bg-primary rounded-md flex items-center justify-center">
            <span className="text-white font-bold text-lg leading-none">A</span>
          </div>
          <span className="font-bold text-xl tracking-tight text-foreground">ABA Online</span>
        </Link>
      </div>
      <div className="w-full max-w-[420px] bg-card rounded-xl shadow-md border border-border p-6 sm:p-8">
        {children}
      </div>
    </div>
  );
}
