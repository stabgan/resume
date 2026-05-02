# RRK Master Guide

60 minutes. Not a quiz — a judgment test. Can you walk from ambiguous customer problem to production GenAI system, explain tradeoffs, and sound like someone Google puts in front of strategic accounts?

## The One-Sentence Identity

> An FDE is an embedded builder who turns frontier AI into production reality inside a customer's actual environment.

Say it once, then prove it with structure.

## The Default Answer Shape (use it on every RRK prompt)

1. **Clarify business goal:** who is the user, what decision/action changes, what ROI matters?
2. **Clarify constraints:** data sensitivity, latency, scale, compliance, integration, budget, rollout timeline.
3. **Propose MVP:** smallest useful system, not the final platform.
4. **Design architecture:** data, model, tools, orchestration, serving, auth, observability.
5. **Evaluate and operate:** quality, safety, latency, cost, traces, SLOs, rollback.
6. **Scale and productize:** reusable modules, customer enablement, field feedback to product.

Senior signal: **do not start with "I would use Gemini."** Start with the customer outcome and the risk envelope.

Opening line that works for 90% of prompts:

> Let me first clarify the user workflow, success metric, data boundary, and unacceptable failure modes. Then I'll propose an MVP and harden it for production.

## Discovery — the foundation of every FDE answer

Ask these questions out loud during the round. The interviewer expects it.

- What task are users trying to complete?
- What's painful today — time, cost, error, compliance, revenue leakage, customer experience?
- Who owns the process: business, security, data platform, app, legal, support?
- What data is available, where does it live, who grants access?
- What are the unacceptable failures?
- What does pilot success look like?
- Who owns this after we leave?

Good senior phrase:

> Before proposing architecture, I'd separate the business workflow from the model workflow. The model only matters if it changes an operational decision.

## Prototype vs. Productionize vs. Rollout

### Prototype
Prototype only the risky parts:
- Retrieval quality if knowledge-heavy.
- Tool reliability if action-heavy.
- Latency/cost if high-volume.
- Safety/compliance if regulated.
- Human adoption if workflow-changing.

For a customer demo: real-ish data (not toy examples), one happy path + one failure path, observability visible early (traces, retrieved chunks, tool calls, confidence, cost).

### Productionize
The jump to production is usually about:
- Auth and authz.
- Data isolation and network boundary.
- Rate limits and quotas.
- Prompt/version management.
- Evaluation gates.
- Audit logging.
- Rollback.
- Human-in-the-loop for risky actions.
- Ownership after handoff.

### Rollout
- Internal alpha with 10–20 users.
- Golden task set and baseline metric.
- Shadow mode if actions affect customers.
- Canary by team/region/segment.
- SLO dashboards.
- Weekly decision review: expand / pause / rollback.

### Feedback loop (the FDE close)
End RRK answers with this pattern:

> I'd write the reusable patterns back as assets: a connector template, an eval harness, a deployment checklist, and a list of product gaps to send back to the engineering team.

This is literally the 4th responsibility in the JD. Say it naturally.

## AI/ML Engineering — Know These Cold

### LLM system components (name them in order)

1. Input normalization and policy checks.
2. Retrieval or context assembly.
3. Model selection and prompting.
4. Tool calling or agent orchestration.
5. Output validation and safety checks.
6. Human approval for high-risk actions.
7. Logging, traces, evals, cost tracking.

### Model selection — tiered answer

- **Gemini Pro class:** hard reasoning, complex multimodal, high-value low-volume.
- **Gemini Flash class:** default for production assistants where latency/cost matter.
- **Gemini Flash-Lite or smaller:** extraction, classification, routing, high-volume cheap tasks.
- **Open/fine-tuned model:** when data control, cost, latency, or domain specificity matters.

Senior phrase:

> I wouldn't pick one model for the whole system. I'd use a router: cheap deterministic components first, fast model for routine cases, stronger model for escalations.

### RAG done properly (not "vector DB + LLM")

Cover in this order:

