# RRK Casebook — 10 Customer Cases

Rehearse **aloud**. For each case: 2 min clarify, 10 min design, 3 min summarize tradeoffs.

## Universal frame

Start every answer with:

> Let me first clarify the user workflow, success metric, data boundary, and unacceptable failure modes. Then I'll propose an MVP and harden it for production.

Then cover: business goal → users + stakeholders → data + integration → architecture → security/privacy → evaluation → latency/cost → rollout → product feedback.

---

## Case 1 — Slow Company Website *(from the recruiter PDF)*

**Prompt:** Your marketing manager complains that the new company website is slow. What would you do?

**Clarify first:**
- Slow for all users or specific geography / device / browser?
- Which pages?
- When did it start?
- Any recent release, campaign, traffic spike, third-party script, CDN change?
- What metric are they measuring: page load, TTFB, LCP, API latency?

**Split layers:**
- Browser / rendering
- CDN / static assets
- Network
- Backend APIs
- Database / cache
- Third-party pixels / scripts

**Evidence:**
- Real user monitoring, synthetic checks, CDN logs, API p95/p99, error rates.
- Trace one real slow request end to end.

**Mitigate first:**
- Rollback recent change if correlated.
- Disable heavy third-party script.
- Cache hot assets / API responses.
- Scale saturated service.

**Prevent:**
- Performance budget, SLO, release canary, alerting, runbook.

**Senior close:**

> I'd separate immediate customer impact from root cause. If a rollback or cache rule restores experience, do that first, then continue root-cause analysis from traces and release diff.

---

## Case 2 — Enterprise RAG Assistant for a Bank

**Prompt:** A bank wants an internal assistant over policies, product docs, and support tickets. Design it.

**Clarify:**
- Read-only Q&A or can it take actions?
- Which users and permissions?
- Data sources and freshness?
- PII / financial data?
- Accuracy requirement and unacceptable failures?
- Pilot success metric?

**Architecture:**
- Ingest from SharePoint / Drive / Jira / ticketing / database.
- Preserve ACLs and metadata.
- Parse, dedupe, chunk, embed.
- Store in Vector Search or managed RAG service.
- Query rewrite, hybrid search, rerank, metadata filter.
- Generate grounded answer with citations.
- Refuse when evidence is insufficient.
- Log question, retrieval, answer, latency, cost.

**Security:**
- User identity propagated to retrieval.
- Document-level ACL filtering.
- No sensitive data in prompts/logs beyond policy.
- Audit logs for every answer.

**Eval:**
- Golden question set from real support queries.
- Retrieval recall.
- Faithfulness.
- Citation correctness.
- Deflection / task-success rate.
- Human review of high-impact domains.

**Rollout:**
- Internal pilot with one department.
- Shadow against existing support answers.
- Canary expansion.
- Weekly error taxonomy.

**Product feedback close:**

> If I see repeated connector/ACL/chunking failures, I'd turn them into reusable ingestion templates and feature requests for the Google Cloud agent/RAG stack.

---

## Case 3 — Multi-Agent Claims Workflow

**Prompt:** An insurance customer wants agents to process claims: read documents, check policy, detect fraud risk, draft recommendations.

**Design:**
- Prefer workflow + specialized agents, NOT unconstrained autonomy.
- Intake agent extracts claim facts.
- Policy retrieval agent grounds coverage.
- Fraud-risk model/agent flags anomalies.
- Recommendation writer drafts decision with evidence.
- Human adjuster approves final action.

**Controls:**
- Typed schemas between steps.
- No automatic denial without human approval.
- Evidence citations required.
- Step limits + trace IDs.
- Low-confidence cases routed to review.

**Eval:**
- Historical claims replay.
- False-approval vs. false-denial cost separately.
- Human-adjuster agreement.
- Latency per claim.
- Audit completeness.

**Tie to your story:**

> This resembles my J&J contract-approval work. I'd avoid a hard gate initially and deploy recommendation-with-override until the risk is measured.

---

## Case 4 — MCP / OAuth Tool Integration

**Prompt:** A customer wants a Gemini agent to create tickets, query CRM, and update internal records. How do you integrate tools securely?

**Clarify:**
- Read vs. write tools.
- User-delegated vs. service-account actions.
- Existing identity provider.
- Approval requirements.
- Audit retention.

**Architecture:**
- Agent built with ADK or equivalent.
- Tools exposed through MCP servers or typed function-calling layer.
- OAuth / OIDC for delegated user access where actions depend on user permissions.
- Service account for backend-only tools with least privilege.
- Apigee / API gateway for policy, quotas, auth, logging.
- IAP or private access for internal app.
- VPC-SC / PSC when preserving network/data perimeter.

**Security controls:**
- Tool allowlist by task.
- Scope minimization.
- Validate arguments before tool execution.
- Human approval for writes.
- Idempotency keys.
- Audit log: user, prompt, tool, args, result, trace.
- Prompt-injection defense: retrieved content cannot grant tool permissions.

**Close:**

> The agent should never be more privileged than the user or workflow it represents.

---

## Case 5 — Eval Pipeline For Agentic Support

**Prompt:** A customer has a support agent that demos well but fails in production. Design evals and observability.

**Metrics:**
- Task success.
- First-contact resolution.
- Escalation correctness.
- Hallucination / unsupported answer rate.
- Policy violation rate.
- Tool success/failure rate.
- p95 latency.
- Cost per resolved ticket.

**Eval layers:**
- Unit tests for tools and prompt contracts.
- Golden conversation set.
- Regression suite for known incidents.
- LLM-as-judge with human calibration.
- Safety red-team prompts.
- Offline replay of production traces.
- Online canary with rollback threshold.

