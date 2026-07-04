import { useEffect, useRef, type MouseEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

// Marketing landing page, ported faithfully from the Claude Design artifact
// "ProjectMath Landing.dc.html". The design is bespoke, fully inline-styled
// marketing HTML (unrelated to the app's component system), so it's rendered
// verbatim. The two dynamic bits from the .dc logic are reproduced without JS:
//   - accent theme  -> the default "Indigo" palette is set as CSS vars on the root
//   - pricing toggle -> a CSS-only radio switch (Monthly / Yearly)
// `style-hover="..."` attributes become the `.pm-hov-*` hover classes below.

const STYLES = `
.pm-landing *{margin:0;box-sizing:border-box}
.pm-landing{font-family:'Plus Jakarta Sans',sans-serif;-webkit-font-smoothing:antialiased;color:#11142b;scroll-behavior:smooth}
.pm-landing a{color:inherit;text-decoration:none}
.pm-landing ::selection{background:rgba(99,102,241,.18)}
@keyframes pm-floaty{0%,100%{transform:translateY(0)}50%{transform:translateY(-12px)}}
@keyframes pm-floaty2{0%,100%{transform:translateY(0)}50%{transform:translateY(9px)}}
.pm-landing .pm-hov-accent{transition:color .15s}
.pm-landing .pm-hov-accent:hover{color:var(--accent)}
.pm-landing .pm-hov-white{transition:color .15s}
.pm-landing .pm-hov-white:hover{color:#fff}
.pm-landing .pm-hov-navcta:hover{transform:translateY(-2px);box-shadow:0 14px 26px -8px var(--accent)}
.pm-landing .pm-hov-cta:hover{transform:translateY(-2px);box-shadow:0 18px 34px -10px var(--accent)}
.pm-landing .pm-hov-ghost:hover{transform:translateY(-2px);border-color:var(--accent)}
.pm-landing .pm-hov-lift:hover{transform:translateY(-2px)}
.pm-landing .pm-hov-border:hover{border-color:var(--accent)}
.pm-landing .pm-period-radio{position:absolute;width:0;height:0;opacity:0;pointer-events:none}
.pm-landing .pm-tab{flex:1;text-align:center;padding:9px 12px;border-radius:9px;font-weight:700;font-size:13.5px;cursor:pointer;border:none;background:transparent;color:#6b7194;font-family:inherit;transition:all .15s}
.pm-landing #pm-monthly:checked ~ .pm-toggle-wrap .pm-tab-monthly,
.pm-landing #pm-annual:checked ~ .pm-toggle-wrap .pm-tab-annual{background:#fff;color:var(--accent-ink);box-shadow:0 2px 7px rgba(17,20,43,.1)}
.pm-landing .pm-price-monthly,.pm-landing .pm-sub-monthly{display:none}
.pm-landing #pm-monthly:checked ~ .pm-pricing-grid .pm-price-annual,
.pm-landing #pm-monthly:checked ~ .pm-pricing-grid .pm-sub-annual{display:none}
.pm-landing #pm-monthly:checked ~ .pm-pricing-grid .pm-price-monthly,
.pm-landing #pm-monthly:checked ~ .pm-pricing-grid .pm-sub-monthly{display:inline}
`

const MARKUP = `
<div data-screen-label="Landing" style="--accent:#4f46e5;--accent-2:#7c3aed;--accent-soft:#eef0fe;--accent-ink:#3730a3;font-family:'Plus Jakarta Sans',sans-serif;color:#11142b;background:#ffffff;overflow-x:hidden">

  <!-- NAV -->
  <header style="position:sticky;top:0;z-index:50;backdrop-filter:saturate(180%) blur(14px);background:rgba(255,255,255,.82);border-bottom:1px solid #eceef6">
    <nav style="max-width:1180px;margin:0 auto;padding:14px 24px;display:flex;align-items:center;gap:32px">
      <a href="#top" style="display:flex;align-items:center;gap:11px">
        <div style="width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,var(--accent),var(--accent-2));display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:20px;font-family:'Bricolage Grotesque',sans-serif">&#960;</div>
        <span style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:21px;letter-spacing:-.01em">Project<span style="color:var(--accent)">Math</span></span>
      </a>
      <div style="display:flex;align-items:center;gap:28px;margin-left:14px;font-weight:600;font-size:15px;color:#3d4264">
        <a href="#roadmap" class="pm-hov-accent">Roadmap</a>
        <a href="#features" class="pm-hov-accent">AI Tools</a>
        <a href="#pricing" class="pm-hov-accent">Pricing</a>
      </div>
      <div style="margin-left:auto;display:flex;align-items:center;gap:18px">
        __AUTH_LINK__
        <a href="/roadmap" class="pm-hov-navcta" style="display:inline-flex;align-items:center;gap:7px;padding:10px 20px;border-radius:11px;background:var(--accent);color:#fff;font-weight:700;font-size:15px;box-shadow:0 8px 18px -6px var(--accent);transition:transform .15s,box-shadow .15s">Start free</a>
      </div>
    </nav>
  </header>

  <!-- HERO -->
  <section id="top" style="position:relative;background:#f6f7fc;overflow:hidden">
    <div style="position:absolute;inset:0;background:radial-gradient(620px 360px at 78% 8%,rgba(124,58,237,.12),transparent 70%),radial-gradient(560px 420px at 12% 90%,rgba(79,70,229,.10),transparent 70%);pointer-events:none"></div>
    <div style="position:relative;max-width:1180px;margin:0 auto;padding:72px 24px 90px;display:grid;grid-template-columns:1.05fr .95fr;gap:56px;align-items:center">
      <!-- left -->
      <div>
        <div style="display:inline-flex;align-items:center;gap:9px;padding:7px 14px;border-radius:999px;background:#fff;border:1px solid #e6e8f4;box-shadow:0 4px 14px -8px rgba(17,20,43,.25);font-weight:600;font-size:13.5px;color:#46496b">
          <span style="width:8px;height:8px;border-radius:50%;background:#10b981"></span>
          Built for the Singapore A-Level H2 Mathematics (9758)
        </div>
        <h1 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:60px;line-height:1.04;letter-spacing:-.025em;margin:22px 0 0">Master H2 Math,<br>one node at a time.</h1>
        <p style="font-size:19px;line-height:1.55;color:#52567a;max-width:520px;margin:22px 0 0">A guided roadmap that takes you from graphing technique to conics &mdash; with an AI tutor that nudges you to the next step and an AI scanner that marks your working <em>and</em> your presentation.</p>
        <div style="display:flex;flex-wrap:wrap;gap:14px;margin-top:32px">
          <a href="/roadmap" class="pm-hov-cta" style="display:inline-flex;align-items:center;gap:9px;padding:15px 28px;border-radius:13px;background:var(--accent);color:#fff;font-weight:700;font-size:17px;box-shadow:0 12px 26px -8px var(--accent);transition:transform .15s,box-shadow .15s">Explore the roadmap &rarr;</a>
          <a href="#features" class="pm-hov-ghost" style="display:inline-flex;align-items:center;gap:9px;padding:15px 26px;border-radius:13px;background:#fff;border:1px solid #e1e4f0;color:#1f2342;font-weight:700;font-size:17px;transition:transform .15s,border-color .15s">See the AI tools</a>
        </div>
        <div style="margin-top:34px">
          <div style="font-size:13px;color:#8a90ab;font-weight:600;letter-spacing:.04em;text-transform:uppercase">Sourced from real 2025 JC Prelim &amp; A-Level papers</div>
          <div style="display:flex;flex-wrap:wrap;gap:8px;margin-top:12px">
            <span style="padding:6px 12px;border-radius:999px;background:#fff;border:1px solid #e6e8f4;font-weight:700;font-size:13px;color:#46496b">ASRJC</span>
            <span style="padding:6px 12px;border-radius:999px;background:#fff;border:1px solid #e6e8f4;font-weight:700;font-size:13px;color:#46496b">DHS</span>
            <span style="padding:6px 12px;border-radius:999px;background:#fff;border:1px solid #e6e8f4;font-weight:700;font-size:13px;color:#46496b">HCI</span>
            <span style="padding:6px 12px;border-radius:999px;background:#fff;border:1px solid #e6e8f4;font-weight:700;font-size:13px;color:#46496b">ACJC</span>
            <span style="padding:6px 12px;border-radius:999px;background:#fff;border:1px solid #e6e8f4;font-weight:700;font-size:13px;color:#46496b">CJC</span>
          </div>
        </div>
      </div>
      <!-- right visual -->
      <div style="position:relative;height:480px">
        <!-- main practice card -->
        <div style="position:absolute;top:26px;left:28px;right:8px;background:#fff;border-radius:22px;border:1px solid #ebedf6;box-shadow:0 30px 60px -24px rgba(28,32,68,.4);padding:24px;animation:pm-floaty 6s ease-in-out infinite">
          <div style="display:flex;align-items:center;justify-content:space-between">
            <div style="display:inline-flex;align-items:center;gap:8px;padding:5px 11px;border-radius:8px;background:var(--accent-soft);color:var(--accent-ink);font-weight:700;font-size:12.5px">Functions &middot; Q3</div>
            <div style="font-size:12.5px;color:#9aa0bf;font-weight:600">02:14</div>
          </div>
          <p style="margin:18px 0 0;font-size:17px;font-weight:600;line-height:1.5;color:#1c2042">Find the range of the function<br><span style="font-family:'Bricolage Grotesque',sans-serif;font-size:20px">f(x) = x&sup2; &minus; 4x + 7, &nbsp;x &isin; &#8477;.</span></p>
          <div style="margin-top:16px;height:118px;border-radius:14px;background:linear-gradient(#f4f5fb,#f4f5fb) padding-box,repeating-linear-gradient(45deg,#eceef7 0 9px,#f6f7fc 9px 18px);border:1px dashed #daddeb;display:flex;align-items:center;justify-content:center;color:#a7adc8;font-family:ui-monospace,monospace;font-size:12px">your sketch / working area</div>
          <div style="display:flex;gap:10px;margin-top:16px">
            <button style="flex:1;padding:12px;border-radius:11px;border:none;background:var(--accent);color:#fff;font-weight:700;font-size:14.5px;font-family:inherit;cursor:pointer">Check my working</button>
            <button style="padding:12px 16px;border-radius:11px;border:1px solid #e3e6f1;background:#fff;color:#52567a;font-weight:700;font-size:14.5px;font-family:inherit;cursor:pointer">Hint</button>
          </div>
        </div>
        <!-- AI tutor bubble -->
        <div style="position:absolute;bottom:6px;left:0;width:268px;background:#fff;border-radius:18px;border:1px solid #ebedf6;box-shadow:0 22px 44px -18px rgba(28,32,68,.35);padding:14px 16px;animation:pm-floaty2 5s ease-in-out infinite">
          <div style="display:flex;align-items:center;gap:8px;margin-bottom:9px">
            <div style="width:26px;height:26px;border-radius:8px;background:linear-gradient(135deg,var(--accent),var(--accent-2));display:flex;align-items:center;justify-content:center;color:#fff;font-size:13px">&#10022;</div>
            <span style="font-weight:700;font-size:13px">AI Tutor</span>
            <span style="margin-left:auto;width:7px;height:7px;border-radius:50%;background:#10b981"></span>
          </div>
          <p style="font-size:13.5px;line-height:1.5;color:#3d4264;margin:0">Try completing the square first &mdash; what do you get for <b>f(x)</b>?</p>
        </div>
        <!-- scan badge -->
        <div style="position:absolute;top:0;right:0;display:inline-flex;align-items:center;gap:9px;background:#11142b;color:#fff;border-radius:14px;padding:11px 15px;box-shadow:0 18px 36px -14px rgba(17,20,43,.6);animation:pm-floaty 7s ease-in-out infinite">
          <div style="width:26px;height:26px;border-radius:8px;background:linear-gradient(135deg,#f59e0b,#f97316);display:flex;align-items:center;justify-content:center;font-size:14px">&#10531;</div>
          <div style="line-height:1.2"><div style="font-weight:700;font-size:13px">AI Scan</div><div style="font-size:11.5px;color:#aab0d4">2 issues found</div></div>
        </div>
      </div>
    </div>
  </section>

  <!-- STATS -->
  <section style="background:#fff;border-bottom:1px solid #eef0f7">
    <div style="max-width:1180px;margin:0 auto;padding:34px 24px;display:grid;grid-template-columns:repeat(4,1fr);gap:24px;text-align:center">
      <div><div style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:34px;color:var(--accent)">200+</div><div style="font-size:14px;color:#6b7194;margin-top:4px;font-weight:600">rigorously filtered problems</div></div>
      <div><div style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:34px;color:var(--accent)">24</div><div style="font-size:14px;color:#6b7194;margin-top:4px;font-weight:600">H2 topics covered</div></div>
      <div><div style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:34px;color:var(--accent)">9758</div><div style="font-size:14px;color:#6b7194;margin-top:4px;font-weight:600">A-Level H2 syllabus</div></div>
      <div><div style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:34px;color:var(--accent)">100%</div><div style="font-size:14px;color:#6b7194;margin-top:4px;font-weight:600">exam-grade questions</div></div>
    </div>
  </section>

  <!-- ROADMAP (dark) -->
  <section id="roadmap" style="position:relative;background:#0b0e20;color:#fff;overflow:hidden">
    <div style="position:absolute;inset:0;background-image:linear-gradient(rgba(255,255,255,.035) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.035) 1px,transparent 1px);background-size:46px 46px;pointer-events:none"></div>
    <div style="position:absolute;inset:0;background:radial-gradient(700px 420px at 50% -5%,rgba(99,102,241,.22),transparent 70%);pointer-events:none"></div>
    <div style="position:relative;max-width:1180px;margin:0 auto;padding:80px 24px 88px">
      <div style="text-align:center;max-width:640px;margin:0 auto">
        <div style="color:#a5abe0;font-weight:700;font-size:13px;letter-spacing:.1em;text-transform:uppercase">The roadmap</div>
        <h2 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:44px;line-height:1.08;letter-spacing:-.02em;margin:14px 0 0">A clear path through the whole syllabus</h2>
        <p style="font-size:18px;line-height:1.55;color:#aab0d6;margin:16px 0 0">No more guessing what to study next. Follow the nodes, unlock topics as you go, and watch the map fill in.</p>
      </div>

      <div style="display:flex;flex-direction:column;align-items:center;margin-top:46px">

        <!-- Card 1: completed -->
        <div style="width:400px;max-width:100%;background:#12152b;border:1px solid rgba(16,185,129,.4);border-radius:16px;padding:18px 20px;box-shadow:0 16px 36px -22px rgba(16,185,129,.5)">
          <div style="display:flex;align-items:center;gap:13px">
            <div style="flex:none;width:44px;height:44px;border-radius:12px;background:#10241d;border:1px solid rgba(16,185,129,.5);display:flex;align-items:center;justify-content:center;color:#34d399;font-size:20px">&#10003;</div>
            <div style="flex:1"><div style="color:#fff;font-weight:700;font-size:16px">Graphing Technique</div><div style="color:#7e84ad;font-size:12.5px;margin-top:2px">8 questions</div></div>
          </div>
          <div style="margin-top:15px;height:7px;border-radius:99px;background:#222742;overflow:hidden"><div style="height:100%;width:100%;border-radius:99px;background:#10b981"></div></div>
          <div style="display:flex;justify-content:space-between;margin-top:9px;font-size:12px"><span style="color:#34d399;font-weight:700">Completed</span><span style="color:#7e84ad">100%</span></div>
        </div>

        <!-- arrow (accent) -->
        <div style="display:flex;justify-content:center;padding:5px 0"><svg width="22" height="34" viewBox="0 0 22 34" fill="none"><path d="M11 0 V25" style="stroke:var(--accent)" stroke-width="2.5"/><path d="M3.5 19 L11 27 L18.5 19" style="stroke:var(--accent)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/></svg></div>

        <!-- Card 2: in progress -->
        <div style="position:relative;width:400px;max-width:100%;background:#161a33;border:1.5px solid var(--accent);border-radius:16px;padding:18px 20px;box-shadow:0 0 0 4px rgba(99,102,241,.12),0 18px 40px -20px rgba(79,70,229,.7)">
          <div style="position:absolute;top:16px;right:18px;font-size:11px;font-weight:700;color:#fff;background:var(--accent);padding:3px 9px;border-radius:99px">Continue &rarr;</div>
          <div style="display:flex;align-items:center;gap:13px">
            <div style="flex:none;width:44px;height:44px;border-radius:12px;background:linear-gradient(135deg,var(--accent),var(--accent-2));display:flex;align-items:center;justify-content:center;color:#fff;font-size:16px">&#9656;</div>
            <div style="flex:1"><div style="color:#fff;font-weight:700;font-size:16px">Functions</div><div style="color:#aab0e6;font-size:12.5px;margin-top:2px">12 questions</div></div>
          </div>
          <div style="margin-top:15px;height:7px;border-radius:99px;background:#222742;overflow:hidden"><div style="height:100%;width:45%;border-radius:99px;background:linear-gradient(90deg,var(--accent),var(--accent-2))"></div></div>
          <div style="display:flex;justify-content:space-between;margin-top:9px;font-size:12px"><span style="color:#c7cbff;font-weight:700">In progress</span><span style="color:#aab0e6">45%</span></div>
        </div>

        <!-- arrow -->
        <div style="display:flex;justify-content:center;padding:5px 0"><svg width="22" height="34" viewBox="0 0 22 34" fill="none"><path d="M11 0 V25" stroke="#3a4170" stroke-width="2.5"/><path d="M3.5 19 L11 27 L18.5 19" stroke="#3a4170" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/></svg></div>

        <!-- Card 3: up next -->
        <div style="width:400px;max-width:100%;background:#12152b;border:1px solid #2a3160;border-radius:16px;padding:18px 20px">
          <div style="display:flex;align-items:center;gap:13px">
            <div style="flex:none;width:44px;height:44px;border-radius:12px;background:#1b2042;border:1px solid #2f3666;display:flex;align-items:center;justify-content:center;color:#aab0e6;font-size:16px">&#9656;</div>
            <div style="flex:1"><div style="color:#e7e9f7;font-weight:700;font-size:16px">Transformation</div><div style="color:#7e84ad;font-size:12.5px;margin-top:2px">6 questions</div></div>
          </div>
          <div style="margin-top:15px;height:7px;border-radius:99px;background:#222742;overflow:hidden"><div style="height:100%;width:0%;border-radius:99px;background:#3a4170"></div></div>
          <div style="display:flex;justify-content:space-between;margin-top:9px;font-size:12px"><span style="color:#aab0d6;font-weight:700">Up next</span><span style="color:#7e84ad">0%</span></div>
        </div>

        <!-- arrow -->
        <div style="display:flex;justify-content:center;padding:5px 0"><svg width="22" height="34" viewBox="0 0 22 34" fill="none"><path d="M11 0 V25" stroke="#2a3160" stroke-width="2.5"/><path d="M3.5 19 L11 27 L18.5 19" stroke="#2a3160" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/></svg></div>

        <!-- Card 4: locked -->
        <div style="width:400px;max-width:100%;background:#10132a;border:1px solid #232850;border-radius:16px;padding:18px 20px;opacity:.62">
          <div style="display:flex;align-items:center;gap:13px">
            <div style="flex:none;width:44px;height:44px;border-radius:12px;background:#161a33;border:1px solid #262b4d;display:flex;align-items:center;justify-content:center;color:#5b6090;font-size:17px">&#9128;</div>
            <div style="flex:1"><div style="color:#bcc1e0;font-weight:700;font-size:16px">Inequalities</div><div style="color:#6a6f99;font-size:12.5px;margin-top:2px">7 questions</div></div>
          </div>
          <div style="margin-top:15px;height:7px;border-radius:99px;background:#1c2138;overflow:hidden"></div>
          <div style="display:flex;justify-content:space-between;margin-top:9px;font-size:12px"><span style="color:#6a6f99;font-weight:700">Locked</span><span style="color:#54597e">0%</span></div>
        </div>

        <!-- arrow -->
        <div style="display:flex;justify-content:center;padding:5px 0"><svg width="22" height="34" viewBox="0 0 22 34" fill="none"><path d="M11 0 V25" stroke="#2a3160" stroke-width="2.5"/><path d="M3.5 19 L11 27 L18.5 19" stroke="#2a3160" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/></svg></div>

        <!-- Card 5: locked -->
        <div style="width:400px;max-width:100%;background:#10132a;border:1px solid #232850;border-radius:16px;padding:18px 20px;opacity:.62">
          <div style="display:flex;align-items:center;gap:13px">
            <div style="flex:none;width:44px;height:44px;border-radius:12px;background:#161a33;border:1px solid #262b4d;display:flex;align-items:center;justify-content:center;color:#5b6090;font-size:17px">&#9128;</div>
            <div style="flex:1"><div style="color:#bcc1e0;font-weight:700;font-size:16px">Conics</div><div style="color:#6a6f99;font-size:12.5px;margin-top:2px">9 questions</div></div>
          </div>
          <div style="margin-top:15px;height:7px;border-radius:99px;background:#1c2138;overflow:hidden"></div>
          <div style="display:flex;justify-content:space-between;margin-top:9px;font-size:12px"><span style="color:#6a6f99;font-weight:700">Locked</span><span style="color:#54597e">0%</span></div>
        </div>

      </div>

      <div style="display:flex;align-items:center;justify-content:center;gap:26px;margin-top:30px;flex-wrap:wrap">
        <div style="display:flex;align-items:center;gap:8px;font-size:13.5px;color:#aab0d6"><span style="width:11px;height:11px;border-radius:50%;background:#10b981"></span>Completed</div>
        <div style="display:flex;align-items:center;gap:8px;font-size:13.5px;color:#aab0d6"><span style="width:11px;height:11px;border-radius:50%;background:var(--accent)"></span>In progress</div>
        <div style="display:flex;align-items:center;gap:8px;font-size:13.5px;color:#aab0d6"><span style="width:11px;height:11px;border-radius:50%;background:#3a4170"></span>Up next</div>
        <div style="display:flex;align-items:center;gap:8px;font-size:13.5px;color:#aab0d6"><span style="width:11px;height:11px;border-radius:50%;background:#262b4d"></span>Locked</div>
      </div>
      <div style="text-align:center;margin-top:34px">
        <a href="/roadmap" class="pm-hov-lift" style="display:inline-flex;align-items:center;gap:9px;padding:15px 30px;border-radius:13px;background:#fff;color:#0b0e20;font-weight:700;font-size:16px;transition:transform .15s">Start at the first node &rarr;</a>
      </div>
    </div>
  </section>

  <!-- SPACED REPETITION -->
  <section style="background:#fff">
    <div style="max-width:1180px;margin:0 auto;padding:88px 24px;display:grid;grid-template-columns:1fr 1fr;gap:56px;align-items:center">
      <!-- left: copy -->
      <div>
        <div style="color:var(--accent);font-weight:700;font-size:13px;letter-spacing:.1em;text-transform:uppercase">Spaced repetition</div>
        <h2 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:42px;line-height:1.1;letter-spacing:-.02em;margin:14px 0 0">Remember the gotchas,<br>not just the topic.</h2>
        <p style="font-size:18px;line-height:1.6;color:#52567a;max-width:520px;margin:18px 0 0">Getting a question right once isn't the same as remembering it in November. ProjectMath runs a proven <b>SM-2</b> spaced-repetition schedule: every question you slip on comes back at <b>expanding intervals</b> &mdash; just before you'd forget it &mdash; until the trick and the concept behind it are locked in.</p>
        <ul style="list-style:none;padding:0;margin:26px 0 0;display:flex;flex-direction:column;gap:13px">
          <li style="display:flex;gap:11px;font-size:15.5px;color:#2c3050"><span style="color:#10b981;font-weight:800">&#10003;</span>Wrong answers are automatically queued for review</li>
          <li style="display:flex;gap:11px;font-size:15.5px;color:#2c3050"><span style="color:#10b981;font-weight:800">&#10003;</span>Each correct recall pushes the next review further out</li>
          <li style="display:flex;gap:11px;font-size:15.5px;color:#2c3050"><span style="color:#10b981;font-weight:800">&#10003;</span>A daily "due" queue tells you exactly what to revisit</li>
        </ul>
      </div>
      <!-- right: interval ladder -->
      <div style="position:relative">
        <div style="background:#f6f7fc;border:1px solid #ebedf6;border-radius:22px;box-shadow:0 26px 54px -26px rgba(28,32,68,.4);padding:26px">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:18px">
            <span style="font-weight:700;font-size:14px;color:#1c2042">Review schedule</span>
            <span style="display:inline-flex;align-items:center;gap:6px;padding:5px 11px;border-radius:999px;background:var(--accent-soft);color:var(--accent-ink);font-weight:700;font-size:12.5px">3 due today</span>
          </div>
          <div style="display:flex;flex-direction:column;gap:11px">
            <div style="display:flex;align-items:center;gap:13px;background:#fff;border:1px solid #ebedf6;border-radius:13px;padding:13px 15px">
              <div style="width:40px;height:40px;border-radius:11px;background:var(--accent);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-family:'Bricolage Grotesque',sans-serif;font-size:15px">1d</div>
              <div style="font-size:14.5px;color:#2c3050;font-weight:600">First recall &mdash; the day after you got it wrong</div>
            </div>
            <div style="display:flex;align-items:center;gap:13px;background:#fff;border:1px solid #ebedf6;border-radius:13px;padding:13px 15px">
              <div style="width:40px;height:40px;border-radius:11px;background:#6366f1;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-family:'Bricolage Grotesque',sans-serif;font-size:15px">3d</div>
              <div style="font-size:14.5px;color:#2c3050;font-weight:600">Still solid? The gap widens</div>
            </div>
            <div style="display:flex;align-items:center;gap:13px;background:#fff;border:1px solid #ebedf6;border-radius:13px;padding:13px 15px">
              <div style="width:40px;height:40px;border-radius:11px;background:#7c3aed;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-family:'Bricolage Grotesque',sans-serif;font-size:15px">7d</div>
              <div style="font-size:14.5px;color:#2c3050;font-weight:600">A week later, then two&hellip;</div>
            </div>
            <div style="display:flex;align-items:center;gap:11px;justify-content:center;padding-top:4px;color:#8a90ab;font-weight:700;font-size:13px">14d &rarr; 30d &rarr; mastered</div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- FEATURES -->
  <section id="features" style="background:#fff;border-top:1px solid #eef0f7">
    <div style="max-width:1180px;margin:0 auto;padding:88px 24px 30px;text-align:center">
      <div style="color:var(--accent);font-weight:700;font-size:13px;letter-spacing:.1em;text-transform:uppercase">AI tools</div>
      <h2 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:44px;line-height:1.08;letter-spacing:-.02em;margin:14px 0 0">Two tools that mark like a tutor</h2>
      <p style="font-size:18px;line-height:1.55;color:#52567a;max-width:600px;margin:16px auto 0">Method marks, presentation marks, the lot. ProjectMath checks your maths the way a real examiner would.</p>
    </div>

    <!-- AI Scan -->
    <div style="max-width:1180px;margin:0 auto;padding:50px 24px;display:grid;grid-template-columns:1fr 1fr;gap:56px;align-items:center">
      <div style="position:relative">
        <div style="background:#fff;border-radius:20px;border:1px solid #ebedf6;box-shadow:0 26px 54px -26px rgba(28,32,68,.4);padding:24px">
          <div style="display:flex;align-items:center;gap:8px;margin-bottom:16px">
            <div style="width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,#f59e0b,#f97316);display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px">&#10531;</div>
            <span style="font-weight:700;font-size:14px">student_working.jpg</span>
            <span style="margin-left:auto;font-size:12px;color:#10b981;font-weight:700">Scanned &#10003;</span>
          </div>
          <!-- faux handwriting -->
          <div style="position:relative;background:repeating-linear-gradient(#fff 0 31px,#eef0f7 31px 32px);border:1px solid #eef0f7;border-radius:12px;padding:14px 16px;display:flex;flex-direction:column;gap:16px">
            <div style="height:11px;width:78%;background:#d7dbea;border-radius:4px"></div>
            <div style="height:11px;width:60%;background:#d7dbea;border-radius:4px"></div>
            <div style="position:relative;height:11px;width:70%;background:#d7dbea;border-radius:4px;box-shadow:0 16px 0 -6px rgba(239,68,68,.22)"><span style="position:absolute;left:0;bottom:-7px;width:46%;height:3px;background:#ef4444;border-radius:3px"></span><span style="position:absolute;right:-30px;top:-6px;width:24px;height:24px;border-radius:50%;background:#ef4444;color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center">1</span></div>
            <div style="height:11px;width:52%;background:#d7dbea;border-radius:4px"></div>
            <div style="position:relative;height:11px;width:64%;background:#d7dbea;border-radius:4px"><span style="position:absolute;right:-30px;top:-6px;width:24px;height:24px;border-radius:50%;background:#f59e0b;color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center">2</span></div>
          </div>
        </div>
        <div style="margin-top:14px;display:flex;flex-direction:column;gap:10px">
          <div style="display:flex;gap:11px;align-items:flex-start;background:#fff5f5;border:1px solid #fad9d9;border-radius:12px;padding:12px 14px"><span style="flex:none;width:22px;height:22px;border-radius:50%;background:#ef4444;color:#fff;font-size:11px;font-weight:700;display:flex;align-items:center;justify-content:center">1</span><div style="font-size:13.5px;color:#7a1f1f;line-height:1.45"><b>Method error</b> &mdash; sign slip when differentiating; you wrote &minus;2x instead of +2x.</div></div>
          <div style="display:flex;gap:11px;align-items:flex-start;background:#fffaf0;border:1px solid #f7e4bd;border-radius:12px;padding:12px 14px"><span style="flex:none;width:22px;height:22px;border-radius:50%;background:#f59e0b;color:#fff;font-size:11px;font-weight:700;display:flex;align-items:center;justify-content:center">2</span><div style="font-size:13.5px;color:#7a5210;line-height:1.45"><b>Presentation</b> &mdash; state the domain before giving the range to secure the A1 mark.</div></div>
        </div>
      </div>
      <div>
        <div style="display:inline-flex;align-items:center;gap:8px;padding:6px 13px;border-radius:999px;background:#fff7ed;color:#c2410c;font-weight:700;font-size:13px">AI Scan</div>
        <h3 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:34px;line-height:1.12;letter-spacing:-.02em;margin:16px 0 0">Snap your working. Get it marked.</h3>
        <p style="font-size:17px;line-height:1.6;color:#52567a;margin:16px 0 0">Take a photo of your handwritten solution and AI Scan checks it line by line &mdash; catching sign slips, lost method marks, and the presentation details examiners love to dock.</p>
        <ul style="list-style:none;padding:0;margin:22px 0 0;display:flex;flex-direction:column;gap:13px">
          <li style="display:flex;gap:11px;align-items:flex-start;font-size:15.5px;color:#2c3050"><span style="flex:none;color:#10b981;font-weight:800">&#10003;</span>Spots method &amp; sign errors in your working</li>
          <li style="display:flex;gap:11px;align-items:flex-start;font-size:15.5px;color:#2c3050"><span style="flex:none;color:#10b981;font-weight:800">&#10003;</span>Flags presentation marks you'd otherwise lose</li>
          <li style="display:flex;gap:11px;align-items:flex-start;font-size:15.5px;color:#2c3050"><span style="flex:none;color:#10b981;font-weight:800">&#10003;</span>Explains <em>why</em>, with the corrected step</li>
        </ul>
      </div>
    </div>

    <!-- AI Tutor -->
    <div style="max-width:1180px;margin:0 auto;padding:30px 24px 70px;display:grid;grid-template-columns:1fr 1fr;gap:56px;align-items:center">
      <div style="order:2">
        <div style="background:#fff;border-radius:20px;border:1px solid #ebedf6;box-shadow:0 26px 54px -26px rgba(28,32,68,.4);padding:20px;display:flex;flex-direction:column;gap:13px">
          <div style="display:flex;align-items:center;gap:9px;padding-bottom:13px;border-bottom:1px solid #f0f1f8">
            <div style="width:30px;height:30px;border-radius:9px;background:linear-gradient(135deg,var(--accent),var(--accent-2));display:flex;align-items:center;justify-content:center;color:#fff;font-size:15px">&#10022;</div>
            <span style="font-weight:700;font-size:14.5px">AI Tutor</span>
            <span style="margin-left:auto;display:inline-flex;align-items:center;gap:6px;font-size:12px;color:#10b981;font-weight:700"><span style="width:7px;height:7px;border-radius:50%;background:#10b981"></span>online</span>
          </div>
          <div style="align-self:flex-end;max-width:78%;background:var(--accent);color:#fff;border-radius:16px 16px 4px 16px;padding:11px 15px;font-size:14.5px;line-height:1.5">I'm stuck finding the range of f(x) = x&sup2; &minus; 4x + 7.</div>
          <div style="align-self:flex-start;max-width:82%;background:#f3f4fb;color:#2c3050;border-radius:16px 16px 16px 4px;padding:11px 15px;font-size:14.5px;line-height:1.5">Let's not jump to the answer. Try completing the square first &mdash; what's f(x) in the form (x &minus; a)&sup2; + b?</div>
          <div style="align-self:flex-end;max-width:78%;background:var(--accent);color:#fff;border-radius:16px 16px 4px 16px;padding:11px 15px;font-size:14.5px;line-height:1.5">(x &minus; 2)&sup2; + 3</div>
          <div style="align-self:flex-start;max-width:82%;background:#f3f4fb;color:#2c3050;border-radius:16px 16px 16px 4px;padding:11px 15px;font-size:14.5px;line-height:1.5">Exactly. Since (x &minus; 2)&sup2; &ge; 0, the smallest value is 3 &mdash; so the range is <b>[3, &infin;)</b>. &#10022;</div>
          <div style="display:flex;align-items:center;gap:10px;margin-top:4px;border:1px solid #eaecf4;border-radius:12px;padding:9px 13px">
            <span style="font-size:14px;color:#a7adc8;flex:1">Ask a follow-up&hellip;</span>
            <span style="width:30px;height:30px;border-radius:9px;background:var(--accent);color:#fff;display:flex;align-items:center;justify-content:center;font-size:15px">&uarr;</span>
          </div>
        </div>
      </div>
      <div style="order:1">
        <div style="display:inline-flex;align-items:center;gap:8px;padding:6px 13px;border-radius:999px;background:var(--accent-soft);color:var(--accent-ink);font-weight:700;font-size:13px">AI Tutor</div>
        <h3 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:34px;line-height:1.12;letter-spacing:-.02em;margin:16px 0 0">Stuck? Get the next step &mdash; not the answer.</h3>
        <p style="font-size:17px;line-height:1.6;color:#52567a;margin:16px 0 0">Your AI tutor asks the right questions and walks you through the method, so you actually learn the technique instead of copying a solution.</p>
        <ul style="list-style:none;padding:0;margin:22px 0 0;display:flex;flex-direction:column;gap:13px">
          <li style="display:flex;gap:11px;align-items:flex-start;font-size:15.5px;color:#2c3050"><span style="flex:none;color:#10b981;font-weight:800">&#10003;</span>Socratic hints scaled to where you're stuck</li>
          <li style="display:flex;gap:11px;align-items:flex-start;font-size:15.5px;color:#2c3050"><span style="flex:none;color:#10b981;font-weight:800">&#10003;</span>Knows the H2 9758 syllabus &amp; notation</li>
          <li style="display:flex;gap:11px;align-items:flex-start;font-size:15.5px;color:#2c3050"><span style="flex:none;color:#10b981;font-weight:800">&#10003;</span>Available 24/7 &mdash; the night before a test too</li>
        </ul>
      </div>
    </div>
  </section>

  <!-- WHY PROJECTMATH -->
  <section style="background:#f6f7fc;border-top:1px solid #eef0f7;border-bottom:1px solid #eef0f7">
    <div style="max-width:1180px;margin:0 auto;padding:80px 24px">
      <div style="text-align:center;max-width:560px;margin:0 auto">
        <div style="color:var(--accent);font-weight:700;font-size:13px;letter-spacing:.1em;text-transform:uppercase">Why ProjectMath</div>
        <h2 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:42px;line-height:1.1;letter-spacing:-.02em;margin:14px 0 0">Quality over quantity</h2>
      </div>
      <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:22px;margin-top:46px">
        <div style="background:#fff;border:1px solid #ebedf6;border-radius:18px;padding:26px;box-shadow:0 14px 34px -22px rgba(28,32,68,.4)">
          <div style="width:44px;height:44px;border-radius:12px;background:var(--accent-soft);display:flex;align-items:center;justify-content:center;color:var(--accent-ink);font-size:22px">&#128221;</div>
          <h3 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:20px;margin:18px 0 8px">Straight from the exam</h3>
          <p style="font-size:15px;line-height:1.6;color:#52567a;margin:0">Every question is taken from real A-Level and 2025 JC Prelim papers (9758) &mdash; the exact style and rigour you'll meet on the day.</p>
        </div>
        <div style="background:#fff;border:1px solid #ebedf6;border-radius:18px;padding:26px;box-shadow:0 14px 34px -22px rgba(28,32,68,.4)">
          <div style="width:44px;height:44px;border-radius:12px;background:var(--accent-soft);display:flex;align-items:center;justify-content:center;color:var(--accent-ink);font-size:22px">&#10003;</div>
          <h3 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:20px;margin:18px 0 8px">200+, hand-filtered</h3>
          <p style="font-size:15px;line-height:1.6;color:#52567a;margin:0">A rigorously curated library &mdash; no filler, no AI-generated padding. If a problem doesn't teach something worth knowing, it doesn't make the cut.</p>
        </div>
        <div style="background:#fff;border:1px solid #ebedf6;border-radius:18px;padding:26px;box-shadow:0 14px 34px -22px rgba(28,32,68,.4)">
          <div style="width:44px;height:44px;border-radius:12px;background:var(--accent-soft);display:flex;align-items:center;justify-content:center;color:var(--accent-ink);font-size:22px">&#8635;</div>
          <h3 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:20px;margin:18px 0 8px">Built to stick</h3>
          <p style="font-size:15px;line-height:1.6;color:#52567a;margin:0">SM-2 spaced repetition resurfaces the questions you got wrong at the right moment, so the gotchas and concepts don't quietly fade before exams.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- PRICING -->
  <section id="pricing" style="background:#fff">
    <div style="max-width:1180px;margin:0 auto;padding:84px 24px">
      <input type="radio" name="pmperiod" id="pm-monthly" class="pm-period-radio">
      <input type="radio" name="pmperiod" id="pm-annual" class="pm-period-radio" checked>
      <div style="text-align:center;max-width:560px;margin:0 auto">
        <div style="color:var(--accent);font-weight:700;font-size:13px;letter-spacing:.1em;text-transform:uppercase">Pricing</div>
        <h2 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:42px;line-height:1.1;letter-spacing:-.02em;margin:14px 0 0">Start free. Go Pro when you're ready.</h2>
      </div>
      <!-- toggle -->
      <div class="pm-toggle-wrap" style="display:flex;justify-content:center;margin-top:30px">
        <div style="display:flex;gap:4px;background:#f1f2f9;border-radius:13px;padding:5px;width:280px">
          <label for="pm-monthly" class="pm-tab pm-tab-monthly">Monthly</label>
          <label for="pm-annual" class="pm-tab pm-tab-annual">Yearly &middot; save 20%</label>
        </div>
      </div>

      <div class="pm-pricing-grid" style="display:grid;grid-template-columns:1fr 1fr;gap:24px;margin-top:36px;max-width:840px;margin-left:auto;margin-right:auto;align-items:start">
        <!-- Free -->
        <div style="background:#fff;border:1px solid #e7e9f3;border-radius:22px;padding:30px">
          <div style="font-weight:700;font-size:18px">Free</div>
          <p style="font-size:14px;color:#6b7194;margin:6px 0 0">Everything you need to start the roadmap.</p>
          <div style="margin:22px 0;display:flex;align-items:flex-end;gap:4px"><span style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:46px;line-height:1">S$0</span><span style="font-size:15px;color:#8a90ab;margin-bottom:8px">/forever</span></div>
          <a href="/roadmap" class="pm-hov-border" style="display:block;text-align:center;padding:13px;border-radius:12px;border:1px solid #d9dcea;background:#fff;color:#1f2342;font-weight:700;font-size:15px;transition:border-color .15s">Start free</a>
          <ul style="list-style:none;padding:0;margin:24px 0 0;display:flex;flex-direction:column;gap:13px">
            <li style="display:flex;gap:11px;font-size:14.5px;color:#2c3050"><span style="color:#10b981;font-weight:800">&#10003;</span>Full roadmap access</li>
            <li style="display:flex;gap:11px;font-size:14.5px;color:#2c3050"><span style="color:#10b981;font-weight:800">&#10003;</span>Practice questions for every topic</li>
            <li style="display:flex;gap:11px;font-size:14.5px;color:#2c3050"><span style="color:#10b981;font-weight:800">&#10003;</span>5 AI Scans / month</li>
            <li style="display:flex;gap:11px;font-size:14.5px;color:#2c3050"><span style="color:#10b981;font-weight:800">&#10003;</span>10 AI Tutor messages / day</li>
          </ul>
        </div>
        <!-- Pro -->
        <div style="position:relative;background:#0b0e20;color:#fff;border-radius:22px;padding:30px;box-shadow:0 30px 60px -28px rgba(79,70,229,.7);border:1px solid #2a3160">
          <div style="position:absolute;top:-13px;left:50%;transform:translateX(-50%);background:linear-gradient(135deg,var(--accent),var(--accent-2));color:#fff;font-weight:700;font-size:12px;padding:6px 14px;border-radius:999px;white-space:nowrap">&#9733; Most popular</div>
          <div style="font-weight:700;font-size:18px">Pro</div>
          <p style="font-size:14px;color:#aab0d6;margin:6px 0 0">Unlimited AI, plans built around you.</p>
          <div style="margin:22px 0;display:flex;align-items:flex-end;gap:5px"><span style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:46px;line-height:1"><span class="pm-price-annual">S$15</span><span class="pm-price-monthly">S$19</span></span><span style="font-size:14px;color:#aab0d6;margin-bottom:8px"><span class="pm-sub-annual">/mo &middot; billed S$180/yr</span><span class="pm-sub-monthly">/month</span></span></div>
          <a href="#" data-goto-pro class="pm-hov-lift" style="display:block;text-align:center;padding:13px;border-radius:12px;background:linear-gradient(135deg,var(--accent),var(--accent-2));color:#fff;font-weight:700;font-size:15px;transition:transform .15s">Go Pro</a>
          <ul style="list-style:none;padding:0;margin:24px 0 0;display:flex;flex-direction:column;gap:13px">
            <li style="display:flex;gap:11px;font-size:14.5px;color:#e7e9f7"><span style="color:#34d399;font-weight:800">&#10003;</span>Everything in Free</li>
            <li style="display:flex;gap:11px;font-size:14.5px;color:#e7e9f7"><span style="color:#34d399;font-weight:800">&#10003;</span><b>Unlimited</b> AI Scans</li>
            <li style="display:flex;gap:11px;font-size:14.5px;color:#e7e9f7"><span style="color:#34d399;font-weight:800">&#10003;</span><b>Unlimited</b> AI Tutor</li>
            <li style="display:flex;gap:11px;font-size:14.5px;color:#e7e9f7"><span style="color:#34d399;font-weight:800">&#10003;</span>Personalised daily study plans</li>
            <li style="display:flex;gap:11px;font-size:14.5px;color:#e7e9f7"><span style="color:#34d399;font-weight:800">&#10003;</span>Weakness diagnosis &amp; targeted drills</li>
            <li style="display:flex;gap:11px;font-size:14.5px;color:#e7e9f7"><span style="color:#34d399;font-weight:800">&#10003;</span>Priority support</li>
          </ul>
        </div>
      </div>
    </div>
  </section>

  <!-- FINAL CTA -->
  <section style="background:#fff;padding:0 24px 84px">
    <div style="max-width:1180px;margin:0 auto;position:relative;overflow:hidden;border-radius:28px;background:linear-gradient(135deg,var(--accent),var(--accent-2));padding:66px 40px;text-align:center;color:#fff">
      <div style="position:absolute;inset:0;background-image:linear-gradient(rgba(255,255,255,.07) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.07) 1px,transparent 1px);background-size:44px 44px;pointer-events:none"></div>
      <div style="position:relative">
        <h2 style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:46px;line-height:1.08;letter-spacing:-.02em;margin:0">Your H2 Math A starts<br>at the first node.</h2>
        <p style="font-size:18px;color:#e6e6ff;margin:18px auto 0;max-width:520px">Work through 200+ exam-grade problems with an AI tutor and spaced review that makes them stick &mdash; free to start, no card needed.</p>
        <a href="/roadmap" class="pm-hov-lift" style="display:inline-flex;align-items:center;gap:9px;margin-top:30px;padding:16px 34px;border-radius:14px;background:#fff;color:var(--accent-ink);font-weight:800;font-size:17px;transition:transform .15s">Start free today &rarr;</a>
      </div>
    </div>
  </section>

  <!-- FOOTER -->
  <footer style="background:#0b0e20;color:#aab0d6;padding:54px 24px 40px">
    <div style="max-width:1180px;margin:0 auto;display:grid;grid-template-columns:1.4fr 1fr 1fr 1fr;gap:32px">
      <div>
        <div style="display:flex;align-items:center;gap:11px">
          <div style="width:34px;height:34px;border-radius:10px;background:linear-gradient(135deg,var(--accent),var(--accent-2));display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:18px;font-family:'Bricolage Grotesque',sans-serif">&#960;</div>
          <span style="font-family:'Bricolage Grotesque',sans-serif;font-weight:800;font-size:19px;color:#fff">Project<span style="color:var(--accent)">Math</span></span>
        </div>
        <p style="font-size:14px;line-height:1.6;margin:16px 0 0;max-width:280px">The guided roadmap and AI tutor for Singapore A-Level H2 Mathematics (9758).</p>
      </div>
      <div>
        <div style="color:#fff;font-weight:700;font-size:14px;margin-bottom:14px">Product</div>
        <div style="display:flex;flex-direction:column;gap:10px;font-size:14px">
          <a href="#roadmap" class="pm-hov-white">Roadmap</a>
          <a href="#features" class="pm-hov-white">AI Tutor</a>
          <a href="#features" class="pm-hov-white">AI Scan</a>
          <a href="#pricing" class="pm-hov-white">Pricing</a>
        </div>
      </div>
      <div>
        <div style="color:#fff;font-weight:700;font-size:14px;margin-bottom:14px">Topics</div>
        <div style="display:flex;flex-direction:column;gap:10px;font-size:14px">
          <a href="#roadmap" class="pm-hov-white">Graphing Technique</a>
          <a href="#roadmap" class="pm-hov-white">Functions</a>
          <a href="#roadmap" class="pm-hov-white">Transformation</a>
          <a href="#roadmap" class="pm-hov-white">Inequalities &amp; Conics</a>
        </div>
      </div>
      <div>
        <div style="color:#fff;font-weight:700;font-size:14px;margin-bottom:14px">Company</div>
        <div style="display:flex;flex-direction:column;gap:10px;font-size:14px">
          <a href="#" class="pm-hov-white">About</a>
          <a href="#" class="pm-hov-white">Contact</a>
          <a href="#" class="pm-hov-white">Privacy</a>
          <a href="#" class="pm-hov-white">Terms</a>
        </div>
      </div>
    </div>
    <div style="max-width:1180px;margin:36px auto 0;padding-top:22px;border-top:1px solid #1c2140;display:flex;justify-content:space-between;flex-wrap:wrap;gap:10px;font-size:13px;color:#6a6f99">
      <span>&copy; 2026 ProjectMath. All rights reserved.</span>
      <span>Made for Singapore JC students &#127480;&#127468;</span>
    </div>
  </footer>

</div>
`

export function LandingPage() {
  const navigate = useNavigate()
  const { user, loading, openLoginModal, openUpgradeModal } = useAuth()

  // Marks "the login now in progress was triggered by a 'Go Pro' click" so the transition
  // effect below knows to auto-open the upgrade modal instead of redirecting to /roadmap.
  // Deliberately a plain in-memory ref (never persisted to storage) so it resets on reload.
  const goProIntentRef = useRef(false)

  // Redirect into the app only on the login *transition* (logged-out → logged-in), e.g. right after
  // signing in via the modal here, or landing on `/` directly while already authenticated. We must
  // NOT redirect when an already-signed-in user navigates here on purpose (clicking the ProjectMath
  // logo from the app) — in that case the component mounts with `user` already set, so there's no
  // transition and they can view the landing page. (replace: Back won't bounce between / and /roadmap.)
  const prevUserRef = useRef(user)
  useEffect(() => {
    const justLoggedIn = prevUserRef.current == null && user != null
    prevUserRef.current = user
    if (!loading && justLoggedIn) {
      if (goProIntentRef.current) {
        goProIntentRef.current = false
        openUpgradeModal()
      } else {
        navigate('/roadmap', { replace: true })
      }
    }
  }, [user, loading, navigate, openUpgradeModal])

  // Clicks inside the static markup are delegated here:
  //  - the "Log in" link (data-login) opens the auth modal
  //  - the "Go Pro" CTA (data-goto-pro) opens the upgrade modal instantly if logged in, or
  //    opens the login modal first (auto-opening the upgrade modal after sign-in) if logged out
  //  - CTAs that funnel into the app carry href="/roadmap" → router navigate (no reload)
  //  - in-page #section links smooth-scroll (slide) to that section
  function handleClick(e: MouseEvent<HTMLDivElement>) {
    const anchor = (e.target as HTMLElement).closest('a')
    if (!anchor) return
    const href = anchor.getAttribute('href')
    if (anchor.dataset.login !== undefined) {
      e.preventDefault()
      openLoginModal()
    } else if (anchor.dataset.gotoPro !== undefined) {
      e.preventDefault()
      if (user) {
        openUpgradeModal()
      } else {
        goProIntentRef.current = true
        openLoginModal('Log in to continue to Premium checkout.')
      }
    } else if (href === '/roadmap') {
      e.preventDefault()
      navigate('/roadmap')
    } else if (href && href.length > 1 && href.startsWith('#')) {
      const target = document.getElementById(href.slice(1))
      if (target) {
        e.preventDefault()
        target.scrollIntoView({ behavior: 'smooth', block: 'start' })
      }
    }
  }

  // The nav auth link swaps with auth state: "Log in" (opens the modal) when signed out, "Go to
  // roadmap" (routes via the href="/roadmap" branch of handleClick) when signed in.
  const authLink = user
    ? '<a href="/roadmap" style="font-weight:600;font-size:15px;color:#3d4264;cursor:pointer" class="pm-hov-accent">Go to roadmap</a>'
    : '<a href="#" data-login style="font-weight:600;font-size:15px;color:#3d4264;cursor:pointer" class="pm-hov-accent">Log in</a>'

  return (
    <div className="pm-landing">
      <style>{STYLES}</style>
      <div onClick={handleClick} dangerouslySetInnerHTML={{ __html: MARKUP.replace('__AUTH_LINK__', authLink) }} />
    </div>
  )
}