- **Data connectors:** GCS, Drive, SharePoint, Slack, Jira, databases, APIs.
- **Ingestion:** parsing, deduplication, ACL preservation, metadata.
- **Chunking:** semantic vs. fixed-size, overlap, table handling, document hierarchy.
- **Embeddings:** model choice, refresh cadence, multilingual/domain behavior.
- **Retrieval:** hybrid search (dense + BM25), metadata filters, reranking, top-k tuning.
- **Grounding:** cite sources, answer only from retrieved evidence.
- **Evaluation:** retrieval recall, answer faithfulness, task success, hallucination rate.
- **Access control:** document-level permissions at retrieval time.
- **Operations:** index freshness, drift, broken connectors, latency, cost.

Google vocabulary to sprinkle in:
- Vertex AI RAG Engine (managed workflow + connectors)
- Vertex AI Vector Search (scalable vector retrieval, private endpoint pattern)
- BigQuery (structured grounding)
- Cloud Storage (document staging + batch ingestion)

### RAG vs. Fine-tuning decision

Use RAG when:
- Facts change
- Access control matters
- You need citations
- Knowledge lives in documents/databases

Use fine-tuning when:
- Behavior/style/format must improve
- Task is stable
- You have high-quality examples
- Smaller/faster model economics matter

Best answer line:

> I'd start with RAG and evals if the problem is knowledge access. I'd fine-tune only if the failure is behavior, format, or domain representation after retrieval is solid.

Tie to your evidence:

> In my EmbeddingGemma work, the win came from better retrieval representation — hard negatives, temporal holdout, Matryoshka slices — not from fine-tuning the generator. I'd use that mindset before jumping to fine-tune a generator.

## Agentic Systems

### Agent vs. workflow

- **Workflow:** deterministic sequence with LLM calls in known places. Prefer when the process is stable.
- **Agent:** model chooses tools/steps dynamically. Use when tasks vary and require planning.

Senior phrase:

> I default to workflows for reliability and introduce agentic autonomy only where the variability justifies it.

### ADK, Agent Engine, MCP, A2A — the one-liner you must memorize

> MCP connects agents to tools and data. A2A connects agents to other agents. ADK builds the agent. Agent Engine runs it in production.

Definitions:

- **ADK** — code-first Python framework for building agents and multi-agent systems.
- **Agent Engine** — managed runtime on Google Cloud: deploy, scale, observe, govern agents.
- **MCP (Model Context Protocol)** — lets an agent use external tools and context providers through a standard interface.
- **A2A (Agent-to-Agent)** — inter-agent communication/interoperability pattern when specialized agents collaborate across systems.

### Agent failure modes (name them quickly)

- Wrong tool selected.
- Tool succeeds but data is stale.
- Tool returns too much context.
- Agent loops or over-plans.
- Hidden state becomes inconsistent.
- Prompt injection through retrieved content or tool output.
- User asks for action beyond permission.
- Cost explodes through repeated calls.
- Observability loses the chain of reasoning / tool calls.

Controls (pair each failure with a mitigation):

- Typed tool schemas.
- Least-privilege tool scopes.
- Allowlist tools per task.
- Step limits and timeouts.
- Human approval for writes.
- Trace every model call and tool call.
- Regression evals for known failure cases.
- Deterministic validators where possible.

## Operational Excellence

### Reliability
Questions to ask: What must be always available? What can degrade gracefully? Is stale data acceptable? Is a wrong answer worse than no answer?

Patterns:
- Queue long-running jobs.
- Cache expensive retrieval or model outputs where safe.
- Idempotency keys for actions.
- Retry transient failures with backoff.
- Circuit-break unreliable tools.
- Fall back from agent → search → manual escalation.

### Resilience for model failures
- Route simple tasks to smaller/cheaper model.
- Route uncertain cases to stronger model.
- Return "I don't have enough evidence" when grounding fails.
- Human review queue for high-risk cases.

### Resilience for tool failures
- Detect read vs. write failure.
- Preserve trace and user intent.
- Avoid duplicate writes.
- Show actionable error + next step.

