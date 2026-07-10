import { AI_LIMITS } from '../config/aiLimits.js';
import { AiUnavailableError } from './aiErrors.js';

// Per-user pacing between accepted AI requests. In-memory — correct only while the
// backend runs as a single instance (same constraint as pairService).
//
// Two mechanisms:
//  - Chat: check-and-stamp — a request inside the window is rejected with AI_COOLDOWN.
//  - Grade: slot reservation — a photo grade inside the window is HELD (acquireGradeSlot
//    sleeps until the slot frees) instead of rejected; at most one waiter per user, a
//    further submission is rejected. Typed re-grades (/api/grade/text) are exempt by
//    design: they're a correction flow.
export type CooldownKind = 'chat' | 'grade';

const PRUNE_THRESHOLD = 5000;

function cooldownMs(kind: CooldownKind): number {
  return (kind === 'chat' ? AI_LIMITS.chatCooldownS : AI_LIMITS.gradeCooldownS) * 1000;
}

// ---- chat: reject inside the window ----

const lastAccepted = new Map<string, number>(); // `${kind}:${uid}` → epoch ms

function pruneChat(now: number): void {
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
  pruneChat(now);
}

/**
 * Un-stamp after a failed AI call so an error (upstream outage, junk-photo rejection, …)
 * doesn't also cost the user their cooldown.
 */
export function clearCooldown(uid: string, kind: CooldownKind): void {
  lastAccepted.delete(`${kind}:${uid}`);
}

// ---- grade: hold inside the window ----

interface GradeSlot {
  nextFreeAt: number; // epoch ms when the next accepted grade may start
  waiting: boolean; // a held request is already waiting for nextFreeAt's predecessor slot
}

const gradeSlots = new Map<string, GradeSlot>(); // uid → slot

function pruneGradeSlots(now: number): void {
  if (gradeSlots.size < PRUNE_THRESHOLD) return;
  for (const [uid, slot] of gradeSlots) {
    if (!slot.waiting && now >= slot.nextFreeAt) gradeSlots.delete(uid);
  }
}

/**
 * Reserve the user's next grade slot. Synchronous check-and-set, so two concurrent
 * requests from the same user can't both take the waiter position.
 *
 * - Slot free (or window expired) → run now, next request must wait a full window.
 * - Inside the window, no waiter yet → become the single waiter; returns how long to
 *   sleep before running. The window chains so a request after this one waits its turn.
 * - A waiter already exists → AI_COOLDOWN (429): one held grading per user.
 */
export function reserveGradeSlot(uid: string, now = Date.now()): { waitMs: number } {
  const windowMs = cooldownMs('grade');
  const slot = gradeSlots.get(uid);

  if (!slot || now >= slot.nextFreeAt) {
    gradeSlots.set(uid, { nextFreeAt: now + windowMs, waiting: false });
    pruneGradeSlots(now);
    return { waitMs: 0 };
  }

  if (slot.waiting) {
    throw new AiUnavailableError(
      'You already have a grading in progress — wait for it to finish before submitting again.',
      'AI_COOLDOWN',
      429,
      new Date(slot.nextFreeAt).toISOString(),
    );
  }

  const runAt = slot.nextFreeAt;
  slot.nextFreeAt = runAt + windowMs;
  slot.waiting = true;
  return { waitMs: runAt - now };
}

/**
 * Reserve a slot and, if the cooldown is still running, hold the request until the
 * slot frees. Resolves when the grade may proceed to the Gemini gateway.
 */
export async function acquireGradeSlot(uid: string, now = Date.now()): Promise<void> {
  const { waitMs } = reserveGradeSlot(uid, now);
  if (waitMs <= 0) return;
  await new Promise<void>((resolve) => setTimeout(resolve, waitMs));
  const slot = gradeSlots.get(uid);
  if (slot) slot.waiting = false; // the waiter is now the runner — free the wait position
}

/**
 * Start the cooldown window now, skipping any wait a running window would impose.
 *
 * For the one call allowed to jump the queue: a typed correction of a photo scan the user just
 * made, where the student is fixing characters Gemini mis-read. It runs immediately but must still
 * leave a window behind it — a rejected correction writes no `gradings` row, so it costs no quota,
 * and with no cooldown either it could be resubmitted at the rate limiter's pace for the whole
 * grace period. Stamping here consumes the exemption on *attempt* rather than on success (#56).
 *
 * An existing waiter keeps its position: it has already scheduled its wake-up against the old
 * window, and clearing the flag would let a second request take the waiter slot behind it.
 */
export function stampGradeSlot(uid: string, now = Date.now()): void {
  const slot = gradeSlots.get(uid);
  gradeSlots.set(uid, { nextFreeAt: now + cooldownMs('grade'), waiting: slot?.waiting ?? false });
}

/**
 * Refund after a grading failed for a reason that is *our* fault (upstream outage, DB error), so
 * the user doesn't lose their cooldown to it. Callers must NOT refund a `GradingError` — the model
 * rejecting a junk photo still burned a real Gemini call, and refunding it made junk submissions
 * an unmetered vision call every few seconds (issue #56). If another request is already waiting
 * behind the failed one, its reservation stands and nothing is refunded.
 */
export function refundGradeSlot(uid: string): void {
  const slot = gradeSlots.get(uid);
  if (!slot || slot.waiting) return;
  gradeSlots.delete(uid);
}

/** Test helper. */
export function resetAllCooldowns(): void {
  lastAccepted.clear();
  gradeSlots.clear();
}
