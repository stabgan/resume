# Case 09 — Production Agent Debugging
Tags: Agent Debugging, Observability, Root-Cause Analysis, Production Ops. Likelihood: HIGH.

## 1. The Prompt

"The agent sometimes takes the wrong action even though each individual tool works. How do you debug?"

This is a trap prompt. The phrase "each tool works" is the signal: the bug is not in any tool, it is in the seams between reasoning, state, arguments, and retrieval. My job is structured, evidence-driven debugging.

## 2. Customer Context

Anvil Finance deployed an agent three months ago that helps relationship managers prepare client reviews. It orchestrates three tools: Salesforce for CRM, Bloomberg for market prices, an internal research database for analyst notes. Each tool returns correct data in isolation. But the agent sometimes produces off reports. Wrong client in the header. Wrong portfolio name. Stale prices from last Friday. Client A's holdings leaking into Client B's draft. The CX lead wants a fix within a week and the RMs are losing trust. My job: find and fix without regressing the good paths.

## 3. Discovery Phase

Before I touch anything, I ask.

- When did this start? Model upgrade, prompt change, tool schema change, data migration?
- Severity: one percent of sessions, ten percent, fifty percent?
- What do RMs actually report? Three specific sessions with timestamps.
- Patterns by time of day, user cohort, session length, or tenant?
- Agent framework: LangChain, LangGraph, ADK, custom?
- Session state: in-memory per process, Redis, Firestore, Postgres checkpoint?
- Traces, tool-call logs, prompt logs available with retention?
- When was the last regression run and what was the golden set?
- Recent changes landed: prompt, model, tool description, tool schema, reranker?
- Current eval setup? My prior is that it is minimal.
- Before-and-after samples from a known-good window?
- Who owns the tools? Are Salesforce and Bloomberg behind MCP servers we control?

Until I have these, I am guessing. I tell the CX lead the first forty-eight hours is observation, not deploy.

## 4. The Diagnostic Framework. Seven Failure Classes

If every tool works in isolation, the bug lives in one of seven places.

1. **Wrong intent classification.** Agent misread the goal. Test: log user message to intent label, measure accuracy on a golden set of RM utterances.
2. **Wrong tool selection.** Intent right, tool wrong. Test: tighten tool descriptions, add few-shot disambiguators, ablate with a reduced allowlist.
3. **Wrong tool arguments.** Tool right, args wrong. Common: wrong client_id, wrong date range, wrong currency. Test: validate args against a schema before execution, log the arg generation step.
4. **Stale or wrongly scoped data.** Tool returned correct data from the wrong moment or filter. Test: freshness timestamps on retrieval, audit cache invalidation.
5. **Agent state corruption.** Session state leaks across users or conversations. Test: session isolation audit, verify every state read matches the current conversation_id.
6. **Context window overflow.** Too much retrieved, important facts truncated. Test: measure input token distribution per session, add a reranker.
7. **Prompt injection from retrieved content.** Analyst notes or client emails subvert the system prompt. Test: mark retrieved content as untrusted, delimit it, run a known injection suite.

I classify every failure into exactly one class. The distribution tells me where to spend the week.

## 5. MVP Investigation Plan, Day 1 to Day 3

No changes yet. Observe and classify.

Day 1. Pull one hundred failed sessions from the last thirty days. Sources: RM tickets, low CSAT thumbs, anomaly flags. For each, replay with a full trace. Tag each with one of the seven classes. If a session touches two, tag the earliest, because that is the upstream cause.

Day 2. Take the top class and go deep. If it is Class 4, stale data, my prior given the Bloomberg detail is Monday morning sessions after weekend price cache expiry. Check cache TTL, last-update timestamps on Salesforce holdings, whether the research database has a nightly sync window that overlaps early sessions. Formulate a concrete hypothesis.

Day 3. Test the hypothesis on a held-out failure set I did not use to generate it. This is the discipline from my AutoResearch harness: hypothesis, experiment, held-out evaluation, iterate. Prepare the fix and the eval gate.

## 6. Investigation Tools

