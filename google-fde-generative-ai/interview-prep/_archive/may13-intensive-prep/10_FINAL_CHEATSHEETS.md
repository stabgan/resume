# Final Cheatsheets

Use on May 11-13. Before that, use the deeper files.

## One Sentence

> I build production GenAI by starting from the customer workflow, not the model, and making it real through integration, evals, security, observability, and rollout.

## RRK Framework

1. Workflow.
2. Stakeholders.
3. Success metric.
4. Data and permissions.
5. Architecture.
6. Security.
7. Reliability/scale.
8. Evals/observability.
9. Cost/latency.
10. Rollout and product feedback.

## Coding Framework

1. Restate.
2. Clarify.
3. Brute force.
4. Optimized invariant.
5. Code.
6. Dry-run.
7. Complexity.
8. Tests.

If stuck:

> Let me step back and identify the invariant.

## DSA Pattern Map

- Pair/triplet sorted: two pointers.
- Contiguous substring/subarray: sliding window.
- Count/group/lookup: hash map.
- Recent/history: queue/deque.
- Matching/parsing/next greater: stack.
- Sorted/monotonic: binary search.
- Tree path/height/LCA: DFS.
- Shortest path/levels: BFS.
- Dependencies: topological sort.
- Connectivity: DFS/BFS/union-find.
- Top K: heap.
- Generate all: backtracking.
- Min/max/count choices: DP.

## Python Imports

```python
from collections import defaultdict, Counter, deque
import heapq
from functools import lru_cache
```

## OOP Invariants

- Rate limiter: per-user queue contains only active-window timestamps.
- LRU: map gives key -> node, list gives recency.
- TimeMap: per-key sorted timestamps, binary search latest <= query.
- File system: trie nodes represent directories/files.

## System Design Checklist

- Requirements.
- Scale.
- API.
- Data model.
- Architecture.
- Bottleneck.
- Cache/queue/db.
- Failure modes.
- Security.
- Observability.
- Cost.
- Tradeoffs.

## ML Design Checklist

- Business objective.
- ML objective.
- Data/labels.
- Features/context.
- Model.
- Training.
- Evaluation.
- Serving.
- Monitoring/drift.
- Feedback/retraining.
- Privacy/cost.

## GenAI Design Checklist

- User workflow.
- Data sources.
- ACLs.
- Retrieval/chunking/indexing.
- Model choice.
- Prompt/tool strategy.
- Safety.
- Evals.
- Traces.
- Cost/latency.
- Human review.

## Google Cloud One-Liners

- ADK builds agents.
- Agent Engine runs agents.
- MCP connects agents to tools/data.
- A2A connects agents to agents.
- Cloud Run is simple serverless containers.
- GKE is Kubernetes control.
- IAP protects apps with identity-aware access.
- VPC-SC reduces data exfiltration risk.
- PSC provides private connectivity.
- Apigee manages enterprise APIs.
- BigQuery is analytics.
- Cloud SQL is transactional relational.
- Vector Search is scalable vector retrieval.

## RAG Answer

> I would ingest with ACLs and metadata, chunk carefully, use hybrid retrieval plus reranking, generate grounded answers with citations, refuse unsupported answers, and evaluate retrieval recall, faithfulness, citation correctness, latency, and cost.

## Agent Answer

> I would default to deterministic workflow and add agentic autonomy only where variability requires it. Tools need typed schemas, least privilege, step limits, human approval for risky writes, and traces for every model/tool call.

## Cost Answer

> I would baseline tokens, latency, quality, and cost per successful task; segment easy vs hard requests; reduce context; route simple cases to cheaper models; cache safely; and use eval-gated canaries before migrating.

## Security Answer

> Preserve the customer's identity, network, and audit boundaries. The agent should not have more privilege than the user or workflow it represents.

## Hot Stories

1. J&J approval heuristics: ambiguity, data readiness, regulated rollout.
2. Sonnet to Haiku: eval-gated cost/latency optimization.
3. AutoResearch/MCP: field friction to reusable tool.
4. Data Sentry: ownership, OAuth, multi-cloud automation.
5. Gracenote ingestion: production troubleshooting.

## Interview Questions To Ask

- "What production blockers do FDEs most often see after a GenAI demo works?"
- "How does the team convert repeated field patterns into reusable assets or product feedback?"
- "How much of the role is customer-embedded delivery versus internal reference architecture/product work?"
- "What does success look like in the first six months?"

## Final Reminders

- Clarify before solving.
- Do not jump to model choice.
- Say tradeoffs explicitly.
- Bring up evals and observability without being prompted.
- Bring up security before interviewer has to ask.
- Tie technical work to customer impact.
- End FDE answers with reusable product feedback.
