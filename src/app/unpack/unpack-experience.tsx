'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import Image from 'next/image';
import { AnimatePresence, motion } from 'motion/react';

import s from './unpack.module.css';

type Phase = 'idle' | 'ripping' | 'burst' | 'revealed';
type TiltMode = 'pointer' | 'gyro' | 'gyro-locked' | 'static';

/* Deterministic jagged tear edge (percent y at each 10% x step). */
const JAG_X = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
const JAG_Y = [20, 19.4, 20.7, 19.6, 20.9, 19.2, 20.5, 19.5, 21, 19.3, 20];

const STRIP_CLIP = `polygon(0% 0%, 100% 0%, ${[...JAG_X]
  .reverse()
  .map((x, i) => `${x}% ${JAG_Y[JAG_Y.length - 1 - i]}%`)
  .join(', ')})`;

const BODY_CLIP = `polygon(${JAG_X.map((x, i) => `${x}% ${JAG_Y[i]}%`).join(', ')}, 100% 100%, 0% 100%)`;

/* Scatter targets for the minor cards that fly off. */
const MINOR_CARDS = [
  { x: '-38vw', y: '-34vh', r: -32 },
  { x: '36vw', y: '-38vh', r: 28 },
  { x: '-46vw', y: '-10vh', r: -48 },
  { x: '45vw', y: '-14vh', r: 44 },
];

/**
 * Drives --tx / --ty / --hyp custom properties on the stage element.
 * Desktop: pointer position. Mobile: gyroscope (with iOS permission gate).
 */
function useTilt(stageRef: React.RefObject<HTMLDivElement | null>) {
  const target = useRef({ x: 0, y: 0 });
  const [mode, setMode] = useState<TiltMode>('static');

  useEffect(() => {
    const el = stageRef.current;
    if (!el) return;
    let raf = 0;
    const cur = { x: 0, y: 0 };
    const tick = () => {
      cur.x += (target.current.x - cur.x) * 0.09;
      cur.y += (target.current.y - cur.y) * 0.09;
      el.style.setProperty('--tx', cur.x.toFixed(4));
      el.style.setProperty('--ty', cur.y.toFixed(4));
      el.style.setProperty('--hyp', Math.min(1, Math.hypot(cur.x, cur.y)).toFixed(4));
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf);
  }, [stageRef]);

  useEffect(() => {
    const fine = window.matchMedia('(hover: hover) and (pointer: fine)').matches;
    if (fine) {
      setMode('pointer');
      return;
    }
    const DOE = window.DeviceOrientationEvent as
      | (typeof DeviceOrientationEvent & { requestPermission?: () => Promise<string> })
      | undefined;
    if (DOE && typeof DOE.requestPermission === 'function') setMode('gyro-locked');
    else if (DOE) setMode('gyro');
  }, []);

  /* Pointer input is always attached: on touch devices pointermove barely fires,
     so gyro (below) simply takes over when available. */
  useEffect(() => {
    const onMove = (e: PointerEvent) => {
      target.current.x = (e.clientX / window.innerWidth) * 2 - 1;
      target.current.y = (e.clientY / window.innerHeight) * 2 - 1;
    };
    window.addEventListener('pointermove', onMove);
    return () => window.removeEventListener('pointermove', onMove);
  }, []);

  useEffect(() => {
    if (mode === 'gyro') {
      let baseBeta: number | null = null;
      const onOrient = (e: DeviceOrientationEvent) => {
        if (e.beta === null || e.gamma === null) return;
        if (baseBeta === null) baseBeta = e.beta;
        target.current.x = Math.max(-1, Math.min(1, e.gamma / 24));
        target.current.y = Math.max(-1, Math.min(1, (e.beta - baseBeta) / 24));
      };
      window.addEventListener('deviceorientation', onOrient);
      return () => window.removeEventListener('deviceorientation', onOrient);
    }
  }, [mode]);

  const enableGyro = useCallback(async () => {
    const DOE = window.DeviceOrientationEvent as
      | (typeof DeviceOrientationEvent & { requestPermission?: () => Promise<string> })
      | undefined;
    try {
      const res = await DOE?.requestPermission?.();
      if (res === 'granted') setMode('gyro');
    } catch {
      /* user dismissed the iOS prompt; keep the button visible */
    }
  }, []);

  return { mode, enableGyro };
}

function LogoMark({ className }: { className?: string }) {
  return <Image src="/logo.png" width={240} height={240} alt="" aria-hidden="true" className={className} />;
}

/** The booster wrapper artwork; rendered twice (strip + body) so the tear stays aligned. */
function PackArt() {
  return (
    <div className={s.packArt}>
      <div className={s.packFoil} />
      <div className={s.packCrimpTop} />
      <div className={s.packCrimpBottom} />
      <div className={s.packContent}>
        <p className={s.packKicker}>TRAINER BOOSTER</p>
        <LogoMark className={s.packGlobe} />
        <p className={s.packWordmark}>GEOLET</p>
        <p className={s.packSub}>FIVE CARDS · ONE WORLD</p>
      </div>
      <div className={s.packSheen} />
    </div>
  );
}

