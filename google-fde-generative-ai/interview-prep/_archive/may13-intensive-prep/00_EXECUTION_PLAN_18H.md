# Execution Plan - 18 Hours/Day

This plan assumes extreme input capacity. It still preserves sleep because recall, pattern recognition, and verbal fluency collapse without it.

## Daily Operating System

Target day:

- **Sleep:** 6 hours.
- **Prep:** 15-18 hours.
- **Breaks/food/walk:** 1-3 hours.

Default full-day block:

| Time | Track | Output |
|---|---|---|
| 05:00-07:30 | DSA foundations | Read/recall one data structure or algorithm family |
| 07:30-10:30 | Coding drills | 4-6 problems, no execution |
| 10:30-11:00 | Break | Food/walk |
| 11:00-13:00 | Classic system design | One concept cluster + one design |
| 13:00-14:00 | ML system design | One ML lifecycle concept cluster |
| 14:00-14:30 | Break | Food |
| 14:30-17:00 | GenAI/FDE/RRK | One architecture case + Google Cloud mapping |
| 17:00-19:00 | Coding drills | 3-4 problems or one timed mock |
| 19:00-19:45 | Break | Food/walk |
| 19:45-21:30 | Behavioral/presentation | Stories, solution deep dive, customer objections |
| 21:30-22:30 | Recall | Closed-book whiteboard: formulas, templates, cases |
| 22:30-23:00 | Debrief | Error log and next-day queue |

If you start late on May 2, do the evening boot only. From May 3, go full intensity.

## The Sprint Philosophy

Days 1-4: foundations and breadth.

Days 5-8: depth and speed.

Days 9-10: mocks, synthesis, weakness repair.

Days 11-12: recall and taper without losing edge.

May 13: calm execution.

## May 2 - Boot And Orientation

Goal: replace the weak plan with the serious one and start fundamentals.

Outputs:

- Read `01_EVIDENCE_STRATEGY.md`.
- Read this file.
- Build an error log: `coding_errors`, `design_gaps`, `story_gaps`.
- DSA: arrays, hash maps, strings quick revision.
- Coding: Two Sum, Contains Duplicate, Valid Anagram, Group Anagrams, Valid Parentheses.
- RRK: read official PDF extract and role definition.
- Story: 60-second opener.

## May 3 - Core Data Structures + Distributed Systems Basics

DSA foundations:

- Arrays, strings, hash maps, sets, stacks, queues, linked lists.
- Big-O, amortized analysis, Python complexity.

Coding target:

- 12-15 easy/medium problems from arrays, hashing, stack, two pointers.
- Re-solve 3 without notes.

System design:

- Requirements, APIs, capacity estimates, latency, availability.
- Load balancers, caching, CDNs, databases, queues.

ML system design:

- ML lifecycle: data, labels, features, train, eval, serve, monitor.

RRK:

- Slow website troubleshooting.
- Cloud Run vs GKE vs App Engine.

Behavioral:

- J&J ambiguity story.
- Data Sentry ownership story.

## May 4 - Trees, Graphs, Search + Classic Design

DSA foundations:

- Trees, binary search trees, recursion.
- Graph representation, BFS, DFS.
- Topological sort.

Coding target:

- 12-15 tree/graph/search problems.
- Include Number of Islands, Clone Graph, Course Schedule, LCA, Level Order.

System design:

- Design URL shortener.
- Design rate limiter.
- Design notification/feed basics.

ML system design:

- Feature stores, training-serving skew, offline vs online features.

RRK:

- Customer migration from on-prem/AWS to GCP.
- Containers and inference pipeline basics.

Behavioral:

- Gracenote troubleshooting story.
- Hard-gate disagreement story.

## May 5 - Binary Search, Heaps, Intervals + RAG

DSA foundations:

- Binary search variants.
- Heaps/top-k.
- Intervals and sweep line.

Coding target:

- 12-15 problems.
- Include Search Rotated Array, Kth Largest, K Closest, Meeting Rooms, Merge Intervals, Median from Data Stream.

System design:

- Design search autocomplete.
- Design log ingestion/analytics.

ML system design:

- Search/retrieval/ranking architecture.
- Metrics: precision, recall, NDCG, MRR, calibration.

GenAI:

- Enterprise RAG from ingestion to eval.
- Chunking, metadata, ACLs, hybrid search, reranking, citations.

Behavioral:

- Simplifying ML to J&J stakeholders.

## May 6 - DP, Backtracking + Agents And Security

DSA foundations:

