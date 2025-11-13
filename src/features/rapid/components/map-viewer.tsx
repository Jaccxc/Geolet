'use client';

import { useEffect, useRef, useState } from 'react';
import maplibregl from 'maplibre-gl';

import * as turf from '@turf/turf';

import type { Region } from '../types';

interface MapViewerProps {
  regions: Region[];
  onPinDrop?: (lng: number, lat: number) => void;
  disabled?: boolean;
  showAnswer?: boolean;
}

export function MapViewer({ regions, onPinDrop, disabled = false, showAnswer = false }: MapViewerProps) {
  const mapContainer = useRef<HTMLDivElement>(null);
  const map = useRef<maplibregl.Map | null>(null);
  const [userPin, setUserPin] = useState<maplibregl.Marker | null>(null);
  const answerMarkersRef = useRef<maplibregl.Marker[]>([]);
  const hasZoomedToAnswer = useRef<boolean>(false);
  const layersAdded = useRef<boolean>(false);

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
            tiles: ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'],
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

    // Add navigation controls
    map.current.addControl(new maplibregl.NavigationControl(), 'top-right');

    return () => {
      // Cleanup markers
      if (userPin) userPin.remove();
      answerMarkersRef.current.forEach((marker) => marker.remove());

      map.current?.remove();
      map.current = null;
    };
  }, []);

  // Handle pin drop
  useEffect(() => {
    if (!map.current) return;

    const handleClick = (e: maplibregl.MapMouseEvent) => {
      // Don't allow new pins if disabled
      if (disabled) return;

      const { lng, lat } = e.lngLat;

      // Remove existing user pin
      if (userPin) {
        userPin.remove();
      }

      // Add new pin
      const pin = new maplibregl.Marker({ color: '#3b82f6' }).setLngLat([lng, lat]).addTo(map.current!);

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
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [disabled, onPinDrop]);

  // Show answer regions
  useEffect(() => {
    if (!map.current) return;

    const sourceId = 'answer-regions';
    const outlineId = `${sourceId}-outline`;

    // If answer should be hidden and layers are added, remove them
    if (!showAnswer && layersAdded.current) {
      // Remove existing layers/sources
      if (map.current.getLayer(sourceId)) {
        map.current.removeLayer(sourceId);
      }
      if (map.current.getLayer(outlineId)) {
        map.current.removeLayer(outlineId);
      }
      if (map.current.getSource(sourceId)) {
        map.current.removeSource(sourceId);
      }

      // Clear existing answer markers
      answerMarkersRef.current.forEach((marker) => marker.remove());
      answerMarkersRef.current = [];

      // Reset flags
      hasZoomedToAnswer.current = false;
      layersAdded.current = false;
      return;
    }

    // If answer should be shown but layers are already added, do nothing
    if (showAnswer && layersAdded.current) {
      return;
    }

    // If answer should be shown and layers haven't been added yet, add them
    if (!showAnswer) {
      return;
    }

    // Build GeoJSON FeatureCollection from regions with geometry
    const features = regions.filter((r) => r.geometry).map((r) => ({
      type: 'Feature' as const,
      properties: { name: r.name },
      geometry: r.geometry!,
    }));

    // If we have geometry features, add them to the map
    if (features.length > 0) {
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
          'fill-opacity': 0.4,
        },
      });

      // Add outline layer
      map.current.addLayer({
        id: outlineId,
        type: 'line',
        source: sourceId,
        paint: {
          'line-color': '#059669',
          'line-width': 3,
        },
      });
    }

    // For regions without geometry, add markers at centroids
    const regionsWithoutGeometry = regions.filter((r) => !r.geometry && r.centroid_lonlat);
    regionsWithoutGeometry.forEach((region) => {
      if (!region.centroid_lonlat) return;

      const [lng, lat] = region.centroid_lonlat;

      // Create marker element with custom styling
      const el = document.createElement('div');
      el.className = 'answer-marker';
      el.style.width = '30px';
      el.style.height = '30px';
      el.style.borderRadius = '50%';
      el.style.backgroundColor = '#10b981';
      el.style.border = '3px solid #059669';
      el.style.opacity = '0.8';
      el.style.cursor = 'pointer';

      // Add popup with region name
      const popup = new maplibregl.Popup({ offset: 25 }).setHTML(`<strong>${region.name}</strong>`);

      const marker = new maplibregl.Marker({ element: el })
        .setLngLat([lng, lat])
        .setPopup(popup)
        .addTo(map.current!);

      answerMarkersRef.current.push(marker);
    });

    // Zoom to answer regions (only once when answer is first shown)
    if (regions.length > 0 && !hasZoomedToAnswer.current) {
      // Calculate bbox from geometry or use centroids
      const regionsWithGeometry = regions.filter((r) => r.geometry);

      if (regionsWithGeometry.length > 0) {
        // Calculate bbox from all geometries
        let minLng = Infinity, minLat = Infinity;
        let maxLng = -Infinity, maxLat = -Infinity;

        regionsWithGeometry.forEach((region) => {
          if (region.geometry) {
            const bbox = turf.bbox(region.geometry as any);
            const [bMinLng, bMinLat, bMaxLng, bMaxLat] = bbox;
            minLng = Math.min(minLng, bMinLng);
            minLat = Math.min(minLat, bMinLat);
            maxLng = Math.max(maxLng, bMaxLng);
            maxLat = Math.max(maxLat, bMaxLat);
          }
        });

        // Fit to calculated bbox with animation
        map.current.fitBounds(
          [
            [minLng, minLat],
            [maxLng, maxLat],
          ],
          { padding: 60, maxZoom: 8, duration: 1000 }
        );
      } else {
        // Fallback: zoom to first centroid if no geometry available
        const firstRegionWithCentroid = regions.find((r) => r.centroid_lonlat);
        if (firstRegionWithCentroid && firstRegionWithCentroid.centroid_lonlat) {
          const [lng, lat] = firstRegionWithCentroid.centroid_lonlat;
          map.current.flyTo({
            center: [lng, lat],
            zoom: 5,
            duration: 1000,
          });
        }
      }

      // Mark that we've zoomed to the answer
      hasZoomedToAnswer.current = true;
    }

    // Mark that layers have been added
    layersAdded.current = true;
  }, [showAnswer, regions]);

  return <div ref={mapContainer} className={`map-container ${!disabled ? 'map-pin-cursor' : ''}`} />;
}
