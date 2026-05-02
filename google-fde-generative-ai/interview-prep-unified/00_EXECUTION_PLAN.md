# Execution Plan — May 2 to May 13

## The hard facts

- **Target:** May 13 (Wednesday). Two interviews, back-to-back, same day.
- **Interview 1:** RRK, 60 min.
- **Interview 2:** Coding, 60 min. Plain **Google Doc**, whiteboard-style. No IDE, no execution.
- **You have 11 days.** You also have a full-time Gracenote job.
- **You use AI agents for daily coding.** That's an asset for RRK and a gap for coding. This plan closes the gap.

## Daily structure

Two tiers. Pick per day based on workload.

### Minimum viable day (60 min)

For days when Gracenote is heavy.

| Block | Time | Action |
|---|---|---|
| A | 20 min | One RRK case from `cases/` folder, spoken aloud |
| B | 30 min | One coding problem on a blank Google Doc, timed |
| C | 10 min | One STAR story from `09_STORIES_AND_COMP.md`, standing, no notes |

Never skip these three. If you only did the minimum every day for 11 days, you'd still be ready.

### Full day (2.5 hours)

For mornings/evenings with runway.

| Block | Time | Action |
|---|---|---|
| A | 45 min | Two coding problems on Google Doc, one new + one re-solve |
| B | 75 min | One RRK case + read one reference doc (system design, GCP, ML design) |
| C | 30 min | Two STAR stories + verbal rehearsal of opener |

## The 11-day schedule

> **Parallel track — GitHub build plan.** In addition to the daily blocks below, I am shipping 4-6 small repos in 11 days per [`11_BUILD_PLAN.md`](./11_BUILD_PLAN.md): ADK hello-world, CrewAI-vs-LangGraph, OAuth/PKCE demo, Vertex AI RAG Engine, optional A2A and VPC-SC. Each is 2-5 hours. Evening work blocks (Sat May 3 AM, Sun May 4 AM, Mon-Wed May 5-7 PM) belong to building. These repos become concrete talking points for the RRK round, not overclaims.

### May 2 (Sat) — Foundation + environment setup

Goal: orient to the plan; set up the practice environment.

- [ ] Read `01_SOURCE_OF_TRUTH.md` end to end.
- [ ] Create a Google Doc titled `dsa-practice-may2026`. This is where you'll code for 11 days.
- [ ] Coding: **Two Sum** (LC 1). Think aloud, explain before typing.
- [ ] RRK: read `02_RRK_MASTER_GUIDE.md` once.
- [ ] Recall: rehearse the 60-second opener 3×.
- [ ] Logistics: confirm with Priyanka that May 13 works. Ask about interview platform (Meet + CoderPad or Meet + plain Doc).

### May 3 (Sun) — RRK spine + Python fluency

- [ ] Coding: **Longest Substring Without Repeating Characters** (LC 3).
- [ ] RRK: read `02_RRK_MASTER_GUIDE.md` again, slower. Highlight the discovery-to-deployment framework.
- [ ] Case: **Slow Website** (`cases/01_slow_website.md`). Spoken, 15 min.
- [ ] Python: skim `06_PYTHON_AND_OOP.md` imports + hash map / sliding window / BFS templates.
- [ ] Recall: STAR 1 (Data Sentry).

### May 4 (Mon) — Enterprise RAG

- [ ] Coding: **Group Anagrams** (LC 49).
- [ ] RRK: RAG section of `02_RRK_MASTER_GUIDE.md`. Memorize the RAG-done-properly checklist.
- [ ] Case: **Enterprise RAG Assistant** (`cases/02_enterprise_rag_bank.md`).
- [ ] Recall: STAR 2 (J&J ambiguity).

### May 5 (Tue) — Agents, MCP, A2A

- [ ] Coding: **Search in Rotated Sorted Array** (LC 33).
- [ ] RRK: agent section + GCP vocabulary from `08_GCP_AND_FDE_VOCABULARY.md`.
- [ ] Case: **Multi-Agent Claims Workflow** (`cases/03_multi_agent_claims.md`).
- [ ] Recall: STAR 5 (AutoResearch + MCP).
- [ ] Say aloud: "MCP connects agents to tools and data. A2A connects agents to other agents. ADK builds the agent. Agent Engine runs it in production." × 5.

### May 6 (Wed) — Security and customer perimeter

- [ ] Coding: **Valid Parentheses** (LC 20). Plus one OOP class skeleton from `06_PYTHON_AND_OOP.md`.
- [ ] RRK: security section of `02_RRK_MASTER_GUIDE.md`. Memorize OAuth/OIDC, IAP, VPC-SC, PSC, Apigee one-liners.
- [ ] Case: **MCP/OAuth Tool Integration** (`cases/04_mcp_oauth_tool_integration.md`).
- [ ] Recall: STAR 4 (hard-gate disagreement).

### May 7 (Thu) — Eval and observability (your differentiator)

- [ ] Coding: **Kth Largest Element** (LC 215).
- [ ] RRK: eval section. Read `07_SYSTEM_DESIGN.md` ML section.
- [ ] Case: **Eval Pipeline For Agentic Support** (`cases/05_eval_pipeline_agentic_support.md`).
- [ ] Recall: STAR 6 (Sonnet → Haiku migration). Practice the 60-second GEPA explanation.

### May 8 (Fri) — Scale and reliability

