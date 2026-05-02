# System Design — Classic, ML, and GenAI

RRK can turn into a system design at any moment. The official PDF explicitly calls out distributed systems, availability, scalability, performance, robustness, constraints, simplicity, and tradeoffs. This doc covers the three flavors you might see.

## Universal system-design flow

Use this for EVERY design question (classic, ML, or GenAI):

1. **Requirements** (functional + non-functional).
2. **Scale estimates**.
3. **API and data model**.
4. **High-level architecture**.
5. **Deep dive on the bottleneck**.
6. **Reliability and failure modes**.
7. **Security / privacy**.
8. **Cost / performance**.
9. **Tradeoffs and rollout**.

Opening line:

> I'll start by clarifying functional requirements, non-functional requirements, and scale, then propose a simple design and harden the bottlenecks.

## What the official Google Systems Design video actually says

The recruiter PDF links to the Google Careers video *"Prepare for Your Google Interview: Systems Design"* (transcript in `_transcripts/systems_design.txt`). The video is short (~5 min) but it is the exact framework interviewers are trained against. Memorize these quotes.

- **"You will not be coding in this interview."** Systems design is verbal + diagram only, not implementation.
- **"20 minutes for requirements and an initial solution."** The first third of the interview is discovery, not architecture. If you're naming products at minute 5, you're going too fast.
- **"The problem you will solve will be deliberately underspecified... you will need to ask clarifying questions."** Interviewers grade ambiguity navigation first, technical depth second.
- **"We are not looking for one specific answer."** Multiple valid solutions exist. State your assumptions and pick one.
- **"We deal with planet-scale data and compute systems every day."** Expect every question to end with a scale follow-up. Be ready for "now imagine 100x the load."
- **"Trade-offs and compromises... lay them out and explain your reasoning."** The word "tradeoff" or "compromise" should appear at least twice in your answer.
- **"Practice on paper or a whiteboard."** Same advice as the coding round. You won't have your usual tools.

Your default answer shape in `02_RRK_MASTER_GUIDE.md` already matches this framework. The main cadence lesson: budget roughly 20 minutes for clarification + initial architecture, 20 minutes for scaling and failure modes, 15 minutes for tradeoffs + rollout + FDE close.

## Requirements checklist

**Functional:**
- Who are the users?
- Top 2 use cases?
- Read / write / both?
- Real-time or async?
- Search / filter?
- Notifications?
- Admin workflows?

**Non-functional:**
- QPS (queries per second).
- Latency target.
- Availability (4 nines? 3 nines?).
- Consistency (strong vs. eventual).
- Durability.
- Privacy / security.
- Cost.
- Geographic / data residency.

## Capacity estimation — be directionally right, not precise

- Daily active users.
- Requests per user per day.
- Read/write ratio.
- Average payload size.
- Storage per day.
- Peak QPS = average QPS × 5–10.

Say:

> I'll use rough numbers to drive architecture choices, not to pretend precision.

---

# PART 1 — Classic System Design

## Core components (name them)

### Load balancer
- Distribute traffic, health checks, TLS termination, regional routing.

### API service
- Stateless when possible.
- Horizontal scaling.
- Auth at the edge.
- Idempotency for writes.

### Cache
- Hot reads, expensive computations, session/token metadata.
- Tradeoffs: staleness, invalidation, cache stampede.
- Patterns: cache-aside, write-through, TTL.

### Database
| Type | Use |
|---|---|
| SQL | Transactions, strong consistency, relational queries |
| NoSQL (KV / document) | High scale, flexible schema, often eventual consistency |
| Data warehouse (BigQuery) | Analytics, not OLTP |

### Queue / Stream (Kafka, Pub/Sub)
- Decouple producers and consumers.
- Async processing.
- Event-driven architecture.
- Replay and durability.

### CDN
- Static assets.
- Regional caching.
- DDoS protection at the edge.

## Reliability levers

- **Replication** (leader-follower, multi-leader, quorum).
- **Sharding** (partition by key).
- **Circuit breakers** on dependencies.
- **Retries with exponential backoff**.
- **Idempotency keys** for writes.
- **Dead-letter queues** for failed messages.
- **Health checks + auto-restart**.
- **Graceful degradation** (serve stale, partial results).

