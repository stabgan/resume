# Case 05 — Evaluation Pipeline for an Agentic Support System

Tags: Eval, Observability, LLM-native metrics, Production Debugging. Likelihood: VERY HIGH (this is core FDE work; the JD explicitly calls out accuracy, safety, latency, tokens/sec, and cost-per-request).

## 1. The Prompt

"A customer has a support agent that demos well but fails in production. Design evals and observability."

This is the prompt I want. It is the closest thing on the casebook to my day job at Gracenote. I migrated a production agent from Sonnet to Haiku with a DSPy optimizer stack and a DeepEval canary gate, held quality within one point of baseline on a 600-case golden set, cut p95 latency by 50 percent and cost per request by 3x. The senior move is not to reach for a framework. Slow down, insist on instrumentation before changes, and build a 4-layer eval stack the customer can own after I leave.

## 2. Customer Context

"Let me assume we are embedded with Mira Technologies, a B2C travel booking app in India, about 3M MAU. They shipped a GenAI support agent 6 weeks ago on LangChain plus Claude on a vendor platform. Demo sold the program. In production the CS Manager says 'something is off.' Answers wrong, agent contradicts itself across sessions, CS sees a 15 percent bump in escalations. CSAT fell from 4.2 to 3.6. Leadership is 10 days from rollback. I have 2 weeks. Stakeholders: CTO, Head of CS, Head of Trust and Safety, Product lead."

That paragraph sets scale, pain, stack, timeline. It signals I treat the escalation bump and CSAT drop as ground truth, not whether the demo was clean.

## 3. Discovery Phase

I ask about 12 questions and answer each with a stated assumption the interviewer can correct.

1. What "fails" means. I want 10 real complaint transcripts, not adjectives. Assume: "wrong refund policy," "agent forgot user was Gold tier," "cancellation window off by a day."
2. Metrics today. CSAT and deflection only. No model-level or retrieval metrics.
3. Deployment. LangChain on ECS behind an ALB, single Claude model, no version pinning.
4. Knowledge source. RAG over help center Markdown and 18 months of resolved tickets.
5. Prompt versioning. Ad hoc Notion. No git-tracked registry.
6. Regression testing. None. This is the gap.
7. Session state. Stateless per turn. Explains "contradicts itself."
8. Safety filters. Regex PII filter plus a generic system prompt. No jailbreak tests.
9. Test coverage. Zero unit tests on tool schemas, zero contract tests on routing.
10. Handoff logic. Keyword rule on "refund" or "complaint." No model confidence signal.
11. Latency measurement. App-level only. No per-step traces.
12. Retrieved chunk logging. None. So no one knows if retrieval or generation is the problem.
13. Model version. "claude-3-5-sonnet-latest." This is itself a bug.

Almost every complaint maps to "no observability, no evals, no memory, no pinning."

## 4. MVP Proposal: The 4-Layer Eval Framework

"Phase 1 is to instrument and observe, not to change the agent. The temptation is to rewrite prompts on day 1. That is how I ship a placebo."

- Layer 1, Operational. Latency, cost, error rate, handoff rate, retry rate.
- Layer 2, Quality (offline). Retrieval recall, faithfulness, citation correctness.
- Layer 3, Behavioral (offline). Policy adherence, tone, refusal correctness, safety.
- Layer 4, User-facing (online). CSAT, resolution rate, session continuity, sentiment.

Customers jump to Layer 4 and report CSAT dropped. Without Layers 1 to 3, no one can explain why.

## 5. Instrumentation (Days 1 to 3)

Deploy OpenTelemetry with GenAI semantic conventions, export spans to Cloud Trace, mirror structured logs to Cloud Logging, sink into BigQuery for SQL analysis.

Per request:

- correlation_id and conversation_id, linked to the CRM ticket.
- Model call: name, pinned version, prompt version hash, temperature, tokens in, tokens out, latency, cost.
- Retrieval: query, top-k chunks, source URLs, embedding distances, rerank scores.
- Tool call: name, input JSON, output JSON, latency, error status.
- Session state read and write events.
- User feedback signal (thumbs, plus free-text on escalation).

Three days of work, no agent changes. By end of day 3 the team can answer questions they could not on day 0, like "what fraction of wrong answers came with wrong retrieval."

## 6. Building the Golden Set (Days 4 to 7)

Highest-ROI activity on the project. "On the Haiku migration the 600-case golden set was the most valuable artifact, more valuable than the prompt itself."

- Pull 500 real production conversations from the last 30 days out of BigQuery.
- Stratify by outcome (resolved, escalated, abandoned), topic (refund, cancellation, booking change, loyalty), language (English, Hindi, Hinglish), user segment, and length.
- Add 100 known-failure cases from the complaint inbox.
- Hand to 3 CS domain experts, not engineers. Rate on 3 dimensions: correctness (1-5), faithfulness to help-center docs (1-5), tone and policy adherence (1-5).
- Compute Cohen's kappa. Target > 0.7. If below 0.5, the rubric is the problem; rewrite it.
- Final set: N = 600, triple-rated.

