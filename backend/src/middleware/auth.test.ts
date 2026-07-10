import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { NextFunction, Request, Response } from 'express';

// Regression cover for issue #53: an expired user must never end up with a permanent paid tier
// because a Firebase claim write failed. The old downgrade cleared `access_expires_at` — the one
// piece of state saying a downgrade was owed — alongside a fire-and-forget claim write, so any
// claim failure left `tier: 'paid'` with nothing left to trigger a correction.

interface UserRow {
  id: string;
  firebase_uid: string;
  email: string | null;
  subscription_status: string | null;
  access_expires_at: string | null;
  welcome_email_sent_at: string | null;
}

const users = new Map<string, UserRow>();

const { setCustomUserClaims, verifyIdToken } = vi.hoisted(() => ({
  setCustomUserClaims: vi.fn(async () => {}),
  verifyIdToken: vi.fn(async () => ({ uid: 'fb1', email: 'a@b.co', tier: 'paid' } as Record<string, unknown>)),
}));

// Only the two query shapes requireAuth uses: the upsert-and-select, and the status update.
class Query {
  private op: 'upsert' | 'update' | null = null;
  private payload: Record<string, string | null> = {};
  private id: string | null = null;

  upsert(payload: Record<string, string | null>) { this.op = 'upsert'; this.payload = payload; return this; }
  update(payload: Record<string, string | null>) { this.op = 'update'; this.payload = payload; return this; }
  select() { return this; }
  eq(_col: string, val: string) { this.id = val; return this; }
  is() { return this; }
  single() { return this; }

  private exec(): { data: unknown; error: { message: string } | null } {
    if (this.op === 'upsert') {
      const uid = this.payload['firebase_uid'] as string;
      const row = [...users.values()].find((u) => u.firebase_uid === uid);
      return { data: row ?? null, error: row ? null : { message: 'no row' } };
    }
    const row = this.id ? users.get(this.id) : undefined;
    if (row) Object.assign(row, this.payload);
    return { data: row ? [{ id: row.id }] : [], error: null };
  }

  then<R>(resolve: (v: { data: unknown; error: unknown }) => R): R {
    return resolve(this.exec());
  }
}

vi.mock('../db/supabase.js', () => ({ supabase: { from: () => new Query() } }));
vi.mock('../db/firebase.js', () => ({ getFirebaseAdmin: () => ({}) }));
vi.mock('firebase-admin/auth', () => ({ getAuth: () => ({ setCustomUserClaims, verifyIdToken }) }));
vi.mock('../services/emailService.js', () => ({ sendWelcomeEmail: vi.fn(async () => true) }));

const { requireAuth } = await import('./auth.js');

const DAY_MS = 24 * 60 * 60 * 1000;

async function callRequireAuth(): Promise<Request> {
  const req = { headers: { authorization: 'Bearer token' } } as Request;
  const res = {
    status: vi.fn().mockReturnThis(),
    json: vi.fn().mockReturnThis(),
  } as unknown as Response;
  await requireAuth(req, res, vi.fn() as unknown as NextFunction);
  // The reconcile is deliberately off the request's critical path; let it settle before asserting.
  await new Promise((resolve) => setImmediate(resolve));
  return req;
}

function seedLapsedPaidUser(): string {
  const lapsed = new Date(Date.now() - DAY_MS).toISOString();
  users.set('u1', {
    id: 'u1',
    firebase_uid: 'fb1',
    email: 'a@b.co',
    subscription_status: 'active',
    access_expires_at: lapsed,
    welcome_email_sent_at: new Date().toISOString(),
  });
  return lapsed;
}

describe('requireAuth — PayNow expiry downgrade', () => {
  beforeEach(() => {
    users.clear();
    setCustomUserClaims.mockClear();
    setCustomUserClaims.mockImplementation(async () => {});
    verifyIdToken.mockResolvedValue({ uid: 'fb1', email: 'a@b.co', tier: 'paid' });
  });

  it('downgrades a lapsed paid user and reconciles the claim', async () => {
    seedLapsedPaidUser();

    const req = await callRequireAuth();

    expect(req.user?.tier).toBe('free');
    expect(setCustomUserClaims).toHaveBeenCalledWith('fb1', { tier: 'free' });
    expect(users.get('u1')?.subscription_status).toBe('expired');
  });

  it('retains the lapsed expiry rather than clearing it', async () => {
    const lapsed = seedLapsedPaidUser();

    await callRequireAuth();

    expect(users.get('u1')?.access_expires_at).toBe(lapsed);
  });

  it('stays free on every later request when the claim write keeps failing', async () => {
    const lapsed = seedLapsedPaidUser();
    setCustomUserClaims.mockRejectedValue(new Error('firebase unavailable'));
    vi.spyOn(console, 'error').mockImplementation(() => {});

    // First request: enforcement is derived from the stored expiry, so it downgrades regardless.
    expect((await callRequireAuth()).user?.tier).toBe('free');

    // The claim write failed, so the token still says paid and the row must still say "owed":
    // the expiry survives and the status is NOT marked expired, leaving the reconcile retryable.
    expect(users.get('u1')?.access_expires_at).toBe(lapsed);
    expect(users.get('u1')?.subscription_status).toBe('active');

    // The bug: previously `access_expires_at` was nulled here, so this second call — and every
    // call thereafter — resolved `paid` forever.
    expect((await callRequireAuth()).user?.tier).toBe('free');
    expect((await callRequireAuth()).user?.tier).toBe('free');
  });

  it('does not re-issue the claim write once the row is marked expired', async () => {
    seedLapsedPaidUser();

    await callRequireAuth(); // reconciles: claim -> free, status -> expired
    setCustomUserClaims.mockClear();

    // The stale token still carries `tier: 'paid'` until it refreshes (~1h). The user must keep
    // resolving free, but without hammering Firebase on every single request.
    expect((await callRequireAuth()).user?.tier).toBe('free');
    expect(setCustomUserClaims).not.toHaveBeenCalled();
  });

  it('leaves an unexpired paid user alone', async () => {
    const future = new Date(Date.now() + 20 * DAY_MS).toISOString();
    users.set('u1', {
      id: 'u1',
      firebase_uid: 'fb1',
      email: 'a@b.co',
      subscription_status: 'active',
      access_expires_at: future,
      welcome_email_sent_at: new Date().toISOString(),
    });

    const req = await callRequireAuth();

    expect(req.user?.tier).toBe('paid');
    expect(setCustomUserClaims).not.toHaveBeenCalled();
    expect(users.get('u1')?.access_expires_at).toBe(future);
  });

  it('leaves a card subscriber (null expiry) paid', async () => {
    users.set('u1', {
      id: 'u1',
      firebase_uid: 'fb1',
      email: 'a@b.co',
      subscription_status: 'active',
      access_expires_at: null,
      welcome_email_sent_at: new Date().toISOString(),
    });

    expect((await callRequireAuth()).user?.tier).toBe('paid');
  });
});
