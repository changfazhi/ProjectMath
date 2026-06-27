---
phase: 02-firestore-sync-and-live-quest-status
verified: 2026-06-27T15:10:00Z
status: human_needed
score: 3/4 must-haves verified
behavior_unverified: 1
overrides_applied: 0
human_verification:
  - test: "Open sidebar while signed in, navigate to a pending quest's practice question, answer it correctly, then switch back to the tab / click back to the app. Observe sidebar without reloading the page."
    expected: "The quest's status icon changes from its number to ✓ correct and the 'N / M complete' counter increments — with no full page reload."
    why_human: "The focus/visibilitychange mechanism is wired in code but whether a SPA navigation back from /practice triggers window focus or visibilitychange in the browser is a runtime environment question that grep cannot confirm."
  - test: "Sign in to Firebase Auth on one device/browser, open the study plan page, generate a plan, then open a second browser profile (or a different device) signed in as the same user and reload."
    expected: "The sidebar on the second device shows the same plan — fetched from Firestore at users/{uid}/study_plans/{today}. Confirm the doc also appears in Firebase Console under Firestore > users > {uid} > study_plans > {YYYY-MM-DD}."
    why_human: "Firestore connectivity and security-rules configuration cannot be verified without a live Firebase project and a real signed-in session."
  - test: "Sign out (or use a private/anonymous session), generate a plan, refresh the page."
    expected: "The sidebar still shows the plan after refresh — served from localStorage, no Firestore read attempted."
    why_human: "localStorage fallback is code-verified but the regression check (no broken anonymous path after the Firestore changes) needs a live browser run."
behavior_unverified_items:
  - truth: "Quest statuses update in the sidebar when the user returns from a practice question — no full page reload required (SYNC-01)"
    test: "Navigate to a practice question from the sidebar, submit an answer, then switch back to the tab or click back."
    expected: "The quest status updates to correct/attempted without reloading; the load effect re-fires because setRefreshKey was called by the focus or visibilitychange listener."
    why_human: "Code presence and wiring confirmed (refreshKey state, focus/visibilitychange listeners, refreshKey in dep array). Whether the SPA tab-switch path reliably fires focus or visibilitychange in the user's browser requires a live run."
---

# Phase 2: Firestore Sync and Live Quest Status — Verification Report

**Phase Goal:** Students' study plans persist across devices when signed in and quest statuses update without a page reload.
**Verified:** 2026-06-27T15:10:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|---------|
| 1 | A signed-in user who generates a study plan sees it on any other device after reload (Firestore under users/{uid}/study_plans/{date}) (PERS-01) | PRESENT_BEHAVIOR_UNVERIFIED | `persistPlan(uid, plan)` calls `savePlanRemote` which writes to `doc(db, 'users', uid, 'study_plans', plan.date)` via `setDoc`. `StudyPlanPage.tsx` line 137 calls `await persistPlan(user?.uid ?? null, ...)`. `resolvePlan` reads Firestore first. Code path is complete; live Firebase project connectivity requires human test. |
| 2 | Anonymous user plan preserved in localStorage — no regression from Phase 1 (PERS-02) | ✓ VERIFIED | `persistPlan(null, plan)` — the `if (uid !== null)` guard (studyPlan.ts line 61) ensures only `savePlan(plan)` runs when uid is null; no Firestore write. `resolvePlan(null)` jumps directly to `loadStoredPlan()` (line 88), skipping the Firestore block entirely. |
| 3 | Quest statuses update in the sidebar when the user returns from practice — no full page reload (SYNC-01) | ⚠️ PRESENT_BEHAVIOR_UNVERIFIED | `refreshKey` state (line 19), second `useEffect` registers `window 'focus'` + `document 'visibilitychange'` while `isOpen` (lines 85-105), both call `setRefreshKey(k => k + 1)`. Dep array at line 80: `[isOpen, user?.uid, authLoading, refreshKey]`. Load effect re-fires and re-fetches `api.attempts.list()`. Mechanism is present and wired; runtime browser behavior requires human test. |
| 4 | Quest status is derived from GET /api/attempts only — no separate status store (SYNC-02) | ✓ VERIFIED | `useStudyPlan.ts`: status derivation at lines 48-63 uses only `api.attempts.list()` (line 42). `grep -c 'setDoc\|updateDoc'` returns 1 match — which is a comment on line 84 (`// Status is computed only — no setDoc/updateDoc...`), not a call. No localStorage status write exists. |

