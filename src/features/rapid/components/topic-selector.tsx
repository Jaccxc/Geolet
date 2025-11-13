'use client';

import { useEffect, useState } from 'react';
import type { LucideIcon } from 'lucide-react';
import * as LucideIcons from 'lucide-react';

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

import type { Topic } from '../types';

import { TopicSkeleton } from './topic-skeleton';

interface TopicSelectorProps {
  mode: 'pick' | 'map';
  onSelect: (topicKey: string) => void;
  selectedTopic?: string;
}

export function TopicSelector({ mode, onSelect, selectedTopic }: TopicSelectorProps) {
  const [topics, setTopics] = useState<Topic[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchTopics() {
      try {
        setLoading(true);
        setError(null);
        const res = await fetch(`/api/rapid/topics?mode=${mode}`);

        if (!res.ok) throw new Error('Failed to fetch topics');

        const data = await res.json();
        setTopics(data.topics);
      } catch (err) {
        console.error('Failed to fetch topics:', err);
        setError(err instanceof Error ? err.message : 'Failed to fetch topics');
      } finally {
        setLoading(false);
      }
    }

    fetchTopics();
  }, [mode]);

  if (loading) {
    return (
      <div className='grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3'>
        {Array.from({ length: 6 }).map((_, idx) => (
          <TopicSkeleton key={idx} />
        ))}
      </div>
    );
  }

  if (error) {
    return (
      <div className='rounded-lg border border-destructive bg-destructive/10 p-6'>
        <div className='text-lg font-semibold text-destructive'>Error loading topics</div>
        <div className='mt-2 text-sm text-muted-foreground'>{error}</div>
      </div>
    );
  }

  if (topics.length === 0) {
    return (
      <div className='rounded-lg border border-dashed p-12 text-center'>
        <div className='text-lg font-semibold'>No topics available</div>
        <div className='mt-2 text-sm text-muted-foreground'>No topics are configured for {mode} mode yet.</div>
      </div>
    );
  }

  return (
    <div className='grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3'>
      {topics.map((topic) => {
        const maybeIcon = LucideIcons[topic.icon as keyof typeof LucideIcons];
        const Icon = (typeof maybeIcon === 'function' ? maybeIcon : LucideIcons.HelpCircle) as LucideIcon;

        return (
          <Card
            key={topic.key}
            className={`cursor-pointer transition-all hover:shadow-md ${
              selectedTopic === topic.key
                ? 'border-primary bg-primary/5 ring-2 ring-primary'
                : 'hover:border-primary/50'
            }`}
            onClick={() => onSelect(topic.key)}
          >
            <CardHeader>
              <CardTitle className='flex items-center gap-2'>
                <Icon className='h-5 w-5 text-primary' />
                <span>{topic.title}</span>
              </CardTitle>
              {topic.description && <CardDescription>{topic.description}</CardDescription>}
            </CardHeader>

            {topic.difficulty && (
              <CardContent>
                <div className='flex items-center gap-2'>
                  <span className='text-xs font-medium text-muted-foreground'>Difficulty:</span>
                  <span
                    className={`rounded-full px-2 py-0.5 text-xs font-semibold ${
                      topic.difficulty === 'beginner'
                        ? 'bg-green-100 text-green-800'
                        : topic.difficulty === 'intermediate'
                        ? 'bg-yellow-100 text-yellow-800'
                        : 'bg-red-100 text-red-800'
                    }`}
                  >
                    {topic.difficulty}
                  </span>
                </div>
              </CardContent>
            )}
          </Card>
        );
      })}
    </div>
  );
}
