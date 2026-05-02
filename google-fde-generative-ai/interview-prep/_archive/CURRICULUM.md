# The 2-Week Plan — Google FDE GenAI

Built for **14 days, starting after tomorrow's recruiter screen**. Simple and honest.

## The premise this plan is built on

1. You have ~2 weeks after tomorrow. Loop lands around **day 14–15**.
2. **DSA is rusty.** You haven't grinded LeetCode in a long time and you use AI agents for coding daily.
3. **Your AI-agent workflow is not a weakness. It's your superpower** for this specific role. FDE hiring is literally about field→product loops, which is what your Karpathy-AutoResearch-plus-kiro-cli-plus-Firecrawl-plus-steelmind-thinking setup already does.
4. The coding round could be classic DSA **or** debug-a-codebase-bug. We prep for both but lean into what you do naturally.
5. Customer scenario + Googleyness is **30% of the weight** — more than coding. This is where AI/ML candidates lose offers.

## What you'll actually have at the end of 14 days

- Fluency with Google Cloud agent stack (ADK + Agent Engine + A2A + Gemini tiers)
- 30 DSA problems solved on a plain text editor, by pattern
- 1 open-source project on GitHub that Google reviewers will see
- 10 STAR stories memorized, each under 90s
- A comp-negotiation script
- Enough mock-interview reps that the real loop feels familiar

## Ground rules

1. **Every day starts with 30 min DSA** — on a plain text editor, no IDE help, think aloud. Morning, when your brain is fresh.
2. **Every day ends with 30 min behavioral** — rehearse one STAR story aloud. Record yourself on days you have energy.
3. **Block 1 two-hour deep work slot per day** for Google Cloud learning / project building. Protect it.
4. **No grinding LeetCode on weekends** — weekends are for mocks and review only.
5. **Sleep 7–8 hours every night.** Cramming on 5-hour sleep destroys pattern recognition. This is not negotiable.

---

# The daily rhythm (template, applies Monday–Friday)

| Time | Block | What |
|---|---|---|
| 07:00–07:30 | DSA | 1 problem on plain Google Doc, no IDE. 30 min hard cap. |
| 07:30–09:00 | Deep work | Google Cloud stack OR open-source project |
| Day job | — | Work your Gracenote day |
| 19:00–20:00 | Deep work (optional) | Only if you're fresh; else skip |
| 20:30–21:00 | Behavioral | Rehearse one STAR story aloud |
| 21:00 | Done | Put it down. Wind down. |

Weekends: 4-hour mock-heavy block (Saturday morning), rest of day off. Full rest Sunday except 1-hr review of the week.

---

# Day-by-day — Week 1 (Monday–Sunday)

## Day 1 (Monday, tomorrow) — Recruiter screen + set up

- **09:30:** Recruiter call with Harish (use `CHEATSHEET_recruiter_call.md`)
- **Rest of day:** Your real Gracenote work. Don't prep.
- **Evening (30 min):** Set up two things so you're ready from Day 2:
  1. A blank Google Doc titled `dsa-practice` — this is where you'll code for 14 days, no IDE
  2. A local folder `adk-langgraph-bridge/` with `git init`, empty README.md
- **Night:** Send the post-call thank-you email to Harish. Sleep.

## Day 2 (Tuesday) — Arrays + Two Pointers

