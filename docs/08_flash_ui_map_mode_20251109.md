# Step 8: Flash UI - Map Mode

**Timeline:** 5-6 hours
**Priority:** High (Completes Flash feature set)

## Overview
Build the map-based Flash game UI, integrating the MapViewer component created in Step 7 with the game flow.

## Prerequisites
- Step 6 completed (Flash UI Choice Mode)
- Step 7 completed (MapLibre Integration)

## Detailed Tasks

### 8.1 Create Map Card Component

#### `/src/features/flash/components/map-card.tsx`

```typescript
'use client';

import { useState } from 'react';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { MapViewer } from './map-viewer';
import { Badge } from '@/components/ui/badge';
import { CheckCircle2, XCircle, MapPin } from 'lucide-react';
import type { Region } from '../types';

interface MapCardProps {
  payload: any;
  answerRegions: Region[];
  bbox: [number, number, number, number];
  onAnswer: (pinDrop: [number, number], timeMs: number) => void;
}

export function MapCard({ payload, answerRegions, bbox, onAnswer }: MapCardProps) {
  const [pinLocation, setPinLocation] = useState<[number, number] | null>(null);
  const [submitted, setSubmitted] = useState(false);
  const [result, setResult] = useState<{ correct: boolean; distance?: number } | null>(null);
  const [startTime] = useState(Date.now());

  const handlePinDrop = (lng: number, lat: number) => {
    if (submitted) return;
    setPinLocation([lng, lat]);
  };

  const handleSubmit = async () => {
    if (!pinLocation || submitted) return;

    setSubmitted(true);
    const timeMs = Date.now() - startTime;

    // Client-side validation (for immediate feedback)
    const validation = await validatePinDropClient(pinLocation, answerRegions);
    setResult(validation);

    // Wait for feedback animation
    setTimeout(() => {
      onAnswer(pinLocation, timeMs);
    }, 2500);
  };

  return (
    <Card className="max-w-4xl mx-auto">
      <CardHeader className="text-center space-y-4">
        {/* Prompt */}
        <div>
          <div className="text-lg font-medium text-muted-foreground mb-2">
            {getPromptLabel(payload)}
          </div>
          <div className="text-4xl font-bold">
            {payload.text || payload.number || payload.city}
          </div>
          {payload.romanization && (
            <div className="text-sm text-muted-foreground mt-1">
              {payload.romanization}
            </div>
          )}
        </div>

        {/* Instructions */}
        {!pinLocation && (
          <Badge variant="outline" className="inline-flex items-center gap-2">
            <MapPin className="w-4 h-4" />
            Click on the map to place your answer
          </Badge>
        )}

        {/* Result Feedback */}
        {result && (
          <div className={`flex items-center justify-center gap-2 p-3 rounded-lg ${
            result.correct ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
          }`}>
            {result.correct ? (
              <>
                <CheckCircle2 className="w-5 h-5" />
                <span className="font-medium">Correct!</span>
                {result.distance && (
                  <span className="text-sm">({result.distance.toFixed(0)} km away)</span>
                )}
              </>
            ) : (
              <>
                <XCircle className="w-5 h-5" />
                <span className="font-medium">Not quite!</span>
                {result.distance && (
                  <span className="text-sm">({result.distance.toFixed(0)} km from answer)</span>
                )}
              </>
            )}
          </div>
        )}
      </CardHeader>

      <CardContent className="space-y-4">
        {/* Map */}
        <MapViewer
          regions={answerRegions}
          bbox={bbox}
          onPinDrop={handlePinDrop}
          disabled={submitted}
          showAnswer={submitted}
        />

        {/* Submit Button */}
        <Button
          size="lg"
          className="w-full"
          onClick={handleSubmit}
          disabled={!pinLocation || submitted}
        >
          {pinLocation ? 'Submit Answer' : 'Place pin to continue'}
        </Button>
      </CardContent>
    </Card>
  );
}

function getPromptLabel(payload: any): string {
  if (payload.text) return 'Where is this script used?';
  if (payload.number) return 'Where is this phone number from?';
  if (payload.city) return 'Where is this city located?';
  return 'Click on the map';
}

// Client-side validation for immediate feedback
async function validatePinDropClient(
  pinDrop: [number, number],
  regions: Region[]
): Promise<{ correct: boolean; distance?: number }> {
  // Import Turf.js dynamically to keep bundle size down
  const turf = await import('@turf/turf');
  const [lng, lat] = pinDrop;
  const point = turf.point([lng, lat]);

  for (const region of regions) {
    if (region.geometry) {
      try {
        const polygon = turf.feature(region.geometry as any);
        if (turf.booleanPointInPolygon(point, polygon)) {
          return { correct: true };
        }
      } catch (e) {
        // Fallback to centroid
      }
    }

    // Centroid check
    const [centerLng, centerLat] = region.centroid_lonlat;
    const center = turf.point([centerLng, centerLat]);
    const distance = turf.distance(point, center, { units: 'kilometers' });
    const tolerance = region.meta.tolerance_km ?? 50;

    if (distance <= tolerance) {
      return { correct: true, distance };
    }
  }

  // Find distance to nearest
  const distances = regions.map(r => {
    const [centerLng, centerLat] = r.centroid_lonlat;
    const center = turf.point([centerLng, centerLat]);
    return turf.distance(point, center, { units: 'kilometers' });
  });

  return {
    correct: false,
    distance: Math.min(...distances),
  };
}
```

