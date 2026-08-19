import type { Metadata } from 'next';
import { Cinzel } from 'next/font/google';

import { Unpack2Experience } from './unpack2-experience';

const cinzel = Cinzel({
  variable: '--font-cinzel',
  weight: ['600', '700', '900'],
  subsets: ['latin'],
});

export const metadata: Metadata = {
  title: 'Geolet — Unpack II',
  description: 'Rip open a Geolet trainer pack. Textured-artwork edition of the unpack demo.',
};

export default function Unpack2Page() {
  return (
    <div className={cinzel.variable}>
      <Unpack2Experience />
    </div>
  );
}
