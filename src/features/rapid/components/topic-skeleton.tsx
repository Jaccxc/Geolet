// components/topic-skeleton.tsx
'use client';

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';

export function TopicSkeleton() {
  return (
    <Card className='animate-pulse'>
      <CardHeader>
        <CardTitle className='flex items-center gap-2'>
          <Skeleton className='h-5 w-5 rounded-full' />
          <Skeleton className='h-5 w-32' />
        </CardTitle>
        <Skeleton className='mt-2 h-4 w-48' />
      </CardHeader>
      <CardContent>
        <Skeleton className='h-4 w-24' />
      </CardContent>
    </Card>
  );
}
