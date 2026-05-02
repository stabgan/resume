# Classic System Design Foundations

RRK can turn into system design at any moment. The official PDF explicitly calls out distributed systems, availability, scalability, performance, robustness, constraints, simplicity, and tradeoffs.

## Universal System Design Flow

1. Requirements.
2. Scale estimates.
3. API and data model.
4. High-level architecture.
5. Deep dive on bottleneck.
6. Reliability and failure modes.
7. Security/privacy.
8. Cost/performance.
9. Tradeoffs and rollout.

Opening:

> I will start by clarifying functional requirements, non-functional requirements, and scale, then propose a simple design and harden the bottlenecks.

## Requirements Checklist

Functional:

- Who are users?
- What are top use cases?
- Read/write?
- Real-time or async?
- Search/filter?
- Notifications?
- Admin workflows?

Non-functional:

- QPS.
- Latency.
- Availability.
- Consistency.
- Durability.
- Privacy/security.
- Cost.
- Geographic/data residency.

## Capacity Estimation

Be directionally right:

- Daily active users.
- Requests/user/day.
- Read/write ratio.
- Average payload size.
- Storage/day.
- Peak QPS = average QPS * 5-10.

Say:

> I will use rough numbers to drive architecture choices, not to pretend precision.

## Core Components

### Load Balancer

Purpose:

- Distribute traffic.
- Health checks.
- TLS termination.
- Regional routing.

### API Service

Design:

- Stateless when possible.
- Horizontal scaling.
- Auth at edge.
- Idempotency for writes.

### Cache

Use for:

- Hot reads.
- Expensive computations.
- Session/token metadata.

Tradeoffs:

- Staleness.
- Invalidation.
- Cache stampede.

Patterns:

- Cache-aside.
- Write-through.
- TTL.

### Database

SQL:

- Transactions.
- Strong consistency.
- Relational queries.

NoSQL:

- High scale key-value/document.
- Flexible schema.
- Often eventual consistency.

Data warehouse:

- Analytics, not OLTP.
- BigQuery-style workloads.

### Queue / Stream

Use for:

- Async processing.
- Buffering spikes.
- Decoupling services.
- Retry/dead-letter.

Examples:

- Pub/Sub, Kafka, SQS.

### Object Storage

Use for:

- Files.
- Logs.
- Model artifacts.
- Batch datasets.

### CDN

Use for:

- Static assets.
- Global low-latency reads.
- Reducing origin load.

## Distributed Systems Concepts

### Availability vs Consistency

Do not recite CAP mechanically. Apply it.

Example:

- Payment ledger needs consistency.
- Feed likes can tolerate eventual consistency.
- RAG document permissions need strict authorization even if search index is eventually refreshed.

### Idempotency

Use for:

- Retries.
- Payment/write APIs.
- Tool-calling agents that may repeat actions.

Pattern:

- Client sends idempotency key.
- Server stores outcome for key.
- Retry returns same result.

### Backpressure

Use when downstream cannot keep up:

- Queue.
- Rate limit.
- Shed load.
- Degrade gracefully.

### Circuit Breaker

Use when dependency fails:

- Stop calling failing dependency.
- Return fallback.
- Probe for recovery.

### Sharding

Shard by:

- User ID.
- Tenant ID.
- Geography.
- Document/customer.

Pitfalls:

- Hot shards.
- Cross-shard queries.
- Rebalancing.

### Replication

Use for:

- Read scale.
- Availability.
- Disaster recovery.

Tradeoffs:

- Replica lag.
- Consistency.
- Failover complexity.

## Google Cloud Service Mapping

Know enough to name options:

- Compute: Cloud Run, GKE, Compute Engine, App Engine.
- Data: Cloud SQL, AlloyDB, Spanner, Firestore, Bigtable, BigQuery.
- Queue/stream: Pub/Sub, Dataflow.
- Storage: Cloud Storage.
- API: Apigee, API Gateway.
- Security: IAM, IAP, VPC-SC, PSC, Cloud KMS.
- Observability: Cloud Logging, Monitoring, Trace.
- ML/GenAI: Vertex AI, Agent Engine, RAG Engine, Vector Search.

## Common Design Prompts

### Design A Rate Limiter

Core:

- Per user/API key.
- Token bucket or sliding window.
- Store counters in Redis/memory.
- Distributed consistency tradeoff.
- Return 429 with retry-after.

FDE angle:

- Customer API quotas, abuse prevention, cost control for LLM calls.

### Design URL Shortener

Core:

- Generate short code.
- Store mapping.
- Redirect service.
- Cache hot links.
- Analytics async.
- Handle collisions.

Concepts:

- Read-heavy.
- Low latency.
- Cache/CDN.

### Design Notification System

Core:

- API creates event.
- Queue.
- Preference service.
- Channel workers: email/SMS/push.
- Retry and DLQ.
- Deduplication.

Concepts:

- Async.
- Idempotency.
- Fanout.

### Design Search Autocomplete

Core:

- Query logs.
- Trie or prefix index.
- Top suggestions.
- Ranking by popularity/personalization.
- Cache hot prefixes.
- Batch update vs streaming.

### Design File Storage / Drive

Core:

- Metadata DB.
- Object storage for files.
- Chunked upload.
- Permissions.
- Versioning.
- Sync/conflict.

FDE angle:

- Enterprise documents for RAG require ACL preservation.

### Design Web Crawler

Core:

- URL frontier queue.
- Fetchers.
- Politeness/robots.
- Dedup.
- Parser.
- Storage/indexing.
- Retry.

FDE angle:

- Firecrawl-like connector, data ingestion for RAG.

### Design Chat / Messaging

Core:

- WebSocket or polling.
- Message service.
- Storage.
- Fanout.
- Offline delivery.
- Ordering.
- Read receipts.

### Design Log Ingestion / Observability

Core:

- Agents emit logs.
- Stream ingestion.
- Buffer.
- Storage hot/cold.
- Query/index.
- Alerting.

FDE angle:

- Agent traces, tool call logs, latency/cost metrics.

## RRK Troubleshooting Framework

For "website is slow":

1. Who is affected?
2. What changed?
3. What metric?
4. Which layer?
5. What evidence?
6. Immediate mitigation?
7. Root cause?
8. Prevention?

Layer stack:

- Browser.
- CDN.
- Network.
- API.
- Database.
- Cache.
- Queue.
- Third-party.
- Model/tool call.

## What Senior Sounds Like

Say:

- "I would keep the MVP simple, then harden the bottleneck."
- "The consistency requirement depends on the user-visible failure."
- "I would make writes idempotent because retries are inevitable."
- "I would separate synchronous user path from asynchronous heavy work."
- "I would add observability before scaling because otherwise we cannot debug production."

Do not say:

- "Use microservices" without reason.
- "Use Kubernetes" by default.
- "Use NoSQL because scale."
- "CAP theorem says..." without applying it.

## Must-Design Before May 13

Whiteboard these:

1. Rate limiter.
2. URL shortener.
3. Notification system.
4. Search autocomplete.
5. File storage / Drive.
6. Log ingestion/observability.
7. API gateway for enterprise tools.
8. Cloud migration from on-prem/AWS to GCP.

Each design should take 35-45 minutes with spoken tradeoffs.
