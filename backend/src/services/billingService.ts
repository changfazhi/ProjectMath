import type Stripe from 'stripe';
import { getStripe } from '../db/stripe.js';
import { supabase } from '../db/supabase.js';
import { getAuth } from 'firebase-admin/auth';
import { getFirebaseAdmin } from '../db/firebase.js';

const FRONTEND_URL = process.env.FRONTEND_URL ?? 'http://localhost:5173';

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

  // Block duplicate active subscriptions; allow PayNow repurchase after expiry.
  if (row?.subscription_status === 'active') {
    const isExpiredPayNow =
      row.access_expires_at !== null && new Date(row.access_expires_at) <= new Date();
    if (!isExpiredPayNow) {
      throw new Error('You already have an active subscription. Use the Premium button to manage it.');
    }
  }

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

  // Card subscription
  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: 'subscription',
    line_items: [{ price: priceId, quantity: 1 }],
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
  await getAuth(getFirebaseAdmin()).setCustomUserClaims(firebaseUid, { tier: 'free' });
  await supabase
    .from('users')
    .update({ subscription_status: status, access_expires_at: null })
    .eq('id', userId);
}

async function lookupUserByCustomer(customerId: string): Promise<{ id: string; firebase_uid: string } | null> {
  const { data } = await supabase
    .from('users')
    .select('id, firebase_uid')
    .eq('stripe_customer_id', customerId)
    .single();
  return data as { id: string; firebase_uid: string } | null;
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

      if (session.mode === 'subscription') {
        await grantPaidTier(firebaseUid, userId);
      } else if (session.mode === 'payment') {
        const paynowPlan = session.metadata?.paynow_plan as 'monthly' | 'semesterly' | undefined;
        const msToAdd = paynowPlan === 'semesterly'
          ? 180 * 24 * 60 * 60 * 1000
          : 30 * 24 * 60 * 60 * 1000;
        const expiresAt = new Date(Date.now() + msToAdd);
        await grantPayNowTier(firebaseUid, userId, expiresAt);
      }
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
