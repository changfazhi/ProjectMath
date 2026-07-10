// One-off repair for issue #53: finds accounts left holding a `tier: 'paid'` Firebase claim
// after their access ended, and optionally resets them to free.
//
// The bad state is invisible from Postgres alone — a correctly-downgraded user and a stuck one
// both end up with subscription_status='expired' and access_expires_at=NULL. They differ only in
// the Firebase custom claim, so the claims are the only place to look.
//
// Usage: npx tsx scripts/audit-stale-paid-claims.ts          # report only
//        npx tsx scripts/audit-stale-paid-claims.ts --fix    # also reset the claims to free
import 'dotenv/config';
import { getAuth } from 'firebase-admin/auth';
import { supabase } from '../src/db/supabase.js';
import { unwrap } from '../src/db/unwrap.js';
import { getFirebaseAdmin } from '../src/db/firebase.js';

const fix = process.argv.includes('--fix');
const auth = getAuth(getFirebaseAdmin());

interface Row {
  id: string;
  firebase_uid: string;
  email: string | null;
  subscription_status: string | null;
  access_expires_at: string | null;
}

// Collect every Firebase uid whose custom claim currently says paid.
const paidUids = new Set<string>();
let pageToken: string | undefined;
do {
  const page = await auth.listUsers(1000, pageToken);
  for (const user of page.users) {
    if (user.customClaims?.['tier'] === 'paid') paidUids.add(user.uid);
  }
  pageToken = page.pageToken;
} while (pageToken);

console.log(`Firebase users holding a paid claim: ${paidUids.size}`);
if (paidUids.size === 0) process.exit(0);

const rows = unwrap(
  await supabase
    .from('users')
    .select('id, firebase_uid, email, subscription_status, access_expires_at')
    .in('firebase_uid', [...paidUids]),
  'Failed to load users',
) as Row[];

const byUid = new Map(rows.map((row) => [row.firebase_uid, row]));

// A paid claim is legitimate only while the row still says active *and* any stored PayNow expiry
// is in the future. Anything else is a claim that outlived the access it was granted for.
const stale = [...paidUids].map((uid) => {
  const row = byUid.get(uid);
  if (!row) return { uid, row: null, reason: 'no matching users row' };
  if (row.subscription_status !== 'active') {
    return { uid, row, reason: `subscription_status=${row.subscription_status ?? 'null'}` };
  }
  if (row.access_expires_at && new Date(row.access_expires_at) <= new Date()) {
    return { uid, row, reason: `access expired ${row.access_expires_at}` };
  }
  return null;
}).filter((entry): entry is { uid: string; row: Row | null; reason: string } => entry !== null);

if (stale.length === 0) {
  console.log('No stale paid claims found.');
  process.exit(0);
}

console.log(`\nStale paid claims: ${stale.length}\n`);
for (const { uid, row, reason } of stale) {
  console.log(`  ${uid}  ${row?.email ?? '(unknown email)'}  — ${reason}`);
}

if (!fix) {
  console.log('\nReport only. Re-run with --fix to reset these claims to free.');
  process.exit(0);
}

console.log('\nResetting claims to free...');
for (const { uid, row } of stale) {
  await auth.setCustomUserClaims(uid, { tier: 'free' });
  // access_expires_at is intentionally left as-is: requireAuth uses a past timestamp to keep
  // deriving `free`, and clearing it is what caused this bug in the first place.
  if (row && row.subscription_status !== 'expired') {
    const { error } = await supabase
      .from('users')
      .update({ subscription_status: 'expired' })
      .eq('id', row.id);
    if (error) throw new Error(`Failed to update user ${row.id}: ${error.message}`);
  }
  console.log(`  reset ${uid}`);
}

console.log(`\nDone — reset ${stale.length} claim(s).`);
console.log('Affected users must sign out and back in (or wait ~1 hour) for their token to refresh.');
