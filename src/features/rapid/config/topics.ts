import { Globe, Languages, MapPin, Phone } from 'lucide-react';

import type { TopicCardConfig } from '../components/topic-card';

export const PICK_MODE_TOPICS: TopicCardConfig[] = [
  {
    id: 'india-languages',
    title: 'India Languages',
    description: 'Identify regional scripts across Indian states - from Devanagari to Telugu',
    icon: Languages,
    mode: 'language-pick',
    difficulty: 'intermediate',
    estimatedCards: 15,
    targetTags: [
      'script:devanagari:hindi',
      'script:devanagari:marathi',
      'script:gurmukhi:punjabi',
      'script:gujarati',
      'script:bengali',
      'script:bengali:assamese',
      'script:kannada',
      'script:telugu',
      'script:tamil',
      'script:odia',
      'script:malayalam',
      'script:meitei:manipuri',
    ],
  },
  {
    id: 'global-languages',
    title: 'Global Languages',
    description: 'Recognize language scripts from around the world',
    icon: Globe,
    mode: 'language-pick',
    difficulty: 'advanced',
    estimatedCards: 20,
    // No targetTags - will include all language scripts
  },
  {
    id: 'global-phone',
    title: 'Global Phone Numbers',
    description: 'Match country codes to countries (+886 for Taiwan, +91 for India)',
    icon: Phone,
    mode: 'phone-pick',
    difficulty: 'beginner',
    estimatedCards: 15,
  }
];

export const MAP_MODE_TOPICS: TopicCardConfig[] = [
  {
    id: 'india-languages-map',
    title: 'India Languages',
    description: 'Click on the map to identify where regional scripts are used',
    icon: Languages,
    mode: 'language-map',
    difficulty: 'intermediate',
    estimatedCards: 15,
    targetTags: [
      'script:devanagari:hindi',
      'script:devanagari:marathi',
      'script:gurmukhi:punjabi',
      'script:gujarati',
      'script:bengali',
      'script:bengali:assamese',
      'script:kannada',
      'script:telugu',
      'script:tamil',
      'script:odia',
      'script:malayalam',
      'script:meitei:manipuri',
    ],
  },
  {
    id: 'global-languages-map',
    title: 'Global Languages',
    description: 'Pin locations on the map where scripts are used worldwide',
    icon: Globe,
    mode: 'language-map',
    difficulty: 'advanced',
    estimatedCards: 20,
  },
  {
    id: 'global-phone-map',
    title: 'Global Phone Numbers',
    description: 'Click the country on the map based on phone codes',
    icon: Phone,
    mode: 'phone-map',
    difficulty: 'beginner',
    estimatedCards: 15,
  },
  {
    id: 'major-cities-map',
    title: 'Major Cities',
    description: 'Locate major cities on the world map by name',
    icon: MapPin,
    mode: 'city-map',
    difficulty: 'beginner',
    estimatedCards: 20,
  },
];
