import Link from 'next/link';
import { BarChart3, Globe, Map, Target, TrendingUp, Zap } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

export function LandingPage() {
  return (
    <div className='flex flex-col gap-20 py-12'>
      <HeroSection />
      <FeaturesSection />
      <HowItWorksSection />
      <CTASection />
    </div>
  );
}

function HeroSection() {
  return (
    <section className='relative overflow-hidden'>
      <div className='container mx-auto px-4 py-20 text-center'>
        <div className='mx-auto max-w-4xl'>
          <div className='mb-6 inline-flex items-center gap-2 rounded-full border border-primary/20 bg-primary/10 px-4 py-2 text-sm'>
            <Zap className='h-4 w-4 text-primary' />
            <span className='text-primary'>Train smarter, play better</span>
          </div>

          <h1 className='mb-6 font-alt font-bold leading-tight tracking-tight'>
            <span className='mb-2 block text-4xl text-white lg:text-6xl'>Master GeoGuessr with</span>
            <span className='block bg-gradient-to-r from-green-300 to-green-500 bg-clip-text text-5xl text-transparent lg:text-7xl'>
              Focused Training
            </span>
          </h1>

          <p className='mb-8 text-xl text-muted-foreground lg:text-2xl'>
            Level up your geography skills with spaced repetition minigames.
            <br />
            Learn language scripts, phone codes, and city recognition.
          </p>

          <div className='flex flex-col gap-4 sm:flex-row sm:justify-center'>
            <Button asChild size='lg' className='text-lg'>
              <Link href='/signup'>Start Training Free</Link>
            </Button>
            <Button asChild size='lg' variant='outline' className='text-lg'>
              <Link href='/pricing'>View Pricing</Link>
            </Button>
          </div>

          <p className='mt-4 text-sm text-muted-foreground'>No credit card required • Free tier available</p>
        </div>
      </div>
    </section>
  );
}

function FeaturesSection() {
  const features = [
    {
      icon: Zap,
      title: 'Rapid Mode',
      description:
        'Fast-paced drills with instant feedback. Choose between Pick Mode (multiple choice) or Map Mode (click-to-answer).',
    },
    {
      icon: TrendingUp,
      title: 'Spaced Repetition',
      description:
        'Smart algorithm tracks your progress and prioritizes cards you struggle with. Review at optimal intervals.',
    },
    {
      icon: BarChart3,
      title: 'Insight Analytics',
      description:
        'Import your GeoGuessr games and discover your weaknesses. Get personalized training recommendations.',
    },
    {
      icon: Globe,
      title: 'Global Coverage',
      description:
        'Train on language scripts from India to Taiwan, phone codes worldwide, and major cities across continents.',
    },
    {
      icon: Map,
      title: 'Interactive Maps',
      description: 'Practice by clicking on maps to identify regions, states, and cities based on visual clues.',
    },
    {
      icon: Target,
      title: 'Targeted Practice',
      description:
        'Focus on specific regions like Indian languages or global phone codes. Customize your training sessions.',
    },
  ];

  return (
    <section className='container mx-auto px-4'>
      <div className='mb-12 text-center'>
        <h2 className='mb-4 text-4xl font-bold'>Everything You Need to Excel</h2>
        <p className='text-xl text-muted-foreground'>Comprehensive tools designed for serious GeoGuessr players</p>
      </div>

      <div className='grid gap-6 md:grid-cols-2 lg:grid-cols-3'>
        {features.map((feature, index) => {
          const Icon = feature.icon;
          return (
            <Card key={index} className='border-border bg-card'>
              <CardHeader>
                <div className='mb-2 inline-flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10'>
                  <Icon className='h-6 w-6 text-primary' />
                </div>
                <CardTitle>{feature.title}</CardTitle>
              </CardHeader>
              <CardContent>
                <CardDescription className='text-base'>{feature.description}</CardDescription>
              </CardContent>
            </Card>
          );
        })}
      </div>
    </section>
  );
}

function HowItWorksSection() {
  const steps = [
    {
      step: '1',
      title: 'Create Your Account',
      description: 'Sign up for free and get instant access to all training modes.',
    },
    {
      step: '2',
      title: 'Choose Your Focus',
      description: 'Select from India Languages, Global Scripts, Phone Codes, or Cities.',
    },
    {
      step: '3',
      title: 'Start Training',
      description: 'Complete daily drills with our smart spaced repetition system.',
    },
    {
      step: '4',
      title: 'Track Progress',
      description: 'Monitor your accuracy, speed, and improvement over time.',
    },
  ];

  return (
    <section className='container mx-auto px-4'>
      <div className='mb-12 text-center'>
        <h2 className='mb-4 text-4xl font-bold'>How It Works</h2>
        <p className='text-xl text-muted-foreground'>Get started in minutes</p>
      </div>

      <div className='grid gap-8 md:grid-cols-2 lg:grid-cols-4'>
        {steps.map((step, index) => (
          <div key={index} className='text-center'>
            <div className='mb-4 inline-flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-2xl font-bold text-primary'>
              {step.step}
            </div>
            <h3 className='mb-2 text-xl font-semibold'>{step.title}</h3>
            <p className='text-muted-foreground'>{step.description}</p>
          </div>
        ))}
      </div>
    </section>
  );
}

function CTASection() {
  return (
    <section className='container mx-auto px-4'>
      <Card className='border-primary/20 bg-gradient-to-br from-primary/10 to-purple-500/10'>
        <CardContent className='py-12 text-center'>
          <h2 className='mb-4 text-4xl font-bold'>Ready to Level Up?</h2>
          <p className='mb-8 text-xl text-muted-foreground'>Join players training smarter every day</p>
          <Button asChild size='lg' className='text-lg'>
            <Link href='/signup'>Start Free Training</Link>
          </Button>
        </CardContent>
      </Card>
    </section>
  );
}
