import { GoogleGenAI } from '@google/genai';
import 'dotenv/config';

export const GEMINI_MODEL = process.env.GEMINI_MODEL ?? 'gemini-2.5-flash';

let client: GoogleGenAI | null = null;

// Lazily constructed so the backend still boots without a Gemini key —
// only the /api/chat endpoint fails (rather than the whole server) when it's missing.
export function getGemini(): GoogleGenAI {
  if (client) return client;
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error('Missing GEMINI_API_KEY in environment — AI hints are unavailable');
  }
  client = new GoogleGenAI({ apiKey });
  return client;
}
