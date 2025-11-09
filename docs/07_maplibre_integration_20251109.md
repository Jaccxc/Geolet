# Step 7: MapLibre Integration & Pin-Drop Validation

**Timeline:** 6-8 hours
**Priority:** High (Core differentiator for Geolet)

## Overview
Integrate MapLibre GL JS for interactive map rendering and implement pin-drop answer validation using Turf.js for geometric calculations.

## Prerequisites
- Step 4 completed (types with Region schema)
- Understanding of MapLibre GL JS
- Familiarity with GeoJSON and Turf.js

## Detailed Tasks

### 7.1 Install Dependencies

```bash
bun add maplibre-gl
bun add @turf/turf @turf/helpers
bun add -D @types/maplibre-gl
```

### 7.2 Setup MapLibre Styles

Add to `/src/app/globals.css`:

```css
/* MapLibre GL CSS */
@import 'maplibre-gl/dist/maplibre-gl.css';

/* Custom map styles */
.map-container {
  position: relative;
  width: 100%;
  height: 500px;
  border-radius: 0.5rem;
  overflow: hidden;
}

.map-pin-cursor {
  cursor: crosshair !important;
}

.map-overlay {
  position: absolute;
  top: 1rem;
  left: 1rem;
  background: white;
  padding: 0.75rem 1rem;
  border-radius: 0.375rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  z-index: 10;
}
```

### 7.3 Create Map Component

#### `/src/features/flash/components/map-viewer.tsx`

```typescript
'use client';

import { useEffect, useRef, useState } from 'react';
import maplibregl from 'maplibre-gl';
import * as turf from '@turf/turf';
import type { Region } from '../types';

interface MapViewerProps {
  regions: Region[];
  bbox?: [number, number, number, number];
  onPinDrop?: (lng: number, lat: number) => void;
  disabled?: boolean;
  showAnswer?: boolean;
}

export function MapViewer({
  regions,
  bbox,
  onPinDrop,
  disabled = false,
  showAnswer = false,
}: MapViewerProps) {
  const mapContainer = useRef<HTMLDivElement>(null);
  const map = useRef<maplibregl.Map | null>(null);
  const [userPin, setUserPin] = useState<maplibregl.Marker | null>(null);

  useEffect(() => {
    if (!mapContainer.current || map.current) return;

    // Initialize map
    map.current = new maplibregl.Map({
      container: mapContainer.current,
      style: {
        version: 8,
        sources: {
          'raster-tiles': {
            type: 'raster',
            tiles: [
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ],
            tileSize: 256,
            attribution: '© OpenStreetMap contributors',
          },
        },
        layers: [
          {
            id: 'simple-tiles',
            type: 'raster',
            source: 'raster-tiles',
            minzoom: 0,
            maxzoom: 19,
          },
        ],
      },
      center: [0, 20],
      zoom: 1.5,
    });

    // Fit to bbox if provided
    if (bbox) {
      map.current.fitBounds(
        [
          [bbox[0], bbox[1]], // SW
          [bbox[2], bbox[3]], // NE
        ],
        { padding: 50, maxZoom: 10 }
      );
    }

    // Add navigation controls
    map.current.addControl(new maplibregl.NavigationControl(), 'top-right');

    return () => {
      map.current?.remove();
      map.current = null;
    };
  }, [bbox]);

  // Handle pin drop
  useEffect(() => {
    if (!map.current || disabled) return;

    const handleClick = (e: maplibregl.MapMouseEvent) => {
      const { lng, lat } = e.lngLat;

      // Remove existing user pin
      if (userPin) {
        userPin.remove();
      }

      // Add new pin
      const pin = new maplibregl.Marker({ color: '#3b82f6' })
        .setLngLat([lng, lat])
        .addTo(map.current!);

      setUserPin(pin);

      // Callback
      if (onPinDrop) {
        onPinDrop(lng, lat);
      }
    };

    map.current.on('click', handleClick);

    return () => {
      map.current?.off('click', handleClick);
    };
  }, [disabled, onPinDrop, userPin]);

  // Show answer regions
  useEffect(() => {
    if (!map.current || !showAnswer) return;

    const sourceId = 'answer-regions';

    // Remove existing layer/source if present
    if (map.current.getLayer(sourceId)) {
      map.current.removeLayer(sourceId);
    }
    if (map.current.getSource(sourceId)) {
      map.current.removeSource(sourceId);
    }

    // Build GeoJSON FeatureCollection
    const features = regions
      .filter(r => r.geometry)
      .map(r => ({
        type: 'Feature' as const,
        properties: { name: r.name },
        geometry: r.geometry!,
      }));

    if (features.length === 0) return;

    // Add source
    map.current.addSource(sourceId, {
      type: 'geojson',
      data: {
        type: 'FeatureCollection',
        features,
      },
    });

    // Add fill layer
    map.current.addLayer({
      id: sourceId,
      type: 'fill',
      source: sourceId,
      paint: {
        'fill-color': '#10b981',
        'fill-opacity': 0.3,
      },
    });

    // Add outline layer
    map.current.addLayer({
      id: `${sourceId}-outline`,
      type: 'line',
      source: sourceId,
      paint: {
        'line-color': '#059669',
        'line-width': 2,
      },
    });
  }, [showAnswer, regions]);

  return (
    <div
      ref={mapContainer}
      className={`map-container ${!disabled ? 'map-pin-cursor' : ''}`}
    />
  );
}
```

