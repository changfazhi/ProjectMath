import { randomBytes } from 'node:crypto';
import type { GradeImage, PairSession } from '../types/index.js';

const TTL_MS = Number(process.env.PAIR_TTL_MIN ?? 10) * 60_000;
const MAX_IMAGES_PER_PAIR = Number(process.env.GRADE_MAX_IMAGES ?? 5);

// Ephemeral pairing handshakes, keyed by capability token. In-memory only — a backend
// restart drops in-flight pairings (the user simply re-scans). Fine for a single instance.
const pairs = new Map<string, PairSession>();

// Thrown for client-facing pairing problems → mapped to HTTP 4xx in the route.
export class PairError extends Error {
  constructor(
    message: string,
    public readonly status = 400,
  ) {
    super(message);
    this.name = 'PairError';
  }
}

function isExpired(p: PairSession): boolean {
  return Date.now() > p.expires_at;
}

export function createPair(userId: string, questionId: string): PairSession {
  // 256 bits of entropy, URL-safe — the token is the only credential, so it must be unguessable.
  const token = randomBytes(32).toString('base64url');
  const now = Date.now();
  const pair: PairSession = {
    token,
    userId,
    question_id: questionId,
    images: [],
    created_at: now,
    expires_at: now + TTL_MS,
  };
  pairs.set(token, pair);
  return pair;
}

export function getValidPair(token: string): PairSession | null {
  const p = pairs.get(token);
  if (!p) return null;
  if (isExpired(p)) {
    pairs.delete(token);
    return null;
  }
  return p;
}

export function addImage(token: string, image: GradeImage): number {
  const p = getValidPair(token);
  if (!p) throw new PairError('This phone link has expired. Please scan a fresh QR code.', 404);
  if (p.images.length >= MAX_IMAGES_PER_PAIR) {
    throw new PairError(`You can send at most ${MAX_IMAGES_PER_PAIR} photos per scan.`, 400);
  }
  p.images.push(image);
  return p.images.length;
}

export function closePair(token: string): void {
  pairs.delete(token);
}

// Periodically drop expired pairings so the Map doesn't grow unbounded.
const sweep = setInterval(() => {
  for (const [token, p] of pairs) {
    if (isExpired(p)) pairs.delete(token);
  }
}, 60_000);
sweep.unref?.();
