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
  },
  {
    id: 'global-languages',
    title: 'Global Languages',
    description: 'Recognize language scripts from around the world',
    icon: Globe,
    mode: 'language-pick',
    difficulty: 'advanced',
    estimatedCards: 20,
  },
  {
    id: 'global-phone',
    title: 'Global Phone Numbers',
    description: 'Match country codes to countries (+886 for Taiwan, +91 for India)',
    icon: Phone,
    mode: 'phone-pick',
    difficulty: 'beginner',
    estimatedCards: 15,
  },
  {
    id: 'major-cities',
    title: 'Major Cities',
    description: 'Identify which country major cities belong to',
    icon: MapPin,
    mode: 'city-pick',
    difficulty: 'beginner',
    estimatedCards: 20,
  },
];