Trace correlation. OpenTelemetry with GenAI semantic conventions on every agent step. Cloud Trace for the per-request span tree. Every span tagged with session_id, conversation_id, user_id, tenant_id, model_version, prompt_version, tool_version. Traces link to the user feedback record so I can pivot from a thumbs-down straight to the span.

Deterministic replay. Pin the model version, pin the prompt version, seed any randomness. Replay from stored inputs and compare. If they diverge, the environment changed. If they match, the bug is reproducible and I can bisect.

Log enrichment. Tool argument values logged with PII redaction via Cloud DLP. Retrieved chunk IDs logged, not chunks. Intermediate reasoning at debug level only, because chain-of-thought leaks PII and prompt structure.

Session state inspection. Dump Firestore or Redis keys for failing sessions and diff against a healthy window. Look for cross-session keys, mismatched user_id, keys that outlived their conversation. In LangGraph I inspect the checkpointer state by thread_id and confirm namespace keys are scoped correctly.

At Gracenote, when I took over ingestion for 1500 plus catalogs and 1.5 million records a month, I did not start with docs. I pulled the top twenty false-positive cases and traced each from source to final match. Temporal ambiguity was the pattern. I layered temporal heuristics and swapped XGBoost for LightGBM: 58 percent FP reduction at 97 percent precision. Same pattern here. Debug from real failures, not from architecture diagrams.

## 7. The "Each Tool Works" Trap

Common findings when every tool is individually correct.

- **Argument mismatch.** Tool 1 returns client_id as integer 123. Agent passes "client_id=123" when Tool 2 expects "clientId". The call succeeds with a wildcard match and returns plausible but wrong data.
- **Type coercion.** Tool 1 returns datetime with timezone. Agent flattens to a date string, Tool 2 interprets in UTC while the RM is in IST. Prices come from the wrong trading day.
- **Staleness and data races.** Tool 1 reads from a Redis cache warmed five minutes ago. Tool 2 reads live. The report cross-references inconsistent states.
- **Scope.** Tool returns a wider time range or broader filter than the agent assumed. The LLM silently accepts the first N rows.
- **Session state leakage.** Agent uses the prior conversation's retrieved context in the current query because memory was appended without being scoped to conversation_id.

Every one of these looks like "the agent is wrong" until you look at the seams.

## 8. Session State, the Common Culprit

When RMs overlap sessions on the same agent process, state leakage is my first suspect for the Client-A-in-Client-B symptom.

What I check. Is state keyed by user_id and conversation_id, or just one? Is state cleaned at session end or left to TTL? Is memory scope explicit in the framework? In LangGraph the checkpointer must use a namespaced thread_id per conversation. In ADK session boundaries must be declared, not implicit.

Mitigation. Add session_id to every log line and tool call header. Review every state access path. Add a read-time assertion: the state I am reading must carry the same conversation_id as the request I am handling, otherwise raise and alert. Cheap insurance.

My LangGraph production work uses a Postgres checkpointer with stateful resumption and HITL interrupts. I have seen what happens when thread_id is derived from the wrong source. The assertion above stops the next incident before it starts.

## 9. Deployed Fix Strategy

Fix by class.

- **Class 1 and 2, intent and tool selection.** Better tool descriptions, few-shot disambiguators, tool allowlist by user role. DSPy MIPROv2 compiles the few-shot sets from labeled examples.
- **Class 3, arguments.** Pydantic schema validator before tool execution. Reject and re-plan on failure instead of executing with a guess.
- **Class 4, stale data.** Freshness check on retrieval, bypass cache for price queries within the trading day, stamp every tool response with as_of time and surface it in the prompt.
- **Class 5, state corruption.** Session-id-scoped state, read-time assertion, nightly audit job that flags any key lacking a conversation_id.
- **Class 6, context overflow.** Reranker, cap retrieved tokens, log truncation events as a metric.
- **Class 7, injection.** Wrap retrieved content in untrusted delimiters, add a system prompt clause that retrieved content is data not instructions, run a known injection suite on every release.

