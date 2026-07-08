import nodemailer, { type Transporter } from 'nodemailer';
import 'dotenv/config';

let transport: Transporter | null = null;

// Lazily constructed so the backend still boots without Gmail credentials —
// only /api/feedback fails (rather than the whole server) when they're missing.
export function getMailer(): Transporter {
  if (transport) return transport;
  const user = process.env.GMAIL_USER;
  const pass = process.env.GMAIL_APP_PASSWORD;
  if (!user || !pass) {
    throw new Error('Missing GMAIL_USER / GMAIL_APP_PASSWORD in environment — feedback email is unavailable');
  }
  transport = nodemailer.createTransport({ service: 'gmail', auth: { user, pass } });
  return transport;
}
