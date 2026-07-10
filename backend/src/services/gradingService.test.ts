import { beforeEach, describe, expect, it, vi } from 'vitest';

// Regression cover for issue #56.
//
// `POST /api/grade/text` used to skip the 60s grade cooldown for *every* typed submission, on the
// theory that it only ever corrects a photo scan. Nothing enforced that: the route takes arbitrary
// LaTeX and has never referenced a prior grading, so it was a standalone uncooled AI grader. The
// daily scan quota did apply (a typed grade writes a `gradings` row, which is what it counts), so
// free users were capped at 3/day — but a paid user's quota is unlimited.
//
// Separately, refunding the cooldown on a `GradingError` let junk photos run an unmetered Gemini
// vision call every few seconds: a rejected submission writes no row, so it costs no quota either.

const HOUR_MS = 60 * 60 * 1000;

interface LatestGrading {
  image_paths: string[];
  created_at: string;
}

const state = {
  scansToday: 0,
  latestGrading: null as LatestGrading | null,
  aiThrows: null as Error | null,
  gradable: true,
  insertedTables: [] as string[],
};

// Only the query shapes gradingService uses: a head-count, a newest-first lookup, and two inserts.
class Query {
  private counting = false;
  private limited = false;
  private singled = false;
  private inserting = false;

  constructor(private readonly table: string) {}

  select(_cols?: unknown, opts?: { head?: boolean }) {
    if (opts?.head) this.counting = true;
    return this;
  }
  insert(_rows: unknown) {
    this.inserting = true;
    state.insertedTables.push(this.table);
    return this;
  }
  eq() { return this; }
  gte() { return this; }
  order() { return this; }
  limit() { this.limited = true; return this; }
  single() { this.singled = true; return this; }

  private exec(): unknown {
    if (this.inserting) {
      return this.singled
        ? { data: { id: 'g1', created_at: new Date().toISOString() }, error: null }
        : { error: null };
    }
    if (this.counting) return { count: state.scansToday, error: null };
    if (this.limited) return { data: state.latestGrading ? [state.latestGrading] : [], error: null };
    return { data: [], error: null };
  }

  then<R>(resolve: (v: unknown) => R): R {
    return resolve(this.exec());
  }
}

vi.mock('../db/supabase.js', () => ({
  supabase: {
    from: (table: string) => new Query(table),
    storage: { from: () => ({ upload: async () => ({ error: null }) }) },
  },
}));

vi.mock('../db/gemini.js', () => ({ GEMINI_MODEL: 'test-model' }));

vi.mock('./questionService.js', () => ({
  getQuestionWithSolution: async () => ({
    id: 'q1', marks: 5, prompt_latex: 'p', correct_answer: '1', solution_latex: 's', parts: null,
  }),
}));

vi.mock('./geminiGateway.js', () => ({
  aiGenerate: vi.fn(async () => {
    if (state.aiThrows) throw state.aiThrows;
    return {
      text: JSON.stringify({
        gradable: state.gradable,
        rejection_reason: state.gradable ? '' : 'The photo appears to be blank',
        ignored_images: [],
        parts: state.gradable
          ? [{ label: 'whole', verdict: 'correct', marks_awarded: 5, marks_total: 5, errors: [], hints: [], summary: '' }]
          : [],
        overall_feedback: 'ok',
        transcription_latex: 'x',
      }),
    };
  }),
}));

const { acquireGradeSlot, refundGradeSlot, stampGradeSlot } = vi.hoisted(() => ({
  acquireGradeSlot: vi.fn(async () => {}),
  refundGradeSlot: vi.fn(),
  stampGradeSlot: vi.fn(),
}));
vi.mock('./cooldownService.js', () => ({ acquireGradeSlot, refundGradeSlot, stampGradeSlot }));

const { gradeSolution, gradeTranscription, GradingError } = await import('./gradingService.js');
const { QuotaExceededError } = await import('./usageService.js');

const base = { userId: 'u1', tier: 'free' as const, question_id: 'q1' };
const typed = () => gradeTranscription({ ...base, transcription_latex: 'x^2' });
const photo = () => gradeSolution({ ...base, images: [{ mimeType: 'image/png', buffer: Buffer.from('x') }] });