### Performance metrics to track
- End-to-end latency.
- Model latency.
- Retrieval latency.
- Tool latency.
- Queue wait time.
- p50 / p95 / p99.
- Tokens in/out.
- **Cost per successful task**, not just cost per request.

Optimization order:
1. Remove unnecessary context.
2. Cache/reuse retrieval.
3. Use smaller model for routing/extraction.
4. Parallelize independent tool calls.
5. Stream response if useful.
6. Move heavy work async.
7. Fine-tune or distill only if above insufficient.

## Security, Privacy, Compliance

This is your differentiator given J&J and Data Sentry.

### Principles (say these)
- Least privilege.
- Data minimization.
- Tenant isolation.
- Auditability.
- Explicit human approval for risky writes.
- Preserve customer data boundary.
- No secrets in prompts/logs.
- Respect document-level ACLs in RAG.

### Google Cloud vocabulary (use names sparingly, correctly)
- **IAM / service accounts** — identity and permissions.
- **OAuth / OIDC** — delegated user authorization and enterprise identity integration.
- **IAP** — identity-aware access to apps.
- **VPC Service Controls** — reduce data exfiltration risk around Google Cloud services.
- **Private Service Connect** — private connectivity to managed services and APIs.
- **Apigee** — API management: policies, quotas, auth, analytics.
- **Cloud Logging / Monitoring / Trace** — audit and operational visibility.
- **Security Command Center** — security posture and threat detection.

Senior phrase:

> For a regulated customer, I'd keep the agent near the data boundary instead of copying sensitive data into a new system. The integration design should preserve existing identity, network, and audit controls.

### Prompt injection and tool poisoning

- Treat retrieved text and tool outputs as **untrusted input**.
- Separate system instructions from user/document content.
- Documents cannot grant permissions.
- Validate tool arguments.
- Policy checks before external actions.
- Log the evidence used for every answer/action.

## Scalability — the 10K-to-millions question

From the PDF sample prompt.

### 10K internal users
- Known identity, controlled traffic, smaller support surface, internal data + policy, manual escalation tolerable.

### Millions of external users
- Multi-region availability, strict abuse prevention, strong quotas/rate limits, tenant isolation, more languages/devices, larger observability and support load, stronger privacy/legal exposure, cost becomes product constraint.

Architecture changes when going from one to the other:
- Stateless serving where possible.
- Async queues for long tasks.
- CDN/cache static assets.
- Regional failover.
- Tiered model routing (more requests → more budget pressure).
- Stronger evaluation before rollout.
- Automated abuse and safety monitoring.

## Performance and Cost Optimization

Answer in units Google cares about:
- Cost per request.
- **Cost per successful task.**
- Tokens per request.
- Tokens/sec.
- p95 latency.
- Model mix.
- Cache hit rate.
- Retrieval top-k and chunk size.
- Tool call count.

Your strongest evidence:

> At Gracenote I moved a 10K request/day workflow from Sonnet to Haiku using DSPy (MIPROv2, GEPA, rule mining) with a DeepEval regression gate. p95 latency dropped 50% and cost per request dropped 3× while quality held within one point on the golden set.

General playbook:
1. Measure baseline.
2. Segment request types.
3. Route easy tasks to cheaper path.
4. Reduce prompt/context size.
5. Use eval gate before migration.
6. Canary.
7. Monitor cost and quality together.

## Troubleshooting — The PDF's Sample Prompt

*"Your marketing manager complains that the new company website is slow. What would you do?"*

Structure:

1. **Clarify symptom:** slow for whom, when, where, how measured?
2. **Establish scope:** all users or segment, all pages or one path, recent deploy?
3. **Split layers:** client, CDN, network, backend, database, third-party, model/API.
4. **Check metrics:** latency percentiles, error rate, traffic, saturation.
5. **Trace one request** end to end.
6. **Form hypothesis** and test.
7. **Mitigate first**, root cause second.
8. **Add prevention:** SLO, alert, test, runbook.

