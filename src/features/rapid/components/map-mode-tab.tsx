'use client';

import { Construction } from 'lucide-react';

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export function MapModeTab() {
  return (
    <div className='flex items-center justify-center py-20'>
      <Card className='w-full max-w-lg border-border bg-card'>
        <CardHeader>
          <CardTitle className='flex items-center justify-center gap-3 text-center'>
            <Construction className='h-6 w-6 text-yellow-500' />
            <span>Under Construction</span>
          </CardTitle>
        </CardHeader>
        <CardContent className='space-y-4 text-center'>
          <p className='text-muted-foreground'>Map Mode is currently under development. Check back soon!</p>
          <div className='text-sm text-muted-foreground'>
            This mode will let you practice by clicking on a map to identify regions, cities, and countries based on
            language scripts and phone codes.
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