- [ ] Coding: **Number of Islands** (LC 200).
- [ ] RRK: scale section. Read `07_SYSTEM_DESIGN.md` classic section.
- [ ] Case: **10K Internal Users to Millions External** (`cases/08_scale_internal_to_external.md`).
- [ ] Recall: STAR 3 (Gracenote ingestion troubleshooting).

### May 9 (Sat) — Mock day 1

Goal: full simulation, both rounds back to back, because that's the real format.

- [ ] **Morning, 09:00–10:00:** Coding mock. 60 min. Pick `Course Schedule` (LC 207) or `Lowest Common Ancestor` (LC 236). Code only on a Google Doc. Think aloud the entire time. Record yourself.
- [ ] **15-min break.** Water, walk.
- [ ] **10:15–11:15:** RRK mock. 60 min. Pick 2 cases from casebook. Same setup — speak aloud, no notes, record.
- [ ] **11:15–12:15:** Debrief. Write 5 things you missed.
- [ ] **Afternoon:** Rest.
- [ ] Recall: one fresh STAR story (try "failure" if you haven't).

### May 10 (Sun) — Repair weak spots

No new material. Fix what surfaced on May 9.

- [ ] Re-solve the coding problem you got stuck on in the mock.
- [ ] Re-answer the weaker RRK case.
- [ ] Read aloud every template in `04_CODING_PROTOCOL.md`.
- [ ] First read of `10_INTERVIEW_DAY.md`.

### May 11 (Mon) — Mock day 2 + compression

- [ ] Coding: pick `Coin Change` (LC 322) or `Subsets` (LC 78). Google Doc, no-run.
- [ ] RRK mock: `Customer Data Readiness` (`cases/06_customer_data_readiness.md`) + `Cost Reduction` (`cases/07_cost_reduction.md`).
- [ ] Recall: full opener + "why Google/why FDE" + 1 hot story.
- [ ] **Switch to `10_INTERVIEW_DAY.md` as your primary reference.** Stop reading deep docs.

### May 12 (Tue) — Taper (DO NOT CRAM)

This is the most important day of prep. Less is more.

- [ ] Morning: one easy coding warmup (`Valid Parentheses` or `Binary Search`) on a Google Doc. 20 min.
- [ ] Read `10_INTERVIEW_DAY.md`.
- [ ] Rehearse 3 hot stories (J&J, Haiku, AutoResearch/MCP). 30 min.
- [ ] Logistics check: camera, mic, lighting, internet, backup hotspot, interview links, water, notebook, charger.
- [ ] **By 21:00: everything off. Sleep by 22:30.**

### May 13 (Wed) — Interview day

Calm retrieval only. The night before did the work.

- [ ] **30 min before round 1:** Read `10_INTERVIEW_DAY.md`. Nothing else.
- [ ] **10 min before:** Type a tiny Python class + one BFS loop on a blank Doc. Activates muscle memory.
- [ ] **5 min before:** Say the opener aloud once.
- [ ] Stop.
- [ ] Enter round 1.
- [ ] Between rounds: see `10_INTERVIEW_DAY.md` "Mid-Interview Reset" section.
- [ ] Round 2.
- [ ] Thank-you email to Priyanka within 2 hours.

## Same-day reality: how to survive two back-to-back rounds

Two 60-minute technical rounds in one day will drain you. Plan for it:

1. **Eat a proper breakfast 2+ hours before round 1.** Not sugary. Eggs, oats, protein. No heavy lunch carbs between rounds or you'll crash.
2. **Water before, not during.** If you drink mid-round you'll need a bathroom break you can't take.
3. **Schedule a 15–30 min break between rounds if the recruiter lets you pick.** If they're back-to-back, you get maybe 5 min of transition.
4. **Walk between rounds.** Even 5 min of moving resets cognitive load. Don't stare at a screen.
5. **Don't review technical notes between rounds.** Your brain can't absorb new input in 5 min; it *can* fumble recall if you try.
6. **Do review the opener once between rounds.** 30 seconds. That's it.
7. **Expect round 2 (coding) to feel harder than round 1** purely because you're depleted. Budget 1–2 extra minutes at the start of round 2 just to breathe and clarify the problem.

## If your Gracenote day job blows up

Default to **Minimum Viable Day** and keep going. Do not catch up with a 5-hour weekend grind — that trades sleep for volume, and sleep is what keeps pattern recognition alive.

## What NOT to do

- Don't grind 50 hard LeetCode problems. Not the bar. 22 medium done well > 50 hard skimmed.
- Don't build a new open-source project this week. The resume is set; Google has it.
- Don't rewrite the resume again.
- Don't negotiate comp in your head. Keep that for when Priyanka brings it up.
- Don't memorize Google product names beyond what's in `08_GCP_AND_FDE_VOCABULARY.md`. Breadth matters more than obscure names.
- **Do build the repos in `11_BUILD_PLAN.md` as scheduled.** One small repo per evening on ADK, CrewAI-vs-LangGraph, OAuth/PKCE, Vertex AI RAG Engine. They become talking points, not overclaims. Learning by building is the fastest path for me.

## Error log

Keep three running lists in a notebook or a plain text file:

### Coding errors
```
Problem: <LC number and name>
Pattern: <sliding window / BFS / etc>
What I missed: <specific invariant or edge case>
Redo date: <48 hours from now>
```

### RRK gaps
```
Case: <name>
Missing dimension: <e.g., I forgot to mention security boundary>
Better answer shape: <1 line>
```

### Story gaps
```
Question: <what was asked>
Story used: <which one>
Weakness: <lost the thread at minute 1:15>
Stronger ending: <1 line>
```

The error log is more valuable than re-reading these docs.
