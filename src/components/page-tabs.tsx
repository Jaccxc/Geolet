'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

import { cn } from '@/utils/cn';

const tabs = [
  { name: 'Dashboard', href: '/' },
  { name: 'Rapid', href: '/rapid' },
  { name: 'Insight', href: '/insight' },
];

export function PageTabs() {
  const pathname = usePathname();

  const isActive = (href: string) => {
    if (href === '/') {
      return pathname === '/';
    }
    return pathname.startsWith(href);
  };

  return (
    <div className='border-white/8 flex-shrink-0 border-b'>
      <div className='w-full flex justify-start px-8'>
        <nav className='flex gap-6'>
          {tabs.map((tab) => (
            <Link
              key={tab.href}
              href={tab.href}
              className={cn(
                'relative border-b-2 py-4 text-sm font-medium transition-colors',
                isActive(tab.href)
                  ? 'border-blue-500 text-white'
                  : 'border-transparent text-gray-400 hover:text-gray-300'
              )}
            >
              {tab.name}
            </Link>
          ))}
        </nav>
      </div>
    </div>
  );
}