## Classic design archetypes (know the skeleton for each)

### URL shortener
- Hash or base62 of counter → short ID.
- KV store: short ID → long URL.
- Cache the hot subset.
- Redirect service is stateless.
- Consider custom aliases, expiry, analytics.

### Rate limiter
- See `06_PYTHON_AND_OOP.md` Map+Queue pattern for the class.
- Distributed version: Redis INCR with TTL, or token bucket.
- Where to apply: at the gateway, per-user, per-endpoint.

### Notification / feed service
- Fan-out on write (push to followers) vs. fan-out on read (pull from followings).
- Hybrid for celebrity users.
- Queue for async delivery.
- Template service for message formatting.

### File storage (simplified Google Drive)
- Object store (GCS / S3) for blobs.
- Metadata service for hierarchy, ACLs.
- Chunking for large files.
- Deduplication by content hash.
- CDN for shared public files.

### Chat / messaging
- WebSocket for real-time.
- Persistent storage for message history.
- Unread counters.
- Presence service.
- E2E encryption for privacy.

---

# PART 2 — ML System Design

This is the main differentiator for you. Many candidates can say "RAG." You need to design the whole production system.

## Universal ML system-design flow

1. **Problem framing** — business goal → ML objective.
2. **Success metrics** — offline + online.
3. **Data and labels**.
4. **Features or context**.
5. **Model choice**.
6. **Training / evaluation**.
7. **Serving path**.
8. **Monitoring and drift**.
9. **Feedback / retraining**.
10. **Safety, privacy, cost**.

Opening:

> I'd first map the business goal to an ML objective and define offline and online metrics before choosing models.

## Metrics by task

**Classification:** precision, recall, F1, AUROC, AUPRC, calibration.

**Ranking / search:** NDCG, MRR, recall@k, precision@k, CTR, conversion.

**Generation:** task success, faithfulness, citation correctness, human preference, safety violation rate, cost per successful task, p95 latency / time to first token.

**Operations:** drift, data freshness, model latency, error rate, override/escalation rate.

## Data and labels — the first question to ask

- Where does data live?
- Who owns it?
- Is it fresh?
- Is it labeled?
- Is there leakage?
- Are labels consistent across teams / regions?
- Are PII or private data present?
- What are retention rules?

Tie to your J&J story:

> If labels encode inconsistent human processes, the model will learn inconsistency. I'd surface that before training.

## Training / Serving modes

| Mode | Use for |
|---|---|
| Batch training | Large datasets, periodic retraining, stable labels |
| Online inference | User-facing decisions, low latency, real-time context |
| Batch inference | Offline enrichment, large document processing, nightly recs |
| Streaming | Real-time events, fraud detection, monitoring |

## Model serving infrastructure

Components:
- Preprocessing.
- Model server (TF Serving, Triton, vLLM, custom).
- Feature / context retrieval.
- Model registry / version.
- Traffic router (for A/B, canary).
- Logging and tracing.
- Monitoring.

Containers + inference pipeline answer:

> I'd containerize the preprocessor, model server, and postprocessor separately so each can scale independently. Autoscaling on request queue depth. GPU for the model container; CPU for the rest. Model registry gates promotion from staging to canary to prod.

## ML design archetypes

### Recommendation system
- Candidate generation (retrieval) + ranking.
- Offline training on user-item interactions.
- Online serving: feature store → retrieval → ranker → diversification.
- Eval: offline NDCG, online CTR + dwell time.
- Cold start: content-based for new users/items.

### Search / ranking
- Inverted index + vector retrieval.
- Learning-to-rank for top-100.
- Features: query-doc interaction, historical CTR, freshness.
- Online eval: NDCG, session abandonment.

### Fraud detection
- Real-time features (recent velocity, deviation from baseline).
- Imbalanced classes → appropriate loss + threshold tuning.
- Cost matrix: false positive (lost customer) vs. false negative (lost $).
- Human review queue for borderline cases.

### Feature store
- Offline store (batch training) + online store (low-latency serving).
- Point-in-time correctness to prevent leakage.
- Shared feature definitions across teams.

