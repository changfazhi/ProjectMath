import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { ApiError } from '@google/genai';
import { AiUnavailableError, mapAiError } from './aiErrors.js';

// Realistic Google 429 bodies — the SDK surfaces these as ApiError.message.
const MINUTE_429 = JSON.stringify({
  error: {
    code: 429,
    message: 'You exceeded your current quota, please check your plan and billing details.',
    status: 'RESOURCE_EXHAUSTED',
    details: [
      {
        '@type': 'type.googleapis.com/google.rpc.QuotaFailure',
        violations: [
          {
            quotaMetric: 'generativelanguage.googleapis.com/generate_content_free_tier_requests',
            quotaId: 'GenerateRequestsPerMinutePerProjectPerModel-FreeTier',
            quotaValue: '10',
          },
        ],
      },
      { '@type': 'type.googleapis.com/google.rpc.RetryInfo', retryDelay: '1.49s' },
    ],
  },
});

const DAILY_429 = MINUTE_429.replace(
  'GenerateRequestsPerMinutePerProjectPerModel-FreeTier',
  'GenerateRequestsPerDayPerProjectPerModel-FreeTier',
);

describe('mapAiError', () => {
  beforeEach(() => {
    vi.spyOn(console, 'error').mockImplementation(() => {});
  });
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it('maps a per-minute 429 to retryable AI_BUSY with the RetryInfo pause', () => {
    const mapped = mapAiError(new ApiError({ message: MINUTE_429, status: 429 }));
    expect(mapped.error.code).toBe('AI_BUSY');
    expect(mapped.error.httpStatus).toBe(429);
    expect(mapped.retryable).toBe(true);
    expect(mapped.pauseMs).toBe(2000); // ceil(1.49s)
    expect(mapped.dailyExhausted).toBeUndefined();
    expect(mapped.refundDaily).toBe(true); // rejected before daily accounting
  });

  it('maps a per-day 429 to non-retryable AI_DAILY_LIMIT', () => {
    const mapped = mapAiError(new ApiError({ message: DAILY_429, status: 429 }));
    expect(mapped.error.code).toBe('AI_DAILY_LIMIT');
    expect(mapped.retryable).toBe(false);
    expect(mapped.dailyExhausted).toBe(true);
    expect(mapped.refundDaily).toBeUndefined();
  });

  it('maps 503 (high demand) to retryable AI_BUSY', () => {
    const mapped = mapAiError(
      new ApiError({ message: '{"error":{"code":503,"status":"UNAVAILABLE"}}', status: 503 }),
    );
    expect(mapped.error.code).toBe('AI_BUSY');
    expect(mapped.error.httpStatus).toBe(503);
    expect(mapped.retryable).toBe(true);
    expect(mapped.refundDaily).toBeUndefined(); // reached Google — still counts
  });

  it('maps 404 (unknown/retired model) to non-retryable AI_ERROR', () => {
    const mapped = mapAiError(
      new ApiError({ message: 'models/gemini-9.9-flash is not found', status: 404 }),
    );
    expect(mapped.error.code).toBe('AI_ERROR');
    expect(mapped.retryable).toBe(false);
  });

  it('maps network failures to retryable AI_BUSY', () => {
    const mapped = mapAiError(new TypeError('fetch failed'));
    expect(mapped.error.code).toBe('AI_BUSY');
    expect(mapped.retryable).toBe(true);
    expect(mapped.refundDaily).toBe(true); // never reached Google
  });

  it('maps unknown errors to non-retryable AI_ERROR', () => {
    const mapped = mapAiError(new Error('supabase exploded'));
    expect(mapped.error.code).toBe('AI_ERROR');
    expect(mapped.retryable).toBe(false);
  });

  it('passes AiUnavailableError through untouched', () => {
    const original = new AiUnavailableError('on cooldown', 'AI_COOLDOWN', 429);
    expect(mapAiError(original).error).toBe(original);
  });

  it('never leaks the raw upstream message to the public error', () => {
    for (const err of [
      new ApiError({ message: MINUTE_429, status: 429 }),
      new ApiError({ message: DAILY_429, status: 429 }),
      new TypeError('fetch failed'),
      new Error('supabase exploded'),
    ]) {
      const { error } = mapAiError(err);
      expect(error.message).not.toMatch(/generativelanguage|quota|supabase|fetch failed/i);
    }
  });
});
