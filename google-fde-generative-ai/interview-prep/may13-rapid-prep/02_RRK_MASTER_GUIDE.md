# RRK Master Guide - Google FDE GenAI

RRK is not a quiz. It is a 60-minute judgment test: can you walk from ambiguous customer problem to production GenAI system, explain tradeoffs, and sound like someone Google can put in front of strategic accounts?

## The One Sentence

> An FDE is an embedded builder who turns frontier AI into production reality inside a customer's actual environment.

Say this once, then prove it with structure.

## The Default Answer Shape

Use this for almost every RRK prompt:

1. **Clarify business goal:** Who is the user, what decision/action changes, what ROI matters?
2. **Clarify constraints:** data sensitivity, latency, scale, compliance, integration, budget, rollout timeline.
3. **Propose MVP:** smallest useful system, not the final platform.
4. **Design architecture:** data, model, tools, orchestration, serving, auth, observability.
5. **Evaluate and operate:** quality, safety, latency, cost, traces, SLOs, rollback.
6. **Scale and productize:** reusable modules, customer enablement, field feedback to product.

Senior signal: do not start with "I would use Gemini." Start with the customer outcome and the risk envelope.

## The Discovery-To-Deployment Framework

### 1. Discovery

Ask:

- What task are users trying to complete?
- What is painful today: time, cost, error, compliance, revenue leakage, customer experience?
- Who owns the process: business owner, security, data platform, app team, legal, support?
- What data is available, where does it live, and who can grant access?
- What are the unacceptable failures?
- What does a pilot success metric look like?

Good phrase:

> Before proposing architecture, I would separate the business workflow from the model workflow. The model only matters if it changes an operational decision.

### 2. Prototype

Prototype only the risky parts:

- Retrieval quality if knowledge-heavy.
- Tool reliability if action-heavy.
- Latency/cost if high-volume.
- Safety/compliance if regulated.
- Human adoption if workflow-changing.

For a customer demo:

- Use real-ish data, not toy examples.
- Show one happy path and one failure path.
- Show observability early: traces, retrieved chunks, tool calls, confidence, cost.

### 3. Productionization

Production asks:

- Authentication and authorization.
- Data isolation and network boundary.
- Rate limits and quotas.
- Prompt/version management.
- Evaluation gates.
- Audit logging.
- Rollback.
- Human-in-the-loop for risky actions.
- Ownership after handoff.

### 4. Rollout

Rollout pattern:

- Internal alpha with 10-20 users.
- Golden task set and baseline.
- Shadow mode if actions affect customers.
- Canary by team/region/customer segment.
- SLO dashboards.
- Weekly decision review: expand, pause, rollback.

### 5. Feedback Loop

FDE-specific close:

> I would write the reusable patterns back as assets: connector template, eval harness, deployment checklist, and product gaps for the engineering team.

This is the role. Say it naturally.

## AI/ML Engineering

### LLM System Components

A production GenAI system usually has:

- Input normalization and policy checks.
- Retrieval or context assembly.
- Model selection and prompting.
- Tool calling or agent orchestration.
- Output validation and safety checks.
- Human approval for high-risk actions.
- Logging, traces, evals, and cost tracking.

### Model Selection

Use a tiered answer:

- **Gemini Pro class:** hard reasoning, complex multimodal tasks, high-value low-volume workflows.
- **Gemini Flash class:** default for production assistants where latency/cost matter.
- **Gemini Flash-Lite or smaller models:** extraction, classification, routing, high-volume cheap tasks.
- **Open/source or fine-tuned model:** when data control, cost, latency, or specialized domain matters.

Good phrase:

> I would not pick one model for the whole system. I would use a router: cheap deterministic components first, faster model for routine cases, stronger model for escalations.

### RAG Done Properly

RAG is not "vector DB plus LLM." Cover:

- Data connectors: GCS, Drive, SharePoint, Slack, Jira, databases, APIs.
- Ingestion: parsing, deduplication, ACL preservation, metadata.
- Chunking: semantic vs fixed-size, overlap, table handling, document hierarchy.
- Embeddings: model choice, refresh cadence, multilingual/domain behavior.
- Retrieval: hybrid search, metadata filters, reranking, top-k tuning.
- Grounding: cite sources, enforce answer from retrieved evidence.
- Evaluation: retrieval recall, answer faithfulness, task success, hallucination rate.
- Access control: document-level permissions at retrieval time.
- Operations: index freshness, drift, broken connectors, latency, cost.

Google Cloud vocabulary:

- **Vertex AI RAG Engine:** managed RAG workflow and connectors.
- **Vertex AI Vector Search:** scalable vector retrieval, including private endpoint patterns.
- **BigQuery:** structured analytics and grounding.
- **Cloud Storage:** document staging and batch ingestion.

### Fine-Tuning

Use fine-tuning when:

- You need consistent style or format.
- Domain language is specialized.
- You have enough high-quality examples.
- Prompting/RAG cannot meet quality or latency.
- You need smaller/faster model economics.

Do not use fine-tuning when:

- The facts change often.
- The problem is access to knowledge, not behavior.
- You lack clean labeled data.
- The risk can be solved with retrieval/evals/tooling.

Tie to your evidence:

> In my EmbeddingGemma work, the win came from better retrieval representation, hard negatives, temporal holdout, and Matryoshka slices. I would use that mindset before jumping to fine-tune a generator.

## Agentic Systems

### Agent vs Workflow

Use this distinction:

- **Workflow:** deterministic sequence with LLM calls in known places. Prefer this when the process is stable.
- **Agent:** model chooses tools/steps dynamically. Use when tasks vary and require planning.

Senior signal:

> I default to workflows for reliability and introduce agentic autonomy only where the variability justifies it.

### ADK, Agent Engine, MCP, A2A

Minimal definitions:

- **ADK:** code-first framework for building agents and multi-agent systems.
- **Agent Engine:** managed runtime for deploying, scaling, observing, and governing agents on Google Cloud.
- **MCP:** tool/data connection protocol. It lets an agent use external tools and context providers through a standard interface.
- **A2A:** agent-to-agent communication/interoperability pattern, useful when specialized agents need to collaborate across systems.

How to explain difference:

> MCP connects agents to tools and data. A2A connects agents to other agents. ADK builds the agent. Agent Engine runs it in production.

### Agent Failure Modes

Name these quickly:

- Wrong tool selected.
- Tool succeeds but data is stale.
- Tool returns too much context.
- Agent loops or over-plans.
- Hidden state becomes inconsistent.
- Prompt injection through retrieved content or tool output.
- User asks for action beyond permission.
- Cost explodes through repeated calls.
- Observability loses the chain of reasoning/tool calls.

Controls:

- Typed tool schemas.
- Least-privilege tool scopes.
- Allowlist tools per task.
- Step limits and timeouts.
- Human approval for writes.
- Trace every model call and tool call.
- Regression evals for known failure cases.
- Deterministic validators where possible.

## Operational Excellence

Discuss production in terms of SLOs and failure domains.

### Reliability

Questions:

- What must be always available?
- What can degrade gracefully?
- Is stale data acceptable?
- Is a wrong answer worse than no answer?

Patterns:

- Queue long-running jobs.
- Cache expensive retrieval or model outputs where safe.
- Use idempotency keys for actions.
- Retry transient failures with backoff.
- Circuit-break unreliable tools.
- Fall back from agent to search/manual escalation.

### Resilience

For model failures:

- Route to smaller/cheaper model for simple tasks.
- Route to stronger model for uncertain cases.
- Return "I do not have enough evidence" when grounding fails.
- Human review queue for high-risk cases.

For tool failures:

- Detect whether read or write action failed.
- Preserve trace and user intent.
- Avoid duplicate writes.
- Show actionable error and next step.

### Performance

Track:

- End-to-end latency.
- Model latency.
- Retrieval latency.
- Tool latency.
- Queue wait time.
- p50/p95/p99.
- Tokens in/out.
- Cost per successful task, not just cost per request.

Optimization order:

1. Remove unnecessary context.
2. Cache/reuse retrieval.
3. Use smaller model for routing/extraction.
4. Parallelize independent tool calls.
5. Stream response if useful.
6. Move heavy work async.
7. Fine-tune or distill only if the above is insufficient.

## Security, Privacy, Compliance

This is a differentiator for you because of J&J and Data Sentry.

### Core Principles

- Least privilege.
- Data minimization.
- Tenant isolation.
- Auditability.
- Explicit human approval for risky writes.
- Preserve customer data boundary.
- No secret in prompts/logs.
- Respect document-level ACLs in RAG.

### Google Cloud Vocabulary

- **IAM/service accounts:** identity and permissions.
- **OAuth/OIDC:** delegated user authorization and enterprise identity integration.
- **IAP:** identity-aware access to apps.
- **VPC Service Controls:** reduce data exfiltration risk around Google Cloud services.
- **Private Service Connect:** private connectivity to managed services and APIs.
- **Apigee:** API management, policies, quotas, auth, analytics.
- **Cloud Logging/Monitoring/Trace:** audit and operational visibility.
- **Security Command Center:** security posture and threat detection.

Good phrase:

> For a regulated customer, I would keep the agent near the data boundary instead of copying sensitive data into a new system. The integration design should preserve existing identity, network, and audit controls.

### Prompt Injection And Tool Poisoning

Cover:

- Treat retrieved text and tool outputs as untrusted input.
- Separate system instructions from user/document content.
- Do not allow documents to grant permissions.
- Validate tool arguments.
- Use policy checks before external actions.
- Log the evidence used for every answer/action.

## Scalability

PDF prompt: 10,000 internal users to millions external.

Use this ladder:

### 10K Internal Users

- Known identity.
- Controlled traffic.
- Smaller support surface.
- Internal data and policy.
- Can tolerate manual escalation.

### Millions External Users

- Multi-region availability.
- Strict abuse prevention.
- Strong quota/rate limiting.
- Tenant isolation.
- More languages/devices.
- Larger observability and support load.
- Stronger privacy/legal exposure.
- Cost becomes a product constraint.