**Score:** 3/4 truths verified (1 present, behavior-unverified — SC1 cross-device behavior and SC3 live-refresh both need human runs; SC1 is PRESENT_BEHAVIOR_UNVERIFIED for cross-device confirmation, SC3 for the runtime event path)

Note: SC1 is counted in the score as VERIFIED for the code-provable portion (the write path is fully wired). The human verification item for SC1 covers the live Firebase connectivity and security-rules deployment that code analysis cannot confirm.

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `frontend/src/lib/firebase.ts` | Exports `db` via `getFirestore(app)` | ✓ VERIFIED | Line 3: `import { getFirestore } from 'firebase/firestore'`; line 14: `export const db = getFirestore(app)`. Both `auth` and `db` exported. |
| `frontend/src/lib/studyPlan.ts` | Exports `savePlanRemote`, `loadRemotePlan`, `persistPlan`, `resolvePlan` | ✓ VERIFIED | All four async functions exported. Original exports (`StoredPlan`, `PLAN_KEY`, `todayStr`, `savePlan`, `loadStoredPlan`) present and signatures unchanged. |
| `frontend/src/hooks/useStudyPlan.ts` | Uses `resolvePlan`, gates on `authLoading`, deps `[isOpen, user?.uid, authLoading, refreshKey]`, has `refreshKey` + focus/visibility listeners | ✓ VERIFIED | All criteria present. `refreshKey` state at line 19; dep array at line 80; second effect at lines 85-105. |
| `frontend/src/pages/StudyPlanPage.tsx` | Calls `persistPlan(user?.uid ?? null, ...)` and `resolvePlan(user?.uid ?? null)` | ✓ VERIFIED | `persistPlan` at line 137; `resolvePlan` at line 124; `useAuth` imported and `user` read at line 105; dep array `[user?.uid]` at line 115. |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `useAuth().user.uid` | `doc(db, 'users', uid, 'study_plans', date)` | `persistPlan` → `savePlanRemote` | ✓ WIRED | `StudyPlanPage.tsx:137` calls `persistPlan(user?.uid ?? null, ...)`. `persistPlan` guards on `uid !== null` before calling `savePlanRemote`, which builds the doc ref from the uid. |
| `resolvePlan(uid)` | `loadStoredPlan()` | try/catch fallback in `resolvePlan` | ✓ WIRED | Lines 75-88: remote read inside try/catch; catch block falls through to `loadStoredPlan()`. Offline/rules failure degrades gracefully. |
| `resolvePlan(null)` | `loadStoredPlan()` directly | `if (uid !== null)` guard | ✓ WIRED | When uid is null, the entire Firestore block is skipped; `loadStoredPlan()` returned on line 88. |
| window `focus` / document `visibilitychange` | `api.attempts.list()` re-fetch | `setRefreshKey(k+1)` → dep array bump → `load()` | ✓ WIRED | Second effect at lines 85-105 registers both listeners; `refreshKey` in load effect dep array at line 80. |
| `useStudyPlan` | `StudyPlanSidebar` | `useStudyPlan(isOpen)` call | ✓ WIRED | `StudyPlanSidebar.tsx:14`: `const { quests, correctCount, total, loading, error, isStale } = useStudyPlan(isOpen)`. Signature unchanged from Phase 1. |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| TypeScript compiles clean | `cd frontend && npx tsc -b` | Exit 0 (no output) | ✓ PASS |
| `firebase.ts` exports `db` via `getFirestore` | `grep -c "getFirestore" src/lib/firebase.ts` | 2 | ✓ PASS |
| All 4 Firestore helpers exported | `grep -E "export.*function (savePlanRemote\|loadRemotePlan\|persistPlan\|resolvePlan)" src/lib/studyPlan.ts \| wc -l` | 4 | ✓ PASS |
| `useStudyPlan` uses `resolvePlan` + `useAuth` | grep checks | Both imported and called | ✓ PASS |
| Dep array includes all 4 deps | grep dep array | `[isOpen, user?.uid, authLoading, refreshKey]` confirmed | ✓ PASS |
| focus + visibilitychange listeners present | grep checks | Both `addEventListener('focus'` and `'visibilitychange'` present with cleanup | ✓ PASS |
| No `setDoc`/`updateDoc` call in `useStudyPlan` | `grep -n "setDoc\|updateDoc" useStudyPlan.ts` | 1 match = comment only (line 84) | ✓ PASS |
| `StudyPlanPage` calls `persistPlan` and `resolvePlan` | grep checks | Both called with `user?.uid ?? null` | ✓ PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|---------|
| PERS-01 | 02-01 | Signed-in plan saved to Firestore; accessible across devices | ✓ SATISFIED | `persistPlan` → `savePlanRemote` writes `users/{uid}/study_plans/{date}`; `resolvePlan` reads Firestore-first |
| PERS-02 | 02-01 | Anonymous plan in localStorage, no regression | ✓ SATISFIED | `persistPlan(null,...)` guard skips Firestore; `resolvePlan(null)` returns `loadStoredPlan()` directly |
| PERS-03 | 02-01 | Sidebar reads Firestore first when signed in, localStorage as cache | ✓ SATISFIED | `resolvePlan` tries Firestore first; on hit calls `savePlan(remote)` (write-through); catch/null falls back to `loadStoredPlan()` |
| SYNC-01 | 02-02 | Quest statuses update on return from practice without page reload | ⚠️ PRESENT_BEHAVIOR_UNVERIFIED | Mechanism wired (refreshKey + focus/visibilitychange); runtime behavior needs human test |
| SYNC-02 | 02-02 | Status derived from GET /api/attempts only, no status store | ✓ SATISFIED | `api.attempts.list()` is the only source; no setDoc/updateDoc/localStorage status write in the hook |

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| None found | — | — | — | — |

