import { Router, type Request, type Response } from 'express';
import express from 'express';
import { z } from 'zod';
import { requireAuth } from '../middleware/auth.js';
import {
  createCheckoutSession,
  createPortalSession,
  getBillingStatus,
  handleWebhookEvent,
  WebhookSignatureError,
} from '../services/billingService.js';

const router = Router();

const checkoutSchema = z.object({
  plan: z.enum(['monthly', 'semesterly']),
  method: z.enum(['card', 'paynow']).default('card'),
});

// POST /api/billing/checkout
// Must be mounted before express.json() — applies its own JSON parser per-route.
router.post(
  '/checkout',
  express.json(),
  requireAuth as express.RequestHandler,
  async (req: Request, res: Response): Promise<void> => {
    const parsed = checkoutSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: 'plan must be "monthly" or "semesterly"; method must be "card" or "paynow"' });
      return;
    }

    const { plan, method } = parsed.data;

    const priceId = method === 'paynow'
      ? (plan === 'monthly' ? process.env.STRIPE_PRICE_MONTHLY_PAYNOW : process.env.STRIPE_PRICE_SEMESTERLY_PAYNOW)
      : (plan === 'monthly' ? process.env.STRIPE_PRICE_MONTHLY : process.env.STRIPE_PRICE_SEMESTERLY);

    if (!priceId) {
      res.status(500).json({ error: 'Stripe price not configured' });
      return;
    }

    try {
      const result = await createCheckoutSession(
        req.user!.uid,
        req.user!.firebaseUid,
        req.user!.email ?? '',
        priceId,
        method,
        plan,
      );
      res.json(result);
    } catch (err) {
      console.error('Checkout session error:', err);
      const message = err instanceof Error ? err.message : 'Failed to create checkout session';
      res.status(500).json({ error: message });
    }
  },
);

// POST /api/billing/portal
router.post(
  '/portal',
  express.json(),
  requireAuth as express.RequestHandler,
  async (req: Request, res: Response): Promise<void> => {
    try {
      const result = await createPortalSession(req.user!.uid);
      res.json(result);
    } catch (err) {
      console.error('Portal session error:', err);
      res.status(500).json({ error: 'Failed to create portal session' });
    }
  },
);

// GET /api/billing/status
router.get(
  '/status',
  requireAuth as express.RequestHandler,
  async (req: Request, res: Response): Promise<void> => {
    try {
      const result = await getBillingStatus(req.user!.uid);
      res.json(result);
    } catch (err) {
      console.error('Billing status error:', err);
      res.status(500).json({ error: 'Failed to load billing status' });
    }
  },
);

// POST /api/billing/webhook
// Raw body required for Stripe signature verification — do NOT apply express.json() here.
router.post(
  '/webhook',
  express.raw({ type: 'application/json' }),
  async (req: Request, res: Response): Promise<void> => {
    const signature = req.headers['stripe-signature'];
    if (!signature || typeof signature !== 'string') {
      res.status(400).json({ error: 'Missing stripe-signature header' });
      return;
    }
    try {
      await handleWebhookEvent(req.body as Buffer, signature);
      res.json({ received: true });
    } catch (err) {
      console.error('Webhook error:', err);
      // A bad signature means the payload isn't from Stripe — nothing to retry. Everything
      // else is a 500 so Stripe redelivers and the claim in handleWebhookEvent re-runs the work.
      if (err instanceof WebhookSignatureError) {
        res.status(400).json({ error: 'Invalid signature' });
        return;
      }
      res.status(500).json({ error: 'Webhook processing failed' });
    }
  },
);

export default router;
