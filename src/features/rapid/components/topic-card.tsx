'use client';

import { LucideIcon } from 'lucide-react';

import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

export interface TopicCardConfig {
  id: string;
  title: string;
  description: string;
  icon: LucideIcon;
  mode: string;
  difficulty: 'beginner' | 'intermediate' | 'advanced';
  estimatedCards: number;
  targetTags?: string[]; // Optional filter for specific skill tags
}

interface TopicCardProps {
  topic: TopicCardConfig;
  onClick: () => void;
}

export function TopicCard({ topic, onClick }: TopicCardProps) {
  const difficultyColors = {
    beginner: 'bg-green-500/10 text-green-500 border-green-500/20',
    intermediate: 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20',
    advanced: 'bg-red-500/10 text-red-500 border-red-500/20',
  };

  const Icon = topic.icon;

  return (
    <Card
      className='cursor-pointer transition-all hover:border-primary hover:shadow-lg hover:shadow-primary/10'
      onClick={onClick}
    >
      <CardHeader>
        <div className='flex items-start justify-between'>
          <div className='flex items-center gap-3'>
            <div className='rounded-lg bg-primary/10 p-3'>
              <Icon className='h-6 w-6 text-primary' />
            </div>
            <div>
              <CardTitle className='text-lg'>{topic.title}</CardTitle>
            </div>
          </div>
          <Badge variant='outline' className={difficultyColors[topic.difficulty]}>
            {topic.difficulty}
          </Badge>
        </div>
        <CardDescription className='mt-2'>{topic.description}</CardDescription>
      </CardHeader>
      <CardContent>
        <div className='flex items-center justify-between text-sm text-muted-foreground'>
          <span>~{topic.estimatedCards} cards available</span>
        </div>
      </CardContent>
    </Card>
  );
}
