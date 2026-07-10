import { beforeEach, describe, expect, it, vi } from 'vitest';

// A minimal in-memory stand-in for the two tables the webhook touches, so the real
// handleWebhookEvent runs unmodified against it. Only the query shapes billingService
// actually uses are implemented; anything else throws rather than silently passing.
interface EventRow { id: string; type: string; status: string; claimed_at: string; completed_at?: string }
interface UserRow {
  id: string;
  email: string | null;
  access_expires_at: string | null;
  stripe_customer_id: string | null;
  subscription_status?: string | null;
  firebase_uid?: string;
}

const events = new Map<string, EventRow>();
const users = new Map<string, UserRow>();
let failUserUpdate = false;
// Fails only the `users` select whose column list matches, so a test can break one specific
// read (e.g. revokePaidTier's expiry check) without breaking every other read in the handler.
let failUserSelectCols: string | null = null;

type Filter = { op: 'eq' | 'lt' | 'is'; col: string; val: string | null };

class Query {
  private op: 'select' | 'insert' | 'update' | null = null;
  private payload: Record<string, string | null> = {};
  private filters: Filter[] = [];
  private cols = '';
  private selectAfterWrite = false;
  private rowMode: 'single' | 'maybeSingle' | 'many' = 'many';

  constructor(private readonly table: string) {}

  insert(payload: Record<string, string>) { this.op = 'insert'; this.payload = payload; return this; }
  update(payload: Record<string, string | null>) { this.op = 'update'; this.payload = payload; return this; }
  select(cols?: string) {
    this.cols = cols ?? '';
    if (this.op === 'update') this.selectAfterWrite = true;
    else this.op = 'select';
    return this;
  }
  eq(col: string, val: string) { this.filters.push({ op: 'eq', col, val }); return this; }
  lt(col: string, val: string) { this.filters.push({ op: 'lt', col, val }); return this; }
  is(col: string, val: null) { this.filters.push({ op: 'is', col, val }); return this; }
  single() { this.rowMode = 'single'; return this; }
  maybeSingle() { this.rowMode = 'maybeSingle'; return this; }

  private matches(row: Record<string, unknown>): boolean {
    return this.filters.every((f) => {
      const actual = row[f.col];
      if (f.op === 'eq') return actual === f.val;
      if (f.op === 'is') return actual === null || actual === undefined;
      return new Date(String(actual)).getTime() < new Date(String(f.val)).getTime();
    });
  }

  private exec(): { data: unknown; error: { code?: string; message: string } | null } {
    const store: Map<string, Record<string, unknown>> =
      this.table === 'stripe_events' ? (events as never) : (users as never);

    if (this.op === 'insert') {
      const id = this.payload['id'] as string;
      if (store.has(id)) return { data: null, error: { code: '23505', message: 'duplicate key value' } };
      store.set(id, { status: 'processing', claimed_at: new Date().toISOString(), ...this.payload });
      return { data: null, error: null };
    }

    // Filters are matched against every row, not just a lookup by primary key, so queries
    // keyed on other columns (lookupUserByCustomer) behave like the real thing.
    const hits = [...store.values()].filter((row) => this.matches(row));

    if (this.op === 'update') {
      if (this.table === 'users' && failUserUpdate) {
        return { data: null, error: { message: 'connection reset' } };
      }
      for (const row of hits) Object.assign(row, this.payload);
      if (this.selectAfterWrite) return { data: hits.map((row) => ({ id: row['id'] })), error: null };
      return { data: null, error: null };
    }

    if (this.table === 'users' && failUserSelectCols !== null && this.cols === failUserSelectCols) {
      return { data: null, error: { message: 'connection reset' } };
    }
    if (this.rowMode !== 'many') return { data: hits[0] ?? null, error: null };
    return { data: hits, error: null };
  }

  // Thenable so `await query...` resolves without an explicit .execute().
  then<R>(resolve: (v: { data: unknown; error: unknown }) => R): R {
    return resolve(this.exec());
  }
}

const { setCustomUserClaims } = vi.hoisted(() => ({ setCustomUserClaims: vi.fn(async () => {}) }));

