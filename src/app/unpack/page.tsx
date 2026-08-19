import type { Metadata } from 'next';
import { Cinzel } from 'next/font/google';

import { UnpackExperience } from './unpack-experience';

const cinzel = Cinzel({
  variable: '--font-cinzel',
  weight: ['600', '700', '900'],
  subsets: ['latin'],
});

export const metadata: Metadata = {
  title: 'Geolet — Unpack',
  description: 'Rip open a Geolet trainer pack. Adaptive holographic card reveal demo.',
};

export default function UnpackPage() {
  return (
    <div className={cinzel.variable}>
      <UnpackExperience />
    </div>
  );
}
