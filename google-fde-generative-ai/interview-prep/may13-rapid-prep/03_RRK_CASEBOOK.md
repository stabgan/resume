# RRK Casebook - Practice Prompts And Answer Skeletons

Use this out loud. For each case: take 2 minutes to clarify, 10 minutes to design, 3 minutes to summarize tradeoffs.

## Universal Case Frame

Start every answer with:

> Let me first clarify the user workflow, success metric, data boundary, and failure modes. Then I will propose an MVP and harden it for production.

Then cover:

- Business goal.
- Users and stakeholders.
- Data and integration.
- Architecture.
- Security/privacy.
- Evaluation.
- Latency/cost.
- Rollout.
- Product feedback.

## Case 1 - Slow Company Website

Prompt:

> Your marketing manager complains that the new company website is slow. What would you do?

Why this matters: this is directly from the recruiter PDF.

Answer skeleton:

1. Clarify:
   - Slow for all users or specific geography/device/browser?
   - Which pages?
   - When did it start?
   - Any recent release, campaign, traffic spike, third-party script, CDN change?
   - What metric: page load, time to first byte, LCP, API latency?
2. Split layers:
   - Browser/rendering.
   - CDN/static assets.
   - Network.
   - Backend APIs.
   - Database/cache.
   - Third-party pixels/scripts.
3. Evidence:
   - Real user monitoring, synthetic checks, CDN logs, API p95/p99, error rates.
   - Trace one request end to end.
4. Mitigation:
   - Rollback recent change if correlated.
   - Disable heavy third-party script.
   - Cache hot assets/API responses.
   - Scale saturated service.
5. Prevention:
   - Performance budget, SLO, release canary, alerting, runbook.

Senior close:

> I would separate immediate customer impact from root cause. If a rollback or cache rule restores experience, do that first, then continue root-cause analysis from traces and release diff.

## Case 2 - Enterprise RAG Assistant

Prompt:

> A bank wants an internal assistant over policies, product docs, and support tickets. Design it.

Clarify:

- Read-only Q&A or can it take actions?
- Which users and permissions?
- Data sources and freshness?
- PII/financial data?
- Accuracy requirement and unacceptable failures?
- Pilot success metric?

Architecture:

- Ingest from SharePoint/Drive/Jira/ticketing/database.
- Preserve ACLs and metadata.
- Parse, dedupe, chunk, embed.
- Store in Vector Search or managed RAG service.
- Query rewrite, hybrid search, rerank, metadata filter.
- Generate grounded answer with citations.
- Refuse when evidence is insufficient.
- Log question, retrieval, answer, latency, cost.

Security:

- User identity propagated to retrieval.
- Document-level ACL filtering.
- No sensitive data in prompts/logs beyond policy.
- Audit logs for every answer.

Eval:

- Golden question set from real support queries.
- Retrieval recall.
- Faithfulness.
- Citation correctness.
- Deflection or task-success rate.
- Human review of high-impact domains.

Rollout:

- Internal pilot with one department.
- Shadow against existing support answers.
- Canary expansion.
- Weekly error taxonomy.

Product feedback:

> If I see repeated connector/ACL/chunking failures, I would turn them into reusable ingestion templates and feature requests for the Google Cloud agent/RAG stack.

## Case 3 - Multi-Agent Claims Workflow

Prompt:

> An insurance customer wants agents to process claims: read documents, check policy, detect fraud risk, and draft recommendations.

Design:

- Prefer workflow plus specialized agents, not unconstrained autonomy.
- Intake agent extracts claim facts.
- Policy retrieval agent grounds coverage.
- Fraud-risk model/agent flags anomalies.
- Recommendation writer drafts decision with evidence.
- Human adjuster approves final action.

Controls:

- Strong typed schemas between steps.
- No automatic denial without human approval.
- Evidence citations required.
- Step limits and trace IDs.
- Model confidence and disagreement routed to review.

Eval:

- Historical claims replay.
- False approval/false denial cost separately.
- Human-adjuster agreement.
- Latency per claim.
- Audit completeness.

Tie to your story:

> This resembles my J&J contract-approval work. I would avoid a hard gate initially and deploy recommendation with override until the risk is measured.

## Case 4 - MCP/OAuth Tool Integration

Prompt:

> A customer wants a Gemini agent to create tickets, query CRM, and update internal records. How do you integrate tools securely?

Clarify:

- Read vs write tools.
- User-delegated vs service-account actions.
- Existing identity provider.
- Approval requirements.
- Audit retention.

Architecture:

- Agent built with ADK or equivalent.
- Tools exposed through MCP servers or typed function-calling layer.
- OAuth/OIDC for delegated user access where actions depend on user permissions.
- Service account for backend-only tools with least privilege.
- Apigee/API gateway for policy, quotas, auth, logging.
- IAP or private access for internal app.
- VPC-SC/PSC when preserving network/data perimeter.

Security controls:

- Tool allowlist by task.
- Scope minimization.
- Validate arguments before tool execution.
- Human approval for writes.
- Idempotency keys.
- Audit log: user, prompt, tool, args, result, trace.
- Prompt-injection defense: retrieved content cannot grant tool permissions.

Good close:

> The agent should never be more privileged than the user or workflow it represents.

## Case 5 - Eval Pipeline For Agentic Support

Prompt:

