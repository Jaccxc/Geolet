'use client';

import { forwardRef, useCallback, useEffect, useImperativeHandle, useRef, useState } from 'react';
import Image from 'next/image';
import { AnimatePresence, motion } from 'motion/react';

import s from './unpack2.module.css';

type Phase = 'idle' | 'ripping' | 'burst' | 'revealed';

/* The tear line sits at 18% of the pack height: on this artwork that is the
   clear band between the "TRAINER BOOSTER" text and the compass emblem. */
const RIP_LINE = 18;

/* Deterministic jagged tear edge (percent y at each 10% x step). */
const JAG_X = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
const JAG_Y = [18, 17.76, 18.28, 17.84, 18.36, 17.68, 18.2, 17.8, 18.4, 17.72, 18];

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
 * Desktop: mouse position. Touch devices: finger position while touching,
 * blended with a slow ambient sway (no gyroscope, no permission prompt).
 */
function useTilt(stageRef: React.RefObject<HTMLDivElement | null>) {
  const target = useRef({ x: 0, y: 0 });
  const sway = useRef(false);
  const lastPointer = useRef(0);
  const [coarse, setCoarse] = useState(false);

  useEffect(() => {
    const isCoarse = window.matchMedia('(pointer: coarse)').matches;
    setCoarse(isCoarse);
    sway.current = isCoarse && !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  }, []);

  useEffect(() => {
    const el = stageRef.current;
    if (!el) return;
    let raf = 0;
    const cur = { x: 0, y: 0 };
    let wx = Infinity;
    let wy = Infinity;
    const tick = () => {
      let tx = target.current.x;
      let ty = target.current.y;
      if (sway.current) {
        const t = performance.now() / 1000;
        tx = Math.max(-1, Math.min(1, tx + Math.sin(t * 0.9) * 0.42));
        ty = Math.max(-1, Math.min(1, ty + Math.cos(t * 0.61) * 0.3));
      }
      cur.x += (tx - cur.x) * 0.09;
      cur.y += (ty - cur.y) * 0.09;
      if (Math.abs(cur.x - wx) > 0.0006 || Math.abs(cur.y - wy) > 0.0006) {
        wx = cur.x;
        wy = cur.y;
        el.style.setProperty('--tx', cur.x.toFixed(4));
        el.style.setProperty('--ty', cur.y.toFixed(4));
        el.style.setProperty('--hyp', Math.min(1, Math.hypot(cur.x, cur.y)).toFixed(4));
      }
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf);
  }, [stageRef]);

  useEffect(() => {
    const gain = window.matchMedia('(pointer: coarse)').matches ? 1.7 : 1;
    const onMove = (e: PointerEvent) => {
      lastPointer.current = performance.now();
      target.current.x = Math.max(-1, Math.min(1, ((e.clientX / window.innerWidth) * 2 - 1) * gain));
      target.current.y = Math.max(-1, Math.min(1, ((e.clientY / window.innerHeight) * 2 - 1) * gain));
    };
    const onRelease = (e: PointerEvent) => {
      if (e.pointerType !== 'mouse') target.current = { x: 0, y: 0 };
    };
    window.addEventListener('pointermove', onMove);
    window.addEventListener('pointerdown', onMove);
    window.addEventListener('pointerup', onRelease);
    window.addEventListener('pointercancel', onRelease);
    return () => {
      window.removeEventListener('pointermove', onMove);
      window.removeEventListener('pointerdown', onMove);
      window.removeEventListener('pointerup', onRelease);
      window.removeEventListener('pointercancel', onRelease);
    };
  }, []);

  /* Gyroscope tilt with no dedicated button: Android attaches straight away;
     iOS asks for motion permission on the first touch (a valid user gesture).
     Pointer input wins while recently active; the ambient sway retires once
     real gyro data arrives. Falls back to touch + sway when denied/absent. */
  useEffect(() => {
    if (!window.matchMedia('(pointer: coarse)').matches) return;
    const DOE = window.DeviceOrientationEvent as
      | (typeof DeviceOrientationEvent & { requestPermission?: () => Promise<string> })
      | undefined;
    if (!DOE) return;
    let attached = false;
    let baseBeta: number | null = null;
    const onOrient = (e: DeviceOrientationEvent) => {
      if (e.beta === null || e.gamma === null) return;
      sway.current = false;
      if (performance.now() - lastPointer.current < 600) return;
      if (baseBeta === null) baseBeta = e.beta;
      target.current.x = Math.max(-1, Math.min(1, e.gamma / 24));
      target.current.y = Math.max(-1, Math.min(1, (e.beta - baseBeta) / 24));
    };
    const attach = () => {
      if (attached) return;
      attached = true;
      window.addEventListener('deviceorientation', onOrient);
    };
    const askOnGesture = () => {
      window.removeEventListener('pointerdown', askOnGesture);
      DOE.requestPermission?.()
        .then((res) => {
          if (res === 'granted') attach();
        })
        .catch(() => {});
    };
    if (typeof DOE.requestPermission === 'function') window.addEventListener('pointerdown', askOnGesture);
    else attach();
    return () => {
      window.removeEventListener('pointerdown', askOnGesture);
      window.removeEventListener('deviceorientation', onOrient);
    };
  }, []);

  return coarse;
}

