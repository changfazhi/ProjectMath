import { beforeEach, describe, expect, it } from 'vitest';
import type { Request } from 'express';
import { accountKey } from './rateLimit.js';
import { closePair, createPair } from '../services/pairService.js';

// Regression cover for issue #55. express-rate-limit's default key is `req.ip`, so two users
// behind one NAT — or, on Cloud Run with `trust proxy` unset, every user everywhere — shared a
// single bucket and could starve each other of AI scans. The key must be the account.

const SHARED_IP = '203.0.113.7';

function req(overrides: Partial<Request>): Request {
  return { ip: SHARED_IP, params: {}, ...overrides } as Request;
}

function authed(uid: string, ip = SHARED_IP): Request {
  return req({ ip, user: { uid, firebaseUid: `fb-${uid}`, email: null, tier: 'free' } });
}

describe('accountKey', () => {
  it('gives two signed-in users on one IP separate buckets', () => {
    // The bug: before this, both resolved to the same `req.ip` and one could lock the other out.
    expect(accountKey(authed('u1'))).not.toBe(accountKey(authed('u2')));
  });

  it('gives one user the same bucket across two IPs', () => {
    expect(accountKey(authed('u1', '198.51.100.1'))).toBe(accountKey(authed('u1', '203.0.113.9')));
  });

  it('keys on the account, not the IP', () => {
    expect(accountKey(authed('u1'))).toBe('user:u1');
  });

  it('prefers the account over a pair token when both are present', () => {
    const pair = createPair('owner', '11111111-1111-1111-1111-111111111111', 'free');
    try {
      expect(accountKey(req({ user: authed('u1').user, params: { token: pair.token } }))).toBe('user:u1');
    } finally {
      closePair(pair.token);
    }
  });
});

describe('accountKey — token-authed phone routes', () => {
  const QUESTION = '11111111-1111-1111-1111-111111111111';
  let token: string;

  beforeEach(() => {
    token = createPair('owner-1', QUESTION, 'free').token;
  });

  it('bills a phone request to the account that created the pairing', () => {
    // The phone is on cellular — a different IP from the desktop that opened the pairing.
    expect(accountKey(req({ ip: '198.51.100.44', params: { token } }))).toBe('user:owner-1');
  });

  it('puts two pairings owned by the same user in one bucket', () => {
    const second = createPair('owner-1', QUESTION, 'free').token;
    try {
      expect(accountKey(req({ params: { token } }))).toBe(accountKey(req({ params: { token: second } })));
    } finally {
      closePair(second);
    }
  });

  it('falls back to the IP for an unknown token', () => {
    expect(accountKey(req({ params: { token: 'not-a-real-token' } }))).toBe(`ip:${SHARED_IP}`);
  });

  it('falls back to the IP once the pairing is closed', () => {
    closePair(token);
    expect(accountKey(req({ params: { token } }))).toBe(`ip:${SHARED_IP}`);
  });
});

describe('accountKey — anonymous fallback', () => {
  it('keys an IPv4 caller on the bare address', () => {
    expect(accountKey(req({}))).toBe(`ip:${SHARED_IP}`);
  });

  it('masks an IPv6 caller to a subnet so it cannot rotate for a fresh bucket', () => {
    const a = accountKey(req({ ip: '2001:db8:1234:5678:1:2:3:4' }));
    const b = accountKey(req({ ip: '2001:db8:1234:5678:9:a:b:c' }));

    expect(a).toBe(b);
    expect(a).not.toContain(':1:2:3:4');
  });

  it('tolerates a missing req.ip rather than throwing', () => {
    expect(() => accountKey(req({ ip: undefined }))).not.toThrow();
  });
});
