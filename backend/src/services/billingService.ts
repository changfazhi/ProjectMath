import type Stripe from 'stripe';
import { getStripe } from '../db/stripe.js';
import { supabase } from '../db/supabase.js';
import { getAuth } from 'firebase-admin/auth';
import { getFirebaseAdmin } from '../db/firebase.js';
import { sendFirstPurchaseEmail, sendReceiptEmail } from './emailService.js';

const FRONTEND_URL = process.env.FRONTEND_URL ?? 'http://localhost:5173';

async function findActiveSubscription(stripe: Stripe, customerId: string): Promise<Stripe.Subscription | null> {
  const subs = await stripe.subscriptions.list({ customer: customerId, status: 'all', limit: 10 });
  return subs.data.find((s) => s.status === 'active' || s.status === 'trialing') ?? null;
}

export async function createCheckoutSession(
  userId: string,
  firebaseUid: string,
  email: string,
  priceId: string,
  method: 'card' | 'paynow',
  plan: 'monthly' | 'semesterly',
): Promise<{ url: string }> {
  const stripe = getStripe();

  const { data: userData } = await supabase
    .from('users')
    .select('stripe_customer_id, subscription_status, access_expires_at')
    .eq('id', userId)
    .single();

  const row = userData as {
    stripe_customer_id: string | null;
    subscription_status: string | null;
    access_expires_at: string | null;
  } | null;

  let customerId = row?.stripe_customer_id ?? null;

  if (!customerId) {
    const customer = await stripe.customers.create({
      email,
      metadata: { user_id: userId, firebase_uid: firebaseUid },
    });
    customerId = customer.id;
    await supabase.from('users').update({ stripe_customer_id: customerId }).eq('id', userId);
  }

  // Verify the stored customer still exists in Stripe (guards against manual Dashboard deletions).
  try {
    const existing = await stripe.customers.retrieve(customerId);
    if ((existing as { deleted?: boolean }).deleted) throw new Error('deleted');
  } catch {
    const customer = await stripe.customers.create({
      email,
      metadata: { user_id: userId, firebase_uid: firebaseUid },
    });
    customerId = customer.id;
    await supabase
      .from('users')
      .update({ stripe_customer_id: customerId, subscription_status: null })
      .eq('id', userId);
  }

  if (method === 'paynow') {
    // Always allowed — stacks on top of any remaining access and cancels an active
    // card subscription at period end (see the webhook handler for both).
    const session = await stripe.checkout.sessions.create({
      customer: customerId,
      mode: 'payment',
      payment_method_types: ['paynow'],
      line_items: [{ price: priceId, quantity: 1 }],
      success_url: `${FRONTEND_URL}/roadmap?checkout=success`,
      cancel_url: `${FRONTEND_URL}/roadmap?checkout=canceled`,
      metadata: { user_id: userId, firebase_uid: firebaseUid, paynow_plan: plan },
    });
    if (!session.url) throw new Error('Stripe did not return a checkout URL');
    return { url: session.url };
  }

  // Card subscription — block only a genuine duplicate (another card subscription already running).
  const activeCardSub = await findActiveSubscription(stripe, customerId);
  if (activeCardSub) {
    throw new Error(
      'You already have an active card subscription. Manage or cancel it from the billing portal before starting a new one.',
    );
  }

  // If PayNow access is still running, delay the first charge until it runs out instead
  // of double-billing during the overlap.
  const payNowExpiryMs = row?.access_expires_at ? new Date(row.access_expires_at).getTime() : null;
  const trialEnd =
    payNowExpiryMs !== null && payNowExpiryMs > Date.now() + 60_000
      ? Math.floor(payNowExpiryMs / 1000)
      : undefined;

  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: 'subscription',
    line_items: [{ price: priceId, quantity: 1 }],
    subscription_data: trialEnd ? { trial_end: trialEnd } : undefined,
    success_url: `${FRONTEND_URL}/roadmap?checkout=success`,
    cancel_url: `${FRONTEND_URL}/roadmap?checkout=canceled`,
    metadata: { user_id: userId, firebase_uid: firebaseUid },
  });
  if (!session.url) throw new Error('Stripe did not return a checkout URL');
  return { url: session.url };
}