---

# PART 3 — GenAI System Design

## Universal GenAI design checklist

- User workflow.
- Data sources and ACLs.
- Retrieval / chunking / indexing.
- Model choice (tiered).
- Prompt / tool strategy.
- Safety validators.
- Evals.
- Traces.
- Cost / latency.
- Human review.

Opening:

> I'd start from the user workflow and the unacceptable failure mode, then layer on retrieval, model, tools, evals, and observability.

## Enterprise RAG archetype

Cover in this order:

- **Data connectors:** GCS, SharePoint, Drive, Jira, tickets, databases.
- **Ingestion:** parsing, dedup, ACL preservation, metadata.
- **Chunking:** semantic vs. fixed, overlap, table handling.
- **Embeddings:** model choice, refresh cadence.
- **Retrieval:** hybrid (dense + BM25), metadata filter, rerank.
- **Grounding:** cite sources, refuse when insufficient.
- **Evaluation:** retrieval recall, faithfulness, citation correctness.
- **Access control:** user identity propagated to retrieval, doc-level ACLs.
- **Operations:** index freshness, broken connectors, latency, cost.

## Agentic system archetype

- **Orchestrator** (deterministic workflow > autonomous agent where possible).
- **Tools** (read vs. write separated; typed schemas).
- **Agent(s)** with least-privilege tool scopes.
- **Memory** — short-term (conversation) + long-term (user profile, persistent facts).
- **Safety validators** between agent output and user action.
- **Human approval** for high-risk writes.
- **Tracing** — every model call and tool call, with correlation IDs.

## Tool-calling security (mini-archetype)

- OAuth / OIDC for delegated user access.
- Service account for backend tools with least privilege.
- Tool allowlist per task.
- Validate tool arguments before execution.
- Idempotency keys for writes.
- Prompt-injection defense: treat retrieved content as untrusted; documents cannot grant permissions.

## Eval + observability archetype

**Eval layers:**
- Unit tests for tools and prompt contracts.
- Golden conversation set.
- Regression suite for known incidents.
- LLM-as-judge with human calibration.
- Safety red-team prompts.
- Offline replay of production traces.
- Online canary with pre-decided rollback threshold.

**Observability:**
- Trace conversation ID across model calls, retrieval, tool calls.
- Log retrieved chunks and citations.
- Track model version, prompt version, tool version.
- Dashboards by use case and customer segment.

## Scaling GenAI — cost and latency

**Optimization order:**
1. Remove unnecessary context.
2. Cache repeated retrievals and answers (carefully — staleness).
3. Route easy requests to cheaper model.
4. Parallelize independent tool calls.
5. Stream the response.
6. Move heavy work async.
7. Fine-tune / distill only if above is insufficient.

Units to track:
- **Cost per successful task** (not just per request).
- Tokens in / out per request.
- p95 latency.
- Tool call count.
- Cache hit rate.
- Model mix.

Your evidence:

> At Gracenote, I moved a 10K req/day workflow from Sonnet to Haiku using DSPy optimization and DeepEval gates. p95 latency dropped 50%, cost per request dropped 3×, quality held within one point.

---

# Tradeoff language (say these out loud in the interview)

- "Agent autonomy vs. deterministic workflow."
- "Freshness vs. latency."
- "Larger context vs. cost + distraction."
- "Stronger model vs. cost / latency."
- "Fine-tune vs. RAG."
- "Human review vs. automation speed."
- "Private deployment vs. managed-service speed."
- "Strong consistency vs. availability during network partitions."
- "Cache freshness vs. hit rate."
- "Vertical scale vs. horizontal scale."

Interviewers grade on *whether you surface tradeoffs*, not on which you pick. Say the tradeoff aloud, pick one side, and explain why given the constraints.

# The "last 5 minutes" close

Every design answer should end with:

1. **Rollout plan** (pilot → shadow → canary → full).
2. **What you'd monitor** (3 key metrics).
3. **Product feedback** — *"If I kept hitting the same integration / eval / data pattern, I'd capture it as a reusable module and send it back as a feature request to the Google Cloud engineering team."*

That last line is the FDE-specific close. Don't skip it.
