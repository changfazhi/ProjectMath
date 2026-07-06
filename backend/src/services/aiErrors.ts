import type { Response } from 'express';
import { ApiError } from '@google/genai';

// Public-safe replacement for anything that goes wrong at or near the Gemini call.
// The raw upstream error (Google's JSON blob, network errors, …) is logged server-side
// only — err.message here is always safe to show a student verbatim.
export type AiErrorCode = 'AI_COOLDOWN' | 'AI_BUSY' | 'AI_DAILY_LIMIT' | 'AI_ERROR';

export class AiUnavailableError extends Error {
  constructor(
    message: string, // public-safe, user-facing
    readonly code: AiErrorCode,
    readonly httpStatus: number,
    readonly resetAt?: string, // ISO — when it's worth trying again (cooldowns, daily cap)
  ) {
    super(message);
    this.name = 'AiUnavailableError';
  }
}

// Google 429 bodies carry QuotaFailure violations (quotaId tells minute vs day) and a
// RetryInfo retryDelay like "1.49s". The blob arrives as ApiError.message; parse defensively.
interface Upstream429Info {
  isDaily: boolean;
  retryDelayS: number | null;
}

function parse429(message: string): Upstream429Info {
  const isDaily = /per\s?day|PerDay/i.test(message);
  const delayMatch = message.match(/retryDelay[^0-9]*([0-9.]+)s/i);
  const retryDelayS = delayMatch ? Math.ceil(Number(delayMatch[1])) : null;
  return { isDaily, retryDelayS: Number.isFinite(retryDelayS) ? retryDelayS : null };
}

// The SDK throws ApiError with a numeric .status, but be defensive: duck-type a numeric
// status field, and as a last resort fish the code out of an embedded JSON error body.
function upstreamStatus(err: unknown): number | null {
  if (err instanceof ApiError) return err.status;
  if (err && typeof err === 'object') {
    const s = (err as { status?: unknown }).status;
    if (typeof s === 'number') return s;
  }
  if (err instanceof Error) {
    const m = err.message.match(/"code"\s*:\s*(4\d\d|5\d\d)/);
    if (m) return Number(m[1]);
  }
  return null;
}

function isNetworkError(err: unknown): boolean {
  if (!(err instanceof Error)) return false;
  return (
    err.name === 'AbortError' ||
    /fetch failed|network|ECONNRESET|ECONNREFUSED|ETIMEDOUT|EAI_AGAIN|socket hang up/i.test(
      err.message,
    )
  );
}

export interface MappedAiError {
  error: AiUnavailableError;
  /** Whether the gateway may retry the underlying call. */
  retryable: boolean;
  /** For upstream per-minute 429s: how long the whole gateway should pause. */
  pauseMs?: number;
  /** True when Google says the key's daily quota is spent. */
  dailyExhausted?: boolean;
}

/**
 * Convert anything thrown by (or around) a Gemini call into a public-safe error plus
 * retry metadata for the gateway. Logs the raw error server-side — callers must NOT
 * send the original error's message to a client.
 */
export function mapAiError(err: unknown): MappedAiError {
  if (err instanceof AiUnavailableError) {
    return { error: err, retryable: false };
  }

  const status = upstreamStatus(err);
  const raw = err instanceof Error ? err.message : String(err);

  if (status === 429) {
    const { isDaily, retryDelayS } = parse429(raw);
    if (isDaily) {
      console.error('[ai] upstream DAILY quota exhausted:', raw);
      return {
        error: new AiUnavailableError(
          'The AI has reached its daily capacity — it resets overnight. Please try again tomorrow.',
          'AI_DAILY_LIMIT',
          429,
        ),
        retryable: false,
        dailyExhausted: true,
      };
    }
    console.error('[ai] upstream rate limit (per-minute):', raw);
    return {
      error: new AiUnavailableError(
        'The AI is handling a lot of requests right now — please try again in a minute.',
        'AI_BUSY',
        429,
      ),
      retryable: true,
      pauseMs: (retryDelayS ?? 15) * 1000,
    };
  }

  if (status === 503 || status === 500 || status === 502 || status === 504) {
    console.error(`[ai] upstream ${status}:`, raw);
    return {
      error: new AiUnavailableError(
        'The AI is experiencing high demand — please try again in a moment.',
        'AI_BUSY',
        503,
      ),
      retryable: true,
    };
  }

  if (status !== null) {
    // 400/401/403/404 — misconfiguration (bad key, restricted key, unknown/retired model).
    // Never retryable, and the details are ours to fix, not the student's to see.
    console.error(`[ai] upstream ${status} — check GEMINI_API_KEY / GEMINI_MODEL:`, raw);
    return {
      error: new AiUnavailableError(
        'The AI tutor is temporarily unavailable. Please try again later.',
        'AI_ERROR',
        502,
      ),
      retryable: false,
    };
  }

  if (isNetworkError(err)) {
    console.error('[ai] network failure reaching Gemini:', raw);
    return {
      error: new AiUnavailableError(
        "We couldn't reach the AI — please try again in a moment.",
        'AI_BUSY',
        503,
      ),
      retryable: true,
    };
  }

  console.error('[ai] unexpected error during AI call:', err);
  return {
    error: new AiUnavailableError(
      'The AI tutor hit an unexpected problem. Please try again.',
      'AI_ERROR',
      502,
    ),
    retryable: false,
  };
}

/** Consistent JSON body for AI availability errors — mirrors sendQuotaError's shape. */
export function sendAiError(res: Response, err: AiUnavailableError): void {
  res.status(err.httpStatus).json({
    error: err.message,
    code: err.code,
    ...(err.resetAt ? { reset_at: err.resetAt } : {}),
  });
}