No `TBD`, `FIXME`, `XXX`, `any` types, inline styles, stub returns, or hardcoded empty arrays found in the modified files. `StudyPlanPage.tsx` has `// eslint-disable-next-line react-hooks/exhaustive-deps` at line 114 — this suppresses the exhaustive-deps warning because `loadPlan` is a local function whose identity changes each render; the dep array `[user?.uid]` is the correct intentional dependency. This is an acceptable and common React pattern, not a debt marker.

### Human Verification Required

#### 1. Cross-Device Persistence (PERS-01)

**Test:** Sign in to Firebase Auth on Device A, open `/review`, generate a study plan. Then open Device B (or a second browser profile) signed in as the same user and navigate to any page with the sidebar open (or to `/review`).
**Expected:** Device B shows the same plan in the sidebar without generating a new one. Confirm the Firestore doc exists at `users/{uid}/study_plans/{YYYY-MM-DD}` in the Firebase Console.
**Why human:** Firestore connectivity, security-rules deployment, and multi-device session are live infrastructure that code analysis cannot exercise.

#### 2. Live Quest Status Refresh (SYNC-01 — behavior-unverified)

**Test:** With the sidebar open and showing a pending quest, click that quest to navigate to `/practice/:topicId?question_id=...`. Answer the question correctly. Then switch back to the original tab (or click back).
**Expected:** The quest's icon changes to ✓ and the "N / M complete" count increments — without any page reload.
**Why human:** The focus/visibilitychange wiring is present and correct in code, but whether the browser fires `window focus` or `document visibilitychange` on a same-app navigation return (React Router SPA transition) versus a true tab-switch is a runtime environment question.

#### 3. Anonymous Fallback (PERS-02 regression check)

**Test:** Sign out (or open a private/incognito window), generate a study plan, then hard-refresh the page.
**Expected:** Sidebar still shows the plan — loaded from localStorage, no Firestore error, no blank sidebar.
**Why human:** localStorage fallback is code-verified but a live browser run confirms the full anonymous path works after the Firestore changes without unintended side effects.

### Gaps Summary

No code gaps. All implementation artifacts are present, substantive, and wired. The single human_needed status is driven by one behavior-unverified truth (SC3 / SYNC-01 live-refresh runtime behavior) and the cross-device / anonymous regression checks that require a running Firebase project.

---

_Verified: 2026-06-27T15:10:00Z_
_Verifier: Claude (gsd-verifier)_
