import { Resend } from 'resend';
import 'dotenv/config';

let client: Resend | null = null;

// Lazily constructed so the backend still boots without a Resend key —
// only transactional emails fail (rather than the whole server) when it's missing.
export function getResend(): Resend {
  if (client) return client;
  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    throw new Error('Missing RESEND_API_KEY in environment — transactional email is unavailable');
  }
  client = new Resend(apiKey);
  return client;
}
