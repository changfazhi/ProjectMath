import type { Response } from 'express';
import { supabase } from '../db/supabase.js';
import { TIER_LIMITS } from '../config/limits.js';
import type { Tier } from '../config/featureTiers.js';
import { nextSgtMidnightUtc, sgtDayStartUtc } from '../lib/sgTime.js';

export type QuotaKind = 'scans' | 'chat' | 'diagnosis' | 'study_plan';

// Thrown when a tier quota or cooldown is exhausted — mapped to HTTP 429 in routes.
export class QuotaExceededError extends Error {
  constructor(
    message: string,
    readonly quota: QuotaKind,
    readonly limit: number,
    readonly resetAt: string, // ISO — when the user may try again
  ) {
    super(message);
    this.name = 'QuotaExceededError';
  }
}

/** Pure limit decision — split out so tests don't need Supabase mocks for the math. */
export function isOverLimit(used: number, limit: number | null): boolean {
  return limit !== null && used >= limit;
}

export async function countScansToday(userId: string): Promise<number> {
  const { count, error } = await supabase
    .from('gradings')
    .select('id', { count: 'exact', head: true })
    .eq('session_id', userId)
    .gte('created_at', sgtDayStartUtc().toISOString());
  if (error) throw new Error(error.message);
  return count ?? 0;
}

export async function countChatMessagesToday(userId: string): Promise<number> {
  const { count, error } = await supabase
    .from('chat_messages')
    .select('id', { count: 'exact', head: true })
    .eq('session_id', userId)
    .eq('role', 'user')
    .gte('created_at', sgtDayStartUtc().toISOString());
  if (error) throw new Error(error.message);
  return count ?? 0;
}

export async function assertScanQuota(userId: string, tier: Tier): Promise<void> {
  const limit = TIER_LIMITS[tier].scansPerDay;
  if (limit === null) return;
  const used = await countScansToday(userId);
  if (isOverLimit(used, limit)) {
    throw new QuotaExceededError(
      `You've used all ${limit} free AI scans for today. They reset at midnight — or upgrade for unlimited scans.`,
      'scans',
      limit,
      nextSgtMidnightUtc().toISOString(),
    );
  }
}

export async function assertChatQuota(userId: string, tier: Tier): Promise<void> {
  const limit = TIER_LIMITS[tier].chatMessagesPerDay;
  if (limit === null) return;
  const used = await countChatMessagesToday(userId);
  if (isOverLimit(used, limit)) {
    throw new QuotaExceededError(
      `You've used all ${limit} free hint messages for today. They reset at midnight — or upgrade for unlimited hints.`,
      'chat',
      limit,
      nextSgtMidnightUtc().toISOString(),
    );
  }
}

export interface UsageSummary {
  tier: Tier;
  resets_at: string; // next SGT midnight, ISO
  scans: { used: number; limit: number | null; remaining: number | null };
  chat: { used: number; limit: number | null; remaining: number | null };
}

export async function getUsageSummary(userId: string, tier: Tier): Promise<UsageSummary> {
  const limits = TIER_LIMITS[tier];
  const [scansUsed, chatUsed] = await Promise.all([
    countScansToday(userId),
    countChatMessagesToday(userId),
  ]);
  return {
    tier,
    resets_at: nextSgtMidnightUtc().toISOString(),
    scans: {
      used: scansUsed,
      limit: limits.scansPerDay,
      remaining: limits.scansPerDay === null ? null : Math.max(0, limits.scansPerDay - scansUsed),
    },
    chat: {
      used: chatUsed,
      limit: limits.chatMessagesPerDay,
      remaining:
        limits.chatMessagesPerDay === null
          ? null
          : Math.max(0, limits.chatMessagesPerDay - chatUsed),
    },
  };
}

/** Consistent 429 body for every quota/cooldown rejection across routes. */
export function sendQuotaError(res: Response, err: QuotaExceededError, tier: Tier): void {
  res.status(429).json({
    error: err.message,
    code: 'QUOTA_EXCEEDED',
    quota: err.quota,
    limit: err.limit,
    reset_at: err.resetAt,
    upgradeable: tier === 'free',
  });
}
