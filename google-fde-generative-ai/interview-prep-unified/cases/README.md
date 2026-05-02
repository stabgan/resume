# Case Studies — Rehearsal Index

Ten fully worked customer cases for the RRK (Role-Related Knowledge) round. Each case is 2000-3000 words, structured identically, and spoon-fed. I spend my time absorbing and practicing, not cross-referencing.

This folder replaces the old single-file `03_RRK_CASEBOOK.md` (archived in `_archive/`).

## How To Use

1. Read one case per day, out loud, from Section 1 (prompt) to the end.
2. Second pass: close the file, re-answer the prompt from memory in 3 minutes.
3. Mark gaps in the error log inside `00_EXECUTION_PLAN.md` ("RRK gaps" section).
4. On mock days (May 9 and May 11) re-answer a case without looking. Record yourself.

Every case ties back to at least one of the evidence pillars in `01_SOURCE_OF_TRUTH.md` (Gracenote Haiku migration, EmbeddingGemma, vLLM translation, J&J CCP, Data Sentry, published MCP servers, AutoResearch, partner catalog). If I cannot map a case to a pillar, I am not ready for that case.

## The 10 Cases

| # | File | Scenario | Primary evidence pillar | Likelihood |
|---|---|---|---|---|
| 1 | [`01_slow_website.md`](./01_slow_website.md) | Canonical Google prompt: "Your marketing manager complains the website is slow, what would you do?" | Observability instinct; cross-stack triage | HIGH (in recruiter PDF) |
| 2 | [`02_enterprise_rag_bank.md`](./02_enterprise_rag_bank.md) | RBI-regulated Indian bank wants a secure RAG assistant on internal policy docs | EmbeddingGemma fine-tune; Vertex AI RAG Engine | HIGH |
| 3 | [`03_multi_agent_claims.md`](./03_multi_agent_claims.md) | IRDAI-regulated insurer wants a multi-agent claims workflow; I argue workflow-over-agent | Gracenote LangGraph; HITL interrupts | HIGH |
| 4 | [`04_mcp_oauth_tool_integration.md`](./04_mcp_oauth_tool_integration.md) | SaaS wants an agent that uses Slack + internal APIs via MCP with OAuth/PKCE | Published MCP servers (`@stabgan/*`); Data Sentry Microsoft Graph OAuth | HIGH |
| 5 | [`05_eval_pipeline_agentic_support.md`](./05_eval_pipeline_agentic_support.md) | Support agent is "sometimes wrong," no one can measure it; build a 4-layer eval framework | Gracenote DeepEval + GEPA gates | VERY HIGH |
| 6 | [`06_customer_data_readiness.md`](./06_customer_data_readiness.md) | Healthcare customer wants GenAI but data is a mess; run a 4-week readiness sprint | J&J CCP data-cleaning playbook | MEDIUM-HIGH |
| 7 | [`07_cost_reduction.md`](./07_cost_reduction.md) | Workload too expensive, CFO alarmed; I pull 7 cost levers gated on evals | Gracenote Sonnet → Haiku migration (signature story) | VERY HIGH |
| 8 | [`08_scale_internal_to_external.md`](./08_scale_internal_to_external.md) | 10K internal users worked; now scale to millions of external customers | vLLM 12M translation at $460 on 4×L40S | HIGH |
| 9 | [`09_production_agent_debugging.md`](./09_production_agent_debugging.md) | Agent misbehaves in production; walk through a 7-class failure taxonomy | Gracenote LangGraph traces; AutoResearch harness | HIGH |
| 10 | [`10_exec_discovery.md`](./10_exec_discovery.md) | 30-min call with a CEO who wants GenAI but cannot name a use case | J&J customer-embed discovery motion | MEDIUM |

## Rehearsal Schedule (aligned to `00_EXECUTION_PLAN.md`)

| Date | Case | Pair with |
|---|---|---|
| May 3 (Sat) | Case 1 — Slow Website | STAR 1 (Data Sentry) |
| May 4 (Sun) | Case 2 — Enterprise RAG | STAR 2 (J&J ambiguity) |
| May 5 (Mon) | Case 3 — Multi-Agent Claims | STAR 5 (AutoResearch + MCP) |
| May 6 (Tue) | Case 4 — MCP/OAuth | STAR 4 (hard-gate disagreement) |
| May 7 (Wed) | Case 5 — Eval Pipeline | STAR 6 (Sonnet → Haiku) |
| May 8 (Thu) | Case 8 — Scale Internal to External | STAR 3 (Gracenote ingestion) |
| May 9 (Fri, Mock Day 1) | Pick 2 cases, back-to-back | Full RRK simulation |
| May 10 (Sat) | Weak spot from mock | Repair |
| May 11 (Sun, Mock Day 2) | Case 6 + Case 7 | Full RRK simulation |
| May 12 (Mon, taper) | Skim all 10, no new reading | Sleep |
| May 13 (Tue, interview) | None, calm retrieval only | — |

Cases 9 and 10 are covered during the May 9 and May 11 mocks by random selection.

## Structure Every Case Follows

Every case has these sections, in this order. I can skim by section number when I need a specific piece (discovery questions, architecture, risks) without re-reading.

1. The Prompt — exact interviewer phrasing
2. Customer Context — industry, size, stack, stakeholders, stakes
3. Discovery Phase — the 6 to 10 clarifying questions I ask before architecting
4. Framework / Diagnosis / Architecture — the core technical answer
5. Proposed Solution with GCP mapping
6. Evaluation Strategy — how I know it works
7. Security, Compliance, Data Governance
8. Deployment Plan — phases, timeline, resource asks
9. Risks and Mitigations
10. Cost Model — tokens, infra, headcount, one honest number
11. Success Metrics — leading and lagging
12. Closing Talking Points — the 60-second wrap
13. Expected Follow-up Questions with prepared answers
14. Evidence Pillar Ties — exact sentence to cite my resume
15. Words To Use (JD-aligned phrases)
16. Words To Avoid (AI-generated tells, vague corporate fluff)
17. One-Line Summary
18. Rehearsal Checklist

## Non-Negotiables

- Speak every case out loud at least twice before May 13.
- Every answer starts with clarification. Never jump to architecture.
- Always map GCP products (Agent Engine, Agent Builder, Vertex AI RAG Engine, Vector Search, IAP, VPC-SC, Secret Manager, Apigee) to the customer problem — not the other way around.
- Every case names one honest cost number and one honest risk.
- Every case closes with a product feedback point ("here is the friction that became a feature request"). That is the FDE loop.

## Cross-References

- Master RRK framework and STAR stories: `../02_RRK_MASTER_GUIDE.md`
- Evidence pillars + "Your Gaps Are Closeable" build plan: `../01_SOURCE_OF_TRUTH.md`
- GitHub repos I am building to close JD gaps: `../11_BUILD_PLAN.md`
- GCP product map and FDE vocabulary: `../08_GCP_AND_FDE_VOCABULARY.md`
- Day-of logistics and between-round reset: `../10_INTERVIEW_DAY.md`
