import { AI_LIMITS } from '../config/aiLimits.js';
import { AiUnavailableError } from './aiErrors.js';

// Per-user pacing between accepted AI requests (chat hints / photo grading). In-memory —
// correct only while the backend runs as a single instance (same constraint as pairService).
// Typed re-grades (/api/grade/text) are exempt by design: they're a correction flow.
export type CooldownKind = 'chat' | 'grade';

const lastAccepted = new Map<string, number>(); // `${kind}:${uid}` → epoch ms
const PRUNE_THRESHOLD = 5000;

function cooldownMs(kind: CooldownKind): number {
  return (kind === 'chat' ? AI_LIMITS.chatCooldownS : AI_LIMITS.gradeCooldownS) * 1000;
}

function prune(now: number): void {
  if (lastAccepted.size < PRUNE_THRESHOLD) return;
  const maxAge = Math.max(cooldownMs('chat'), cooldownMs('grade'));
  for (const [key, ts] of lastAccepted) {
    if (now - ts > maxAge) lastAccepted.delete(key);
  }
}

/**
 * Throws AI_COOLDOWN (429) if the user sent an accepted request within the window;
 * otherwise stamps now as their latest accepted request. Check-and-stamp is synchronous,
 * so two concurrent requests from the same user can't both pass.
 */
export function assertAndStampCooldown(uid: string, kind: CooldownKind, now = Date.now()): void {
  const key = `${kind}:${uid}`;
  const last = lastAccepted.get(key);
  const windowMs = cooldownMs(kind);

  if (last !== undefined && now - last < windowMs) {
    const waitS = Math.ceil((last + windowMs - now) / 1000);
    throw new AiUnavailableError(
      `AI is on cooldown — try again in ${waitS} second${waitS === 1 ? '' : 's'}.`,
      'AI_COOLDOWN',
      429,
      new Date(last + windowMs).toISOString(),
    );
  }

  lastAccepted.set(key, now);
  prune(now);
}

/**
 * Un-stamp after a failed AI call so an error (upstream outage, junk-photo rejection, …)
 * doesn't also cost the user their cooldown.
 */
export function clearCooldown(uid: string, kind: CooldownKind): void {
  lastAccepted.delete(`${kind}:${uid}`);
}

/** Test helper. */
export function resetAllCooldowns(): void {
  lastAccepted.clear();
}
