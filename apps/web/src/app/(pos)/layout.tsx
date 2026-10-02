import { Inter, Roboto_Mono } from 'next/font/google';
import Link from 'next/link';

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' });
const robotoMono = Roboto_Mono({ subsets: ['latin'], variable: '--font-roboto-mono' });

export default function PosLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className={`h-screen bg-bg text-text font-sans flex flex-col ${inter.variable} ${robotoMono.variable}`}>
      {/* POS Top Bar - No Sidebar for maximum space */}
      <header className="h-16 bg-surface border-b border-border flex items-center justify-between px-6 shrink-0 shadow-sm z-10">
        <div className="flex items-center gap-4">
          <Link href="/pos" className="font-bold text-xl text-primary flex items-center gap-2">
            <span className="w-8 h-8 rounded bg-primary text-white flex items-center justify-center font-bold text-lg">A</span>
            ABA POS
          </Link>
          <div className="h-6 w-px bg-border mx-2"></div>
          <div className="flex items-center gap-2 text-sm text-text-muted">
            <span className="font-medium text-text">ABA HQ Store</span>
            <span>•</span>
            <span className="flex items-center gap-1">
              <span className="w-2 h-2 rounded-full bg-success"></span> Online
            </span>
          </div>
        </div>
        
        <div className="flex items-center gap-4">
          <Link href="/erp/dashboard" className="text-sm font-medium text-text-muted hover:text-text transition-colors">
            Exit to ERP
          </Link>
          <div className="flex items-center gap-2 pl-4 border-l border-border">
            <div className="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-medium">
              AB
            </div>
            <div className="text-sm font-medium">Aisha Bello</div>
          </div>
        </div>
      </header>

      {/* POS Main Content Area */}
      <main className="flex-1 overflow-hidden flex flex-col relative">
        {children}
      </main>
    </div>
  );
}
