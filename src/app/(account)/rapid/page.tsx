import { getSession } from '@/features/account/controllers/get-session';
import { RapidExperience } from '@/features/rapid/components/rapid-experience';

export default async function RapidPage() {
  const session = await getSession();
  return <RapidExperience isAuthenticated={Boolean(session)} />;
}
