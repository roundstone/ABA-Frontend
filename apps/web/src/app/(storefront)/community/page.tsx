import { getPageBySlug } from '@/features/content/api';
import { brand } from '@/config/brand';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Users, Info, ArrowRight, TrendingUp } from 'lucide-react';
import React from 'react';

export default async function CommunityPage() {
  const page = await getPageBySlug('community');
  
  // Sort sections by order
  const sections = [...page.sections].sort((a, b) => a.order - b.order);

  // We only show published content to the public
  const publishedSections = sections.filter(s => s.status === 'Published');

  // We map them by a stable identifier or just map over them
  return (
    <div className="flex flex-col w-full font-sans pt-4 mt-20 animate-in fade-in duration-1000">
      <section className="py-16 border-b border-border bg-brand-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-4xl md:text-5xl font-extrabold text-brand-900 mb-6">
            {page.title}
          </h1>
          <p className="text-xl text-text-muted max-w-3xl mx-auto mb-8">
            {publishedSections.find(s => s.name === 'Hero')?.content || `Join the ${brand.name} community.`}
          </p>
          <div className="flex justify-center gap-4">
            <Button asChild size="lg" className="bg-copper hover:bg-copper-hover text-white">
              <Link href="/auth/register">Join</Link>
            </Button>
            <Button asChild size="lg" variant="outline">
              <Link href="/portal/referrals/share">Share your link</Link>
            </Button>
          </div>
        </div>
      </section>

      <section className="py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-2 gap-12">
            <div>
              <h2 className="text-2xl font-bold text-brand-900 mb-4 flex items-center gap-2">
                <Users className="w-6 h-6 text-brand-600" /> 
                How the hierarchy works
              </h2>
              <div className="prose text-text-muted max-w-none">
                {publishedSections.find(s => s.name === 'How the hierarchy works')?.content}
              </div>
            </div>
            
            <div>
              <h2 className="text-2xl font-bold text-brand-900 mb-4 flex items-center gap-2">
                <TrendingUp className="w-6 h-6 text-brand-600" />
                Earning
              </h2>
              <div className="prose text-text-muted max-w-none">
                {publishedSections.find(s => s.name === 'Earning')?.content}
              </div>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-brand-900 mb-4 flex items-center gap-2">
                <Info className="w-6 h-6 text-brand-600" />
                Purchasing advantages
              </h2>
              <div className="prose text-text-muted max-w-none">
                {publishedSections.find(s => s.name === 'Purchasing advantages')?.content}
              </div>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-brand-900 mb-4 flex items-center gap-2">
                <Info className="w-6 h-6 text-brand-600" />
                FAQ
              </h2>
              <div className="prose text-text-muted max-w-none whitespace-pre-wrap">
                {publishedSections.find(s => s.name === 'FAQ')?.content}
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="py-16 border-t border-border bg-surface-2 text-center">
        <div className="max-w-3xl mx-auto px-4">
          <h2 className="text-3xl font-bold text-text mb-4">
            {publishedSections.find(s => s.name === 'Call to action')?.content || 'Ready to start earning?'}
          </h2>
          <Button asChild size="lg" className="bg-brand-600 hover:bg-brand-700 text-white mt-4">
            <Link href="/auth/register">Join the Community <ArrowRight className="w-4 h-4 ml-2" /></Link>
          </Button>
        </div>
      </section>
    </div>
  );
}
