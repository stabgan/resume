# Google FDE GenAI — Interview Prep (Unified)

**Interview:** RRK (60 min) + Coding (60 min), **same day**.
**Format:** Virtual. Coding is in a **plain Google Doc** (confirmed by HR). No IDE, no execution.
**Target date:** May 13 (Wednesday). Recruiter cadence is Wed/Thu.
**Contact:** Priyanka Biswas (bipriyanka@google.com).
**Level:** Open between **L4 and L5**, decided by your interview performance. You are interviewing for a level, not just for a role.

This folder is the single source of truth for your prep. It replaces both earlier drafts (`may13-intensive-prep/` and `may13-rapid-prep/`), which are archived for reference. Best parts of both are merged here.

## Study Order (do this, in this order)

| Step | File | Purpose |
|---|---|---|
| 0 | [`00_EXECUTION_PLAN.md`](./00_EXECUTION_PLAN.md) | Day-by-day schedule May 2 → May 13, same-day logistics |
| 1 | [`01_SOURCE_OF_TRUTH.md`](./01_SOURCE_OF_TRUTH.md) | What's known about the loop, level, comp, evidence pillars, "Your Gaps Are Closeable" build plan |
| 2 | [`02_RRK_MASTER_GUIDE.md`](./02_RRK_MASTER_GUIDE.md) | The main spine — how to handle 60 min of RRK |
| 2.5 | [`11_BUILD_PLAN.md`](./11_BUILD_PLAN.md) | Six GitHub projects I ship in 11 days to close JD gaps (ADK, CrewAI, OAuth, RAG Engine, A2A, VPC-SC) |
| 3 | [`cases/`](./cases/) | Ten fully worked customer cases (2000-3000 words each). Start with [`cases/README.md`](./cases/README.md) |
| 4 | [`04_CODING_PROTOCOL.md`](./04_CODING_PROTOCOL.md) | Google-Doc whiteboard mechanics + 40-min protocol |
| 5 | [`05_CODING_PROBLEM_SET.md`](./05_CODING_PROBLEM_SET.md) | 22 core problems + 18 stretch + 5 OOP extensions (27 total in solutions) |
| 5a | [`05a_CODING_SOLUTIONS.md`](./05a_CODING_SOLUTIONS.md) | **Reference Python solutions** for all 27 problems (22 core + 5 OOP: MinStack, TimeMap, HitCounter, Logger, FileSystem). Use to check your own work after drilling on a blank Doc. |
| 6 | [`06_PYTHON_AND_OOP.md`](./06_PYTHON_AND_OOP.md) | Python fluency + OOP class-design templates |
| 7 | [`07_SYSTEM_DESIGN.md`](./07_SYSTEM_DESIGN.md) | Classic + ML + GenAI system design skeletons |
| 8 | [`08_GCP_AND_FDE_VOCABULARY.md`](./08_GCP_AND_FDE_VOCABULARY.md) | Google Cloud product map, decision trees, JD-language phrases |
| 9 | [`09_STORIES_AND_COMP.md`](./09_STORIES_AND_COMP.md) | 8 STAR stories + compensation script (including signing/relocation/multi-offer extensions) |
| 10 | [`10_INTERVIEW_DAY.md`](./10_INTERVIEW_DAY.md) | Day-of checklist, taper, back-to-back energy, **recovery scripts**, **self-eval rubric** for mock recordings |
| 11 | [`12_RAPID_FIRE_QA.md`](./12_RAPID_FIRE_QA.md) | **70 one-line Q&A probes** (RAG, agents, evals, cost, security, GCP, personal). Drill between main topics. |
| 12 | [`13_BEHAVIORAL_INDEX.md`](./13_BEHAVIORAL_INDEX.md) | **30 Google behavioral prompts** mapped to 13 stories (8 existing + 5 new career-arc stories) |
| 13 | [`14_NARRATED_WALKTHROUGHS.md`](./14_NARRATED_WALKTHROUGHS.md) | **Two full spoken transcripts**: Rate Limiter coding round (40 min) + Enterprise RAG RRK round (60 min) |
| 14 | [`15_VIDEO_STUDY_PLAN.md`](./15_VIDEO_STUDY_PLAN.md) | **DeepLearning.AI Pro + YouTube** plan. 3 official Google-Careers videos linked in the recruiter PDF (transcripts in `_transcripts/`) + 8 JD-aligned DLAI courses + Karpathy/3B1B/Stanford CS25. ~11h across 11 days. |
| — | [`_transcripts/`](./_transcripts/) | Extracted transcripts of the 3 official Google interview-prep YouTube videos linked in the recruiter PDF: systems design, coding demo, and "Life in App Engine Production" (the PDF's troubleshooting reference). Read once, cite in mocks. |
| — | [`_leetcode_google_tags/`](./_leetcode_google_tags/) | Raw LeetCode Google company-tag CSVs (thirty-days / three-months / six-months / all), pulled from the free public mirror. Same data as LeetCode Premium's "Google Last 30 Days" view. See `05_CODING_PROBLEM_SET.md` for the ranked gaps. |
| 15 | [`16_BLIND_INTEL.md`](./16_BLIND_INTEL.md) | **Harvested Blind intel** on Google FDE India comp (₹1.0-1.3 Cr L5 target), interview shape, culture signals, and updated comp negotiation script. |
| 16 | [`17_METRIC_DEFENSE.md`](./17_METRIC_DEFENSE.md) | **Hostile-interviewer drill**: every resume number (AUROC 0.95, 3x cost, 50% p95, 12M rows/$460, +12pts, 58% FP drop, Data Sentry) defended with denominator, baseline, eval design, leakage check, rollback criteria, failure cases. |
| 17 | [`18_ADVERSARIAL_MOCK_SCRIPT.md`](./18_ADVERSARIAL_MOCK_SCRIPT.md) | **30 RRK interruption prompts + 15 coding gotchas** organized by answer stage. Script these into May 9 and May 11 mocks so solo rehearsal has hostile-interviewer pressure. |

> **Note:** `03_RRK_CASEBOOK.md` is now the [`cases/`](./cases/) folder. The old single-file skeleton is archived at `../interview-prep/_archive/03_RRK_CASEBOOK_v1_skeleton.md`.

## Non-Negotiables (14 days)

1. **Sleep 7 hours minimum.** Recall collapses without it. Cramming on 5 hours loses you the round.
2. **Every coding problem practiced on a plain Google Doc.** No VS Code, no Cursor, no Copilot. Whether Google uses a plain Doc or a syntax-highlighted platform, practicing on the harder surface pays off both ways.
3. **Every RRK answer starts with clarification.** Never jump to architecture.
4. **One STAR story rehearsed aloud per night, standing, no notes.**
5. **No new material after May 11.** Taper into recall, not new inputs.

## The 6 Capabilities Google Grades FDEs On

From mining the official PDF + 10 live FDE postings:

| # | Capability | How the Round Tests It |
|---|---|---|
| 1 | Customer discovery + ambiguity navigation | RRK cases + behavioral |
| 2 | Production agentic + GenAI systems (ADK, Agent Engine, MCP, A2A) | RRK deep-dives |
| 3 | Enterprise integration (OAuth/OIDC, VPC-SC, IAP, APIs) | RRK system design |
| 4 | Eval, observability, LLM-native metrics (tokens/sec, $/req, traces) | RRK + behavioral |
| 5 | Python fluency + OOP under pressure on a Google Doc | Coding round |
| 6 | Field insight → product feedback loop | RRK close + behavioral |

Your evidence is strong on 1, 2, 4, 6. Capability 3 (GCP integration) is closed by the GitHub build plan in `11_BUILD_PLAN.md` (ADK, OAuth, RAG Engine, A2A, VPC-SC reference repos). Capability 5 (no-IDE Python muscle memory) is closed by drilling `05_CODING_PROBLEM_SET.md` on a plain Google Doc every day.

## Your 60-Second Opener

Memorize this and time it. Use some version of it in both rounds when asked to introduce yourself.

> I am a senior AI/ML engineer focused on production GenAI systems. At Gracenote I run a LangGraph multi-agent workflow with stateful checkpointing and HITL interrupts, and I recently migrated a 10K request/day generation service from expensive Sonnet to cheaper Haiku using DSPy optimization and DeepEval gates, cutting p95 latency 50% and cost per request 3x. Before that I spent two years embedded with J&J MedTech teams, turning undocumented approval heuristics into a production decision-support model that cleared legal, security, and CAB review inside their existing AWS footprint. The common thread is exactly what this FDE role asks for: enter a messy customer environment, build the connective tissue, evaluate it rigorously, and turn repeatable friction into reusable tools.

## The One-Sentence Answer to "What Is FDE?"

> An FDE is an embedded builder who turns frontier AI into production reality inside a customer's actual environment.

## Flagship story locator (when you need the actual words tonight)

Your 3 hot stories live in `09_STORIES_AND_COMP.md`. Exact locations:

- **J&J approval heuristics (ambiguity, hard-gate reframe)** — `09_STORIES_AND_COMP.md`, Story 2. Maps to behavioral prompts 6, 22, 4, 9 in `13_BEHAVIORAL_INDEX.md`.
- **Sonnet → Haiku migration (cost, eval discipline)** — `09_STORIES_AND_COMP.md`, Story 6. Numbers live in `01_SOURCE_OF_TRUTH.md` (p95 -50%, cost/req -3x, DeepEval+DSPy+GEPA). Case version in `cases/07_cost_reduction.md`.
- **AutoResearch + MCP flagship (field friction → tool, product feedback loop)** — `09_STORIES_AND_COMP.md`, Story 5. Do twice. This is the one that signals FDE.

One-liner for every round close: *"If I kept hitting the same integration / eval / data pattern, I'd capture it as a reusable module and send it back as a feature request to the Google Cloud engineering team."* Lives in `02_RRK_MASTER_GUIDE.md` and `10_INTERVIEW_DAY.md` cheat sheet.

## Emergency Minimum If Time Collapses

If Gracenote work blows up a day:
- Minimum daily: 1 RRK case (20 min) + 1 coding problem on Google Doc (30 min) + 1 STAR story rehearsal (10 min)
- Total: 60 minutes. Never skip these three.