Architecture changes:

- Stateless serving where possible.
- Async queues for long tasks.
- CDN/cache static assets.
- Regional failover.
- Tiered model routing.
- Stronger evaluation before rollout.
- Automated abuse and safety monitoring.

## Performance And Cost Optimization

Answer in units Google cares about:

- Cost per request.
- Cost per successful task.
- Tokens per request.
- Tokens/sec.
- p95 latency.
- Model mix.
- Cache hit rate.
- Retrieval top-k and chunk size.
- Tool call count.

Your strongest example:

> At Gracenote I moved a 10K request/day workflow from expensive Sonnet to cheaper Haiku using DSPy optimization and DeepEval regression gates. p95 latency dropped 50% and cost per request dropped 3x while quality held within one point.

General playbook:

1. Measure baseline.
2. Segment request types.
3. Route easy tasks to cheaper path.
4. Reduce prompt/context size.
5. Use eval gate before migration.
6. Canary.
7. Monitor cost and quality together.

## Troubleshooting

Use the PDF's slow website sample as canonical.

The structure:

1. Clarify symptom: slow for whom, when, where, how measured?
2. Establish scope: all users or segment, all pages or one path, recent deploy?
3. Split layers: client, CDN, network, backend, database, third-party, model/API.
4. Check metrics: latency percentiles, error rate, traffic, saturation.
5. Trace one request end to end.
6. Form hypothesis and test.
7. Mitigate first, then root cause.
8. Add prevention: SLO, alert, test, runbook.

Good phrase:

> I would first distinguish user-perceived latency from backend latency. A page can feel slow because of frontend assets, network, API fanout, database, or a third-party call.

## System Design

### Opening Questions

Ask:

- Who are the users?
- What are the top 2 use cases?
- Read-only or write actions?
- What data sources?
- What freshness requirement?
- What latency target?
- What compliance constraints?
- What scale now and in 12 months?
- What is the success metric?

### Architecture Skeleton

For most GenAI systems:

1. User/app entry point.
2. Auth and policy layer.
3. Orchestrator/workflow/agent.
4. Retrieval/data/tool layer.
5. Model layer.
6. Validation/safety layer.
7. Action layer if writes are allowed.
8. Observability/eval layer.
9. Admin/governance layer.

### Tradeoff Language

Use explicit tradeoffs:

- Agent autonomy vs deterministic workflow.
- Freshness vs latency.
- Larger context vs cost and distraction.
- Stronger model vs cost/latency.
- Fine-tune vs RAG.
- Human review vs automation speed.
- Private deployment vs managed-service speed.

## Consulting And Customer Communication

The interviewer will listen for whether you can operate with customers, not just code.

### Discovery Questions That Sound Senior

- "What would make this pilot a business success in 30 days?"
- "Which failure would make you shut it down?"
- "Who has authority to approve data access?"
- "Which team will own this after we leave?"
- "Can we observe the current workflow before designing the AI version?"
- "Do users need an answer, a recommendation, or an action?"

### Pushback Template

Use when the customer asks for unsafe automation:

> I understand the desire to automate end to end. Given the compliance risk, I would start with recommendation plus human override, measure precision and escalation rate, then graduate high-confidence cases to automation.

Tie to J&J hard-gate disagreement if asked.

### Demo Value

A good customer demo shows:

- The business workflow.
- The AI assistance.
- Evidence/grounding.
- Failure behavior.
- Audit trail.
- Metrics dashboard.

## Your 60-Second RRK Opener

Use this when asked to introduce your experience:

> I am a senior AI/ML engineer focused on production GenAI systems. At Gracenote I run a LangGraph multi-agent workflow with stateful checkpointing and HITL interrupts, and I recently migrated a 10K request/day generation service from expensive Sonnet to cheaper Haiku using DSPy optimization and DeepEval gates, cutting p95 latency 50% and cost per request 3x. Before that I spent two years embedded with J&J MedTech teams, turning undocumented approval heuristics into a production decision-support model that cleared legal, security, and CAB review inside their existing AWS footprint. The common thread is exactly what this FDE role asks for: enter a messy customer environment, build the connective tissue, evaluate it rigorously, and turn repeatable friction into reusable tools.

## If You Do Not Know A Product

Do not fake detail. Say:

> I have not deployed that exact product in production, but I understand the pattern. I would map it to identity, network boundary, observability, eval, and rollback requirements, then validate the product-specific mechanics with docs or a Google specialist.

This sounds better than overclaiming.

## Final RRK Checklist

Before May 13, you should be able to answer:

- How do you design enterprise RAG?
- When do you choose RAG vs fine-tuning?
- How do you secure an agent with tools?
- What is MCP vs A2A?
- How do you evaluate an agent?
- How do you reduce LLM cost without losing quality?
- How do you troubleshoot slow systems?
- How do you scale from internal pilot to external product?
- How do you handle customer ambiguity?
- What repeatable product feedback would you send back to Google?