### 7.4 Create Pin-Drop Validation Logic

#### `/src/features/flash/controllers/validate-pin-drop.ts`

```typescript
import * as turf from '@turf/turf';
import type { Region } from '../types';

export interface PinDropValidationResult {
  correct: boolean;
  distance_km?: number;
  nearest_region?: string;
}

export function validatePinDrop(
  lng: number,
  lat: number,
  answerRegions: Region[]
): PinDropValidationResult {
  const clickedPoint = turf.point([lng, lat]);

  for (const region of answerRegions) {
    // Method 1: Check polygon geometry if available
    if (region.geometry) {
      try {
        const polygon = turf.feature(region.geometry as any);

        if (turf.booleanPointInPolygon(clickedPoint, polygon)) {
          return {
            correct: true,
            nearest_region: region.name,
          };
        }
      } catch (error) {
        console.error('Polygon validation error:', error);
      }
    }

    // Method 2: Fallback to centroid + tolerance
    const [centerLng, centerLat] = region.centroid_lonlat;
    const center = turf.point([centerLng, centerLat]);
    const distance = turf.distance(clickedPoint, center, { units: 'kilometers' });

    // Get tolerance from meta or use default
    const tolerance = region.meta.tolerance_km ?? 50;

    if (distance <= tolerance) {
      return {
        correct: true,
        distance_km: distance,
        nearest_region: region.name,
      };
    }
  }

  // Find nearest region for feedback
  const distances = answerRegions.map(region => {
    const [centerLng, centerLat] = region.centroid_lonlat;
    const center = turf.point([centerLng, centerLat]);
    return {
      region: region.name,
      distance: turf.distance(clickedPoint, center, { units: 'kilometers' }),
    };
  });

  distances.sort((a, b) => a.distance - b.distance);

  return {
    correct: false,
    distance_km: distances[0]?.distance,
    nearest_region: distances[0]?.region,
  };
}
```

### 7.5 Update Queue API for Map Mode

Modify `/src/app/api/flash/queue/route.ts`:

