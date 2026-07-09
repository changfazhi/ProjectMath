import 'dotenv/config';
import http from 'node:http';
import path from 'node:path';
import express from 'express';
import cors from 'cors';
import topicsRouter from './routes/topics.js';
import questionsRouter from './routes/questions.js';
import attemptsRouter from './routes/attempts.js';
import conceptsRouter from './routes/concepts.js';
import starsRouter from './routes/stars.js';
import streaksRouter from './routes/streaks.js';
import chatRouter from './routes/chat.js';
import gradeRouter from './routes/grade.js';
import pairRouter from './routes/pair.js';
import reviewRouter from './routes/review.js';
import usageRouter from './routes/usage.js';
import billingRouter from './routes/billing.js';
import feedbackRouter from './routes/feedback.js';
import { initRealtime } from './realtime.js';
import { startPayNowExpiryReminderCron } from './jobs/payNowExpiryReminder.js';

const app = express();
const PORT = process.env.PORT ?? 3001;

app.use(cors({
  origin: process.env.NODE_ENV === 'production'
    ? (process.env.CORS_ORIGIN ?? 'https://yourproductiondomain.com')
    : 'http://localhost:5173',
}));

// Billing router mounts BEFORE express.json() so the webhook route can receive raw body
// for Stripe signature verification. Non-webhook billing routes apply express.json() themselves.
app.use('/api/billing', billingRouter);

app.use(express.json());

app.use('/api/topics', topicsRouter);

// /api/topics/:topicId/questions, /api/topics/:topicId/next — topic-scoped question routes
app.use('/api/topics', questionsRouter);

// /api/topics/:topicId/concepts
app.use('/api/topics', conceptsRouter);

// /api/questions/:id — direct question lookup
app.use('/api/questions', questionsRouter);

app.use('/api/attempts', attemptsRouter);
app.use('/api/stars', starsRouter);
app.use('/api/streaks', streaksRouter);
app.use('/api/chat', chatRouter);
app.use('/api/grade', gradeRouter);
app.use('/api/pair', pairRouter);
app.use('/api/review', reviewRouter);
app.use('/api/usage', usageRouter);
app.use('/api/feedback', feedbackRouter);

app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

// In production the container serves the built frontend from ../public (see Dockerfile),
// keeping everything same-origin: relative /api fetches, the Socket.IO connection, and
// the QR code built from window.location.origin all work unchanged.
if (process.env.NODE_ENV === 'production') {
  const frontendDist = process.env.FRONTEND_DIST ?? path.resolve(__dirname, '../public');
  app.use(express.static(frontendDist));
  // SPA fallback so client-side routes (/practice/..., /m/:token) survive a hard refresh.
  app.get('*', (req, res, next) => {
    if (req.path.startsWith('/api') || req.path.startsWith('/socket.io') || req.path === '/health') {
      next();
      return;
    }
    res.sendFile(path.join(frontendDist, 'index.html'));
  });
}

// http.Server (not app.listen) so Socket.IO can attach for live phone-upload pairing.
const httpServer = http.createServer(app);
initRealtime(httpServer);
startPayNowExpiryReminderCron();

httpServer.listen(PORT, () => {
  console.log(`Math Trainer backend running on http://localhost:${PORT}`);
});