function CardBack() {
  return (
    <div className={s.cardBack}>
      <div className={s.cardBackRing}>
        <LogoMark className={s.cardBackGlobe} />
      </div>
      <p className={s.cardBackWord}>GEOLET</p>
    </div>
  );
}

function HeroCard() {
  return (
    <div className={s.heroCard}>
      <div className={s.heroInner}>
        <div className={s.heroArt}>
          <div className={s.heroStars} />
          <LogoMark className={s.heroGlobe} />
        </div>
        <div className={s.heroPlate}>
          <p className={s.heroName}>GEOLET</p>
          <p className={s.heroRarity}>★★★</p>
        </div>
        <p className={s.heroType}>WORLD TRAVELER · LEGENDARY</p>
        <p className={s.heroFlavor}>Every road remembers where it began.</p>
        <p className={s.heroFooter}>Nº 001 / 151 · POLYCHROME</p>
      </div>
      {/* holographic layers, driven by --tx / --ty / --hyp */}
      <div className={s.holoRainbow} />
      <div className={s.holoSparkle} />
      <div className={s.holoGlare} />
    </div>
  );
}

export function UnpackExperience() {
  const [phase, setPhase] = useState<Phase>('idle');
  const [round, setRound] = useState(0);
  const stageRef = useRef<HTMLDivElement>(null);
  const packRef = useRef<HTMLDivElement>(null);
  const rip = useRef(0);
  const dragX = useRef(0);
  const packW = useRef(1);
  const springRaf = useRef(0);
  const { mode, enableGyro } = useTilt(stageRef);

  const setRipVar = (v: number) => {
    rip.current = v;
    packRef.current?.style.setProperty('--rip', v.toFixed(4));
  };

  const completeRip = useCallback(() => {
    setRipVar(1);
    if ('vibrate' in navigator) navigator.vibrate?.(35);
    setPhase('burst');
  }, []);

  const onSeamDown = (e: React.PointerEvent<HTMLDivElement>) => {
    if (phase !== 'idle' && phase !== 'ripping') return;
    const rect = packRef.current?.getBoundingClientRect();
    if (!rect) return;
    // Only grips near the tear seam (top ~40% of the pack).
    const yRatio = (e.clientY - rect.top) / rect.height;
    if (yRatio < 0.02 || yRatio > 0.44) return;
    cancelAnimationFrame(springRaf.current);
    e.currentTarget.setPointerCapture(e.pointerId);
    dragX.current = e.clientX;
    packW.current = rect.width;
    setPhase('ripping');
  };

  const onSeamMove = (e: React.PointerEvent<HTMLDivElement>) => {
    if (phase !== 'ripping' || !e.currentTarget.hasPointerCapture(e.pointerId)) return;
    const dx = e.clientX - dragX.current;
    dragX.current = e.clientX;
    if (dx <= 0) return;
    const next = Math.min(1, rip.current + dx / packW.current);
    setRipVar(next);
    if (next >= 1) {
      e.currentTarget.releasePointerCapture(e.pointerId);
      completeRip();
    }
  };

  const onSeamUp = (e: React.PointerEvent<HTMLDivElement>) => {
    if (phase !== 'ripping') return;
    if (e.currentTarget.hasPointerCapture(e.pointerId)) e.currentTarget.releasePointerCapture(e.pointerId);
    if (rip.current >= 0.85) {
      completeRip();
      return;
    }
    setPhase('idle');
    const back = () => {
      const next = rip.current * 0.86 - 0.004;
      if (next <= 0) {
        setRipVar(0);
        return;
      }
      setRipVar(next);
      springRaf.current = requestAnimationFrame(back);
    };
    springRaf.current = requestAnimationFrame(back);
  };

  const onSeamKey = (e: React.KeyboardEvent<HTMLDivElement>) => {
    if (phase !== 'idle' || (e.key !== 'Enter' && e.key !== ' ')) return;
    e.preventDefault();
    const rush = () => {
      const next = rip.current + 0.045;
      if (next >= 1) {
        completeRip();
        return;
      }
      setRipVar(next);
      springRaf.current = requestAnimationFrame(rush);
    };
    setPhase('ripping');
    springRaf.current = requestAnimationFrame(rush);
  };

  const replay = () => {
    cancelAnimationFrame(springRaf.current);
    setRipVar(0);
    setRound((r) => r + 1);
    setPhase('idle');
  };

  const packVisible = phase !== 'revealed';
  const cardsOut = phase === 'burst' || phase === 'revealed';

  return (
    <div ref={stageRef} className={s.stage} data-phase={phase}>
      <div className={s.backdrop} />
      <div className={s.vignette} />

      <header className={s.header}>
        <span className={s.headerWord}>GEOLET</span>
        <span className={s.headerDivider} />
        <span className={s.headerSub}>UNPACK</span>
      </header>

      <div className={s.sceneCenter}>
        <div className={s.tilt}>
          <AnimatePresence>
            {packVisible && (
              <motion.div
                key={`pack-${round}`}
                ref={packRef}
                className={s.pack}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.2 }}
                role="button"
                tabIndex={0}
                aria-label="Rip open the booster pack"
                onKeyDown={onSeamKey}
                onPointerDown={onSeamDown}
                onPointerMove={onSeamMove}
                onPointerUp={onSeamUp}
                onPointerCancel={onSeamUp}
              >
                <div className={s.packFloat}>
                  {/* bottom piece */}
                  <motion.div
                    className={s.packBody}
                    style={{ clipPath: BODY_CLIP }}
                    animate={
                      phase === 'burst'
                        ? { y: '58%', rotate: 4, opacity: 0 }
                        : { y: 0, rotate: 0, opacity: 1 }
                    }
                    transition={{ duration: 0.65, delay: phase === 'burst' ? 0.22 : 0, ease: [0.22, 1, 0.36, 1] }}
                  >
                    <PackArt />
                    <div className={s.tornShadow} />
                  </motion.div>

                  {/* top strip */}
                  <motion.div
                    className={s.packStripMotion}
                    animate={
                      phase === 'burst'
                        ? { x: '70%', y: '-170%', rotate: 26, opacity: 0 }
                        : { x: 0, y: 0, rotate: 0, opacity: 1 }
                    }
                    transition={{ duration: 0.7, ease: [0.22, 1, 0.36, 1] }}
                  >
                    <div className={s.packStrip} style={{ clipPath: STRIP_CLIP }}>
                      <PackArt />
                    </div>
                  </motion.div>

                  {/* perforation hint + seam glow */}
                  {phase !== 'burst' && (
                    <>
                      <div className={s.perforation} />
                      <div className={s.perforationNotch} />
                    </>
                  )}
                  <div className={s.seamGlow}>
                    <div className={s.seamCore} />
                    <div className={s.seamSpark} />
                  </div>

                  {phase === 'burst' && (
                    <div className={s.burstFx}>
                      <div className={s.flash} />
                      <div className={s.flashStreak} />
                      <div className={s.shockwave} />
                    </div>
                  )}
                </div>
              </motion.div>
            )}
          </AnimatePresence>

          {cardsOut && (
            <div className={s.cardsLayer}>
              {MINOR_CARDS.map((t, i) => (
                <div key={`minor-${round}-${i}`} className={s.minorWrap}>
                  <motion.div
                    className={s.minorCard}
                    initial={{ x: 0, y: 30, scale: 0.55, rotate: 0, opacity: 0 }}
                    animate={{ x: t.x, y: t.y, scale: 0.8, rotate: t.r, opacity: [0, 1, 1, 0] }}
                    transition={{
                      duration: 1.05,
                      delay: 0.16 + i * 0.07,
                      ease: [0.16, 1, 0.3, 1],
                      opacity: { duration: 1.05, delay: 0.16 + i * 0.07, times: [0, 0.12, 0.68, 1] },
                    }}
                  >
                    <CardBack />
                  </motion.div>
                </div>
              ))}
              <motion.div
                key={`hero-${round}`}
                className={s.heroSlot}
                initial={{ y: 70, scale: 0.5, opacity: 0 }}
                animate={{ y: 0, scale: 1, opacity: 1 }}
                transition={{ type: 'spring', stiffness: 160, damping: 17, delay: 0.38 }}
                onAnimationComplete={() => setPhase('revealed')}
              >
                <HeroCard />
              </motion.div>
            </div>
          )}
        </div>
      </div>

      <footer className={s.footer}>
        {phase === 'idle' && <p className={s.hint}>Drag across the golden seam to rip it open</p>}
        {phase === 'revealed' && (
          <motion.div
            className={s.revealBar}
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
          >
            <p className={s.revealCaption}>WORLD TRAVELER · POLYCHROME</p>
            <button type="button" className={s.replayBtn} onClick={replay}>
              Open another pack
            </button>
          </motion.div>
        )}
        {mode === 'gyro-locked' && (
          <button type="button" className={s.gyroBtn} onClick={enableGyro}>
            Enable tilt (gyroscope)
          </button>
        )}
        <p className={s.modeTag}>
          {mode === 'pointer' && 'Follows your mouse'}
          {mode === 'gyro' && 'Follows your phone’s tilt'}
          {mode === 'gyro-locked' && 'Motion access needed for tilt'}
          {mode === 'static' && ''}
        </p>
      </footer>
    </div>
  );
}