- **07:00 DSA:** `Two Sum` (LC 1). Plain Doc. 30 min.
- **07:30 Deep work (2 hrs):** [Google Cloud Agent Engine blog](https://cloud.google.com/blog/products/ai-machine-learning/build-and-manage-multi-system-agents-with-vertex-ai) + skim [ADK quickstart docs](https://google.github.io/adk-docs/). Install ADK. Run the "hello agent" sample.
- **20:30 Behavioral:** Rehearse STAR #1 (ownership beyond responsibility — J&J Data Sentry).

## Day 3 (Wednesday) — Sliding Window + ADK hands-on

- **07:00 DSA:** `Longest Substring Without Repeating Characters` (LC 3). Plain Doc.
- **07:30 Deep work:** Clone `adk-samples` repo. Run the **multi-agent sample**. Understand the 5 core ADK concepts: Agent, Tool, Flow, Session, Memory.
- **20:30 Behavioral:** STAR #2 (requirements changed mid-delivery — J&J CCP undocumented heuristic).

## Day 4 (Thursday) — Hashing + A2A + Gemini tiers

- **07:00 DSA:** `Group Anagrams` (LC 49). Plain Doc.
- **07:30 Deep work:** Read [A2A protocol announcement](https://developers.googleblog.com/en/a2a-a-new-era-of-agent-interoperability/) + [Vertex AI A2A docs](https://docs.cloud.google.com/agent-builder/agent-engine/develop/a2a). Know **A2A vs. MCP** in one sentence each. Also: memorize the Gemini 2.5 tier decision (Pro / Flash / Flash-Lite — when each).
- **20:30 Behavioral:** STAR #5 (converted field friction to a tool — AutoResearch harness). **This is your strongest story; rehearse it twice.**

## Day 5 (Friday) — Binary Search + Vertex AI Agent Engine architecture

- **07:00 DSA:** `Search in Rotated Sorted Array` (LC 33). Plain Doc.
- **07:30 Deep work:** Agent Engine vs. Cloud Run vs. GKE decision tree. Read the [MLOps Community piece on deploying ADK + IAP on Cloud Run](https://mlops.community/deploying-ai-agents-in-the-enterprise-without-losing-your-humanity-using-adk-and-google-cloud).
- **20:30 Behavioral:** STAR #7 (big bet on unproven tech — Claude 4.5 Haiku migration with DSPy MIPROv2 + GEPA + InferRules).

## Day 6 (Saturday) — Mock day 1

- **09:00–11:00:** Full 90-min mock interview on [Pramp](https://www.pramp.com/) or [interviewing.io](https://interviewing.io/). Pick "coding — medium." Code on a plain editor. Think aloud.
- **11:00–12:00:** Debrief — what went wrong, what pattern you missed, which phrases you said that were weak.
- **14:00–17:00:** Start building `adk-langgraph-bridge`. First commit: port the Gracenote supervisor/specialist pattern to ADK. Get it running locally.
- **Evening:** Rest. No prep.

## Day 7 (Sunday) — Rest + review

- **10:00–11:00:** Re-read [CANONICAL_JD.md](./CANONICAL_JD.md). Let it sink in.
- **11:00–12:00:** Review the 6 DSA problems you've done so far. Can you re-solve each one in under 20 minutes? If not, redo.
- **Rest of day:** Off.

---

# Day-by-day — Week 2 (Monday–Friday)

## Day 8 (Monday) — Trees/DFS + ADK deploy to Agent Engine

- **07:00 DSA:** `Lowest Common Ancestor` (LC 236). Plain Doc.
- **07:30 Deep work:** Deploy your `adk-langgraph-bridge` agent to Vertex AI Agent Engine. Get it running, send a test request, read the trace in Cloud Trace.
- **20:30 Behavioral:** STAR #3 (diagnosed a problem in unseen environment — first weeks at Gracenote, the 1500+ catalog pipeline takeover).

## Day 9 (Tuesday) — Graphs/BFS + customer-scenario practice

- **07:00 DSA:** `Number of Islands` (LC 200). Plain Doc.
- **07:30 Deep work:** Watch a 1-hour mock customer-scenario round on YouTube (search "Palantir FDE interview mock" or "Google FDE customer scenario"). Practice the pattern: clarify → break down → propose MVP → iterate.
- **20:30 Behavioral:** STAR #4 (disagreed with senior stakeholder).

## Day 10 (Wednesday) — Top K / Heap + GEPA paper

- **07:00 DSA:** `Kth Largest Element` (LC 215). Plain Doc.
- **07:30 Deep work:** Read the [GEPA paper](https://arxiv.org/abs/2507.19457) cover-to-cover. You cite it on your resume; defend it. Also: rehearse the 60-second "explain GEPA" pitch out loud 3 times.
- **20:30 Behavioral:** STAR #6 (simplified complex to non-technical audience — J&J MedTech approval workflow owners).

## Day 11 (Thursday) — Dynamic Programming + Open-source push

- **07:00 DSA:** `Coin Change` (LC 322). Plain Doc. *(DP is the one area to not skip; 1-D DP is fair game.)*
- **07:30 Deep work:** Write the README for `adk-langgraph-bridge`. Compare LangGraph patterns ↔ ADK patterns side-by-side. Include architecture diagram (mermaid is fine). Push to GitHub. Add to LinkedIn.
- **20:30 Behavioral:** STAR #8 (shipped with incomplete data — J&J undocumented heuristic → scoped ML spec).

## Day 12 (Friday) — Backtracking + mock 2

- **07:00 DSA:** `Word Search` (LC 79). Plain Doc.
- **19:00–21:00:** Second mock. This time pick **"system design"** on interviewing.io — practice designing an agentic system on GCP for a customer scenario. Think aloud. Use Vertex AI primitives by name.
- **Behavioral:** STAR #9 (a failure and what changed).

## Day 13 (Saturday) — Full dress rehearsal

- **09:00–10:00:** DSA mock (1 medium-hard).
- **10:00–11:00:** System design mock.
- **11:00–12:00:** Behavioral mock — have a friend ask you 5 random STAR-triggering questions.
- **14:00–15:00:** Review all 10 STAR stories. For each: can you tell it in 90s? If no, tighten.
- **15:00–16:00:** Re-read [CANONICAL_JD.md](./CANONICAL_JD.md) one more time.
- **Evening:** Off.

## Day 14 (Sunday) — Taper

**The single most important day of prep — do almost nothing.**

- **10:00–11:00:** Read [CHEATSHEET_interview_day.md](./CHEATSHEET_interview_day.md) (you'll create this on Day 13).
- **11:00–12:00:** Light: re-skim your resume out loud once, re-read GEPA abstract.
- **Rest of day:** Walk, sleep, eat well, hydrate. **No cramming.**

## Day 15 — Interview day

You're ready. Your brain needs rest and quick retrieval — not more input.

---

# The three deep-dive references

Go deeper on each of these as you hit them in the day-by-day plan:

| Topic | File |
|---|---|
| DSA pattern-first drill (all 30 problems + why each) | [`DSA_RECOVERY.md`](./DSA_RECOVERY.md) |
| Coding round protocol (Google Doc + debug-a-codebase) | [`CODING_ROUND_PROTOCOL.md`](./CODING_ROUND_PROTOCOL.md) |
| STAR stories — full scripts (10 stories) | [`STAR_STORIES.md`](./STAR_STORIES.md) |

---

# The one mandatory open-source project — `adk-langgraph-bridge`

**Effort:** ~8 hours distributed across Days 2–11.
**Why it's worth every hour:**

1. Google reviewers will Google you during the loop. Seeing a recent, public ADK project ticks the "knows Google tooling" box instantly.
2. It's your anchor artifact in Round 1 (AI/ML) — you can say "let me show you how I'd port my LangGraph Gracenote pattern to ADK" and pull up your own repo.
3. It closes your biggest technical gap (ADK hands-on) with a public proof.

**Scope:**
- Port one simplified LangGraph supervisor/specialist workflow from your Gracenote setup into ADK (Python)
- Deploy to Vertex AI Agent Engine
- README with side-by-side code comparison
- Mermaid diagram
- 1-page "trade-offs I noticed" section

**Nice to have (only if Days 11–12 run fast):** `fde-reference-architecture` — a README-only repo with mermaid diagrams of a customer-embedded agent deployment. No code required.

---

# Your AI-agent workflow is a selling point. Use it right.

You said you use AI agents for daily coding. **Don't hide this**. Here's when to lean in and when to hold back.

### LEAN IN (behavioral + customer scenario rounds)

- **STAR #5** (field-friction→tool) is literally this story. Tell it with specifics: kiro-cli, Firecrawl MCP, steelmind-thinking MCP, hypothesis logs, memory logs.
- When asked "how do you work day to day?": describe the AutoResearch harness. This signals exactly the "field insight → product feedback" behavior the JD calls for. Google wants FDEs who *are* the customer-zero for their AI tooling.
- When asked about GEPA / MIPROv2 / DSPy: "I drove technique selection through the AutoResearch loop — that's how we landed on Matryoshka with weighted dim slices." This is a flex.

### HOLD BACK (the live coding round itself)

- In the live coding round, you will not have access to an AI agent. This is the one environment where your daily workflow doesn't help — you'll be typing on a plain Google Doc while an interviewer watches.
- **This is why Days 2–12 of this plan exist** — rebuild enough muscle memory that you can solve a medium in 25–30 min cold, while thinking aloud.
- If you get stuck during the real interview, say: *"Let me walk through the edge cases out loud before I continue coding."* Interviewers love this; it's what strong engineers actually do.

### If asked directly "do you use AI tools for coding day to day?"

Honest, brief, professional:
> "Yes, heavily. I treat it like a staff engineer pairing with me — it handles boilerplate and scaffolding so I can spend my time on architecture, trade-offs, and edge cases. For this interview I've been practicing without it to make sure the fundamentals are sharp."

Don't apologize. Don't over-share. Move on.

---

# What's in the interview-prep folder now

| File | Purpose |
|---|---|
| `README.md` | Start here — routing + quick context |
| **`CURRICULUM.md`** (this file) | Day-by-day 2-week plan |
| `CANONICAL_JD.md` | The synthesized JD (read once, reference weekly) |
| `DSA_RECOVERY.md` | 30-problem pattern-first DSA recovery plan |
| `CODING_ROUND_PROTOCOL.md` | Google Doc mechanics + debug-a-codebase playbook |
| `STAR_STORIES.md` | All 10 STAR stories with full scripts |
| `CHEATSHEET_recruiter_call.md` | For tomorrow morning |
| `RESEARCH_SOURCES.md` | All cited sources |
| `CURRICULUM_6WEEK_archive.md` | Previous 6-week plan, kept for reference |

---

# If the loop lands in 1 week instead of 2

If Harish comes back fast and the loop is in 7 days, do this instead:

- **Day 1:** Recruiter call.
- **Days 2–3:** ADK hands-on + deploy `adk-langgraph-bridge` (skip the fancy README; just get it running).
- **Days 4–5:** 12 DSA problems (pick one per pattern, see `DSA_RECOVERY.md`).
- **Day 6:** Two mocks + 5 STAR stories.
- **Day 7:** Taper.

Everything else is cut.