I flag my past failure because the interviewer tests calibration. "Early on I reported 100 percent pass rate on a friendly sample of 20 cases. Now I always state N and kappa, and refuse to quote a number if kappa is below 0.7. That discipline is why the Haiku migration held up in review."

## 7. Eval Layers in Depth

Layer 1, Unit tests on agent components. Tool schema validation. About 50 prompt contract tests (given X, route to Y) on every commit. Retrieval sanity tests with expected top chunks. Pydantic output validators in strict mode.

Layer 2, Regression suite. Every deploy replays the 600-case set. Fail gate: any dimension drops more than 1 point from baseline, or pass rate drops more than 2 points, deploy blocked. DeepEval canary pattern from the Haiku migration.

Layer 3, LLM-as-judge with human calibration. Judge prompt: "Given user question, retrieved docs, agent answer, rate faithfulness 1-5 with rationale." Gemini 2.5 Pro as judge, different family from the agent, reduces self-preference. 20 percent human sample, track kappa(judge, human), retire the prompt if it drops below 0.6. Biases tested: position bias (swap order, flag flips), verbosity, self-preference.

Layer 4, Safety red team. 50 adversarial prompts: prompt injection, jailbreak, PII extraction, off-topic coercion. Automated monthly. Human review on 10. Gate: 100 percent appropriate refusal.

Layer 5, Offline replay. Shadow-run the new version on the last 7 days of prod traffic. Diff against prod, hand diffs to the CS lead. Cheapest way to catch regressions before a canary.

Layer 6, Online canary. 5 percent traffic for 24 hours. Rollback: handoff up > 2 points, p95 up > 20 percent, CSAT down > 0.2. Automated, not a meeting.

## 8. Observability Dashboards

Slice by use case (refund, cancellation, booking change), customer segment, geography, language. Per-slice metrics on Cloud Monitoring:

- Latency p50, p95, p99.
- Tool call count per session (spikes mean a tool-loop bug).
- Retrieval hit rate: "retrieved at least one doc a human labeler calls relevant."
- Escalation and abandonment rates.
- Cost per successful task, not cost per request.
- Token in and out distributions, not means. Long tails kill the budget.
- Retry rate per step.
- Error classification: 5xx, 4xx, timeout, policy violation, schema validation failure.

## 9. Cost Tracking

On the Haiku migration I learned cost per request is the wrong number. A request that returns a hallucinated refund policy is not cheap; it is expensive through escalations and refunds issued in error. The right number is cost per successfully resolved session: total LLM spend divided by sessions that resolved without handoff and got positive feedback.

From there I route by difficulty. Easy intents like order status go to a small model. Hard intents like multi-turn cancellation with partial refunds go to a large model. The model router economic case gets written from the BigQuery table, not from vendor slides.

## 10. Failure Classification: The Root Cause Map

By day 10 I have scored the top 500 complaints against the golden set and classified each:

- Retrieval miss. Right doc exists, not retrieved. Fix: chunking, embedding, top-k, hybrid search.
- Generation miss. Right doc retrieved, answer wrong. Fix: prompt, model upgrade, RAG-fusion, chain-of-verification.
- Tool miss. Wrong tool called. Fix: tool description, few-shot, router training.
- Context overflow. Model drowns. Fix: rerank and trim, token budget.
- State inconsistency. Session state corrupted across turns. The "contradicts itself" complaint. Fix: stateful checkpointing, the LangGraph pattern I run at Gracenote.
- Cost spike. Long contexts, tool loops. Fix: per-session budget, loop limit.
- Latency spike. Slow retrieval or slow tool. Fix: circuit breaker, fallback, cache.
- Hallucination. Answer not grounded. Fix: output validator, forced citations, refusal prompt.

On Mira I would bet retrieval miss plus state inconsistency plus tool miss explain 80 percent of the pain.

## 11. Architecture

```
Prod agent
   |-- OTel GenAI spans --> Cloud Trace --------+
   |-- structured logs  --> Cloud Logging ------+--> BigQuery
   |-- feedback events  --> Pub/Sub ------------+
                                                |
Nightly Vertex AI Pipeline:                     |
  - golden-set replay                           |
  - eval layers 2, 3, 4                         v
  - scores --> Cloud Monitoring dashboards
                                                |
Deploy-time (CI/CD):                            |
  - unit + contract tests                       |
  - offline replay on last 7 days               |
  - canary at 5% with automated rollback        |
                                                |
Prompt registry (git) + model version pin + feature flags
```

Vendor-neutral on the agent side, Google-native on the eval and observability side. Bring your agent, we bring the eval spine.

## 12. Tradeoffs

1. LLM-as-judge versus human-only. Judges scale but carry bias. Use both, 20 percent human sample for kappa.
2. Cost of evals versus coverage. The 600-case set is expensive on every commit. Batch nightly, gate CI on a 60-case smoke set.
3. Pinning versus latest. Pin in production, canary new versions. "Latest" is an anti-pattern in high-stakes surfaces.

## 13. Specific Metrics With Targets

