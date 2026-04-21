'use client';

import { useState } from 'react';
import { Map, MousePointer2 } from 'lucide-react';

import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';

import { RapidGuestProvider } from '../context/rapid-guest-context';

import { MapModeTab } from './map-mode-tab';
import { PickModeTab } from './pick-mode-tab';

interface RapidExperienceProps {
  isAuthenticated: boolean;
}

export function RapidExperience({ isAuthenticated }: RapidExperienceProps) {
  // Tracks whether any child tab is currently in an active game session.
  // When true, we hide the page title and the tab switcher so the user can
  // focus on gameplay without the "choose a mode" chrome competing for space.
  const [isPlaying, setIsPlaying] = useState(false);

  return (
    <RapidGuestProvider key={isAuthenticated ? 'auth' : 'guest'} isAuthenticated={isAuthenticated}>
      <div className='container mx-auto px-4 py-8'>
        {!isPlaying && (
          <div className='mb-8'>
            <h1 className='mb-2 text-4xl font-bold'>Rapid Mode</h1>
            <p className='text-lg text-muted-foreground'>Fast-paced training to sharpen your GeoGuessr skills</p>
          </div>
        )}

        <Tabs defaultValue='pick' className='w-full'>
          {!isPlaying && (
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
          )}

          <TabsContent value='pick' className='mt-0'>
            <PickModeTab isAuthenticated={isAuthenticated} onPlayingChange={setIsPlaying} />
          </TabsContent>

          <TabsContent value='map' className='mt-0'>
            <MapModeTab isAuthenticated={isAuthenticated} onPlayingChange={setIsPlaying} />
          </TabsContent>
        </Tabs>
      </div>
    </RapidGuestProvider>
  );
}
