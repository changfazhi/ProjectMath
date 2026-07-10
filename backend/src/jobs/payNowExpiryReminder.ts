import { schedule } from 'node-cron';
import { supabase } from '../db/supabase.js';
import { sendPayNowExpiryReminder } from '../services/emailService.js';

const MS_PER_DAY = 24 * 60 * 60 * 1000;

function todaySGT(): string {
  return new Date().toLocaleDateString('en-CA', { timeZone: 'Asia/Singapore' }); // YYYY-MM-DD
}

export function daysUntil(accessExpiresAt: string, from: Date): number {
  const diffMs = new Date(accessExpiresAt).getTime() - from.getTime();
  return Math.max(1, Math.ceil(diffMs / MS_PER_DAY));
}

// Fires once/day for each PayNow account inside the reminder window (default: last 3 days before
// access_expires_at).
//
// Card subscribers are excluded by `stripe_subscription_id IS NULL`, not by the absence of an
// expiry: a subscription bought on top of PayNow keeps that expiry on the row (issue #57) and
// trials until it, so their access does not lapse — the card takes over. Filtering on the expiry
// alone would email them "your access ends in 3 days" on the eve of their first charge.
export async function runPayNowExpiryReminders(): Promise<void> {
  const reminderDays = Number(process.env.PAYNOW_REMINDER_DAYS ?? 3);
  const now = new Date();
  const windowEnd = new Date(now.getTime() + reminderDays * MS_PER_DAY);
  const today = todaySGT();
  const notYetRemindedToday = `last_expiry_reminder_sent_on.is.null,last_expiry_reminder_sent_on.lt.${today}`;

  const { data, error } = await supabase
    .from('users')
    .select('id, email, access_expires_at')
    .eq('subscription_status', 'active')
    .is('stripe_subscription_id', null)
    .not('access_expires_at', 'is', null)
    .gt('access_expires_at', now.toISOString())
    .lte('access_expires_at', windowEnd.toISOString())
    .or(notYetRemindedToday);

  if (error) {
    console.error('PayNow expiry reminder query failed:', error);
    return;
  }

  const rows = (data ?? []) as Array<{ id: string; email: string | null; access_expires_at: string }>;

  for (const row of rows) {
    if (!row.email) continue;

    // Atomically claim today's reminder before sending — a same-day re-run of the cron
    // (or a second server instance) then finds no matching row left to update and skips.
    const { data: claimed } = await supabase
      .from('users')
      .update({ last_expiry_reminder_sent_on: today })
      .eq('id', row.id)
      .or(notYetRemindedToday)
      .select('id');
    if (!claimed || claimed.length === 0) continue;

    await sendPayNowExpiryReminder(row.email, daysUntil(row.access_expires_at, now), new Date(row.access_expires_at));
  }
}

export function startPayNowExpiryReminderCron(): void {
  schedule(
    '0 9 * * *',
    () => {
      runPayNowExpiryReminders().catch((err) => console.error('PayNow expiry reminder cron failed:', err));
    },
    { timezone: 'Asia/Singapore' },
  );
}
