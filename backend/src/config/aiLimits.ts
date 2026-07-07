import 'dotenv/config';

// Limits describing the upstream Gemini key and how we pace calls against it.
// Everything is env-overridable so a future model/tier switch is a .env change,
// not a code change. Defaults match the gemini-2.5-flash free tier (10 RPM / 250 RPD).
function envNum(name: string, fallback: number): number {
  const raw = process.env[name];
  const n = raw === undefined ? NaN : Number(raw);
  return Number.isFinite(n) && n > 0 ? n : fallback;
}

export type AiCallKind = 'chat' | 'grade' | 'diagnosis';

export const AI_LIMITS = {
  /** The key's real requests-per-minute limit (informational; outboundRpm is what we enforce). */
  rpm: envNum('AI_RPM_LIMIT', 10),
  /** The key's requests-per-day limit — once spent locally we fail fast until midnight PT. */
  rpd: envNum('AI_RPD_LIMIT', 250),
  /** What we actually release per minute — under the real RPM so bursts never hit Google's 429. */
  outboundRpm: envNum('AI_OUTBOUND_RPM', 8),
  /** Per-user pacing between accepted AI requests. */
  chatCooldownS: envNum('AI_CHAT_COOLDOWN_S', 5),
  gradeCooldownS: envNum('AI_GRADE_COOLDOWN_S', 60),
  /** How long a request may sit in the gateway queue before failing with AI_BUSY. */
  queueMaxWaitMs: {
    chat: envNum('AI_CHAT_QUEUE_MAX_WAIT_S', 30) * 1000,
    grade: envNum('AI_GRADE_QUEUE_MAX_WAIT_S', 120) * 1000,
    diagnosis: envNum('AI_GRADE_QUEUE_MAX_WAIT_S', 120) * 1000,
  } satisfies Record<AiCallKind, number>,
  /** Hard cap on queued requests — beyond this, fail immediately with AI_BUSY. */
  queueMaxLength: envNum('AI_QUEUE_MAX_LENGTH', 50),
};