> A customer has a support agent that demos well but fails in production. Design evals and observability.

Metrics:

- Task success.
- First-contact resolution.
- Escalation correctness.
- Hallucination/unsupported answer rate.
- Policy violation rate.
- Tool success/failure rate.
- p95 latency.
- Cost per resolved ticket.

Eval layers:

- Unit tests for tools and prompt contracts.
- Golden conversation set.
- Regression suite for known incidents.
- LLM-as-judge with human calibration.
- Safety red-team prompts.
- Offline replay of production traces.
- Online canary with rollback threshold.

Observability:

- Trace conversation ID across model calls, retrieval, tool calls.
- Log retrieved chunks and citations.
- Track model version, prompt version, tool version.
- Dashboard by use case and customer segment.

Tie to your story:

> I used this pattern in the Haiku migration: DeepEval regression gate, canary, and pre-decided rollback criteria before moving traffic.

## Case 6 - Customer Data Readiness

Prompt:

> A customer wants GenAI, but their data is messy, duplicated, and spread across legacy systems. What do you do?

Answer:

- Do not start with model choice.
- Inventory data sources, owners, formats, freshness, permissions.
- Pick one business workflow and one slice of data.
- Build data-quality checks: missingness, duplicates, stale docs, inconsistent labels.
- Create a minimal canonical schema.
- Use metadata and ACLs from the start.
- Establish data refresh and ownership.
- Decide whether RAG, batch extraction, or structured pipeline is the right first step.

Good phrase:

> Data readiness is usually the blocker that looks like a model problem. I would make that visible early instead of hiding it behind a demo.

Tie to J&J:

> At J&J, the business rules were tribal knowledge. I paused the original predictive spec and reframed it as decision support with human override.

## Case 7 - Cost Reduction Without Quality Loss

Prompt:

> A customer's LLM workload is too expensive. How do you reduce cost without hurting quality?

Steps:

1. Baseline:
   - Request volume, token counts, model mix, latency, quality metric, failure cases.
2. Segment:
   - Simple classification/extraction vs complex reasoning.
   - High-value vs low-value requests.
3. Optimize:
   - Prompt/context trimming.
   - Retrieval top-k tuning.
   - Cache repeated answers.
   - Route easy cases to cheaper model.
   - Batch/offline where possible.
   - Fine-tune/distill if repeated stable task.
4. Validate:
   - Golden set and canary.
   - Quality threshold before traffic shift.
   - Monitor cost per successful task.

Your proof:

> I have done this in production: Sonnet to Haiku through DSPy optimization and DeepEval gates, 50% p95 latency reduction and 3x cost reduction.

## Case 8 - Scale From 10K Internal Users To Millions External

Prompt:

> Your internal GenAI tool works for 10,000 employees. What changes before launching to millions of external customers?

Differences:

- Identity: internal SSO to external auth/tenant model.
- Abuse: prompt abuse, scraping, injection, fraud.
- Reliability: higher SLO, multi-region, incident response.
- Cost: model spend can dominate unit economics.
- Privacy: stricter consent, retention, deletion.
- Support: user-facing errors and escalation.
- Product: onboarding, feedback, analytics.

Architecture changes:

- Stateless services where possible.
- Queue async tasks.
- Rate limiting and quota enforcement.
- Tenant isolation.
- Regional deployment and failover.
- Stronger cache strategy.
- Model router.
- Safety filters and abuse monitoring.
- Automated evals before every release.

Good close:

> Internal launch proves utility. External launch requires product-grade reliability, abuse resistance, privacy posture, and cost controls.

## Case 9 - Production Agent Debugging

Prompt:

> The agent sometimes takes the wrong action even though each individual tool works. How do you debug?

Approach:

- Pull traces for failed sessions.
- Classify failure: wrong intent, wrong retrieval, wrong tool, bad tool arguments, stale state, permission issue, prompt injection, ambiguous user ask.
- Replay with fixed model/prompt/tool versions.
- Compare successful and failed trajectories.
- Add targeted regression examples.
- Tighten tool descriptions and schemas.
- Add policy gate before action.
- Add human review for uncertain writes.

Good phrase:

> In agent systems, the bug is often in the interface between reasoning, state, and tools, not in any one component.

## Case 10 - Customer Executive Discovery

Prompt:

> A C-suite stakeholder says, "We need GenAI across the business." How do you run discovery?

Answer:

- Ask for business objectives, not AI wishlist.
- Identify top workflows by cost, volume, error, and strategic value.
- Map stakeholders and data owners.
- Choose one use case with measurable ROI in 30-60 days.
- Define unacceptable risks.
- Align on pilot scope, success metrics, and ownership.
- Bring engineering/security/legal early.

Useful questions:

- "Which workflow would you fund even if it were not AI?"
- "What metric would make the pilot a success?"
- "Which failure would be unacceptable?"
- "Who will own this after the pilot?"
- "Where does the data live today?"

Senior close:

> I would convert the executive ambition into a narrow pilot with measurable ROI, then use the pilot to discover repeatable platform patterns.

## Rapid Mock Script

For any case, finish with this:

> My MVP would prove the workflow on a narrow user group, with evals and traces visible from day one. I would not over-automate early. Once quality, latency, safety, and cost hold in canary, I would expand and turn repeatable integration/eval patterns into reusable assets or product feedback.