**Observability:**
- Trace conversation ID across model calls, retrieval, tool calls.
- Log retrieved chunks and citations.
- Track model version, prompt version, tool version.
- Dashboard by use case and customer segment.

**Tie to your story:**

> I used this pattern in the Sonnet→Haiku migration: DeepEval regression gate, canary, and pre-decided rollback criteria before moving traffic.

---

## Case 6 — Customer Data Readiness

**Prompt:** A customer wants GenAI, but their data is messy, duplicated, and spread across legacy systems. What do you do?

**Answer shape:**
- Do NOT start with model choice.
- Inventory data sources, owners, formats, freshness, permissions.
- Pick one business workflow and one slice of data.
- Build data-quality checks: missingness, duplicates, stale docs, inconsistent labels.
- Create a minimal canonical schema.
- Use metadata and ACLs from the start.
- Establish data refresh and ownership.
- Decide whether RAG, batch extraction, or structured pipeline is the right first step.

**Senior phrase:**

> Data readiness is usually the blocker that looks like a model problem. I'd make that visible early instead of hiding it behind a demo.

**Tie to J&J:**

> At J&J, the business rules were tribal knowledge. I paused the original predictive spec and reframed it as decision support with human override.

---

## Case 7 — Cost Reduction Without Quality Loss

**Prompt:** A customer's LLM workload is too expensive. How do you reduce cost without hurting quality?

**Steps:**
1. **Baseline:** request volume, token counts, model mix, latency, quality metric, failure cases.
2. **Segment:** simple classification/extraction vs. complex reasoning. High-value vs. low-value requests.
3. **Optimize:**
   - Prompt / context trimming.
   - Retrieval top-k tuning.
   - Cache repeated answers.
   - Route easy cases to cheaper model.
   - Batch / offline where possible.
   - Fine-tune / distill if stable repeated task.
4. **Validate:** golden set + canary; quality threshold before traffic shift; monitor cost per successful task.

**Your proof:**

> I've done this in production: Sonnet → Haiku through DSPy optimization (MIPROv2, GEPA, rule mining) and DeepEval gates — 50% p95 latency reduction and 3× cost reduction, quality held within one point on the golden set.

---

## Case 8 — Scale From 10K Internal to Millions External

**Prompt:** Your internal GenAI tool works for 10,000 employees. What changes before launching to millions of external customers?

**Differences:**
- Identity: internal SSO → external auth / tenant model.
- Abuse: prompt abuse, scraping, injection, fraud.
- Reliability: higher SLO, multi-region, incident response.
- Cost: model spend can dominate unit economics.
- Privacy: stricter consent, retention, deletion.
- Support: user-facing errors and escalation.
- Product: onboarding, feedback, analytics.

**Architecture changes:**
- Stateless services where possible.
- Queue async tasks.
- Rate limiting + quota enforcement.
- Tenant isolation.
- Regional deployment + failover.
- Stronger cache strategy.
- Model router (easy → cheap model, hard → strong model).
- Safety filters + abuse monitoring.
- Automated evals before every release.

**Close:**

> Internal launch proves utility. External launch requires product-grade reliability, abuse resistance, privacy posture, and cost controls.

---

## Case 9 — Production Agent Debugging

**Prompt:** The agent sometimes takes the wrong action even though each individual tool works. How do you debug?

**Approach:**
- Pull traces for failed sessions.
- Classify failure: wrong intent, wrong retrieval, wrong tool, bad tool arguments, stale state, permission issue, prompt injection, ambiguous user ask.
- Replay with fixed model/prompt/tool versions.
- Compare successful and failed trajectories.
- Add targeted regression examples.
- Tighten tool descriptions and schemas.
- Add policy gate before action.
- Add human review for uncertain writes.

**Senior phrase:**

> In agent systems, the bug is often in the interface between reasoning, state, and tools — not in any one component.

---

## Case 10 — Customer Executive Discovery

**Prompt:** A C-suite stakeholder says "We need GenAI across the business." How do you run discovery?

**Answer:**
- Ask for business objectives, not an AI wishlist.
- Identify top workflows by cost, volume, error, strategic value.
- Map stakeholders and data owners.
- Choose one use case with measurable ROI in 30–60 days.
- Define unacceptable risks.
- Align on pilot scope, success metrics, ownership.
- Bring engineering / security / legal early.

**Useful questions (say these aloud):**
- "Which workflow would you fund even if it were not AI?"
- "What metric would make the pilot a success?"
- "Which failure would be unacceptable?"
- "Who'll own this after the pilot?"
- "Where does the data live today?"

**Senior close:**

> I'd convert the executive ambition into a narrow pilot with measurable ROI, then use the pilot to discover repeatable platform patterns.

---

## Universal closing line (use at the end of every case)

> My MVP would prove the workflow on a narrow user group, with evals and traces visible from day one. I wouldn't over-automate early. Once quality, latency, safety, and cost hold in canary, I'd expand and turn repeatable integration and eval patterns into reusable assets or product feedback for the engineering team.

## Rehearsal protocol

For each case:
1. Say the case prompt aloud.
2. Speak the answer start to finish, timed. Target 12–15 minutes per case.
3. Don't look at the notes while speaking. Peek only if fully stuck.
4. End with the universal closing line.
5. Mark in your error log: what dimension did you forget? (Security? Eval? Rollout? Product feedback?)

By May 12 you should have rehearsed each of these at least twice. The second pass should feel easier than the first.
