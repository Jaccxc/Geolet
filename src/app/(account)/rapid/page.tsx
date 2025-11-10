'use client';

import { Map, MousePointer2 } from 'lucide-react';

import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { MapModeTab } from '@/features/rapid/components/map-mode-tab';
import { PickModeTab } from '@/features/rapid/components/pick-mode-tab';

export default function RapidPage() {
  return (
    <div className='container mx-auto px-4 py-8'>
      <div className='mb-8'>
        <h1 className='mb-2 text-4xl font-bold'>Rapid Mode</h1>
        <p className='text-lg text-muted-foreground'>Fast-paced training to sharpen your GeoGuessr skills</p>
      </div>

      <Tabs defaultValue='pick' className='w-full'>
        <TabsList className='mb-8 grid w-full max-w-md grid-cols-2'>
          <TabsTrigger value='pick' className='flex items-center gap-2'>
            <MousePointer2 className='h-4 w-4' />
            <span>Pick Mode</span>
          </TabsTrigger>
          <TabsTrigger value='map' className='flex items-center gap-2'>
            <Map className='h-4 w-4' />
            <span>Map Mode</span>
          </TabsTrigger>
        </TabsList>

        <TabsContent value='pick' className='mt-0'>
          <PickModeTab />
        </TabsContent>

        <TabsContent value='map' className='mt-0'>
          <MapModeTab />
        </TabsContent>
      </Tabs>
    </div>
  );
}
