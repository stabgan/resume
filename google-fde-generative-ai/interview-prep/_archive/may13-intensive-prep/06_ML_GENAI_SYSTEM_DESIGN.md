# ML And GenAI System Design

This is the main differentiator. Many candidates can say "RAG." You need to design the whole production system: data, model, serving, eval, monitoring, security, latency, cost, and rollout.

## Universal ML System Design Flow

1. Problem framing.
2. Success metrics.
3. Data and labels.
4. Features or context.
5. Model choice.
6. Training/evaluation.
7. Serving path.
8. Monitoring and drift.
9. Feedback/retraining.
10. Safety, privacy, cost.

Opening:

> I would first map the business goal to an ML objective and define offline and online metrics before choosing models.

## Metrics

Classification:

- Precision, recall, F1.
- AUROC, AUPRC.
- Calibration.

Ranking/search:

- NDCG.
- MRR.
- Recall@k.
- Precision@k.
- CTR/conversion.

Generation:

- Task success.
- Faithfulness.
- Citation correctness.
- Human preference.
- Safety violation rate.
- Cost per successful task.
- p95 latency / time to first token.

Operations:

- Drift.
- Data freshness.
- Model latency.
- Error rate.
- Override/escalation rate.

## Data And Labels

Ask:

- Where does data live?
- Who owns it?
- Is it fresh?
- Is it labeled?
- Is there leakage?
- Are labels consistent across teams/regions?
- Are PII/private data present?
- What are retention rules?

Tie to your J&J story:

> If labels encode inconsistent human processes, the model will learn inconsistency. I would surface that before training.

## Training / Serving

### Batch Training

Use for:

- Large datasets.
- Periodic retraining.
- Stable labels.

### Online Inference

Use for:

- User-facing decisions.
- Low latency.
- Real-time context.

### Batch Inference

Use for:

- Offline enrichment.
- Large document processing.
- Nightly recommendations.

### Streaming

Use for:

- Real-time events.
- Fraud detection.
- Monitoring.

## Model Serving Infrastructure

Components:

- Preprocessing.
- Model server.
- Feature/context retrieval.
- Model registry/version.
- Traffic router.
- Canary/A-B.
- Logging.
- Monitoring.

Containers/inference pipeline answer:

> I would package preprocessing and model serving into containers, deploy behind an autoscaled service, separate synchronous low-latency inference from async batch work, and log model version, input schema version, latency, and output for monitoring.

Google mapping:

- Vertex AI endpoints for managed model serving.
- Cloud Run for containerized lightweight services.
- GKE when the customer needs Kubernetes/custom control.
- Pub/Sub/Dataflow for streaming or async inference.
- BigQuery for analytics and feature generation.
- Cloud Storage for artifacts.

## ML System Design Prompts

### Fraud Detection

Cover:

- Real-time transaction stream.
- Features: user, merchant, velocity, device, geo.
- Labels from chargebacks/manual review.
- Model: gradient boosting/deep model.
- Serving: low-latency online.
- Human review for uncertain cases.
- Metrics: recall at fixed false-positive rate, cost-weighted precision/recall.
- Monitoring: drift, fraud pattern shift, alert fatigue.

### Recommendation System

Cover:

- Candidate generation.
- Ranking.
- Re-ranking/business rules.
- Feedback loop.
- Cold start.
- Diversity.
- Online metrics: CTR, watch time, conversion.
- Offline metrics: NDCG/Recall@k.

### Search / Retrieval

Cover:

- Ingestion.
- Indexing.
- BM25 + dense embeddings.
- Reranker.
- Query understanding.
- Latency/cost.
- Evaluation: recall@k, NDCG, human relevance.

### Content Moderation

Cover:

- Multi-stage classifier.
- Rules + model.
- Human escalation.
- Precision/recall tradeoff by harm class.
- Audit and appeals.

## GenAI System Design Flow

1. User workflow.
2. Data sources and permissions.
3. RAG/context strategy.
4. Model and prompt strategy.
5. Tools/agent strategy.
6. Safety/policy.
7. Evaluation.
8. Observability.
9. Cost/latency.
10. Rollout.

## Enterprise RAG

Architecture:

