/**
 * Unwrap a supabase-js result, throwing on failure.
 *
 * supabase-js resolves with `{ data, error }` instead of rejecting, so an unchecked call makes
 * a database error indistinguishable from a legitimately empty result — a `null` row, an empty
 * claim, a write that never landed. Callers that tolerate a missing row should pair this with
 * `.maybeSingle()`, which reports zero rows as `data: null` rather than a `PGRST116` error.
 *
 * Lives apart from `supabase.ts` because that module throws at import time when the service-role
 * env vars are absent; this is a pure function and stays importable from tests.
 */
export function unwrap<T>(result: { data: T; error: { message: string } | null }, context: string): T {
  if (result.error) throw new Error(`${context}: ${result.error.message}`);
  return result.data;
}