- Recursion tree, backtracking.
- 1-D DP, 2-D DP, knapsack patterns.

Coding target:

- 10-12 problems.
- Include Subsets, Combination Sum, Word Search, Coin Change, House Robber, Word Break, Longest Increasing Subsequence.

System design:

- Design file storage / Google Drive simplified.
- Design chat/messaging simplified.

ML system design:

- Model serving: batch, online, streaming, model registry, A/B testing, canary.

GenAI/FDE:

- ADK, Agent Engine, MCP, A2A.
- Agent failure modes.
- Tool-calling security.

Cloud/security:

- IAM, OAuth/OIDC, IAP, VPC-SC, PSC, Apigee.

## May 7 - OOP / Practical Python + Inference Pipelines

DSA/OOP foundations:

- Classes, invariants, mutability, heapq, deque, defaultdict, Counter.
- LRU cache, rate limiter, logger, file system, browser history.

Coding target:

- 8-10 OOP/practical problems.
- One 60-minute timed coding mock.

System design:

- Design API gateway.
- Design web crawler.

ML system design:

- Inference pipelines: preprocessing, model server, batching, GPU/CPU, autoscaling, queueing, fallback.

RRK:

- Containers, inference infra, GKE vs Cloud Run vs Agent Engine.
- "How would you build an inference pipeline?"

Behavioral:

- Haiku migration story.

## May 8 - Google Cloud / Enterprise Integration Day

DSA:

- Re-solve all misses from May 3-7.
- 6 fresh medium problems.

System design:

- Secure multi-region enterprise architecture.
- Cloud migration: on-prem/AWS to GCP.

ML/GenAI:

- Agentic customer support system.
- Evals and observability for agents.

Google Cloud:

- Vertex AI, Gemini, Agent Builder, Agent Engine, RAG Engine, Vector Search, BigQuery, Cloud Logging/Monitoring/Trace.
- VPC-SC, PSC, IAP, Apigee, IAM, Workload Identity Federation.

Behavioral:

- AutoResearch/MCP field-friction story.

## May 9 - Full Simulation 1

Morning:

- Coding mock 1: 60 minutes, no run.
- Coding mock 2: 60 minutes, no run.
- Review and re-code both.

Afternoon:

- RRK mock: slow website + enterprise RAG.
- System design mock: rate limiter or feed.
- ML design mock: recommendation/ranking or fraud detection.

Evening:

- Behavioral mock: 8 questions.
- Presentation drill: 7-slide J&J or Gracenote solution, spoken without slides.

## May 10 - Full Simulation 2

Morning:

- Coding mock: graph/DP.
- Coding mock: OOP/practical.
- Re-solve 10 old misses.

Afternoon:

- RRK mock: customer wants agent with tools in regulated environment.
- ML/GenAI mock: production eval/observability pipeline.
- Cloud mock: GKE vs Cloud Run vs Agent Engine; BigQuery vs Cloud SQL; security objections.

Evening:

- Compensation/level script.
- Googleyness/GCA hypotheticals.

## May 11 - Final Breadth Closure

DSA:

- Finish Must 60.
- Start/continue Should 40.
- Re-solve all red problems.

Design:

- Closed-book classic system design templates.
- Closed-book ML system design templates.
- Closed-book GenAI/RAG/agent templates.

RRK:

- 10 case rapid-fire.

Behavioral:

- 8 stories, 90 seconds each.

## May 12 - Recall Taper

No new deep topics.

Do:

- 2 coding warmups.
- 1 medium timed coding.
- Read `10_FINAL_CHEATSHEETS.md`.
- Rehearse opener, hot stories, and design frameworks.
- Sleep.

Do not:

- Start NeetCode hard rabbit holes.
- Read random Blind threads.
- Rewrite resume.
- Over-negotiate in your head.

## May 13 - Interview Day

Morning:

- 20 minutes: final cheatsheet.
- 20 minutes: easy coding warmup and one OOP skeleton.
- 10 minutes: opener and hot stories.
- Stop.

During interview:

- Slow down.
- Clarify.
- State assumptions.
- Make tradeoffs explicit.
- Keep customer/business impact visible.

## Daily Error Log

Maintain three lists:

### Coding Errors

Format:

- Problem:
- Pattern:
- What I missed:
- Correct invariant:
- Redo date:

### Design Gaps

Format:

- Prompt:
- Missing dimension:
- Better answer:
- One-liner to remember:

### Story Gaps

Format:

- Question:
- Story chosen:
- Weakness:
- Stronger ending:

The error log is more valuable than passive reading.
