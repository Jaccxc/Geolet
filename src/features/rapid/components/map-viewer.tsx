'use client';

import { useEffect, useRef, useState } from 'react';
import maplibregl from 'maplibre-gl';

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
    if (map.current.getLayer(`${sourceId}-outline`)) {
      map.current.removeLayer(`${sourceId}-outline`);
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