/* ------------------------------------------------------------------ */
/* Spark particles: additively blended embers sprayed from the tear.   */
/* ------------------------------------------------------------------ */

type Spark = {
  x: number;
  y: number;
  vx: number;
  vy: number;
  life: number;
  maxLife: number;
  size: number;
};

export type SparkHandle = {
  /** Spray embers at pack-relative coords (u, v in 0..1). */
  tear: (u: number, v: number, intensity: number) => void;
};

const CANVAS_SPAN = 2.6;
const CANVAS_OFFSET = 0.8;
const MAX_SPARKS = 420;

const SparkCanvas = forwardRef<SparkHandle>(function SparkCanvas(_props, ref) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const sparks = useRef<Spark[]>([]);
  const raf = useRef(0);
  const running = useRef(false);
  const reduced = useRef(false);
  const coarse = useRef(false);

  const dprCap = () => Math.min(coarse.current ? 1.25 : 2, window.devicePixelRatio || 1);
  const maxSparks = () => (coarse.current ? 150 : MAX_SPARKS);

  useEffect(() => {
    reduced.current = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    coarse.current = window.matchMedia('(pointer: coarse)').matches;
    const canvas = canvasRef.current;
    if (!canvas) return;
    const fit = () => {
      const dpr = dprCap();
      const rect = canvas.getBoundingClientRect();
      canvas.width = Math.max(1, Math.round(rect.width * dpr));
      canvas.height = Math.max(1, Math.round(rect.height * dpr));
    };
    fit();
    window.addEventListener('resize', fit);
    return () => {
      window.removeEventListener('resize', fit);
      cancelAnimationFrame(raf.current);
      running.current = false;
    };
  }, []);

  const step = useCallback(() => {
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext('2d');
    if (!canvas || !ctx) {
      running.current = false;
      return;
    }
    const { width: w, height: h } = canvas;
    const dpr = dprCap();
    const drawHalo = !coarse.current;

    ctx.globalCompositeOperation = 'destination-out';
    ctx.fillStyle = 'rgba(0, 0, 0, 0.3)';
    ctx.fillRect(0, 0, w, h);

    ctx.globalCompositeOperation = 'lighter';
    const alive: Spark[] = [];
    for (const p of sparks.current) {
      p.x += p.vx;
      p.y += p.vy;
      p.vy += 0.055 * dpr;
      p.vx *= 0.985;
      p.life -= 1;
      if (p.life <= 0 || p.y > h) continue;
      alive.push(p);
      const t = p.life / p.maxLife;
      const g = Math.round(140 + 115 * t);
      const b = Math.round(30 + 200 * t * t);
      const r = p.size * (0.6 + t);
      ctx.fillStyle = `rgba(255, ${g}, ${b}, ${Math.min(1, t * 1.6)})`;
      ctx.beginPath();
      ctx.arc(p.x, p.y, r, 0, Math.PI * 2);
      ctx.fill();
      if (drawHalo) {
        ctx.fillStyle = `rgba(255, ${g}, ${b}, ${0.16 * t})`;
        ctx.beginPath();
        ctx.arc(p.x, p.y, r * 3.2, 0, Math.PI * 2);
        ctx.fill();
      }
    }
    sparks.current = alive;
    if (alive.length > 0) {
      raf.current = requestAnimationFrame(step);
    } else {
      ctx.clearRect(0, 0, w, h);
      running.current = false;
    }
  }, []);

  const wake = useCallback(() => {
    if (!running.current) {
      running.current = true;
      raf.current = requestAnimationFrame(step);
    }
  }, [step]);

  const spawn = useCallback((u: number, v: number, count: number, speed: number, spread: number, up: number) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const dpr = dprCap();
    const n = coarse.current ? Math.ceil(count / 2) : count;
    const cx = ((CANVAS_OFFSET + u) / CANVAS_SPAN) * canvas.width;
    const cy = ((CANVAS_OFFSET + v) / CANVAS_SPAN) * canvas.height;
    for (let i = 0; i < n; i++) {
      if (sparks.current.length >= maxSparks()) break;
      const angle = -Math.PI / 2 + (Math.random() - 0.5) * spread;
      const vel = (0.4 + Math.random() * speed) * dpr;
      const maxLife = 26 + Math.random() * 40;
      sparks.current.push({
        x: cx + (Math.random() - 0.5) * 3 * dpr,
        y: cy + (Math.random() - 0.5) * 2 * dpr,
        vx: Math.cos(angle) * vel,
        vy: Math.sin(angle) * vel * up,
        life: maxLife,
        maxLife,
        size: (0.5 + Math.random() * 1.3) * dpr,
      });
    }
  }, []);

  useImperativeHandle(
    ref,
    () => ({
      tear: (u, v, intensity) => {
        if (reduced.current) return;
        spawn(u, v, 1 + Math.round(intensity * 2), 1.6 + intensity, Math.PI * 1.1, 1);
        wake();
      },
    }),
    [spawn, wake]
  );

  return <canvas ref={canvasRef} className={s.sparkCanvas} aria-hidden="true" />;
});

