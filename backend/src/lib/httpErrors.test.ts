import { describe, it, expect, vi, afterEach } from 'vitest';
import type { Response } from 'express';
import { sendServerError, GENERIC_ERROR_MESSAGE } from './httpErrors.js';

// A minimal Express Response double that records status()/json() calls.
function fakeRes(): Response & { statusCode?: number; body?: unknown } {
  const res = {} as Response & { statusCode?: number; body?: unknown };
  res.status = vi.fn((code: number) => {
    res.statusCode = code;
    return res;
  }) as unknown as Response['status'];
  res.json = vi.fn((body: unknown) => {
    res.body = body;
    return res;
  }) as unknown as Response['json'];
  return res;
}

describe('sendServerError', () => {
  afterEach(() => vi.restoreAllMocks());

  it('responds 500 with the generic message, never the raw error text', () => {
    vi.spyOn(console, 'error').mockImplementation(() => {});
    const res = fakeRes();

    sendServerError(res, 'GET /api/topics', new Error('relation "users" does not exist'));

    expect(res.statusCode).toBe(500);
    expect(res.body).toEqual({ error: GENERIC_ERROR_MESSAGE });
    // The internal detail must not appear in what the client receives.
    expect(JSON.stringify(res.body)).not.toContain('relation "users"');
  });

  it('logs the real error server-side under the given context', () => {
    const spy = vi.spyOn(console, 'error').mockImplementation(() => {});
    const cause = new Error('connection refused');

    sendServerError(fakeRes(), 'POST /api/attempts', cause);

    expect(spy).toHaveBeenCalledOnce();
    const [message, logged] = spy.mock.calls[0];
    expect(String(message)).toContain('POST /api/attempts');
    expect(logged).toBe(cause);
  });

  it('handles a non-Error thrown value without itself throwing', () => {
    vi.spyOn(console, 'error').mockImplementation(() => {});
    const res = fakeRes();

    expect(() => sendServerError(res, 'GET /api/usage', 'a bare string')).not.toThrow();
    expect(res.statusCode).toBe(500);
    expect(res.body).toEqual({ error: GENERIC_ERROR_MESSAGE });
  });
});