// `../db/unwrap.js` is deliberately left unmocked — the real error-checking is under test.
vi.mock('../db/supabase.js', () => ({ supabase: { from: (t: string) => new Query(t) } }));
vi.mock('../db/firebase.js', () => ({ getFirebaseAdmin: () => ({}) }));
vi.mock('firebase-admin/auth', () => ({ getAuth: () => ({ setCustomUserClaims }) }));
vi.mock('./emailService.js', () => ({
  sendFirstPurchaseEmail: vi.fn(async () => true),
  sendReceiptEmail: vi.fn(async () => true),
}));

let nextEvent: Record<string, unknown>;
vi.mock('../db/stripe.js', () => ({
  getStripe: () => ({
    webhooks: { constructEvent: () => nextEvent },
    subscriptions: { list: async () => ({ data: [] }), update: vi.fn(async () => {}) },
  }),
}));

process.env['STRIPE_WEBHOOK_SECRET'] = 'whsec_test';
const { handleWebhookEvent } = await import('./billingService.js');

const DAY_MS = 24 * 60 * 60 * 1000;

function payNowEvent(id: string) {
  return {
    id,
    type: 'checkout.session.completed',
    created: Math.floor(Date.now() / 1000),
    data: {
      object: {
        id: `cs_${id}`,
        mode: 'payment',
        amount_total: null,
        metadata: { user_id: 'u1', firebase_uid: 'fb1', paynow_plan: 'monthly' },
      },
    },
  };
}

function daysGranted(): number {
  const expiry = users.get('u1')!.access_expires_at;
  if (!expiry) return 0;
  return Math.round((new Date(expiry).getTime() - Date.now()) / DAY_MS);
}

function subscriptionDeletedEvent(id: string) {
  return {
    id,
    type: 'customer.subscription.deleted',
    created: Math.floor(Date.now() / 1000),
    data: { object: { id: 'sub_1', customer: 'cus_1' } },
  };
}

describe('handleWebhookEvent — PayNow idempotency', () => {
  beforeEach(() => {
    events.clear();
    users.clear();
    failUserUpdate = false;
    failUserSelectCols = null;
    setCustomUserClaims.mockClear();
    users.set('u1', { id: 'u1', email: null, access_expires_at: null, stripe_customer_id: null });
  });

  it('grants one billing period on first delivery', async () => {
    nextEvent = payNowEvent('evt_1');
    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(daysGranted()).toBe(30);
    expect(events.get('evt_1')?.status).toBe('completed');
  });

  it('does not stack a second period when Stripe redelivers the same event', async () => {
    nextEvent = payNowEvent('evt_1');
    await handleWebhookEvent(Buffer.from(''), 'sig');
    await handleWebhookEvent(Buffer.from(''), 'sig'); // lost 2xx → Stripe retries

    expect(daysGranted()).toBe(30);
  });

  it('still stacks a genuine second purchase (distinct event id)', async () => {
    nextEvent = payNowEvent('evt_1');
    await handleWebhookEvent(Buffer.from(''), 'sig');
    nextEvent = payNowEvent('evt_2');
    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(daysGranted()).toBe(60);
  });

  it('rejects a delivery while another holds a live claim, so Stripe retries', async () => {
    events.set('evt_1', {
      id: 'evt_1',
      type: 'checkout.session.completed',
      status: 'processing',
      claimed_at: new Date().toISOString(),
    });
    nextEvent = payNowEvent('evt_1');

    await expect(handleWebhookEvent(Buffer.from(''), 'sig')).rejects.toThrow(/already being processed/);
    expect(daysGranted()).toBe(0);
  });

  it('takes over a stale claim left by a process that died mid-handler', async () => {
    events.set('evt_1', {
      id: 'evt_1',
      type: 'checkout.session.completed',
      status: 'processing',
      claimed_at: new Date(Date.now() - 10 * 60_000).toISOString(),
    });
    nextEvent = payNowEvent('evt_1');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(daysGranted()).toBe(30);
    expect(events.get('evt_1')?.status).toBe('completed');
  });

  it('throws and leaves the event replayable when the tier write fails', async () => {
    failUserUpdate = true;
    nextEvent = payNowEvent('evt_1');

    await expect(handleWebhookEvent(Buffer.from(''), 'sig')).rejects.toThrow(/Failed to update user/);
    expect(events.get('evt_1')?.status).toBe('processing');
  });
});

