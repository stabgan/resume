# Case 03. Multi-Agent Claims Workflow

Tags: Multi-agent, Workflow vs Agent, Regulated Customer, HITL. Likelihood: HIGH (matches JD pattern).

## 1. The Prompt

"An insurance customer wants agents to process claims: read documents, check policy, detect fraud risk, and draft recommendations."

This is the prompt I expect in the 60-minute RRK round. The interviewer is checking whether I slam "multi-agent" and draw boxes, or scope the problem and pick the right tool. The senior move is to argue workflow first and reach for agentic patterns only where they earn their keep.

## 2. Customer Context

"Assume we are embedded with Stellaris Insurance, a mid-size general insurer in India. 15,000 claims per month, 80 adjusters across 3 regions, time-to-resolution 4.2 days with 2.1 on document review. Fraud team flags about 3 percent by hand. CTO wants to automate claims triage and drafting. Stakeholders: CTO on engineering, Head of Claims as business owner, CRO on compliance, IRDAI regulatory lead. Stack is Azure, Oracle DB, SharePoint, custom claims portal. Reasonable anchor?"

## 3. Discovery Phase

Before I design, I ask 10 to 12 clarifying questions, each with a stated assumption the interviewer can correct.

1. Business goal. Reduce time-to-resolution and lift throughput. Not replace adjusters.
2. Unacceptable failure. Auto-approving a fraudulent claim, or auto-denying a legitimate one.
3. Current workflow. Adjuster opens claim, pulls SharePoint docs, reads policy in Oracle, writes narrative, submits above threshold for supervisor sign-off.
4. Decision rights today. Adjuster under ₹2 lakh, supervisor above. Fraud team has parallel flag authority.
5. Data. Claim form (scanned), accident photos, medical reports, police FIR, repair estimates, prior claims history.
6. Integration surface. Portal REST APIs, Oracle JDBC with a reporting replica, SharePoint Graph API.
7. Regulatory. IRDAI wants traceable decisions, grievance timelines, 10-year audit. Every decision reconstructable.
8. Decision rights for the agent. Recommend only in v1. Auto-approval is a v3 conversation.
9. Migration. Keep Oracle and portal on Azure, move GenAI workloads to GCP as a focused beachhead, connect via PSC.
10. Timeline. Pilot in 60 days, one claim type, one region, 3 adjusters. Phased rollout over 6 months.
11. Data residency. India-only, asia-south1 or asia-south2.
12. Existing ML. Fraud team has a rules engine and a small GBM. We keep that asset.

## 4. Workflow vs Agent, the Senior Choice

The prompt says "agents" and the lazy reply is to draw a ReAct loop. I push back.

"A workflow is a deterministic DAG where I pick the next step. An agent is a loop where the model picks the next step. For a regulated insurer in v1, I want a workflow with model-powered nodes, not an autonomous agent. Five reasons."

- Reliability. Deterministic workflows are debuggable. Agents with hidden state are not. When a claim is wrongly denied and the CRO asks why, I point to a node.
- Compliance. IRDAI audit needs predictable traces. An agent that chose a different tool order on identical inputs fails audit.
- Cost. Agent loops explode on edge cases. A bounded DAG has a predictable per-claim cost I can quote to the CFO.
- Adoption. "The agent is thinking" collapses trust. "Step 2 of 4, policy check complete, 3 clauses cited" builds it.
- Rollback. I can swap the draft writer from Pro to Flash without touching the rest. With an opaque agent I roll back everything.

"I use agentic patterns where they earn their cost. Document understanding with tool use is one. Adjuster-side assistive chat is another. The spine of claims processing is a workflow."

## 5. MVP Proposal

Smallest useful system for a 60-day pilot.

- Phase 1 is a 3-step sequential workflow with a human approval node, not an autonomous multi-agent system.
- Step A, Document Intake. Document AI for OCR and layout, custom extractors for the claim form, Gemini 2.5 Flash for free-text normalization.
- Step B, Policy Check. Vertex AI Vector Search over policy docs, Gemini 2.5 Pro for coverage determination with forced citations.
- Step C, Recommendation Draft. Template-constrained draft from Gemini 2.5 Flash with a confidence score.
- Step D, human adjuster approves. Non-negotiable for v1. No writeback without approval.
- Fraud score. Separate LightGBM classifier, not an LLM. High-risk flag routes to senior adjuster before the draft is generated.
- Pilot cohort. 3 senior adjusters, auto property damage claims, one region. Target 1,000 claims over 4 weeks.