/** Turbulence filters that displace the seam line into a crackling energy bolt. */
function BoltFilters() {
  return (
    <svg width="0" height="0" style={{ position: 'absolute' }} aria-hidden="true">
      <defs>
        <filter id="unpack2-bolt-a" x="-5%" y="-900%" width="110%" height="1900%">
          <feTurbulence type="fractalNoise" baseFrequency="0.028 0.09" numOctaves="2" seed="3" result="n">
            <animate
              attributeName="seed"
              dur="0.45s"
              values="3;7;11;15;19;23"
              repeatCount="indefinite"
              calcMode="discrete"
            />
          </feTurbulence>
          <feDisplacementMap in="SourceGraphic" in2="n" scale="13" xChannelSelector="R" yChannelSelector="G" />
        </filter>
        <filter id="unpack2-bolt-b" x="-5%" y="-1400%" width="110%" height="2900%">
          <feTurbulence type="fractalNoise" baseFrequency="0.055 0.16" numOctaves="2" seed="8" result="n">
            <animate
              attributeName="seed"
              dur="0.35s"
              values="8;2;14;26;20;32"
              repeatCount="indefinite"
              calcMode="discrete"
            />
          </feTurbulence>
          <feDisplacementMap in="SourceGraphic" in2="n" scale="22" xChannelSelector="R" yChannelSelector="G" />
        </filter>
      </defs>
    </svg>
  );
}

/** The booster wrapper artwork; rendered twice (strip + body) so the tear stays aligned. */
function PackArt() {
  return (
    <div className={s.packArt}>
      <Image
        src="/unpack2/pack-v2.png"
        alt=""
        fill
        priority
        sizes="(max-width: 768px) 80vw, 420px"
        draggable={false}
        className={s.packImg}
      />
      <div className={s.packSheen} />
    </div>
  );
}

