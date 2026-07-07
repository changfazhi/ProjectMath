import type { GenerateContentParameters, GenerateContentResponse } from '@google/genai';
import { getGemini } from '../db/gemini.js';
import { AI_LIMITS, type AiCallKind } from '../config/aiLimits.js';
import { AiUnavailableError, mapAiError } from './aiErrors.js';

// Single choke point for every Gemini call. Proactively paces outbound requests under the
// key's per-minute limit (so users queue instead of seeing Google 429s), tracks the daily
// budget (fail fast once spent — queueing can't manufacture daily capacity), and retries
// transient upstream failures (503/500/network) from the queue. In-memory state — assumes
// a single backend instance, like the rest of this app's runtime state.

const PRIORITY: Record<AiCallKind, number> = { chat: 0, grade: 1, diagnosis: 2 };
const MAX_ATTEMPTS = 3; // 1 initial + up to 2 retries for transient failures
const RETRY_BACKOFF_MS = 2000;

interface QueueEntry {
  kind: AiCallKind;
  params: GenerateContentParameters;
  enqueuedAt: number;
  deadline: number; // reject with AI_BUSY if still queued past this
  notBefore: number; // retry backoff / not eligible to run before this
  attempts: number;
  resolve: (r: GenerateContentResponse) => void;
  reject: (e: AiUnavailableError) => void;
}

interface GatewayDeps {
  call: (params: GenerateContentParameters) => Promise<GenerateContentResponse>;
  limits: typeof AI_LIMITS;
}

function busyError(): AiUnavailableError {
  return new AiUnavailableError(
    'The AI is very busy right now — please try again in a few minutes.',
    'AI_BUSY',
    503,
  );
}

export class GeminiGateway {
  private queue: QueueEntry[] = [];
  private callTimes: number[] = []; // dispatch timestamps within the sliding minute
  private dayKey = '';
  private dayCount = 0;
  private dailyBlockedUntil = 0; // epoch ms; >now means fail fast with AI_DAILY_LIMIT
  private pausedUntil = 0; // epoch ms; set when Google 429s despite our pacing
  private timer: ReturnType<typeof setTimeout> | null = null;
  private wakeAt = Infinity;

  constructor(private deps: GatewayDeps) {}

  generate(kind: AiCallKind, params: GenerateContentParameters): Promise<GenerateContentResponse> {
    const now = Date.now();
    this.rolloverIfNeeded(now);

    if (this.dailyBlockedUntil > now || this.dayCount >= this.deps.limits.rpd) {
      if (this.dailyBlockedUntil <= now) this.blockDaily(now);
      return Promise.reject(this.dailyError());
    }
    if (this.queue.length >= this.deps.limits.queueMaxLength) {
      return Promise.reject(busyError());
    }

    return new Promise<GenerateContentResponse>((resolve, reject) => {
      this.queue.push({
        kind,
        params,
        enqueuedAt: now,
        deadline: now + this.deps.limits.queueMaxWaitMs[kind],
        notBefore: now,
        attempts: 0,
        resolve,
        reject,
      });
      this.pump();
    });
  }

  // ---- internals ----

  private pump(): void {
    const now = Date.now();
    this.rolloverIfNeeded(now);

    // Expire entries that waited too long.
    this.queue = this.queue.filter((e) => {
      if (e.deadline <= now) {
        e.reject(busyError());
        return false;
      }
      return true;
    });

    if (this.dailyBlockedUntil > now) {
      this.rejectAllQueued(this.dailyError());
      return;
    }

    while (this.queue.length > 0) {
      // Rate window: how many dispatches in the last 60s?
      this.callTimes = this.callTimes.filter((t) => now - t < 60_000);
      if (this.callTimes.length >= this.deps.limits.outboundRpm) {
        this.wakeBy(now, this.callTimes[0] + 60_000 - now);
        return;
      }
      if (this.pausedUntil > now) {
        this.wakeBy(now, this.pausedUntil - now);
        return;
      }

      // Highest priority (chat first), then FIFO, among entries whose backoff has elapsed.
      const eligible = this.queue.filter((e) => e.notBefore <= now);
      if (eligible.length === 0) {
        this.wakeBy(now, Math.min(...this.queue.map((e) => e.notBefore)) - now);
        return;
      }
      eligible.sort((a, b) => PRIORITY[a.kind] - PRIORITY[b.kind] || a.enqueuedAt - b.enqueuedAt);
      const entry = eligible[0];
      this.queue.splice(this.queue.indexOf(entry), 1);

      if (this.dayCount >= this.deps.limits.rpd) {
        this.blockDaily(now);
        entry.reject(this.dailyError());
        this.rejectAllQueued(this.dailyError());
        return;
      }

      this.callTimes.push(now);
      this.dayCount++;
      this.execute(entry);
    }
  }