## 6. Full Architecture

```
┌──────────────┐     ┌─────────────────────────────────────────────┐     ┌──────────────┐
│ Claims Portal│────▶│        LangGraph Supervisor (Cloud Run)     │◀───▶│ Oracle (PSC) │
└──────────────┘     │                                             │     └──────────────┘
       │             │  ┌────────┐ ┌────────┐ ┌────────┐ ┌───────┐ │     ┌──────────────┐
       ▼             │  │Intake  │▶│Policy  │▶│Coverage│▶│Draft  │ │◀───▶│ SharePoint   │
┌──────────────┐     │  │spec.   │ │Retrieve│ │Determ. │ │Writer │ │     │ (Graph API)  │
│ Cloud Storage│◀────│  └────────┘ └────────┘ └────────┘ └───────┘ │     └──────────────┘
│ (CMEK)       │     │  ┌─────────┐ ┌────────┐ ┌────────┐ ┌──────┐ │
└──────────────┘     │  │Doc AI   │ │Vector  │ │Fraud   │ │HITL  │ │
       │             │  │OCR+Form │ │Search  │ │(LGBM)  │ │Gate  │ │
       ▼             │  └─────────┘ └────────┘ └────────┘ └──────┘ │
┌──────────────┐     └──────────────────────┬──────────────────────┘
│ Cloud DLP    │                            │
│ (redact PII) │                            ▼
└──────────────┘                  ┌──────────────────────┐
                                  │ BigQuery audit log   │
                                  │ Cloud Logging/Trace  │
                                  │ (immutable, 10-yr)   │
                                  └──────────────────────┘
```

- Intake. Document AI for OCR and form-field extraction, Cloud Storage with CMEK and 10-year retention.
- Policy Retrieval. Vertex AI Vector Search, metadata-filtered by coverage type and policy version. Re-embedded daily.
- Coverage Determination. Gemini 2.5 Pro with a forced-citation schema. Validator confirms cited IDs exist.
- Fraud Detection. LightGBM on claim amount, time since policy start, prior claim density, geography, repair shop risk. Calibrated probability plus reason codes.
- Orchestrator. LangGraph supervisor with specialist nodes. Portable to ADK for GCP-native.
- HITL node. Adjuster approval before any write.
- Writeback. Portal API call attaches recommendation, cited clauses, fraud score, confidence.
- Audit logger. Cloud Logging plus BigQuery with table-level policy, 10-year retention, CMEK.
- Observability. Cloud Trace across nodes, claim_id as correlation ID, model version and prompt hash as span attributes.

## 7. Agent Design, Depth

Failure modes and controls.

- Wrong tool selected. Typed tool schemas, allowlist per node, no shared tool pool.
- Tool returns stale data. Freshness check on policy version before each determination.
- Agent loops. Step counter in LangGraph state, hard stop at 10.
- Hidden state inconsistency. Explicit state machine, no implicit scratchpad, every transition logged.
- Prompt injection from a claim. Retrieved text tagged untrusted, system prompt isolates instructions from content, classifier filters override patterns.
- Over-privileged action. Least privilege per tool. Write actions require HITL.
- Cost explosion. Per-claim token budget, alert at 2x average, circuit breaker at 5x.

LangGraph specifics.

- Stateful Postgres checkpointer so adjusters can resume after a break.
- Deterministic replay for audit. Same claim_id, same inputs, same model version, same output.
- HITL interrupts. Draft Writer pauses for the adjuster UI to approve, reject, or edit before Writeback fires.

Pattern I ran at Gracenote, where I lifted no-touch approval from 30 to 40 percent with supervisor, specialists, and HITL interrupts.

## 8. Security and Privacy