- Retrieval recall@5 > 0.85. Below that, rebuild the RAG stack.
- Faithfulness > 4.0/5 on the Gemini 2.5 Pro judge, calibrated to human kappa > 0.7.
- Citation correctness > 95 percent.
- p95 latency < 3s for read queries, < 8s for complex multi-tool queries.
- Cost per resolved session target 0.15 USD. Current unknown, measure first.
- Hallucination rate on numeric facts (prices, dates, policy thresholds) < 0.1 percent.
- Human handoff rate trending down week over week during pilot.
- CSAT back above 4.0 by end of pilot.

## 14. The 2-Week Action Plan

- Days 1-3: Instrument. OTel, Cloud Trace, BigQuery sink. No agent changes.
- Days 4-7: 600-case golden set. 3 CS annotators, triple-rated, kappa > 0.7.
- Days 8-10: Run eval layers 2 and 3. Classify top 500 failures. Identify top 3 buckets.
- Days 11-12: Implement top 3 fixes. Likely: session checkpointing, rerank plus top-k retune, output validator on numeric fields.
- Days 13-14: Canary at 5 percent with pre-decided rollback. Roll forward or back by end of day 14.

## 15. Tie to My Evidence

"This is the pattern I ran for the Sonnet-to-Haiku migration at Gracenote. DeepEval regression suite, canary gate, quality held within one point of baseline on a 600-case golden set. Cost per request dropped 3x, p95 dropped 50 percent, 3 adjacent teams adopted the pattern. I used DSPy MIPROv2 for instruction and demo search, and DSPy GEPA for prompt evolution on the holdout. When quality dipped I asked the diagnostic question first: retrieval or generation. If generation, re-compile with DSPy on the golden set rather than hand-edit.

Session inconsistency maps to work I already shipped. On Gracenote I run LangGraph with stateful checkpointing so multi-turn agents keep context. My AutoResearch extension keeps hypothesis and memory logs so a run is reconstructable. My EmbeddingGemma fine-tune shaped how I think about retrieval eval: temporal holdout plus leakage audit, otherwise recall-at-k looks beautiful and means nothing."

## 16. Follow-up Q&A

- Non-deterministic outputs. Temperature 0 for evals, or 3 samples with 2-of-3 consensus.
- Position bias on LLM-as-judge. Randomize order, position-swap audit monthly, 20 percent human sample.
- Who builds the golden set. CS domain experts, not engineers. Track kappa.
- No historical logs. Synthetic questions from the help center plus scripted scenarios, ship instrumentation, iterate from week 2.
- Cost of evals. Batch nightly, gate CI on 60-case smoke subset, monthly budget line.
- When to upgrade models. Canary the larger model on a subset, decide on cost per resolved session.
- No humans to annotate. Gemini 2.5 Pro judge plus spot-check, build a 2-person labeling team by month 2.
- Multi-turn eval. Conversation level, not turn level. Coherence metric across turns.
- Handoff rate target. Trend matters more than absolute.
- Refuse versus answer. Confidence threshold plus refusal prompt. Track refusal rate; an agent that refuses everything is useless.
- Session coherence. "State exists and was read on turn 2 or later." Sample 50 sessions per week.
- More expensive but better model. Cost per successful task. A 2x more expensive model resolving 30 percent more sessions is cheaper.
- Debugging a complaint. Pull by correlation_id, replay the trace, isolate the failing layer, write a golden-set case from it.
- Frameworks. DeepEval, Arize Phoenix, DSPy, OpenTelemetry GenAI semantic conventions.
- Judge model choice. Different family from the agent. Claude agent, Gemini 2.5 Pro judge. Test for family bias.

## 17. Red Flags I Avoid

- "We will just add more prompts."
- "Gemini will handle it."
- "Customer should use the fallback when it fails."
- "We will fix it after launch."
- "Quality is subjective."

Each is what a junior says 20 minutes in. Each is what the interviewer is listening for.

## 18. Senior Closing

If I keep hitting this pattern across customers I would package the 4-layer framework as a reusable FDE module: golden-set builder, LLM-judge harness with kappa tracking, canary gate tied to deploy, standard OTel GenAI span schema. I would feed back to Google the specific gaps between OTel GenAI semantic conventions and Vertex AI agent tracing, since that is where the next round of platform work lives. The outcome I want on Mira is boring in the right way: CSAT back above 4.0, handoff rate trending down, rollback button not pressed, an eval suite the CS team can run after I leave.

## 19. 90-Second Recall Summary

Mira demo-passed and prod-failed with no evals, pinning, session state, or traces. 2-week plan: days 1-3 instrument with OTel, Cloud Trace, BigQuery; days 4-7 build a 600-case golden set with 3 CS annotators at kappa > 0.7; days 8-10 run the 4-layer eval stack and classify failures; days 11-12 fix the top 3 (retrieval, session state, output grounding); days 13-14 canary at 5 percent with pre-decided rollback. Layers: operational, quality offline, behavioral offline, user-facing online. Judge with Gemini 2.5 Pro, pin models, track cost per resolved session, gate deploys on the golden set. Same pattern as my Sonnet-to-Haiku migration at Gracenote where I cut p95 by 50 percent and cost by 3x at one point of baseline. Ship the eval spine, then change the agent.