export async function createPortalSession(userId: string): Promise<{ url: string }> {
  const stripe = getStripe();

  const { data: userData } = await supabase
    .from('users')
    .select('stripe_customer_id')
    .eq('id', userId)
    .single();

  const customerId = (userData as { stripe_customer_id: string | null } | null)?.stripe_customer_id;
  if (!customerId) throw new Error('No Stripe customer found for this user');

  // Guard against stale customer IDs (e.g. manually deleted from Stripe Dashboard).
  try {
    const existing = await stripe.customers.retrieve(customerId);
    if ((existing as { deleted?: boolean }).deleted) throw new Error('deleted');
  } catch {
    await supabase
      .from('users')
      .update({ stripe_customer_id: null, subscription_status: null })
      .eq('id', userId);
    throw new Error('Stripe customer no longer exists. Please subscribe again.');
  }

  const session = await stripe.billingPortal.sessions.create({
    customer: customerId,
    return_url: `${FRONTEND_URL}/roadmap`,
  });

  return { url: session.url };
}

async function grantPaidTier(firebaseUid: string, userId: string): Promise<void> {
  await getAuth(getFirebaseAdmin()).setCustomUserClaims(firebaseUid, { tier: 'paid' });
  await supabase.from('users').update({ subscription_status: 'active', access_expires_at: null }).eq('id', userId);
}

async function grantPayNowTier(firebaseUid: string, userId: string, expiresAt: Date): Promise<void> {
  await getAuth(getFirebaseAdmin()).setCustomUserClaims(firebaseUid, {
    tier: 'paid',
    expires_at: expiresAt.toISOString(),
  });
  await supabase
    .from('users')
    .update({ subscription_status: 'active', access_expires_at: expiresAt.toISOString() })
    .eq('id', userId);
}

async function revokePaidTier(firebaseUid: string, userId: string, status: string): Promise<void> {
  // A card subscription can end because it was scheduled to cancel at period end after the
  // user rolled over to PayNow (see checkout.session.completed above) — if PayNow access is
  // still running, leave the tier alone instead of clobbering it.
  const { data } = await supabase.from('users').select('access_expires_at').eq('id', userId).single();
  const accessExpiresAt = (data as { access_expires_at: string | null } | null)?.access_expires_at;
  if (accessExpiresAt && new Date(accessExpiresAt) > new Date()) return;

  await getAuth(getFirebaseAdmin()).setCustomUserClaims(firebaseUid, { tier: 'free' });
  await supabase
    .from('users')
    .update({ subscription_status: status, access_expires_at: null })
    .eq('id', userId);
}

async function lookupUserByCustomer(
  customerId: string,
): Promise<{ id: string; firebase_uid: string; email: string | null } | null> {
  const { data } = await supabase
    .from('users')
    .select('id, firebase_uid, email')
    .eq('stripe_customer_id', customerId)
    .single();
  return data as { id: string; firebase_uid: string; email: string | null } | null;
}

// Marks the once-ever "first purchase" flag atomically (only the caller that flips it from
// NULL actually sends) and, only then, sends the congrats email. If the send fails, the
// claim is rolled back so the next transaction retries instead of the account being
// permanently marked "congratulated" with nothing ever delivered.
async function sendFirstPurchaseEmailIfNeeded(userId: string, email: string): Promise<void> {
  const { data: claimed } = await supabase
    .from('users')
    .update({ first_purchase_email_sent_at: new Date().toISOString() })
    .eq('id', userId)
    .is('first_purchase_email_sent_at', null)
    .select('id');
  if (claimed && claimed.length > 0) {
    const sent = await sendFirstPurchaseEmail(email);
    if (!sent) {
      await supabase.from('users').update({ first_purchase_email_sent_at: null }).eq('id', userId);
    }
  }
}