- Connectors: Drive, SharePoint, Slack, Jira, DB, GCS.
- Parser: PDF/doc/html/table extraction.
- Cleaner: dedupe, normalize, redact if needed.
- Chunker: semantic/fixed/hierarchical.
- Metadata: source, owner, ACL, timestamp, business unit.
- Embedder.
- Index: Vector Search / RAG Engine / hybrid search.
- Retriever: metadata filters, ACL filters, top-k.
- Reranker.
- Generator with citations.
- Safety/refusal.
- Observability/eval.

Design choices:

- Hybrid retrieval beats dense-only for enterprise terms.
- ACL filtering must happen before generation.
- Freshness strategy matters more than model size for policy docs.
- Citations make support and audit easier.

Evaluation:

- Retrieval recall.
- Context precision/recall.
- Faithfulness.
- Answer relevancy.
- Citation correctness.
- "I don't know" correctness.

## Agentic Systems

When to use agent:

- Task sequence varies.
- Tools are needed.
- Planning is useful.

When not:

- Workflow is deterministic.
- High-risk actions.
- Strict latency.
- Easy rule-based pipeline.

Agent architecture:

- Orchestrator.
- Tool registry.
- Memory/state.
- Policy guard.
- Model router.
- Trace collector.
- Human approval queue.

Failure modes:

- Wrong tool.
- Bad arguments.
- Tool output prompt injection.
- State inconsistency.
- Infinite loop.
- Permission escalation.
- Cost explosion.
- Untraceable decision.

Controls:

- Tool schemas.
- Allowlist.
- Step limits.
- Least privilege.
- Human approval for writes.
- Trace every step.
- Regression eval trajectories.

## MCP vs A2A vs ADK vs Agent Engine

Say:

> ADK is the code-first agent framework. Agent Engine is the managed runtime. MCP connects agents to tools and data. A2A connects agents to other agents.

Use case:

- MCP: connect to CRM, ticketing, internal data, search, custom tool.
- A2A: specialist agents collaborate across systems.
- Agent Engine: managed deployment/scale/observability/governance.
- Cloud Run: flexible container deployment, often with IAP.
- GKE: customer already uses Kubernetes or needs deep control.

## Evals And Observability

You should over-index here. It is your differentiator.

Eval layers:

- Unit tests for tool schemas.
- Golden task set.
- Offline replay.
- LLM-as-judge with human calibration.
- Safety/red-team set.
- Canary metrics.
- Production feedback.

Observability:

- Trace ID across request.
- User/task.
- Prompt version.
- Model version.
- Retrieval query and chunks.
- Tool calls and arguments.
- Latency per step.
- Token counts.
- Cost.
- Safety decision.
- Final answer/action.

Your proof:

> Sonnet to Haiku migration: DSPy optimization, DeepEval regression, canary, p95 latency down 50%, cost per request down 3x.

## Cost / Latency

Levers:

- Smaller model for routing/extraction.
- Strong model only for hard cases.
- Prompt compression.
- Retrieval top-k tuning.
- Cache common retrieval/results.
- Async long workflows.
- Batch offline work.
- Streaming response.
- Fine-tune/distill stable tasks.

Metrics:

- Tokens/sec.
- Tokens/request.
- Cost/request.
- Cost/successful task.
- p95 latency.
- Tool-call count.

## Security / Privacy For GenAI

Principles:

- Preserve customer data boundary.
- Least privilege.
- ACL-aware retrieval.
- Do not train on customer data unless explicitly agreed.
- Do not log secrets.
- Redact sensitive content where needed.
- Audit every action.

Prompt injection:

- Treat documents/tool outputs as untrusted.
- Separate instructions from content.
- Validate tool arguments.
- Never let retrieved content grant permissions.

## Must-Design Before May 13

1. Enterprise RAG assistant for a bank.
2. Customer support tool-calling agent.
3. Claims/contract decision-support workflow.
4. Production eval and observability platform for agents.
5. ML fraud detection system.
6. Search/retrieval/ranking system.
7. Model serving/inference pipeline.
8. Fine-tuned embedding retrieval system.

## Your Resume Anchors

Use them:

- J&J: data/label ambiguity, regulated rollout, decision support.
- Gracenote: production agent workflow, eval/cost, ingestion troubleshooting.
- EmbeddingGemma: retrieval representation, hard negatives, temporal holdout.
- MCP servers: tool integration and field friction.
- Data Sentry: OAuth and multi-cloud automation.

Every design answer should connect to one of these if possible.