export function Unpack2Experience() {
  const [phase, setPhase] = useState<Phase>('idle');
  const [round, setRound] = useState(0);
  const stageRef = useRef<HTMLDivElement>(null);
  const packRef = useRef<HTMLDivElement>(null);
  const rip = useRef(0);
  const dragX = useRef(0);
  const packW = useRef(1);
  const springRaf = useRef(0);
  const ripRaf = useRef(0);
  const sparksRef = useRef<SparkHandle>(null);
  const coarse = useTilt(stageRef);

  /* touch pointermove can outpace the display; coalesce --rip writes to one per frame */
  const setRipVar = (v: number) => {
    rip.current = v;
    if (ripRaf.current) return;
    ripRaf.current = requestAnimationFrame(() => {
      ripRaf.current = 0;
      packRef.current?.style.setProperty('--rip', rip.current.toFixed(4));
    });
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
    const yRatio = (e.clientY - rect.top) / rect.height;
    if (yRatio < 0.02 || yRatio > 0.42) return;
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
    sparksRef.current?.tear(next, RIP_LINE / 100, Math.min(1, dx / 14));
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
      sparksRef.current?.tear(next, RIP_LINE / 100, 0.7);
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
      <BoltFilters />
      <div className={s.backdrop} />
      <div className={s.vignette} />

      <header className={s.header}>
        <span className={s.headerWord}>GEOLET</span>
        <span className={s.headerDivider} />
        <span className={s.headerSub}>UNPACK · II</span>
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
                        ? { y: '62%', rotate: 3, opacity: [1, 1, 0] }
                        : { y: 0, rotate: 0, opacity: 1 }
                    }
                    transition={{
                      duration: 0.7,
                      delay: phase === 'burst' ? 0.3 : 0,
                      ease: [0.22, 1, 0.36, 1],
                      opacity: { duration: 0.7, delay: phase === 'burst' ? 0.3 : 0, times: [0, 0.55, 1] },
                    }}
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
                    <div className={s.seamAura} />
                    <div className={s.seamBolt} />
                    <div className={s.seamBoltFine} />
                  </div>

                  <SparkCanvas ref={sparksRef} />
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
                    initial={{ x: '0vw', y: '6vh', scale: 0.6, rotate: 0 }}
                    animate={{
                      x: ['0vw', '0vw', t.x],
                      y: ['6vh', '-26vh', t.y],
                      scale: [0.6, 0.78, 0.82],
                      rotate: [0, 0, t.r],
                      opacity: [1, 1, 0],
                    }}
                    transition={{
                      duration: 1.25,
                      delay: 0.1 + i * 0.06,
                      ease: [0.3, 0.9, 0.35, 1],
                      times: [0, 0.42, 1],
                      opacity: { duration: 1.25, delay: 0.1 + i * 0.06, times: [0, 0.7, 1] },
                    }}
                  >
                    <div className={s.cardBack}>
                      <Image
                        src="/unpack2/back.png"
                        alt=""
                        fill
                        sizes="(max-width: 768px) 55vw, 260px"
                        draggable={false}
                        className={s.cardImg}
                      />
                    </div>
                  </motion.div>
                </div>
              ))}
              <motion.div
                key={`hero-${round}`}
                className={s.heroSlot}
                initial={{ y: '7vh', scale: 0.62 }}
                animate={{
                  y: ['7vh', '-25vh', '-25vh', '0vh'],
                  scale: [0.62, 0.85, 0.9, 1],
                }}
                transition={{ duration: 1.55, delay: 0.16, ease: [0.3, 0.8, 0.3, 1], times: [0, 0.36, 0.52, 1] }}
                onAnimationComplete={() => setPhase('revealed')}
              >
                <div className={s.heroCard}>
                  <Image
                    src="/unpack2/card.png"
                    alt="Geolet, World Traveler, legendary card"
                    fill
                    sizes="(max-width: 768px) 66vw, 300px"
                    draggable={false}
                    className={s.cardImg}
                  />
                  {/* holographic layers, driven by --tx / --ty / --hyp */}
                  <div className={s.holoRainbow} />
                  <div className={s.holoSparkle} />
                  <div className={s.holoGlare} />
                </div>
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
        <p className={s.modeTag}>{coarse ? 'Tilts with your touch' : 'Follows your mouse'}</p>
      </footer>
    </div>
  );
}