export async function handleWebhookEvent(rawBody: Buffer, signature: string): Promise<void> {
  const stripe = getStripe();
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;
  if (!webhookSecret) throw new Error('Missing STRIPE_WEBHOOK_SECRET');

  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(rawBody, signature, webhookSecret);
  } catch {
    throw new Error('Webhook signature verification failed');
  }

  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object as Stripe.Checkout.Session;
      const userId = session.metadata?.user_id;
      const firebaseUid = session.metadata?.firebase_uid;
      if (!userId || !firebaseUid) break;

      const { data: userRow } = await supabase
        .from('users')
        .select('email, access_expires_at, stripe_customer_id')
        .eq('id', userId)
        .single();
      const row = userRow as {
        email: string | null;
        access_expires_at: string | null;
        stripe_customer_id: string | null;
      } | null;
      const email = session.customer_details?.email ?? row?.email ?? null;

      if (session.mode === 'subscription') {
        await grantPaidTier(firebaseUid, userId);
      } else if (session.mode === 'payment') {
        const paynowPlan = session.metadata?.paynow_plan as 'monthly' | 'semesterly' | undefined;
        const msToAdd = paynowPlan === 'semesterly'
          ? 180 * 24 * 60 * 60 * 1000
          : 30 * 24 * 60 * 60 * 1000;

        // Stack onto remaining PayNow access; otherwise roll over from an active card
        // subscription (canceling it at period end) so there's no gap or overlap.
        let baselineMs = Date.now();
        const existingExpiryMs = row?.access_expires_at ? new Date(row.access_expires_at).getTime() : null;
        if (existingExpiryMs !== null && existingExpiryMs > baselineMs) {
          baselineMs = existingExpiryMs;
        } else if (row?.stripe_customer_id) {
          const activeSub = await findActiveSubscription(stripe, row.stripe_customer_id);
          const currentPeriodEnd = activeSub?.items.data[0]?.current_period_end;
          if (activeSub && currentPeriodEnd) {
            baselineMs = currentPeriodEnd * 1000;
            await stripe.subscriptions.update(activeSub.id, { cancel_at_period_end: true });
          }
        }

        const expiresAt = new Date(baselineMs + msToAdd);
        await grantPayNowTier(firebaseUid, userId, expiresAt);
      }

      // Email side-effects — fire-and-forget, must never fail the webhook response.
      if (email) {
        sendFirstPurchaseEmailIfNeeded(userId, email).catch(() => {});
        if (session.amount_total != null && session.currency) {
          const description = session.mode === 'subscription'
            ? 'ProjectMath Premium — card subscription'
            : `ProjectMath Premium — PayNow (${session.metadata?.paynow_plan ?? 'plan'})`;
          sendReceiptEmail(email, {
            reference: session.id,
            date: new Date(event.created * 1000),
            description,
            amountCents: session.amount_total,
            currency: session.currency,
          }).catch(() => {});
        }
      }
      break;
    }

    case 'invoice.payment_succeeded': {
      // Only recurring renewal charges — the first invoice on a new subscription
      // (billing_reason 'subscription_create') is already receipted above via
      // checkout.session.completed, so sending here too would double up.
      const invoice = event.data.object as Stripe.Invoice;
      if (invoice.billing_reason !== 'subscription_cycle') break;

      const customerId = typeof invoice.customer === 'string' ? invoice.customer : invoice.customer?.id;
      if (!customerId) break;
      const user = await lookupUserByCustomer(customerId);
      if (!user?.email) break;

      await sendReceiptEmail(user.email, {
        reference: invoice.id,
        date: new Date(event.created * 1000),
        description: 'ProjectMath Premium — subscription renewal',
        amountCents: invoice.amount_paid,
        currency: invoice.currency,
      });
      break;
    }

    case 'customer.subscription.updated': {
      const sub = event.data.object as Stripe.Subscription;
      const { status } = sub;
      if (status !== 'canceled' && status !== 'past_due' && status !== 'unpaid') break;
      const customerId = typeof sub.customer === 'string' ? sub.customer : sub.customer.id;
      const user = await lookupUserByCustomer(customerId);
      if (!user) break;
      await revokePaidTier(user.firebase_uid, user.id, status);
      break;
    }

    case 'customer.subscription.deleted': {
      const sub = event.data.object as Stripe.Subscription;
      const customerId = typeof sub.customer === 'string' ? sub.customer : sub.customer.id;
      const user = await lookupUserByCustomer(customerId);
      if (!user) break;
      await revokePaidTier(user.firebase_uid, user.id, 'canceled');
      break;
    }

    case 'customer.deleted': {
      const customer = event.data.object as Stripe.Customer;
      const user = await lookupUserByCustomer(customer.id);
      if (!user) break;
      await revokePaidTier(user.firebase_uid, user.id, 'canceled');
      await supabase
        .from('users')
        .update({ stripe_customer_id: null })
        .eq('id', user.id);
      break;
    }
  }
}
