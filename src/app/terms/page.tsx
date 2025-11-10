/* eslint-disable react/no-unescaped-entities */
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Terms of Service - Geolet',
  description: 'Terms of service for Geolet - GeoGuessr training platform',
};

export default function TermsPage() {
  return (
    <div className='container mx-auto max-w-4xl px-4 py-12'>
      <h1 className='mb-8 text-4xl font-bold'>Terms of Service</h1>

      <div className='space-y-8 text-foreground'>
        <section>
          <p className='text-muted-foreground'>
            <strong>Last updated:</strong>{' '}
            {new Date().toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}
          </p>
          <p className='mt-4 leading-relaxed text-muted-foreground'>
            Please read these Terms of Service ("Terms") carefully before using Geolet.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>1. Acceptance of Terms</h2>
          <p className='leading-relaxed text-muted-foreground'>
            By accessing or using Geolet ("Service," "Platform," "we," "our," or "us"), you agree to be bound by these
            Terms. If you do not agree to these Terms, you may not access or use the Service.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>2. Description of Service</h2>
          <p className='leading-relaxed text-muted-foreground'>
            Geolet is a GeoGuessr training platform that provides educational minigames and tools to help users improve
            their geographic knowledge, including language scripts, phone codes, and city recognition. The Service uses
            spaced repetition algorithms to optimize learning.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>3. User Accounts</h2>
          <div className='space-y-4'>
            <div>
              <h3 className='mb-2 text-xl font-medium'>3.1 Account Creation</h3>
              <p className='leading-relaxed text-muted-foreground'>
                To use certain features, you must create an account. You agree to provide accurate, current, and
                complete information and to update it as necessary to maintain its accuracy.
              </p>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>3.2 Account Security</h3>
              <p className='leading-relaxed text-muted-foreground'>
                You are responsible for maintaining the confidentiality of your account credentials and for all
                activities that occur under your account. You must immediately notify us of any unauthorized use of your
                account.
              </p>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>3.3 Age Requirement</h3>
              <p className='leading-relaxed text-muted-foreground'>
                You must be at least 13 years old to use Geolet. Users under 18 must have parental or guardian consent.
              </p>
            </div>
          </div>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>4. Acceptable Use</h2>
          <p className='mb-3 leading-relaxed text-muted-foreground'>You agree NOT to:</p>
          <ul className='ml-6 list-disc space-y-2 text-muted-foreground'>
            <li>Use the Service for any illegal purpose or in violation of any laws</li>
            <li>Attempt to gain unauthorized access to any part of the Service or other user&apos;s; accounts</li>
            <li>Use automated scripts, bots, or scrapers to access the Service</li>
            <li>Reverse engineer, decompile, or disassemble any part of the Service</li>
            <li>Upload viruses, malware, or any malicious code</li>
            <li>Harass, abuse, or harm other users</li>
            <li>Share or sell your account access to others</li>
            <li>Use the Service to transmit spam or unsolicited communications</li>
          </ul>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>5. Intellectual Property</h2>
          <div className='space-y-4'>
            <div>
              <h3 className='mb-2 text-xl font-medium'>5.1 Our Content</h3>
              <p className='leading-relaxed text-muted-foreground'>
                All content on Geolet, including text, graphics, logos, software, and training materials, is owned by
                Geolet or our licensors and is protected by copyright, trademark, and other intellectual property laws.
              </p>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>5.2 Your Content</h3>
              <p className='leading-relaxed text-muted-foreground'>
                You retain ownership of any data you submit to the Service. By using the Service, you grant us a limited
                license to use, store, and process your data solely to provide and improve the Service.
              </p>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>5.3 Third-Party Content</h3>
              <p className='leading-relaxed text-muted-foreground'>
                Some training content may reference or be inspired by GeoGuessr gameplay. Geolet is an independent
                training tool and is not affiliated with, endorsed by, or sponsored by GeoGuessr or its parent company.
              </p>
            </div>
          </div>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>6. Subscription and Payments</h2>
          <div className='space-y-4'>
            <div>
              <h3 className='mb-2 text-xl font-medium'>6.1 Free and Paid Plans</h3>
              <p className='leading-relaxed text-muted-foreground'>
                Geolet offers both free and paid subscription plans. Pricing and features are described on our Pricing
                page and may change with notice.
              </p>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>6.2 Billing</h3>
              <p className='leading-relaxed text-muted-foreground'>
                Paid subscriptions are billed in advance on a recurring basis (monthly or annually). You authorize us to
                charge your payment method automatically until you cancel.
              </p>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>6.3 Cancellation and Refunds</h3>
              <p className='leading-relaxed text-muted-foreground'>
                You may cancel your subscription at any time through your account settings. Cancellations take effect at
                the end of the current billing period. We do not offer refunds for partial subscription periods, except
                as required by law.
              </p>
            </div>
          </div>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>7. Service Availability</h2>
          <p className='leading-relaxed text-muted-foreground'>
            We strive to provide reliable service, but we do not guarantee that the Service will be uninterrupted,
            error-free, or available at all times. We reserve the right to modify, suspend, or discontinue any part of
            the Service with or without notice.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>8. Disclaimer of Warranties</h2>
          <p className='leading-relaxed text-muted-foreground'>
            THE SERVICE IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED,
            INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
            NON-INFRINGEMENT. WE DO NOT GUARANTEE THAT THE SERVICE WILL IMPROVE YOUR GEOGUESSR PERFORMANCE OR MEET YOUR
            SPECIFIC REQUIREMENTS.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>9. Limitation of Liability</h2>
          <p className='leading-relaxed text-muted-foreground'>
            TO THE MAXIMUM EXTENT PERMITTED BY LAW, GEOLET AND ITS AFFILIATES, OFFICERS, EMPLOYEES, AND PARTNERS SHALL
            NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING LOST
            PROFITS, DATA LOSS, OR OTHER INTANGIBLE LOSSES ARISING FROM YOUR USE OF THE SERVICE. OUR TOTAL LIABILITY
            SHALL NOT EXCEED THE AMOUNT YOU PAID TO US IN THE PAST 12 MONTHS, OR $100, WHICHEVER IS GREATER.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>10. Indemnification</h2>
          <p className='leading-relaxed text-muted-foreground'>
            You agree to indemnify and hold harmless Geolet, its affiliates, and their respective officers, employees,
            and agents from any claims, damages, losses, or expenses (including legal fees) arising from your use of the
            Service or violation of these Terms.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>11. Termination</h2>
          <p className='leading-relaxed text-muted-foreground'>
            We reserve the right to suspend or terminate your account and access to the Service at any time, with or
            without cause or notice, including for violations of these Terms. Upon termination, your right to use the
            Service immediately ceases. You may also delete your account at any time through your account settings.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>12. Dispute Resolution</h2>
          <div className='space-y-4'>
            <div>
              <h3 className='mb-2 text-xl font-medium'>12.1 Informal Resolution</h3>
              <p className='leading-relaxed text-muted-foreground'>
                If you have a dispute with us, please contact us first to attempt an informal resolution.
              </p>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>12.2 Arbitration</h3>
              <p className='leading-relaxed text-muted-foreground'>
                Any disputes that cannot be resolved informally shall be resolved through binding arbitration in
                accordance with applicable arbitration rules, rather than in court, except where prohibited by law.
              </p>
            </div>
            <div>
              <h3 className='mb-2 text-xl font-medium'>12.3 Class Action Waiver</h3>
              <p className='leading-relaxed text-muted-foreground'>
                You agree to resolve disputes with us on an individual basis and waive any right to participate in class
                actions or class arbitrations.
              </p>
            </div>
          </div>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>13. Changes to Terms</h2>
          <p className='leading-relaxed text-muted-foreground'>
            We may update these Terms from time to time. We will notify you of material changes by posting the new Terms
            on this page and updating the "Last updated" date. Your continued use of the Service after such changes
            constitutes acceptance of the updated Terms.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>14. Governing Law</h2>
          <p className='leading-relaxed text-muted-foreground'>
            These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which
            Geolet operates, without regard to its conflict of law provisions.
          </p>
        </section>

        <section>
          <h2 className='mb-4 text-2xl font-semibold'>15. Contact Information</h2>
          <p className='leading-relaxed text-muted-foreground'>
            If you have questions about these Terms, please contact us:
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

        <section className='border-t border-border pt-8'>
          <p className='text-sm text-muted-foreground'>
            By using Geolet, you acknowledge that you have read, understood, and agree to be bound by these Terms of
            Service.
          </p>
        </section>
      </div>
    </div>
  );
}
