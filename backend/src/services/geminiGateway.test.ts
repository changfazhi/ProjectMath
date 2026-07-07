import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { ApiError } from '@google/genai';
import type { GenerateContentParameters, GenerateContentResponse } from '@google/genai';
import { GeminiGateway } from './geminiGateway.js';
import { AiUnavailableError } from './aiErrors.js';
import type { AI_LIMITS } from '../config/aiLimits.js';

const DAILY_429 =
  '{"error":{"code":429,"status":"RESOURCE_EXHAUSTED","details":[{"violations":[{"quotaId":"GenerateRequestsPerDayPerProjectPerModel-FreeTier"}]}]}}';
const MINUTE_429 =
  '{"error":{"code":429,"status":"RESOURCE_EXHAUSTED","details":[{"violations":[{"quotaId":"GenerateRequestsPerMinutePerProjectPerModel-FreeTier"}]},{"retryDelay":"1s"}]}}';

function makeLimits(overrides: Partial<typeof AI_LIMITS> = {}): typeof AI_LIMITS {
  return {
    rpm: 10,
    rpd: 100,
    outboundRpm: 2,
    chatCooldownS: 5,
    gradeCooldownS: 60,
    queueMaxWaitMs: { chat: 10_000, grade: 20_000, diagnosis: 20_000 },
    queueMaxLength: 10,
    ...overrides,
  };
}

const params = { model: 'test', contents: [] } as unknown as GenerateContentParameters;
const ok = (tag: string) => ({ text: tag }) as unknown as GenerateContentResponse;

async function expectCode(p: Promise<unknown>, code: string): Promise<void> {
  await expect(p).rejects.toSatisfy(
    (e: unknown) => e instanceof AiUnavailableError && e.code === code,
  );
}