function seedLatestGrading(kind: 'photo' | 'typed', ageMs: number): void {
  state.latestGrading = {
    image_paths: kind === 'photo' ? ['u1/q1/a.png'] : [],
    created_at: new Date(Date.now() - ageMs).toISOString(),
  };
}

beforeEach(() => {
  state.scansToday = 0;
  state.latestGrading = null;
  state.aiThrows = null;
  state.gradable = true;
  state.insertedTables = [];
  acquireGradeSlot.mockClear();
  refundGradeSlot.mockClear();
  stampGradeSlot.mockClear();
});

describe('grade cooldown — typed re-grades', () => {
  it('exempts a correction of a photo scan the user just made', async () => {
    seedLatestGrading('photo', 30_000);

    await typed();

    expect(acquireGradeSlot).not.toHaveBeenCalled();
  });

  // The exemption is spent by the attempt, not by a successful grade. A rejected correction writes
  // no `gradings` row, so it costs no quota; with no cooldown behind it either, junk LaTeX could be
  // resubmitted at the rate limiter's pace for the whole grace window (~50 free Gemini calls).
  it('stamps a fresh cooldown window behind an exempt correction', async () => {
    seedLatestGrading('photo', 30_000);

    await typed();

    expect(stampGradeSlot).toHaveBeenCalledWith('u1');
  });

  it('stamps the window even when the exempt correction is rejected', async () => {
    seedLatestGrading('photo', 30_000);
    state.gradable = false;

    await expect(typed()).rejects.toBeInstanceOf(GradingError);

    expect(stampGradeSlot).toHaveBeenCalledWith('u1');
    expect(refundGradeSlot).not.toHaveBeenCalled();
  });

  // The bug: this used to be exempt too, so a paid user could grade at the rate limiter's pace.
  it('cools a typed grade with no prior scan on this question', async () => {
    await typed();

    expect(acquireGradeSlot).toHaveBeenCalledWith('u1');
  });

  it('cools a second consecutive re-grade — the free correction is already spent', async () => {
    seedLatestGrading('typed', 30_000);

    await typed();

    expect(acquireGradeSlot).toHaveBeenCalledWith('u1');
  });

  it('cools a correction of a photo scan that has gone stale', async () => {
    seedLatestGrading('photo', HOUR_MS);

    await typed();

    expect(acquireGradeSlot).toHaveBeenCalledWith('u1');
  });

  it('always cools a photo grade, even right after another one', async () => {
    seedLatestGrading('photo', 30_000);

    await photo();

    expect(acquireGradeSlot).toHaveBeenCalledWith('u1');
  });
});

describe('grade cooldown — refunds', () => {
  it('keeps the cooldown when the model rejects the submission', async () => {
    // The rejection cost a full Gemini vision call and writes no `gradings` row, so it costs no
    // quota either. Refunding here made junk photos an unmetered vision call every few seconds.
    state.gradable = false;

    await expect(photo()).rejects.toBeInstanceOf(GradingError);

    expect(refundGradeSlot).not.toHaveBeenCalled();
    expect(state.insertedTables).toEqual([]);
  });

  it('refunds the cooldown when the AI gateway itself fails', async () => {
    state.aiThrows = new Error('gateway unavailable');

    await expect(photo()).rejects.toThrow('gateway unavailable');

    expect(refundGradeSlot).toHaveBeenCalledWith('u1');
  });

  it('refunds an exempt correction when the gateway fails, so our outage is free', async () => {
    seedLatestGrading('photo', 30_000); // typed correction → exempt, stamps its own window
    state.aiThrows = new Error('gateway unavailable');

    await expect(typed()).rejects.toThrow('gateway unavailable');

    expect(refundGradeSlot).toHaveBeenCalledWith('u1');
  });
});

describe('daily scan quota', () => {
  // Contrary to issue #56, the quota always covered typed re-grades. Pinned so a future change to
  // the cooldown rule above can't quietly drop it.
  it('blocks a typed re-grade once the free tier is exhausted', async () => {
    state.scansToday = 3;
    seedLatestGrading('photo', 30_000);

    await expect(typed()).rejects.toBeInstanceOf(QuotaExceededError);
  });

  it('counts a typed re-grade, because it writes a gradings row', async () => {
    seedLatestGrading('photo', 30_000);

    await typed();

    expect(state.insertedTables).toContain('gradings');
  });
});