Every fix updates the regression suite first. From my Sonnet to Haiku migration the scar tissue is clear: I do not ship prompt or model changes without a DeepEval regression gate.

## 10. The Fix Cadence

- **Day 4-5.** Implement fixes for the top one or two classes. Not more. Changing five things at once means I cannot attribute the result.
- **Day 6.** Regression suite. Confirm no regressions on previously healthy paths. Compare per-class failure rate on the replayed held-out set.
- **Day 7.** Canary at ten percent. Watch per-class failure rate, tool error rate, cost per session.
- **Day 8-14.** Expand to fifty then one hundred percent if metrics hold. Post-mortem with the CX lead, runbook updated.

## 11. Observability. What to Add for Future Debuggability

Instrument. OTel GenAI trace per agent step: reasoning, tool, response spans. Tag every trace with conversation_id, user_id, tenant_id, model_version, prompt_version, tool_version. Log retrieved context size in tokens and a truncation boolean. Per-tool latency and error rate. Session state read and write audit trail. Token cost per session. User feedback loop (thumbs, corrections).

Pipeline. Traces to Cloud Trace, structured logs to Cloud Logging with a sink to BigQuery for long-horizon analysis. Nightly job replays the golden set and writes per-class failure rate to a dashboard.

Dashboards. Per failure class over time. Per tool error rate. State leakage indicators (any session whose state access user_id does not match request user_id). Input token size distribution. Cost per session and cost per successful outcome.

Sampling. Full retention for flagged sessions, ten percent sample for baseline, purge at ninety days unless flagged.

## 12. Architecture

```
               RM (browser)
                   |
                   v
         +---------------------+
         |  Agent Orchestrator |   LangGraph, Postgres checkpointer
         |  (reason, plan,     |   thread_id = (user_id, conversation_id)
         |   act, reflect)     |
         +----------+----------+
                    |
                    v
         +---------------------+
         |    Tool Router      |   arg validator, retry policy
         +----+-----+-----+----+
              |     |     |
              v     v     v
        Salesforce Bloomberg Research
           MCP       MCP       MCP
              \     |     /
               \    |    /
                v   v   v
          OTel GenAI conventions
                    |
     +--------------+--------------+
     |                             |
     v                             v
 Cloud Trace                 Cloud Logging
     |                             |
     +-------------+---------------+
                   v
                BigQuery
                   |
                   v
         Nightly Eval Pipeline
         (DeepEval on golden set,
          DSPy MIPROv2 for prompt
          compilation)
```

Sessions live in Firestore, namespaced by user_id and conversation_id. The checkpointer enforces thread_id scoping. Every tool call is wrapped by a span and an arg validator. The eval pipeline replays a golden set nightly.

## 13. Tradeoffs

- **Full session replay vs partial.** Full gives deterministic reproduction but costs storage. Partial with seed and pinned versions is acceptable when outputs are stable. Default: full for flagged, partial for the sample.
- **More logging vs lean production.** Logging costs money and leaks risk. Enriched logs for ninety days, ten percent sample for baselines, purge intermediate reasoning at thirty days with role-based access.
- **Fix in prompt vs fix in code.** Prompt is cheap and fast but fragile and model-specific. Code is durable but slower. Prompt for disambiguation and tone, code for argument validation, session scoping, cache policy.

## 14. Failure Modes of the Debugging Process Itself

- **Assume too early.** Jumping to "it's the model" before looking at the trace. I force myself to classify one hundred sessions before forming a hypothesis.
- **Fix the symptom.** Catching an exception and returning a default is not a fix. It is a mute button.
- **Change multiple things at once.** Then I cannot attribute improvement. One fix, one canary.
- **Skip the regression test.** This is how my Haiku migration would have regressed without DeepEval.
- **Deploy without monitoring the specific metric the fix targets.** If I fix stale data, my dashboard needs a "stale data incidence" panel before the canary starts.

## 15. Tie to Evidence

