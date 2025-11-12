/* eslint-disable react/no-unescaped-entities */
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Privacy Policy - Geolet',
  description: 'Privacy policy for Geolet - GeoGuessr training platform',
};

export default function PrivacyPage() {
  return (
    <div className='container mx-auto max-w-4xl px-4 py-12'>
      <h1 className='mb-8 text-4xl font-bold'>Privacy Policy</h1>

      <div className='space-y-8 text-foreground'>
        <section>
          <p className='text-muted-foreground'>
            <strong>Last updated:</strong>{' '}
            {new Date().toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>1. Introduction</h2>
          <p className='leading-relaxed text-muted-foreground'>
            Welcome to Geolet ("we," "our," or "us"). We are committed to protecting your personal information and your
            right to privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information
            when you use our GeoGuessr training platform.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>2. Information We Collect</h2>
          <div className='space-y-4'>
            <div>
              <h3 className='mb-2 text-xl font-medium'>2.1 Account Information</h3>
              <p className='leading-relaxed text-muted-foreground'>
                When you create an account, we collect your email address and password (encrypted). You may optionally
                provide additional profile information.
              </p>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>2.2 Usage Data</h3>
              <p className='leading-relaxed text-muted-foreground'>
                We collect information about your training sessions, including:
              </p>
              <ul className='ml-6 mt-2 list-disc space-y-1 text-muted-foreground'>
                <li>Game mode preferences and selections</li>
                <li>Quiz results and accuracy statistics</li>
                <li>Response times and learning progress</li>
                <li>Session history and performance analytics</li>
              </ul>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>2.3 Technical Information</h3>
              <p className='leading-relaxed text-muted-foreground'>
                We automatically collect certain technical information, including IP address, browser type, device
                information, and usage patterns to improve our service.
              </p>
            </div>
          </div>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>3. How We Use Your Information</h2>
          <p className='mb-3 leading-relaxed text-muted-foreground'>We use the information we collect to:</p>
          <ul className='ml-6 list-disc space-y-2 text-muted-foreground'>
            <li>Provide, maintain, and improve our training platform</li>
            <li>Personalize your learning experience using spaced repetition algorithms</li>
            <li>Track your progress and generate performance insights</li>
            <li>Send you important updates about your account and our service</li>
            <li>Respond to your support requests and feedback</li>
            <li>Detect and prevent fraud, abuse, and technical issues</li>
          </ul>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>4. Data Storage and Security</h2>
          <p className='leading-relaxed text-muted-foreground'>
            Your data is stored securely using Supabase, a SOC 2 Type II compliant platform. We implement
            industry-standard security measures including encryption in transit (HTTPS) and at rest. However, no method
            of transmission over the internet is 100% secure, and we cannot guarantee absolute security.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>5. Data Sharing and Disclosure</h2>
          <p className='mb-3 leading-relaxed text-muted-foreground'>
            We do not sell your personal information. We may share your information only in the following circumstances:
          </p>
          <ul className='ml-6 list-disc space-y-2 text-muted-foreground'>
            <li>
              <strong>Service Providers:</strong> With trusted third-party services (e.g., Supabase for database, Stripe
              for payments) who help us operate our platform
            </li>
            <li>
              <strong>Legal Requirements:</strong> When required by law or to protect our rights and safety
            </li>
            <li>
              <strong>Business Transfers:</strong> In connection with a merger, sale, or acquisition of our business
            </li>
          </ul>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>6. Your Privacy Rights</h2>
          <p className='mb-3 leading-relaxed text-muted-foreground'>You have the right to:</p>
          <ul className='ml-6 list-disc space-y-2 text-muted-foreground'>
            <li>
              <strong>Access:</strong> Request a copy of your personal data
            </li>
            <li>
              <strong>Correction:</strong> Update or correct inaccurate information
            </li>
            <li>
              <strong>Deletion:</strong> Request deletion of your account and associated data
            </li>
            <li>
              <strong>Export:</strong> Download your training data and statistics
            </li>
            <li>
              <strong>Opt-out:</strong> Unsubscribe from marketing communications
            </li>
          </ul>
          <p className='mt-3 leading-relaxed text-muted-foreground'>
            To exercise these rights, please contact us through your account settings or email us directly.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>7. Cookies and Tracking</h2>
          <p className='leading-relaxed text-muted-foreground'>
            We use essential cookies to maintain your session and remember your preferences. We also use analytics
            cookies (e.g., Vercel Analytics) to understand how users interact with our platform. You can control cookies
            through your browser settings.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>8. Children's Privacy</h2>
          <p className='leading-relaxed text-muted-foreground'>
            Geolet is not intended for children under 13 years of age. We do not knowingly collect personal information
            from children under 13. If you believe we have collected information from a child under 13, please contact
            us immediately.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>9. International Users</h2>
          <p className='leading-relaxed text-muted-foreground'>
            Geolet is operated globally. If you access our service from outside your country of residence, your
            information may be transferred to and processed in countries with different data protection laws. By using
            our service, you consent to this transfer.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>10. Changes to This Policy</h2>
          <p className='leading-relaxed text-muted-foreground'>
            We may update this Privacy Policy from time to time. We will notify you of any material changes by posting
            the new policy on this page and updating the "Last updated" date. Your continued use of Geolet after such
            changes constitutes acceptance of the updated policy.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>11. Contact Us</h2>
          <p className='leading-relaxed text-muted-foreground'>
            If you have any questions about this Privacy Policy or our privacy practices, please contact us at:
          </p>
          <div className='mt-4 rounded-lg border border-border bg-card p-4'>
            <p className='text-muted-foreground'>
              <strong>Email:</strong> cloud@geolet.net
              <br />
              <strong>Support:</strong> Visit our{' '}
              <a href='/support' className='text-primary hover:underline'>
                Support page
              </a>
            </p>
          </div>
        </section>
      </div>
    </div>
  );
}
