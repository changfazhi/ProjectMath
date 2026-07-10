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
  stripe_subscription_id?: string | null;
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

// Hoisted so tests can seed an active subscription and assert the card→PayNow rollover cancels it.
const { subscriptionsList, subscriptionsUpdate } = vi.hoisted(() => ({
  subscriptionsList: vi.fn(async () => ({ data: [] as unknown[] })),
  subscriptionsUpdate: vi.fn(async () => {}),
}));

vi.mock('../db/stripe.js', () => ({
  getStripe: () => ({
    webhooks: { constructEvent: () => nextEvent },
    subscriptions: { list: subscriptionsList, update: subscriptionsUpdate },
  }),
}));

/** Make `findActiveSubscription` return a live subscription whose period ends in `days`. */
function seedActiveStripeSub(days: number, id = 'sub_1'): void {
  subscriptionsList.mockResolvedValue({
    data: [
      {
        id,
        status: 'active',
        items: { data: [{ current_period_end: Math.floor((Date.now() + days * DAY_MS) / 1000) }] },
      },
    ],
  });
}

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

function cardCheckoutEvent(id: string, subscriptionId = 'sub_1') {
  return {
    id,
    type: 'checkout.session.completed',
    created: Math.floor(Date.now() / 1000),
    data: {
      object: {
        id: `cs_${id}`,
        mode: 'subscription',
        subscription: subscriptionId,
        amount_total: null,
        metadata: { user_id: 'u1', firebase_uid: 'fb1' },
      },
    },
  };
}

function subscriptionUpdatedEvent(id: string, status: string, subscriptionId = 'sub_1') {
  return {
    id,
    type: 'customer.subscription.updated',
    created: Math.floor(Date.now() / 1000),
    data: { object: { id: subscriptionId, status, customer: 'cus_1' } },
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

  // Issue #54: the row is what requireAuth reads, so it must land even if Firebase is down.
  // Written claim-first, this cancellation would have been a no-op and the user would have kept
  // paid access indefinitely — every retry failing at the same claim write, before the row.
  it('revokes on the row even when the Firebase claim write fails', async () => {
    users.set('u1', {
      id: 'u1',
      email: 'a@b.co',
      access_expires_at: null,
      stripe_customer_id: 'cus_1',
      subscription_status: 'active',
      firebase_uid: 'fb1',
    });
    setCustomUserClaims.mockRejectedValueOnce(new Error('firebase unavailable'));
    nextEvent = subscriptionDeletedEvent('evt_1');

    await expect(handleWebhookEvent(Buffer.from(''), 'sig')).rejects.toThrow(/firebase unavailable/);

    expect(users.get('u1')?.subscription_status).toBe('canceled');
    expect(events.get('evt_1')?.status).toBe('processing'); // Stripe retries the claim write
  });
});