// supabase-js reports failures on the result object rather than rejecting, so an unchecked read
// silently degrades to "no row" — and a "no row" here means real money. See issue #53.
describe('handleWebhookEvent — a failed read must never be mistaken for an empty result', () => {
  beforeEach(() => {
    events.clear();
    users.clear();
    failUserUpdate = false;
    failUserSelectCols = null;
    setCustomUserClaims.mockClear();
  });

  it('throws rather than resetting the PayNow baseline when the user read fails', async () => {
    const remaining = new Date(Date.now() + 20 * DAY_MS).toISOString();
    users.set('u1', { id: 'u1', email: null, access_expires_at: remaining, stripe_customer_id: null });
    failUserSelectCols = 'email, access_expires_at, stripe_customer_id';
    nextEvent = payNowEvent('evt_1');

    // Unchecked, `row` would be null: the baseline falls back to Date.now(), silently burning
    // the 20 days the user had already paid for, and the webhook still answers 2xx.
    await expect(handleWebhookEvent(Buffer.from(''), 'sig')).rejects.toThrow(/Failed to load user u1/);
    expect(users.get('u1')?.access_expires_at).toBe(remaining);
    expect(events.get('evt_1')?.status).toBe('processing'); // Stripe retries
  });

  it('throws rather than revoking a user whose expiry read fails', async () => {
    const remaining = new Date(Date.now() + 20 * DAY_MS).toISOString();
    users.set('u1', {
      id: 'u1',
      email: 'a@b.co',
      access_expires_at: remaining,
      stripe_customer_id: 'cus_1',
      subscription_status: 'active',
      firebase_uid: 'fb1',
    });
    failUserSelectCols = 'access_expires_at';
    nextEvent = subscriptionDeletedEvent('evt_1');

    // Unchecked, the guard reads "no expiry" and revokes a user with 20 days of PayNow left.
    await expect(handleWebhookEvent(Buffer.from(''), 'sig')).rejects.toThrow(/Failed to read access expiry/);
    expect(setCustomUserClaims).not.toHaveBeenCalled();
    expect(users.get('u1')?.subscription_status).toBe('active');
  });
});

describe('revokePaidTier — retains a lapsed expiry', () => {
  beforeEach(() => {
    events.clear();
    users.clear();
    failUserUpdate = false;
    failUserSelectCols = null;
    setCustomUserClaims.mockClear();
  });

  it('leaves a past access_expires_at in place so requireAuth keeps deriving free', async () => {
    const lapsed = new Date(Date.now() - DAY_MS).toISOString();
    users.set('u1', {
      id: 'u1',
      email: 'a@b.co',
      access_expires_at: lapsed,
      stripe_customer_id: 'cus_1',
      subscription_status: 'active',
      firebase_uid: 'fb1',
    });
    nextEvent = subscriptionDeletedEvent('evt_1');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(setCustomUserClaims).toHaveBeenCalledWith('fb1', { tier: 'free' });
    expect(users.get('u1')?.subscription_status).toBe('canceled');
    // Nulling this is what made a failed claim write permanent — the timestamp is the only
    // state telling requireAuth a downgrade is still owed.
    expect(users.get('u1')?.access_expires_at).toBe(lapsed);
  });

  it('leaves an active PayNow period alone when a rolled-over card subscription ends', async () => {
    const remaining = new Date(Date.now() + 20 * DAY_MS).toISOString();
    users.set('u1', {
      id: 'u1',
      email: 'a@b.co',
      access_expires_at: remaining,
      stripe_customer_id: 'cus_1',
      subscription_status: 'active',
      firebase_uid: 'fb1',
    });
    nextEvent = subscriptionDeletedEvent('evt_1');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(setCustomUserClaims).not.toHaveBeenCalled();
    expect(users.get('u1')?.subscription_status).toBe('active');
  });
});
