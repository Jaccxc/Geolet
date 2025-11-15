'use client';

import { BookOpen, Lightbulb } from 'lucide-react';

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

import type { SkillTag } from '../types';

interface SkillCardProps {
  skillTags: SkillTag[];
}

export function SkillCard({ skillTags }: SkillCardProps) {
  if (!skillTags || skillTags.length === 0) {
    return null;
  }

  // Show the first skill tag (primary skill)
  const primarySkill = skillTags[0];

  return (
    <Card className='border-primary/20 bg-primary/5'>
      <CardHeader className='pb-3'>
        <CardTitle className='flex items-center gap-2 text-base font-semibold'>
          <Lightbulb className='h-4 w-4 text-primary' />
          <span>Learn: {primarySkill.display}</span>
        </CardTitle>
      </CardHeader>
      <CardContent className='space-y-3 text-sm'>
        {/* Note/Description */}
        {primarySkill.note && (
          <div className='text-muted-foreground'>
            <p>{primarySkill.note}</p>
          </div>
        )}

        {/* Examples */}
        {primarySkill.examples && primarySkill.examples.length > 0 && (
          <div>
            <div className='mb-1 flex items-center gap-1.5 font-medium text-foreground'>
              <BookOpen className='h-3.5 w-3.5' />
              <span>Key patterns:</span>
            </div>
            <div className='flex flex-wrap gap-1.5'>
              {primarySkill.examples.slice(0, 8).map((example, idx) => (
                <span
                  key={idx}
                  className='rounded-md bg-background px-2 py-1 text-xs font-mono border border-border'
                >
                  {example}
                </span>
              ))}
            </div>
          </div>
        )}

        {/* Additional skills indicator */}
        {skillTags.length > 1 && (
          <div className='text-xs text-muted-foreground'>
            + {skillTags.length - 1} more skill{skillTags.length > 2 ? 's' : ''}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