- PII in claim documents. Cloud DLP redaction before embedding and before any LLM call.
- Adjuster identity via OIDC from the portal, logged on every span.
- Oracle via Private Service Connect, no public IP.
- VPC Service Controls perimeter around Vertex AI, Vector Search, Cloud Storage, BigQuery. Egress only to the portal and Oracle over PSC.
- CMEK on Cloud Storage, BigQuery, Vector Search. Keys in Cloud KMS with rotation.
- Retention. 10-year audit, Cloud Storage lifecycle and BigQuery retention set, legal hold capability.

## 9. Evaluation

Metrics.

- Agreement with senior adjusters on a gold set, reported as Cohen's kappa, not raw accuracy.
- False-approval rate, the most expensive failure, per claim type and fraud-flag band.
- False-denial rate, with a customer-complaint correlation.
- Time-to-draft, target p95 under 2 minutes.
- Cost per claim, broken into Document AI, embeddings, Flash, Pro, classifier.
- Fraud catch rate: precision and recall at production threshold, plus lift over the rules engine.

Golden set.

- 500 historical claims, stratified by outcome (approve, deny, partial, escalate), claim type, region, amount band.
- Labeled by senior adjusters, with blind relabeling by a second adjuster on 20 percent.
- Blind replay. Adjusters see only their own decision and the agent's draft. I compute where they agree and where they override.
- I run the harness in the style of my AutoResearch extension, with hypothesis logs, memory logs, and plan-then-execute.

## 10. Rollout

- Week 1 to 2. Shadow mode. Agent runs on every pilot claim, adjuster sees the draft but does not use it.
- Week 3 to 6. Reference mode. Adjuster uses the output as a reference while still writing the decision.
- Week 7 to 12. Draft-and-edit. Agent drafts, adjuster edits. Edit distance is the quality signal.
- Week 13 plus. Canary to confidence-gated auto-approval on low-risk claims. Under ₹50,000, no fraud flag, single-clause coverage, straight-through capped at 10 percent of volume.
- Never. Full auto-approval without a human in scope for v1.

Same augment-then-narrow pattern I used on J&J MedTech, where we shipped 0.95 AUROC decision support with human override and cleared legal, security, and CAB before automation was considered.

## 11. Tradeoffs

- Workflow vs agent autonomy. Workflow for v1 and v2. Agent only for v3, and only for a narrow loop like evidence gathering, not the decision.
- On-premise vs cloud. GCP for velocity, India-region only for residency. Oracle stays on the customer side via PSC.
- LLM fraud vs dedicated classifier. Dedicated classifier. LLMs produce uncalibrated confidence and resist fairness auditing. GBMs are calibrated, explainable per feature, already in the shop.

## 12. Failure Modes

- Document AI misreads a handwritten form. Fallback to human extraction, OCR confidence gate.
- Policy docs updated mid-flight. Re-embed daily, tag chunks with policy version, flag stale at retrieval.
- Coverage model hallucinates a clause. Validator checks cited IDs match retrieved chunks, else escalate.
- Fraud model drifts. Monthly recalibration, AUROC and KS drift alerts on a rolling window.
- Adjusters over-rely on the agent. Track override rate per adjuster. If it drops below a floor, rotate them into calibration.
- Integration drops during Oracle maintenance. Queue with exponential backoff, alert on depth, SLA-protect writeback.
- Adversarial prompt inside a claim. Input classifier filters injection patterns, system prompts isolated from retrieved content, tool-use gated on node.

## 13. Scale

At 150K claims per month, 10x growth.

- Tiered routing. Simple claims on the Flash path, complex on the Pro path, triaged by a lightweight classifier.
- Auto-scaling on Cloud Run for orchestrator and specialist nodes.
- Cost per claim matters. Pre-compute embeddings for common clauses, cache Flash outputs on identical redacted inputs, batch Document AI calls.
- Regional deployment. Active-active across asia-south1 and asia-south2 for DR, IRDAI residency intact.

## 14. Tie to My Evidence

- Gracenote LangGraph pattern: supervisor plus specialists plus HITL interrupts. I lifted no-touch approval from 30 to 40 percent with exactly this shape. I know where the checkpointer hurts, how to serialize state, how to measure the lift.
- J&J MedTech Contract Commitment Portal: recommendation-with-override, not a hard gate. Regulated environment, adjuster trust. Cleared legal, security, and CAB. Same playbook.
- AutoResearch harness for the eval loop: hypothesis logs, memory logs, plan-then-execute. How I systematically surface failure cases.
- Two MCP servers shipped to npm, so if the portal or Oracle need tool-surfaces across agents, I design those contracts cleanly.