Senior phrase:

> I'd first distinguish user-perceived latency from backend latency. A page can feel slow because of frontend assets, network, API fanout, database, or a third-party call.

## System Design Inside RRK

### Opening questions (ask 3–5 of these before designing)
- Who are the users?
- What are the top 2 use cases?
- Read-only or write actions?
- What data sources?
- Freshness requirement?
- Latency target?
- Compliance constraints?
- Scale now and in 12 months?
- Success metric?

### Architecture skeleton for most GenAI systems

1. User/app entry point
2. Auth and policy layer
3. Orchestrator / workflow / agent
4. Retrieval / data / tool layer
5. Model layer
6. Validation / safety layer
7. Action layer (if writes allowed)
8. Observability / eval layer
9. Admin / governance layer

### Tradeoff language (use explicit tradeoffs)

- Agent autonomy vs. deterministic workflow.
- Freshness vs. latency.
- Larger context vs. cost and distraction.
- Stronger model vs. cost/latency.
- Fine-tune vs. RAG.
- Human review vs. automation speed.
- Private deployment vs. managed-service speed.

## Consulting and Customer Communication

The interviewer is listening for whether you can operate with customers, not just code.

### Senior-sounding discovery questions
- "What would make this pilot a business success in 30 days?"
- "Which failure would make you shut it down?"
- "Who has authority to approve data access?"
- "Which team will own this after we leave?"
- "Can we observe the current workflow before designing the AI version?"
- "Do users need an answer, a recommendation, or an action?"

### Pushback template (for when the customer asks for unsafe automation)

> I understand the desire to automate end to end. Given the compliance risk, I'd start with recommendation-plus-human-override, measure precision and escalation rate, and graduate high-confidence cases to automation.

Tie to J&J hard-gate story if asked.

## Your 60-second RRK opener

> I am a senior AI/ML engineer focused on production GenAI systems. At Gracenote I run a LangGraph multi-agent workflow with stateful checkpointing and HITL interrupts, and I recently migrated a 10K request/day generation service from expensive Sonnet to cheaper Haiku using DSPy optimization and DeepEval gates, cutting p95 latency 50% and cost per request 3x. Before that I spent two years embedded with J&J MedTech teams, turning undocumented approval heuristics into a production decision-support model that cleared legal, security, and CAB review inside their existing AWS footprint. The common thread is exactly what this FDE role asks for: enter a messy customer environment, build the connective tissue, evaluate it rigorously, and turn repeatable friction into reusable tools.

## If you don't know a Google product

Do not fake detail. Say:

> I haven't deployed that exact product in production, but I understand the pattern. I'd map it to identity, network boundary, observability, eval, and rollback requirements, then validate the product-specific mechanics with docs or a Google specialist.

This sounds better than overclaiming.

## Phrases to Use / Phrases to Avoid

### Use naturally (these sound senior)
- "Let me first clarify the workflow and success metric."
- "What's the unacceptable failure mode?"
- "I'd treat retrieved content as untrusted input."
- "The model is one part of the production system."
- "I'd start with recommendation plus human override, then graduate to automation."
- "I'd separate user-perceived latency from backend latency."
- "I'd measure cost per successful task, not cost per request."
- "I'd make the reusable patterns into a template or product feedback."

### Avoid (these sound junior)
- "We just used an LLM."
- "I'd use Gemini." (as the first sentence)
- "I'm rusty at this."
- "I mostly use AI agents so I may be slow."
- "It was easy."
- "The business didn't understand."
- "We can add security later."
- "The model should decide."

## Final RRK Checklist (you should be able to answer these)

- How do you design enterprise RAG?
- When do you choose RAG vs. fine-tuning?
- How do you secure an agent with tools?
- What is MCP vs. A2A?
- How do you evaluate an agent?
- How do you reduce LLM cost without losing quality?
- How do you troubleshoot slow systems?
- How do you scale from internal pilot to external product?
- How do you handle customer ambiguity?
- What repeatable product feedback would you send back to Google?
