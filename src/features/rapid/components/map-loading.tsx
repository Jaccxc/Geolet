'use client';

import { Loader2 } from 'lucide-react';

export function MapLoading() {
  return (
    <div className="map-container flex items-center justify-center bg-muted">
      <div className="text-center space-y-2">
        <Loader2 className="w-8 h-8 animate-spin mx-auto text-muted-foreground" />
        <p className="text-sm text-muted-foreground">Loading map...</p>
      </div>
    </div>
  );
}