### 8.2 Update Game Screen for Map Mode

Modify `/src/features/flash/components/game-screen.tsx`:

```typescript
'use client';

import { useState, useEffect } from 'react';
import { ChoiceCard } from './choice-card';
import { MapCard } from './map-card';
import { ProgressHeader } from './progress-header';
import { SessionRecap } from './session-recap';

// ... existing code

export function GameScreen({ queueItems, mode, onComplete }: GameScreenProps) {
  // ... existing state

  const isMapMode = mode.endsWith('-map');

  const handleAnswer = (selectedKeyOrPin: string | [number, number], timeMs: number) => {
    const item = queueItems[currentIndex];
    const newResult = {
      fact_id: item.fact_id,
      ...(typeof selectedKeyOrPin === 'string'
        ? { selected_key: selectedKeyOrPin }
        : { pin_drop: selectedKeyOrPin }
      ),
      time_ms: timeMs,
      correct: false, // Will be validated server-side
    };

    const newResults = [...results, newResult];
    setResults(newResults);

    // Move to next card or show recap
    if (currentIndex < queueItems.length - 1) {
      setTimeout(() => {
        setCurrentIndex(currentIndex + 1);
      }, 100);
    } else {
      // Session complete
      onComplete(newResults);
    }
  };

  // ... existing code

  const currentItem = queueItems[currentIndex];

  return (
    <div className="max-w-4xl mx-auto p-6">
      <ProgressHeader
        current={currentIndex + 1}
        total={queueItems.length}
        correct={correctCount}
        timeElapsed={timeElapsed}
      />

      {isMapMode ? (
        <MapCard
          payload={currentItem.payload}
          answerRegions={currentItem.answer_regions || []}
          bbox={currentItem.bbox || [-180, -90, 180, 90]}
          onAnswer={(pin, time) => handleAnswer(pin, time)}
        />
      ) : (
        <ChoiceCard
          payload={currentItem.payload}
          options={currentItem.options}
          onAnswer={(key, time) => handleAnswer(key, time)}
        />
      )}
    </div>
  );
}
```

### 8.3 Update Session Builder for Map Modes

Modify `/src/features/flash/components/session-builder.tsx`:

