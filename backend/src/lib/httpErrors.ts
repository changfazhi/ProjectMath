import type { Response } from 'express';

/**
 * The single message shown to users for any *unexpected* server error.
 *
 * Internal error detail — Supabase/Postgres messages, stack traces, record ids — must never
 * reach the browser: it confuses users and leaks implementation shape. It is logged server-side
 * instead. See issue #58.
 */
export const GENERIC_ERROR_MESSAGE = 'Something went wrong — please try again.';

/**
 * Log an unexpected error with its route context and respond with a generic 500.
 *
 * Use this only for the *fallback* branch of a route's try/catch — after every typed, genuinely
 * user-facing error (quota, validation, not-found, cooldown, …) has already been matched and
 * returned with its own message. Reaching here means the error was not one we expected, so the
 * client gets `GENERIC_ERROR_MESSAGE` and the real cause goes to the server log under `context`.
 *
 * `context` is a human label for the route, e.g. `'GET /api/topics'`, to make the logs greppable.
 */
export function sendServerError(res: Response, context: string, err: unknown): void {
  console.error(`[${context}] unexpected error:`, err);
  res.status(500).json({ error: GENERIC_ERROR_MESSAGE });
}