// Issue #57. `grantPaidTier` used to write `access_expires_at: null`, erasing PayNow time the user
// had already paid for the moment they layered a card subscription on top of it. Cancelling that
// subscription then walked straight past `revokePaidTier`'s "still has PayNow time?" guard, because
// the guard reads the very column the grant had destroyed.
describe('a card subscription bought on top of PayNow', () => {
  const remaining = () => new Date(Date.now() + 20 * DAY_MS).toISOString();

  function seedPayNowUser(expiry: string | null, subscriptionId: string | null = null): void {
    users.set('u1', {
      id: 'u1',
      email: 'a@b.co',
      access_expires_at: expiry,
      stripe_customer_id: 'cus_1',
      stripe_subscription_id: subscriptionId,
      subscription_status: 'active',
      firebase_uid: 'fb1',
    });
  }

  beforeEach(() => {
    events.clear();
    users.clear();
    failUserUpdate = false;
    failUserSelectCols = null;
    setCustomUserClaims.mockClear();
    subscriptionsUpdate.mockClear();
    subscriptionsList.mockResolvedValue({ data: [] });
  });

  it('does not destroy the remaining PayNow expiry', async () => {
    const expiry = remaining();
    seedPayNowUser(expiry);
    nextEvent = cardCheckoutEvent('evt_1');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(users.get('u1')?.access_expires_at).toBe(expiry);
    expect(users.get('u1')?.stripe_subscription_id).toBe('sub_1');
  });

  // The headline bug. Stripe's `trial_end` already defers the first charge to `expiry`, so the
  // 20 days are paid for; cancelling immediately must not take them back.
  it('keeps PayNow access when the subscription is cancelled during its trial', async () => {
    const expiry = remaining();
    seedPayNowUser(expiry, 'sub_1');
    nextEvent = subscriptionDeletedEvent('evt_1');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(setCustomUserClaims).not.toHaveBeenCalled(); // still paid — no downgrade
    expect(users.get('u1')?.subscription_status).toBe('active');
    expect(users.get('u1')?.access_expires_at).toBe(expiry);
    // The subscription is gone even though the tier survives, or deriveTier would read it as live.
    expect(users.get('u1')?.stripe_subscription_id).toBeNull();
  });

  it('downgrades and clears the subscription when no PayNow time is left', async () => {
    seedPayNowUser(new Date(Date.now() - DAY_MS).toISOString(), 'sub_1');
    nextEvent = subscriptionDeletedEvent('evt_1');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(setCustomUserClaims).toHaveBeenCalledWith('fb1', { tier: 'free' });
    expect(users.get('u1')?.subscription_status).toBe('canceled');
    expect(users.get('u1')?.stripe_subscription_id).toBeNull();
  });

  it('records the subscription id so a lapsed PayNow expiry stops mattering', async () => {
    seedPayNowUser(null);
    nextEvent = cardCheckoutEvent('evt_1', 'sub_xyz');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(users.get('u1')?.stripe_subscription_id).toBe('sub_xyz');
  });

  it('refuses a subscription checkout that carries no subscription', async () => {
    seedPayNowUser(null);
    nextEvent = cardCheckoutEvent('evt_1', '');

    await expect(handleWebhookEvent(Buffer.from(''), 'sig')).rejects.toThrow(/carried no subscription/);
    expect(events.get('evt_1')?.status).toBe('processing'); // Stripe retries
  });

  // Preserving the expiry means the PayNow branch can now see BOTH a live expiry and a live
  // subscription. Rolling the card over is no longer an `else` — skipping it would leave the card
  // to start charging at trial_end, on top of the PayNow period just bought.
  it('still cancels the card subscription when PayNow is bought during its trial', async () => {
    seedPayNowUser(remaining(), 'sub_1');
    seedActiveStripeSub(20);
    nextEvent = payNowEvent('evt_1');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(subscriptionsUpdate).toHaveBeenCalledWith('sub_1', { cancel_at_period_end: true });
    expect(daysGranted()).toBe(50); // 20 remaining + 30 new
  });

  it('stacks from whichever of the two runs longer', async () => {
    seedPayNowUser(new Date(Date.now() + 5 * DAY_MS).toISOString(), 'sub_1');
    seedActiveStripeSub(20); // the card period outlives the PayNow expiry
    nextEvent = payNowEvent('evt_1');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(daysGranted()).toBe(50);
  });
});

// Migration 031 backfills pre-existing subscribers with a sentinel id; every live subscription
// emits `customer.subscription.updated` at least once a billing cycle, replacing it with the real one.
describe('customer.subscription.updated — recording a live subscription', () => {
  beforeEach(() => {
    events.clear();
    users.clear();
    failUserUpdate = false;
    failUserSelectCols = null;
    setCustomUserClaims.mockClear();
    users.set('u1', {
      id: 'u1',
      email: 'a@b.co',
      access_expires_at: null,
      stripe_customer_id: 'cus_1',
      stripe_subscription_id: 'legacy_unbackfilled',
      subscription_status: 'active',
      firebase_uid: 'fb1',
    });
  });

  it.each(['active', 'trialing'])('records the real subscription id on a %s update', async (status) => {
    nextEvent = subscriptionUpdatedEvent('evt_1', status, 'sub_real');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(users.get('u1')?.stripe_subscription_id).toBe('sub_real');
    expect(users.get('u1')?.subscription_status).toBe('active');
  });

  it.each(['past_due', 'unpaid', 'canceled'])('revokes on a %s update', async (status) => {
    nextEvent = subscriptionUpdatedEvent('evt_1', status);

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(users.get('u1')?.subscription_status).toBe(status);
    expect(users.get('u1')?.stripe_subscription_id).toBeNull();
  });

  it('ignores a status it has no opinion about', async () => {
    nextEvent = subscriptionUpdatedEvent('evt_1', 'incomplete');

    await handleWebhookEvent(Buffer.from(''), 'sig');

    expect(users.get('u1')?.stripe_subscription_id).toBe('legacy_unbackfilled');
  });
});
