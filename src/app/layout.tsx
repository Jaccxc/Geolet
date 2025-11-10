import { PropsWithChildren } from 'react';
import type { Metadata } from 'next';
import { Montserrat, Montserrat_Alternates } from 'next/font/google';
import Link from 'next/link';

import { Logo } from '@/components/logo';
import { PageTabs } from '@/components/page-tabs';
import { Toaster } from '@/components/ui/toaster';
import { getSession } from '@/features/account/controllers/get-session';
import { cn } from '@/utils/cn';
import { Analytics } from '@vercel/analytics/react';

import { Navigation } from './navigation';

import '@/styles/globals.css';

export const dynamic = 'force-dynamic';

const montserrat = Montserrat({
  variable: '--font-montserrat',
  subsets: ['latin'],
});

const montserratAlternates = Montserrat_Alternates({
  variable: '--font-montserrat-alternates',
  weight: ['500', '600', '700'],
  subsets: ['latin'],
});

export const metadata: Metadata = {
  title: 'Geolet - GeoGuessr Training Platform',
  description:
    'Master GeoGuessr with focused minigames for languages, phone codes, and cities. Analyze your performance and train your weak spots.',
  keywords: 'GeoGuessr, training, geoguessr practice, language scripts, phone codes, geography',
};

export default async function RootLayout({ children }: PropsWithChildren) {
  const session = await getSession();

  return (
    <html lang='en' className='dark'>
      <body className={cn('font-sans antialiased', montserrat.variable, montserratAlternates.variable)}>
        <div className='flex min-h-screen flex-col'>
          <AppBar />
          {session && <PageTabs />}
          <main className='flex-1'>
            <div className='h-full'>{children}</div>
          </main>
          <Footer />
        </div>
        <Toaster />
        <Analytics />
      </body>
    </html>
  );
}

async function AppBar() {
  return (
    <header className='border-white/8 h-[60px] min-h-[60px] flex-shrink-0 border-b'>
      <div className='container mx-auto flex h-full items-center justify-between px-4'>
        <Logo />
        <Navigation />
      </div>
    </header>
  );
}

function Footer() {
  return (
    <footer className='h-[80px] min-h-[80px] flex-shrink-0 border-t border-zinc-800'>
      <div className='container mx-auto flex h-full items-center justify-between px-4 text-sm text-neutral-400'>
        <span className='text-xs'>Copyright {new Date().getFullYear()} © Geolet</span>
        <nav className='flex gap-6'>
          <Link href='/privacy' className='transition-colors hover:text-neutral-100'>
            Privacy
          </Link>
          <Link href='/terms' className='transition-colors hover:text-neutral-100'>
            Terms
          </Link>
          <Link href='/support' className='transition-colors hover:text-neutral-100'>
            Support
          </Link>
        </nav>
      </div>
    </footer>
  );
}