## 15. Follow-up Q and A

1. "Why not let the agent take action directly?" Regulatory, trust, reversibility. IRDAI audit fails on non-deterministic decisions. Adjusters lose trust on silent writes. Reversing a wrongful denial is expensive.
2. "Adjuster union pushes back?" Frame as augmentation, not replacement. Adjusters are named reviewers. Publish time saved, not headcount reduced.
3. "How do you prevent the fraud model from discriminating?" Fairness audit pre-launch, disparate impact review per region and gender, protected-attribute sensitivity checks, monthly.
4. "Gemini 2.5 Pro deprecates?" Pinned model version per node, eval gate on upgrade, side-by-side scoring on the gold set before cutover.
5. "Draft quality?" Adjuster edit distance plus a short post-decision survey on time saved.
6. "Cost at 15K claims per month?" Flash path a few cents per claim, Pro path under a dollar, classifier negligible, Document AI the swing factor. 1,000 to 2,000 USD per month at pilot scale.
7. "Multi-language claims?" Vertex AI Translation for English-normalized inference, multilingual embeddings for retrieval, source-language fidelity in the final draft.
8. "Claim types beyond auto?" One new type per month after pilot. Each gets its own gold set and coverage prompts.
9. "LangGraph over ADK?" Team familiarity for v1. ADK is the GCP-native path. I would port once the contract is signed.
10. "SLO?" p95 draft latency under 2 minutes, 99.5 percent orchestrator uptime, 99.9 percent audit log durability.
11. "Debug a wrong answer?" Cloud Trace replay by claim_id, retrieved chunks logged, prompt hash and model version on the span. Reproducible in a notebook in minutes.
12. "Full autonomy in year 2?" Confidence-gated with continuous eval. Lowest-risk slice first, keep override live, publish a drift dashboard to the CRO.
13. "Fraud detection, LLM or not?" Not an LLM. Calibrated classifier, auditable features, fairness-testable, cheap.
14. "Regulator audits?" Full audit log in BigQuery, immutable, 10-year retention, CMEK, replay tool that reconstructs any decision from inputs, model version, and prompt hash.
15. "Bias in historical claims?" Reweighting on training, fairness metrics per protected group, human review when model and rules engine disagree beyond a margin.

## 16. Red Flags to Avoid

- "We would use an autonomous agent to process claims end to end."
- "The LLM will handle fraud detection."
- "We can turn off human review once the model is good enough."
- "Gemini is accurate enough."

Any of these and I have lost the round. Each signals poor judgment on regulated work.

## 17. Senior Closing

FDE product-feedback frame. "If I kept seeing this pattern, regulated customer, multi-step workflow with HITL, immutable audit, I would package the LangGraph supervisor, HITL checkpointing, and audit-immutable-logger as a reusable module. I would feed back to the Agent Engine team the pain of integrating with customer-hosted Oracle under VPC-SC and PSC. That is the FDE loop. Ship, observe, generalize, send back."

## 18. 90-Second Recall Summary

Stellaris Insurance, 15K claims per month, IRDAI-regulated. Pick workflow over agent for v1: audit, cost, trust, rollback. MVP is a 3-step LangGraph workflow. Document AI intake. Vector Search policy retrieval with Gemini 2.5 Pro coverage determination and forced citations. Flash-drafted recommendation. HITL approval before writeback. Fraud is a separate LightGBM classifier, not an LLM. Security is VPC-SC, PSC to Oracle, CMEK, Cloud DLP, BigQuery immutable audit for 10 years. Eval is a 500-claim stratified gold set with blind replay, kappa agreement, AutoResearch-style hypothesis logs. Rollout is shadow, reference, draft-and-edit, then confidence-gated canary. Scale tiers Flash and Pro paths with regional DR. Evidence: Gracenote supervisor plus specialists HITL lift 30 to 40 percent, J&J MedTech 0.95 AUROC with override cleared through CAB, AutoResearch harness, two MCP servers shipped. Close on product feedback to the Agent Engine team on VPC-SC integration pain.