```typescript
// Add map mode support
const requestSchema = z.object({
  mode: z.enum(['language-choice', 'phone-choice', 'language-map', 'phone-map', 'city-map']),
  targetTags: z.array(z.string()).optional(),
  maxCards: z.number().int().min(1).max(50).optional(),
});

// ... in POST handler

// For map modes, include region data and bbox
if (config.mode.endsWith('-map')) {
  const queueItems = await Promise.all(
    cards.map(async (card) => {
      // Get answer regions
      const answerKeys = getAnswerRegionKeys(card.answer);
      const { data: regions } = await supabase
        .from('regions')
        .select('*')
        .in('key', answerKeys);

      // Calculate merged bbox
      const bbox = calculateMergedBbox(regions || []);

      return {
        fact_id: card.id,
        type: card.type,
        payload: card.payload,
        difficulty: card.difficulty,
        answer_regions: regions,
        bbox,
      };
    })
  );

  return NextResponse.json({
    mode,
    items: queueItems,
    total: queueItems.length,
  });
}

// Helper functions
function getAnswerRegionKeys(answer: any): string[] {
  if (answer.kind === 'region') {
    return answer.select.keys;
  }
  if (answer.kind === 'tag' && answer.map_equivalents) {
    return answer.map_equivalents.regions;
  }
  return [];
}

function calculateMergedBbox(regions: any[]): [number, number, number, number] {
  if (regions.length === 0) return [-180, -90, 180, 90];

  let minLng = Infinity, minLat = Infinity;
  let maxLng = -Infinity, maxLat = -Infinity;

  for (const region of regions) {
    const [bMinLng, bMinLat, bMaxLng, bMaxLat] = region.bbox;
    minLng = Math.min(minLng, bMinLng);
    minLat = Math.min(minLat, bMinLat);
    maxLng = Math.max(maxLng, bMaxLng);
    maxLat = Math.max(maxLat, bMaxLat);
  }

  return [minLng, minLat, maxLng, maxLat];
}
```

### 7.6 Update Grade API for Pin-Drop Validation

Modify `/src/app/api/flash/grade/route.ts`:

```typescript
import { validatePinDrop } from '@/features/flash/controllers/validate-pin-drop';

const gradeItemSchema = z.object({
  fact_id: z.string().uuid(),
  selected_key: z.string().optional(), // For choice mode
  pin_drop: z.tuple([z.number(), z.number()]).optional(), // For map mode [lng, lat]
  time_ms: z.number().int(),
});

// ... in grading logic

if (item.pin_drop) {
  // Map mode - validate pin drop
  const [lng, lat] = item.pin_drop;

  // Get answer regions
  const answerKeys = getAnswerRegionKeys(card.answer);
  const { data: regions } = await supabase
    .from('regions')
    .select('*')
    .in('key', answerKeys);

  const validation = validatePinDrop(lng, lat, regions || []);
  const correct = validation.correct;

  // ... rest of SRS logic
}
```

## Files to Create/Modify

### Created:
- `/src/features/flash/components/map-viewer.tsx`
- `/src/features/flash/controllers/validate-pin-drop.ts`

### Modified:
- `/src/app/globals.css` (add MapLibre styles)
- `/src/app/api/flash/queue/route.ts` (add map mode support)
- `/src/app/api/flash/grade/route.ts` (add pin-drop validation)

## Acceptance Criteria
- ✅ MapLibre map renders with OpenStreetMap tiles
- ✅ Map fits to bbox of answer regions
- ✅ Clicking map places blue pin marker
- ✅ Pin-drop validation works with polygons (Turf.js)
- ✅ Fallback to centroid + tolerance for cities without polygons
- ✅ Answer regions highlighted in green after submission
- ✅ Queue API returns region data and bbox for map modes
- ✅ Grade API validates pin-drop coordinates correctly
- ✅ No console errors related to MapLibre

## Notes & Considerations

### Free Tile Provider
- Using OpenStreetMap tiles for MVP
- Rate limit: 1 req/sec (sufficient for MVP)
- Alternative: Maptiler free tier (100k loads/month)

### Geometry Simplification
- Keep polygons under 1000 points
- Use tools like mapshaper.org
- Store multiple zoom levels later if needed

### Performance
- Lazy load MapLibre (dynamic import)
- Cache region geometries client-side per session
- Debounce rapid pin drops

### Future Enhancements
- Minimap for context
- Zoom-to-correct-region animation
- Heatmap of user guesses
- Street View integration (paid feature)

## Dependencies
- Step 4 (Data Models with Region types)
- Step 5 (Flash API structure)

## Blocks
- Step 8 (Flash UI - Map Mode)
