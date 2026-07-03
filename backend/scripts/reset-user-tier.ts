// One-off dev utility: resets a user's tier to free and clears stale Stripe data.
// Usage: npx tsx scripts/reset-user-tier.ts <email>
import 'dotenv/config';
import { supabase } from '../src/db/supabase.js';
import { getAuth } from 'firebase-admin/auth';
import { getFirebaseAdmin } from '../src/db/firebase.js';

const email = process.argv[2];
if (!email) {
  console.error('Usage: npx tsx scripts/reset-user-tier.ts <email>');
  process.exit(1);
}

const { data, error } = await supabase
  .from('users')
  .select('id, firebase_uid')
  .eq('email', email)
  .single();

if (error || !data) {
  console.error('User not found:', error?.message);
  process.exit(1);
}

const row = data as { id: string; firebase_uid: string };

await getAuth(getFirebaseAdmin()).setCustomUserClaims(row.firebase_uid, { tier: 'free' });
await supabase
  .from('users')
  .update({ stripe_customer_id: null, subscription_status: null, access_expires_at: null })
  .eq('id', row.id);

console.log(`Done — reset ${email} to free tier and cleared Stripe customer data.`);
console.log('The user must sign out and back in (or wait ~1 hour) for the token to refresh.');
