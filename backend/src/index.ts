import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import topicsRouter from './routes/topics.js';
import questionsRouter from './routes/questions.js';
import attemptsRouter from './routes/attempts.js';
import conceptsRouter from './routes/concepts.js';
import starsRouter from './routes/stars.js';
import streaksRouter from './routes/streaks.js';
import chatRouter from './routes/chat.js';

const app = express();
const PORT = process.env.PORT ?? 3001;

app.use(cors());
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

app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

app.listen(PORT, () => {
  console.log(`Math Trainer backend running on http://localhost:${PORT}`);
});