  private execute(entry: QueueEntry): void {
    this.deps.call(entry.params).then(
      (res) => {
        entry.resolve(res);
        this.pump();
      },
      (err: unknown) => {
        const mapped = mapAiError(err);
        const now = Date.now();

        // Attempts that never consumed Google's daily quota (per-minute 429, network
        // failure) must not burn our local budget — otherwise RPM churn masquerades
        // as the daily limit. Pacing (callTimes) still counts the attempt.
        if (mapped.refundDaily) {
          this.dayCount = Math.max(0, this.dayCount - 1);
        }

        if (mapped.dailyExhausted) {
          // Google is authoritative — our local counter missed some usage (e.g. a restart).
          this.blockDaily(now);
          entry.reject(mapped.error);
          this.rejectAllQueued(this.dailyError());
          return;
        }
        if (mapped.pauseMs) {
          this.pausedUntil = Math.max(this.pausedUntil, now + mapped.pauseMs);
        }

        const nextAttemptAt = now + RETRY_BACKOFF_MS * (entry.attempts + 1);
        if (mapped.retryable && entry.attempts + 1 < MAX_ATTEMPTS && nextAttemptAt < entry.deadline) {
          entry.attempts++;
          entry.notBefore = nextAttemptAt;
          this.queue.push(entry);
        } else {
          entry.reject(mapped.error);
        }
        this.pump();
      },
    );
  }

  private rejectAllQueued(error: AiUnavailableError): void {
    for (const e of this.queue) e.reject(error);
    this.queue = [];
  }

  private dailyError(): AiUnavailableError {
    return new AiUnavailableError(
      'The AI has reached its daily capacity — it resets overnight. Please try again tomorrow.',
      'AI_DAILY_LIMIT',
      429,
      this.dailyBlockedUntil > 0 ? new Date(this.dailyBlockedUntil).toISOString() : undefined,
    );
  }

  private blockDaily(now: number): void {
    this.dailyBlockedUntil = now + this.msUntilNextPtMidnight(now);
  }

  // Google's free-tier daily quota resets at midnight Pacific Time.
  private ptDayKey(now: number): string {
    return new Intl.DateTimeFormat('en-CA', { timeZone: 'America/Los_Angeles' }).format(new Date(now));
  }

  private msUntilNextPtMidnight(now: number): number {
    const parts = new Intl.DateTimeFormat('en-GB', {
      timeZone: 'America/Los_Angeles',
      hour12: false,
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    }).formatToParts(new Date(now));
    const get = (t: string): number => Number(parts.find((p) => p.type === t)?.value ?? 0);
    const secOfDay = (get('hour') % 24) * 3600 + get('minute') * 60 + get('second');
    return (86_400 - secOfDay) * 1000 + 1000; // +1s buffer past midnight
  }

  private rolloverIfNeeded(now: number): void {
    const key = this.ptDayKey(now);
    if (key !== this.dayKey) {
      this.dayKey = key;
      this.dayCount = 0;
      this.dailyBlockedUntil = 0;
    }
  }

  // Wake no later than the requested delay AND no later than the earliest queued
  // deadline — so a timed-out entry is rejected on time, not when a slot frees up.
  private wakeBy(now: number, delayMs: number): void {
    const nextDeadline =
      this.queue.length > 0 ? Math.min(...this.queue.map((e) => e.deadline)) : Infinity;
    this.wake(Math.min(delayMs, Math.max(nextDeadline - now, 0)));
  }

  private wake(delayMs: number): void {
    const at = Date.now() + Math.max(delayMs, 10);
    if (this.timer !== null && this.wakeAt <= at) return; // an earlier wake is already set
    if (this.timer !== null) clearTimeout(this.timer);
    this.wakeAt = at;
    this.timer = setTimeout(() => {
      this.timer = null;
      this.wakeAt = Infinity;
      this.pump();
    }, at - Date.now());
    this.timer.unref?.();
  }
}

let defaultGateway: GeminiGateway | null = null;

/** All Gemini calls in the app go through here — never call generateContent directly. */
export function aiGenerate(
  kind: AiCallKind,
  params: GenerateContentParameters,
): Promise<GenerateContentResponse> {
  if (!defaultGateway) {
    defaultGateway = new GeminiGateway({
      call: (p) => getGemini().models.generateContent(p),
      limits: AI_LIMITS,
    });
  }
  return defaultGateway.generate(kind, params);
}
