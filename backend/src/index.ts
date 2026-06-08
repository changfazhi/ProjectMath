import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import topicsRouter from './routes/topics.js';
import questionsRouter from './routes/questions.js';
import attemptsRouter from './routes/attempts.js';

const app = express();
const PORT = process.env.PORT ?? 3001;

app.use(cors());
app.use(express.json());

app.use('/api/topics', topicsRouter);

// /api/topics/:topicId/questions/next lives under topics for REST clarity
app.use('/api/topics', questionsRouter);

// /api/questions/:id for direct question lookup
app.use('/api/questions', questionsRouter);

app.use('/api/attempts', attemptsRouter);

app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

app.listen(PORT, () => {
  console.log(`Math Trainer backend running on http://localhost:${PORT}`);
});
