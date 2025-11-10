import { Clock, Construction, Target, TrendingUp, Trophy } from 'lucide-react';

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Progress } from '@/components/ui/progress';

export function Dashboard() {
  return (
    <div className='space-y-8'>
      {/* Stats Overview */}
      <div className='grid gap-4 md:grid-cols-2 lg:grid-cols-4'>
        <Card className='border-border bg-card'>
          <CardHeader className='flex flex-row items-center justify-between pb-2'>
            <CardTitle className='text-sm font-medium text-muted-foreground'>Total Sessions</CardTitle>
            <Trophy className='h-4 w-4 text-muted-foreground' />
          </CardHeader>
          <CardContent>
            <div className='text-2xl font-bold text-muted-foreground/30'>-</div>
            <p className='text-xs text-muted-foreground'>Coming soon</p>
          </CardContent>
        </Card>

        <Card className='border-border bg-card'>
          <CardHeader className='flex flex-row items-center justify-between pb-2'>
            <CardTitle className='text-sm font-medium text-muted-foreground'>Avg Accuracy</CardTitle>
            <Target className='h-4 w-4 text-muted-foreground' />
          </CardHeader>
          <CardContent>
            <div className='text-2xl font-bold text-muted-foreground/30'>-</div>
            <p className='text-xs text-muted-foreground'>Coming soon</p>
          </CardContent>
        </Card>

        <Card className='border-border bg-card'>
          <CardHeader className='flex flex-row items-center justify-between pb-2'>
            <CardTitle className='text-sm font-medium text-muted-foreground'>Cards Reviewed</CardTitle>
            <TrendingUp className='h-4 w-4 text-muted-foreground' />
          </CardHeader>
          <CardContent>
            <div className='text-2xl font-bold text-muted-foreground/30'>-</div>
            <p className='text-xs text-muted-foreground'>Coming soon</p>
          </CardContent>
        </Card>

        <Card className='border-border bg-card'>
          <CardHeader className='flex flex-row items-center justify-between pb-2'>
            <CardTitle className='text-sm font-medium text-muted-foreground'>Study Time</CardTitle>
            <Clock className='h-4 w-4 text-muted-foreground' />
          </CardHeader>
          <CardContent>
            <div className='text-2xl font-bold text-muted-foreground/30'>-</div>
            <p className='text-xs text-muted-foreground'>Coming soon</p>
          </CardContent>
        </Card>
      </div>

      {/* Under Construction Notice */}
      <Card className='border-yellow-500/20 bg-yellow-500/5'>
        <CardContent className='flex items-center gap-4 py-8'>
          <Construction className='h-12 w-12 text-yellow-500' />
          <div>
            <h3 className='text-xl font-semibold'>Dashboard Coming Soon</h3>
            <p className='text-muted-foreground'>
              We're building comprehensive analytics to track your progress, visualize your strengths and weaknesses,
              and provide personalized training recommendations.
            </p>
          </div>
        </CardContent>
      </Card>

      {/* Ghost Charts */}
      <div className='grid gap-6 md:grid-cols-2'>
        {/* Activity Chart */}
        <Card className='border-border bg-card'>
          <CardHeader>
            <CardTitle className='text-muted-foreground'>Weekly Activity</CardTitle>
            <CardDescription>Your training sessions over the last 7 days</CardDescription>
          </CardHeader>
          <CardContent>
            <div className='h-[200px] animate-pulse rounded-lg bg-muted/20' />
          </CardContent>
        </Card>

        {/* Accuracy Chart */}
        <Card className='border-border bg-card'>
          <CardHeader>
            <CardTitle className='text-muted-foreground'>Accuracy by Topic</CardTitle>
            <CardDescription>Performance breakdown across training modes</CardDescription>
          </CardHeader>
          <CardContent>
            <div className='h-[200px] animate-pulse rounded-lg bg-muted/20' />
          </CardContent>
        </Card>
      </div>

      {/* Progress Section */}
      <Card className='border-border bg-card'>
        <CardHeader>
          <CardTitle className='text-muted-foreground'>Learning Progress</CardTitle>
          <CardDescription>Track your mastery across different skill categories</CardDescription>
        </CardHeader>
        <CardContent className='space-y-6'>
          <div className='space-y-2'>
            <div className='flex items-center justify-between text-sm'>
              <span className='text-muted-foreground'>India Languages</span>
              <span className='text-muted-foreground/50'>0%</span>
            </div>
            <Progress value={0} className='h-2 bg-muted/20' />
          </div>

          <div className='space-y-2'>
            <div className='flex items-center justify-between text-sm'>
              <span className='text-muted-foreground'>Global Languages</span>
              <span className='text-muted-foreground/50'>0%</span>
            </div>
            <Progress value={0} className='h-2 bg-muted/20' />
          </div>

          <div className='space-y-2'>
            <div className='flex items-center justify-between text-sm'>
              <span className='text-muted-foreground'>Phone Codes</span>
              <span className='text-muted-foreground/50'>0%</span>
            </div>
            <Progress value={0} className='h-2 bg-muted/20' />
          </div>

          <div className='space-y-2'>
            <div className='flex items-center justify-between text-sm'>
              <span className='text-muted-foreground'>Major Cities</span>
              <span className='text-muted-foreground/50'>0%</span>
            </div>
            <Progress value={0} className='h-2 bg-muted/20' />
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
