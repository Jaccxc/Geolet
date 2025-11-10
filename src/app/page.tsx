import { Dashboard } from '@/components/dashboard';
import { LandingPage } from '@/components/landing-page';
import { getSession } from '@/features/account/controllers/get-session';

export default async function HomePage() {
  const session = await getSession();

  // Show dashboard for logged-in users, landing page for guests
  if (session) {
    return (
      <div className='container mx-auto px-4 py-8'>
        <Dashboard />
      </div>
    );
  }

  return <LandingPage />;
}