describe('GeminiGateway', () => {
  beforeEach(() => {
    vi.useFakeTimers();
    // Mid-day Pacific so no test crosses the PT-midnight daily reset.
    vi.setSystemTime(new Date('2026-07-06T20:00:00Z'));
    vi.spyOn(console, 'error').mockImplementation(() => {});
  });
  afterEach(() => {
    vi.useRealTimers();
    vi.restoreAllMocks();
  });

  it('dispatches immediately while under the per-minute limit', async () => {
    const call = vi.fn().mockResolvedValue(ok('a'));
    const gw = new GeminiGateway({ call, limits: makeLimits() });
    await expect(gw.generate('chat', params)).resolves.toEqual(ok('a'));
    expect(call).toHaveBeenCalledTimes(1);
  });

  // Waits must exceed the 60s slot wait for these queue-release tests.
  const patientWaits = { chat: 120_000, grade: 180_000, diagnosis: 180_000 };

  it('queues beyond the per-minute limit and releases when the window frees', async () => {
    const call = vi.fn().mockResolvedValue(ok('x'));
    const gw = new GeminiGateway({
      call,
      limits: makeLimits({ outboundRpm: 2, queueMaxWaitMs: patientWaits }),
    });

    const p1 = gw.generate('chat', params);
    const p2 = gw.generate('chat', params);
    const p3 = gw.generate('chat', params);
    await vi.advanceTimersByTimeAsync(0);
    expect(call).toHaveBeenCalledTimes(2); // third is queued

    await vi.advanceTimersByTimeAsync(60_100);
    expect(call).toHaveBeenCalledTimes(3);
    await expect(Promise.all([p1, p2, p3])).resolves.toHaveLength(3);
  });

  it('releases queued chat before earlier-queued grading (priority)', async () => {
    const order: string[] = [];
    const call = vi.fn().mockImplementation((p: { model: string }) => {
      order.push(p.model);
      return Promise.resolve(ok(p.model));
    });
    const gw = new GeminiGateway({
      call,
      limits: makeLimits({ outboundRpm: 2, queueMaxWaitMs: patientWaits }),
    });

    // Fill the window.
    void gw.generate('chat', { ...params, model: 'warm1' });
    void gw.generate('chat', { ...params, model: 'warm2' });
    await vi.advanceTimersByTimeAsync(0);

    const pGrade = gw.generate('grade', { ...params, model: 'grade' });
    const pChat = gw.generate('chat', { ...params, model: 'chat' });
    await vi.advanceTimersByTimeAsync(60_100); // one slot frees → chat should win it
    expect(order.indexOf('chat')).toBeLessThan(order.indexOf('grade'));
    await vi.advanceTimersByTimeAsync(60_100);
    await expect(Promise.all([pGrade, pChat])).resolves.toHaveLength(2);
  });

  it('rejects a queued request with AI_BUSY once its max wait is exceeded', async () => {
    const call = vi.fn().mockResolvedValue(ok('x'));
    const gw = new GeminiGateway({ call, limits: makeLimits({ outboundRpm: 1 }) });

    void gw.generate('grade', params); // takes the only slot
    await vi.advanceTimersByTimeAsync(0);
    const queued = gw.generate('chat', params); // chat max wait 10s < 60s slot wait
    const assertion = expectCode(queued, 'AI_BUSY');
    await vi.advanceTimersByTimeAsync(10_100);
    await assertion;
    expect(call).toHaveBeenCalledTimes(1);
  });

  it('rejects immediately with AI_BUSY when the queue is full', async () => {
    const call = vi.fn().mockResolvedValue(ok('x'));
    const gw = new GeminiGateway({ call, limits: makeLimits({ outboundRpm: 1, queueMaxLength: 1 }) });

    void gw.generate('chat', params);
    await vi.advanceTimersByTimeAsync(0);
    const q1 = gw.generate('chat', params); // fills the queue
    await expectCode(gw.generate('chat', params), 'AI_BUSY');
    q1.catch(() => {}); // silence eventual timeout rejection
  });

  it('fails fast with AI_DAILY_LIMIT once the local daily budget is spent', async () => {
    const call = vi.fn().mockResolvedValue(ok('x'));
    const gw = new GeminiGateway({ call, limits: makeLimits({ outboundRpm: 10, rpd: 3 }) });

    await Promise.all([
      gw.generate('chat', params),
      gw.generate('chat', params),
      gw.generate('chat', params),
    ]);
    const rejected = gw.generate('chat', params);
    await expectCode(rejected, 'AI_DAILY_LIMIT');
    await rejected.catch((e: AiUnavailableError) => {
      expect(e.resetAt).toBeDefined(); // points at next PT midnight
    });
    expect(call).toHaveBeenCalledTimes(3);
  });

  it('retries transient 503s and eventually succeeds', async () => {
    const call = vi
      .fn()
      .mockRejectedValueOnce(new ApiError({ message: 'high demand', status: 503 }))
      .mockResolvedValueOnce(ok('recovered'));
    const gw = new GeminiGateway({ call, limits: makeLimits({ outboundRpm: 10 }) });

    const p = gw.generate('grade', params);
    await vi.advanceTimersByTimeAsync(2100); // retry backoff
    await expect(p).resolves.toEqual(ok('recovered'));
    expect(call).toHaveBeenCalledTimes(2);
  });

  it('gives up after exhausting retries and rejects with AI_BUSY', async () => {
    const call = vi.fn().mockRejectedValue(new ApiError({ message: 'down', status: 503 }));
    const gw = new GeminiGateway({ call, limits: makeLimits({ outboundRpm: 10 }) });

    const p = gw.generate('grade', params);
    const assertion = expectCode(p, 'AI_BUSY');
    await vi.advanceTimersByTimeAsync(10_000); // covers both backoffs
    await assertion;
    expect(call).toHaveBeenCalledTimes(3); // 1 initial + 2 retries
  });

  it('a per-minute 429 does not consume the daily budget', async () => {
    const call = vi
      .fn()
      .mockRejectedValueOnce(new ApiError({ message: MINUTE_429, status: 429 }))
      .mockResolvedValue(ok('x'));
    const gw = new GeminiGateway({ call, limits: makeLimits({ outboundRpm: 10, rpd: 2 }) });

    const p = gw.generate('chat', params);
    await vi.advanceTimersByTimeAsync(5000); // covers the 1s pause + 2s retry backoff
    await expect(p).resolves.toEqual(ok('x'));
    expect(call).toHaveBeenCalledTimes(2); // failed attempt + successful retry

    // The 429'd attempt was refunded, so with rpd=2 a second request must still fit.
    await expect(gw.generate('chat', params)).resolves.toEqual(ok('x'));
  });

  it('network failures never consume the daily budget', async () => {
    const call = vi.fn().mockRejectedValue(new TypeError('fetch failed'));
    const gw = new GeminiGateway({ call, limits: makeLimits({ outboundRpm: 10, rpd: 3 }) });

    const p = gw.generate('chat', params);
    const assertion = expectCode(p, 'AI_BUSY');
    await vi.advanceTimersByTimeAsync(10_000); // exhausts all 3 attempts
    await assertion;
    expect(call).toHaveBeenCalledTimes(3);

    // All 3 attempts refunded — the full rpd=3 budget is still available.
    call.mockResolvedValue(ok('x'));
    await expect(
      Promise.all([
        gw.generate('chat', params),
        gw.generate('chat', params),
        gw.generate('chat', params),
      ]),
    ).resolves.toHaveLength(3);
  });

  it('5xx failures still count against the daily budget (they reached Google)', async () => {
    const call = vi.fn().mockRejectedValue(new ApiError({ message: 'down', status: 503 }));
    const gw = new GeminiGateway({ call, limits: makeLimits({ outboundRpm: 10, rpd: 3 }) });

    const p = gw.generate('grade', params);
    const assertion = expectCode(p, 'AI_BUSY');
    await vi.advanceTimersByTimeAsync(10_000); // 3 attempts spend the whole budget
    await assertion;
    expect(call).toHaveBeenCalledTimes(3);

    await expectCode(gw.generate('chat', params), 'AI_DAILY_LIMIT');
    expect(call).toHaveBeenCalledTimes(3);
  });

  it('an upstream per-day 429 blocks everything until the PT reset', async () => {
    const call = vi.fn().mockRejectedValue(new ApiError({ message: DAILY_429, status: 429 }));
    const gw = new GeminiGateway({ call, limits: makeLimits({ outboundRpm: 10 }) });

    const p = gw.generate('chat', params);
    const assertion = expectCode(p, 'AI_DAILY_LIMIT');
    await vi.advanceTimersByTimeAsync(0);
    await assertion;

    // Subsequent calls fail fast without touching Gemini.
    await expectCode(gw.generate('chat', params), 'AI_DAILY_LIMIT');
    expect(call).toHaveBeenCalledTimes(1);
  });
});
