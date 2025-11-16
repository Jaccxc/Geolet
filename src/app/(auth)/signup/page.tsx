import { redirect } from 'next/navigation';

import { getSession } from '@/features/account/controllers/get-session';
import { getSubscription } from '@/features/account/controllers/get-subscription';

import {
  requestPasswordReset,
  resendConfirmationEmail,
  signInWithOAuth,
  signInWithPassword,
  signUp,
} from '../auth-actions';
import { AuthUI } from '../auth-ui';

export default async function SignUp() {
  const session = await getSession();
  const subscription = await getSubscription();

  if (session && subscription) {
    redirect('/account');
  }

  if (session && !subscription) {
    redirect('/pricing');
  }

  return (
    <div className='container mx-auto px-4'>
      <AuthUI
        mode='signup'
        signInWithOAuth={signInWithOAuth}
        signUp={signUp}
        signInWithPassword={signInWithPassword}
        resendConfirmationEmail={resendConfirmationEmail}
        requestPasswordReset={requestPasswordReset}
      />
    </div>
  );
}
