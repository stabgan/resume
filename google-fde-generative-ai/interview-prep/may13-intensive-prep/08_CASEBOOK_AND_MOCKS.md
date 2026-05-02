# Casebook And Mocks

Practice these aloud. The goal is not memorized answers; it is structured decomposition under pressure.

## Case Answer Skeleton

Use every time:

1. Clarify user/workflow.
2. Clarify success metric.
3. Clarify constraints and failure modes.
4. Propose MVP.
5. Design architecture.
6. Address security, evals, observability, cost, rollout.
7. State tradeoffs.
8. End with reusable product feedback.

## RRK Cases

### 1. Slow Website

Prompt:

> Marketing says the new company website is slow.

Must cover:

- Affected users, geography, device, browser.
- Recent deploy or traffic spike.
- Frontend, CDN, network, backend, DB, third-party.
- Metrics: LCP, TTFB, p95 API latency, errors.
- Trace one request.
- Mitigate first, root-cause second.

Strong line:

> I would separate user-perceived latency from backend latency before changing architecture.

### 2. Enterprise RAG For Bank

Prompt:

> A bank wants an internal assistant over policies, tickets, and customer docs.

Must cover:

- ACL-aware ingestion.
- PII and audit.
- Hybrid retrieval.
- Citations.
- Refusal when insufficient evidence.
- Eval: retrieval recall, faithfulness, citation correctness.
- Pilot with one business unit.

### 3. Tool-Calling Agent For CRM/Tickets

Prompt:

> Agent can query CRM, create tickets, and update records.

Must cover:

- Read vs write tools.
- OAuth delegated access.
- Least privilege.
- Tool schema validation.
- Human approval for writes.
- Idempotency.
- Trace tool calls.
- Prompt injection defense.

### 4. Multi-Agent Claims Workflow

Prompt:

> Insurance claims need document extraction, policy check, fraud risk, recommendation.

Must cover:

- Workflow before autonomy.
- Specialist agents or deterministic steps.
- Human approval.
- False approval vs false denial.
- Audit trail.
- Tie to J&J decision-support story.

### 5. Inference Pipeline

Prompt:

> Build a production inference pipeline for a GenAI model.

Must cover:

- Containerization.
- Preprocessing.
- Model server.
- Online vs batch.
- GPU/CPU.
- Autoscaling.
- Model registry.
- Canary.
- Monitoring.
- Cost/latency.

### 6. Cloud Migration

Prompt:

> Enterprise customer wants to migrate AI workload from on-prem/AWS to GCP.

Must cover:

- Workload inventory.
- Dependencies.
- Identity/network.
- Data migration.
- Security/compliance.
- Pilot.
- Cutover/rollback.
- Cost governance.

### 7. Cost Reduction

Prompt:

> LLM workload is too expensive.

Must cover:

- Baseline tokens/cost/latency/quality.
- Segment tasks.
- Smaller model router.
- Prompt/context reduction.
- Cache.
- Batch async.
- Eval gate.
- Canary.
- Tie to Haiku migration.

### 8. Scale 10K Internal To Millions External

Must cover:

- Identity changes.
- Abuse/rate limiting.
- Multi-region.
- Tenant isolation.
- Privacy.
- Support.
- Cost controls.
- SLOs.

### 9. Data Readiness

Prompt:

> Customer wants GenAI but data is duplicated, stale, inconsistent.

Must cover:

- Data inventory.
- Ownership.
- Quality checks.
- Canonical schema.
- ACL metadata.
- Pilot one workflow.
- Do not hide data problem behind demo.

### 10. Product Feedback Loop

Prompt:

> What field insight would you send back to product?

Must cover:

- Repeated customer blocker.
- Impact.
- Reusable artifact.
- Product feature request.
- Evidence from deployments.

Examples:

- Connector templates.
- Eval harness.
- Trace viewer.
- Tool permission policy.
- Reference architectures.

## Classic System Design Mocks

Do each in 45 minutes:

1. Rate limiter.
2. URL shortener.
3. Notification system.
4. Search autocomplete.
5. File storage / Drive.
6. Log ingestion/observability.
7. Web crawler.
8. API gateway.

For each, cover:

- Requirements.
- Scale.
- API/data model.
- Architecture.
- Bottleneck.
- Reliability.
- Security.
- Cost.

## ML / GenAI Design Mocks

Do each in 45-60 minutes:

1. Enterprise RAG.
2. Customer support agent.
3. Fraud detection.
4. Recommendation/ranking system.
5. Search/retrieval system.
6. Agent eval/observability platform.
7. Model serving/inference pipeline.
8. Fine-tuned embedding retrieval system.

## Coding Mock Rotation

Do at least 6:

1. Arrays/hash/sliding window.
2. Binary search/heap/interval.
3. Tree.
4. Graph.
5. DP/backtracking.
6. OOP/practical design.

Mock format:

- 5 min clarify.
- 30 min code.
- 10 min dry-run.
- 5 min complexity/tests.

## Presentation-Style Deep Dive

Even if no presentation round, prepare one solution like a 7-slide deck. It becomes your RRK backbone.

### Option A - J&J Contract Approval

Slides:

1. Customer problem and stakeholders.
2. Existing workflow and pain.
3. Data reality: undocumented heuristics.
4. Architecture.
5. Security/legal/CAB rollout.
6. Evaluation and metrics.
7. Result and reusable lesson.

### Option B - Gracenote GenAI Cost Migration

Slides:

1. Production workload.
2. Cost/latency pain.
3. Eval-gated migration strategy.
4. DSPy optimization.
5. Canary and rollback.
6. Result.
7. General reusable pattern.

### Option C - AutoResearch/MCP Field Tool

Slides:

1. Repeated research friction.
2. Agentic workflow.
3. MCP integrations.
4. Safety/verification.
5. Impact on EmbeddingGemma.
6. How it maps to Google ADK/Agent Engine.
7. Product feedback.

## GCA / Googleyness Hypotheticals

Practice:

1. Client expects impossible timeline.
2. Product limitation blocks customer.
3. Customer wants unsafe automation.
4. Project reassigned near completion.
5. You disagree with senior stakeholder.
6. Multiple urgent customers compete for your time.
7. You discover customer data cannot support promised model.
8. You shipped a demo but production fails.

Answer style:

- Clarify.
- Prioritize.
- Communicate transparently.
- Protect user/customer.
- Escalate appropriately.
- Own outcome.

## Mock Scoring Rubric

Score 1-5:

- Clarified before solving.
- Structured decomposition.
- Technical correctness.
- Tradeoffs.
- Security/privacy.
- Evals/observability.
- Cost/latency.
- Customer/business impact.
- Communication clarity.
- Reusable product feedback.

Anything below 4 goes into error log.
