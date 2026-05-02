# Google FDE GenAI — Interview Prep (Unified)

**Interview:** RRK (60 min) + Coding (60 min), **same day**.
**Format:** Virtual. Coding is in a **plain Google Doc**, whiteboard-style. **No IDE, no execution.**
**Target date:** May 13 (Wednesday). Recruiter cadence is Wed/Thu.
**Contact:** Priyanka Biswas (bipriyanka@google.com).

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
| 5 | [`05_CODING_PROBLEM_SET.md`](./05_CODING_PROBLEM_SET.md) | 22 problems (must-do) + 18 stretch + OOP set |
| 6 | [`06_PYTHON_AND_OOP.md`](./06_PYTHON_AND_OOP.md) | Python fluency + OOP class-design templates |
| 7 | [`07_SYSTEM_DESIGN.md`](./07_SYSTEM_DESIGN.md) | Classic + ML + GenAI system design skeletons |
| 8 | [`08_GCP_AND_FDE_VOCABULARY.md`](./08_GCP_AND_FDE_VOCABULARY.md) | Google Cloud product map, decision trees, JD-language phrases |
| 9 | [`09_STORIES_AND_COMP.md`](./09_STORIES_AND_COMP.md) | 8 STAR stories + compensation script |
| 10 | [`10_INTERVIEW_DAY.md`](./10_INTERVIEW_DAY.md) | Day-of checklist, taper, energy management for back-to-back rounds |

> **Note:** `03_RRK_CASEBOOK.md` is now the [`cases/`](./cases/) folder. The old single-file skeleton is archived at `../interview-prep/_archive/03_RRK_CASEBOOK_v1_skeleton.md`.

## Non-Negotiables (14 days)

1. **Sleep 7 hours minimum.** Recall collapses without it. Cramming on 5 hours loses you the round.
2. **Every coding problem practiced on a plain Google Doc.** No VS Code, no Cursor, no Copilot. Exactly the interview environment.
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

## Emergency Minimum If Time Collapses

If Gracenote work blows up a day:
- Minimum daily: 1 RRK case (20 min) + 1 coding problem on Google Doc (30 min) + 1 STAR story rehearsal (10 min)
- Total: 60 minutes. Never skip these three.
