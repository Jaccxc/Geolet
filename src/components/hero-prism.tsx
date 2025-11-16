'use client';

import dynamic from 'next/dynamic';

import { cn } from '@/utils/cn';

const Prism = dynamic(() => import('./Prism'), {
  ssr: false,
  loading: () => <div className='h-full w-full animate-pulse rounded-2xl bg-white/5' />,
});

type HeroPrismProps = {
  className?: string;
};

export function HeroPrism({ className }: HeroPrismProps) {
  return (
    <div className={cn('relative h-[40rem] w-full', className)}>
      <Prism
        animationType='rotate'
        timeScale={0.5}
        height={3.5}
        baseWidth={5.5}
        scale={3.6}
        hueShift={0}
        colorFrequency={1}
        noise={0}
        glow={1}
      />
    </div>
  );
}

