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
}

const events = new Map<string, EventRow>();
const users = new Map<string, UserRow>();
let failUserUpdate = false;

type Filter = { op: 'eq' | 'lt'; col: string; val: string };

class Query {
  private op: 'select' | 'insert' | 'update' | null = null;
  private payload: Record<string, string> = {};
  private filters: Filter[] = [];
  private selectAfterWrite = false;
  private rowMode: 'single' | 'maybeSingle' | 'many' = 'many';

  constructor(private readonly table: string) {}

  insert(payload: Record<string, string>) { this.op = 'insert'; this.payload = payload; return this; }
  update(payload: Record<string, string>) { this.op = 'update'; this.payload = payload; return this; }
  select(_cols?: string) {
    if (this.op === 'update') this.selectAfterWrite = true;
    else this.op = 'select';
    return this;
  }
  eq(col: string, val: string) { this.filters.push({ op: 'eq', col, val }); return this; }
  lt(col: string, val: string) { this.filters.push({ op: 'lt', col, val }); return this; }
  single() { this.rowMode = 'single'; return this; }
  maybeSingle() { this.rowMode = 'maybeSingle'; return this; }

  private matches(row: Record<string, unknown>): boolean {
    return this.filters.every((f) => {
      const actual = row[f.col];
      if (f.op === 'eq') return actual === f.val;
      return new Date(String(actual)).getTime() < new Date(f.val).getTime();
    });
  }

  private idFilter(): string | undefined {
    return this.filters.find((f) => f.op === 'eq' && f.col === 'id')?.val;
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

    if (this.op === 'update') {
      if (this.table === 'users' && failUserUpdate) {
        return { data: null, error: { message: 'connection reset' } };
      }
      const id = this.idFilter();
      const row = id ? store.get(id) : undefined;
      const hit = row && this.matches(row);
      if (hit) Object.assign(row, this.payload);
      if (this.selectAfterWrite) return { data: hit ? [{ id }] : [], error: null };
      return { data: null, error: null };
    }

    // select
    const id = this.idFilter();
    const row = id ? store.get(id) : undefined;
    if (this.rowMode !== 'many') return { data: row ?? null, error: null };
    return { data: row ? [row] : [], error: null };
  }

  // Thenable so `await query...` resolves without an explicit .execute().
  then<R>(resolve: (v: { data: unknown; error: unknown }) => R): R {
    return resolve(this.exec());
  }
}

vi.mock('../db/supabase.js', () => ({ supabase: { from: (t: string) => new Query(t) } }));
vi.mock('../db/firebase.js', () => ({ getFirebaseAdmin: () => ({}) }));
vi.mock('firebase-admin/auth', () => ({ getAuth: () => ({ setCustomUserClaims: vi.fn(async () => {}) }) }));
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

describe('handleWebhookEvent — PayNow idempotency', () => {
  beforeEach(() => {
    events.clear();
    users.clear();
    failUserUpdate = false;
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