```typescript
export function SessionBuilder({ onStart }: SessionBuilderProps) {
  // ... existing state

  return (
    <Card className="max-w-2xl mx-auto">
      <CardHeader>
        <CardTitle>Start a Flash Session</CardTitle>
        <CardDescription>
          Choose your training mode and answer type
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Mode Selection */}
        <div className="space-y-2">
          <label className="text-sm font-medium">Game Type</label>
          <div className="grid grid-cols-3 gap-3">
            <Button
              variant={mode.startsWith('language') ? 'default' : 'outline'}
              onClick={() => setMode('language-choice')}
              className="h-auto py-3"
            >
              <div className="text-center">
                <div className="font-semibold">Languages</div>
              </div>
            </Button>
            <Button
              variant={mode.startsWith('phone') ? 'default' : 'outline'}
              onClick={() => setMode('phone-choice')}
              className="h-auto py-3"
            >
              <div className="text-center">
                <div className="font-semibold">Phone Codes</div>
              </div>
            </Button>
            <Button
              variant={mode.startsWith('city') ? 'default' : 'outline'}
              onClick={() => setMode('city-map')}
              className="h-auto py-3"
            >
              <div className="text-center">
                <div className="font-semibold">Cities</div>
              </div>
            </Button>
          </div>
        </div>

        {/* Answer Mode (if not city) */}
        {!mode.startsWith('city') && (
          <div className="space-y-2">
            <label className="text-sm font-medium">Answer Type</label>
            <div className="grid grid-cols-2 gap-3">
              <Button
                variant={mode.endsWith('choice') ? 'default' : 'outline'}
                onClick={() => setMode(mode.split('-')[0] + '-choice' as any)}
              >
                Multiple Choice
              </Button>
              <Button
                variant={mode.endsWith('map') ? 'default' : 'outline'}
                onClick={() => setMode(mode.split('-')[0] + '-map' as any)}
              >
                Pin on Map
              </Button>
            </div>
          </div>
        )}

        {/* ... rest of component */}
      </CardContent>
    </Card>
  );
}
```

### 8.4 Add Loading State for Map

Create `/src/features/flash/components/map-loading.tsx`:

```typescript
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
```

Add lazy loading to MapViewer:

```typescript
import dynamic from 'next/dynamic';
import { MapLoading } from './map-loading';

const MapViewer = dynamic(
  () => import('./map-viewer').then(mod => ({ default: mod.MapViewer })),
  {
    loading: () => <MapLoading />,
    ssr: false,
  }
);
```

### 8.5 Add Keyboard Shortcuts

Enhance MapCard with keyboard support:

```typescript
useEffect(() => {
  const handleKeyPress = (e: KeyboardEvent) => {
    if (e.key === 'Enter' && pinLocation && !submitted) {
      handleSubmit();
    }
  };

  window.addEventListener('keydown', handleKeyPress);
  return () => window.removeEventListener('keydown', handleKeyPress);
}, [pinLocation, submitted]);
```

## Files to Create/Modify

### Created:
- `/src/features/flash/components/map-card.tsx`
- `/src/features/flash/components/map-loading.tsx`

### Modified:
- `/src/features/flash/components/game-screen.tsx` (add map mode support)
- `/src/features/flash/components/session-builder.tsx` (add map mode selection)

## Acceptance Criteria
- ✅ Session builder shows map mode options
- ✅ Map card displays with correct bbox
- ✅ Clicking map places pin marker
- ✅ Submit button enables after pin placement
- ✅ Feedback shows correct/incorrect with distance
- ✅ Answer regions highlighted after submission
- ✅ Progress flows to next card after 2.5s
- ✅ Keyboard shortcut (Enter) submits answer
- ✅ Map loads lazily with loading indicator
- ✅ Mobile-responsive map interaction

## Notes & Considerations

### UX Flow
1. Display prompt + empty map
2. User clicks to place pin
3. Submit button becomes active
4. User clicks submit (or presses Enter)
5. Show feedback + highlight correct regions
6. Auto-advance after 2.5s

### Feedback Design
- **Correct**: Green badge, checkmark, show distance if available
- **Incorrect**: Red badge, X mark, show distance to nearest region
- **Visual**: Highlight answer regions in green overlay

### Performance
- Lazy load MapLibre bundle (saves ~200KB initial load)
- Cache region geometries for session duration
- Debounce pin drops (prevent rapid re-renders)

### Accessibility
- Keyboard navigation (Enter to submit, Escape to reset pin)
- Screen reader announcements for feedback
- High contrast mode support

## Dependencies
- Step 6 (Flash UI Choice Mode)
- Step 7 (MapLibre Integration)

## Blocks
- None (Flash feature complete after this)
