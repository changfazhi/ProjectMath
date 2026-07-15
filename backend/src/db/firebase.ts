import { initializeApp, cert, getApps, App } from 'firebase-admin/app';

let _app: App | null = null;

export function getFirebaseAdmin(): App {
  if (_app) return _app;
  const { FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY } = process.env;
  if (!FIREBASE_PROJECT_ID || !FIREBASE_CLIENT_EMAIL || !FIREBASE_PRIVATE_KEY) {
    throw new Error('Missing Firebase Admin env vars (FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY)');
  }
  // dotenv strips surrounding quotes from .env values, but `docker --env-file`
  // (and a mis-pasted Secret Manager value) do not — the literal quotes then
  // corrupt the PEM. Strip a matched wrapping pair before unescaping \n.
  const stripQuotes = (v: string) => v.replace(/^"(.*)"$/s, '$1');
  // Reuse existing app if already initialized (e.g. hot-reload)
  _app = getApps()[0] ?? initializeApp({
    credential: cert({
      projectId: stripQuotes(FIREBASE_PROJECT_ID),
      clientEmail: stripQuotes(FIREBASE_CLIENT_EMAIL),
      privateKey: stripQuotes(FIREBASE_PRIVATE_KEY).replace(/\\n/g, '\n'),
    }),
  });
  return _app;
}