- **Gracenote catalog takeover, 1500 plus catalogs and 1.5 million records per month.** Where I learned to debug from real failures. Top twenty FP cases traced, temporal ambiguity found, XGBoost swapped for LightGBM: 58 percent FP reduction at 97 percent precision. Same method here.
- **Sonnet to Haiku migration.** Taught me to gate every change on a DeepEval regression suite. I would not deploy any agent fix without the same gate.
- **LangGraph production.** Stateful checkpointing on Postgres with HITL interrupts. I know what session state leakage looks like in the checkpointer and how to prevent it with scoped thread_ids and read-time assertions.
- **AutoResearch harness.** Hypothesis log plus memory log plus held-out evaluation. That is the debugging discipline for this week. Keeps the investigation honest.

## 16. Follow-up Q and A

- **What if the logs are missing?** That is the first fix. Add OTel GenAI spans for a week, then debug.
- **How do you prevent this from happening again?** Seven-class taxonomy baked into the eval suite, one golden test per class, nightly replay, alert on any class over threshold.
- **Gemini versus Claude for the agent?** Depends on task. If I suspect model-specific failure, A/B with a traffic split and compare per-class failure rate.
- **Older LangChain version?** Plan an upgrade path, regression test on the new version, migrate behind a flag.
- **SLO for handoff rate?** Contextual. If baseline is five percent, alert at ten percent sustained over an hour.
- **Customer privacy in logs?** Redact PII with Cloud DLP before persistence, tokenize client identifiers, restrict access by role.
- **What if the fix breaks something else?** Regression suite catches most, canary catches the rest, rollback is a flag flip.
- **Which debugging tools?** OTel as the vendor-neutral base, LangSmith for LangChain stacks, Arize for broader analytics.
- **What if the agent loops?** Step counter, wall-clock timeout, hard stop with a typed error, metric to alert on.
- **Multi-tenant issues?** Per-tenant session scope, audit for cross-tenant leakage, tenant_id on every span and state key.
- **Non-reproducible bugs?** Statistical evidence, not reproduction. Sample size, confidence interval, before-and-after on the rate.
- **How do you explain this to the customer?** Data. Per-class rate today, fix hypothesis, eval gate, canary plan.
- **Runbook for a production agent anomaly?** Pull samples, classify by the seven classes, hypothesis on the top class, fix one thing, regression-gate, canary, post-mortem.

## 17. Red Flags to Avoid

- "Let me just retrain the model." No. Not without evidence it is a model problem.
- "We'll restart the agent." That is a mute, not a fix.
- "The customer is misusing it." If real RMs are misusing it, the product failed them.
- "That's just an edge case." Edge cases in a one-percent tail become the top complaint when usage scales.
- "We'll handle it in the next release." Not when CX is on fire and trust is leaking.

## 18. Senior Closing

If I kept hitting this pattern (production agent regressions from multi-tool interaction), I would package the seven-class failure taxonomy, the trace replay toolkit, and the session-state auditor as a reusable FDE module. Customers get a repeatable debugging playbook instead of a bespoke investigation every time. Product feedback to Google: Agent Engine could surface multi-tool-interaction failure classes as first-class dashboards. Today every customer builds this themselves, and every customer builds it slightly wrong. A canonical taxonomy in Agent Engine would raise the floor across the field.

## 19. 90-Second Recall Summary

The words "each tool works" are the diagnostic. The bug is in the seams. Seven classes: wrong intent, wrong tool, wrong args, stale data, state corruption, context overflow, prompt injection. Day 1: pull one hundred failed sessions and classify, not fix. Day 2: deep-dive the top class. Day 3: test hypothesis on held-out. Day 4-5: fix one or two classes, gated by DeepEval. Day 6: regression run. Day 7: canary at ten percent. Tools: OTel GenAI on Cloud Trace and Cloud Logging, BigQuery for long-horizon, Firestore sessions scoped by (user_id, conversation_id), LangGraph checkpointer with namespaced thread_id, DSPy MIPROv2 for compiled few-shot, DeepEval for the regression gate. Gracenote proved the method. Haiku proved the gate. LangGraph proved the state discipline.
