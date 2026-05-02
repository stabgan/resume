# Google Cloud + FDE Vocabulary

Speak these names correctly, sparingly, and with context. Never string together a list of GCP products without explaining what each does and why you'd pick it.

## The four one-liners you MUST memorize

Say these aloud 5× per day for 3 days. They become automatic.

1. **MCP** (Model Context Protocol) — connects agents to tools and data.
2. **A2A** (Agent-to-Agent) — connects agents to other agents.
3. **ADK** (Agent Development Kit) — Python, code-first framework for building agents.
4. **Agent Engine** — managed runtime on Google Cloud for deploying, scaling, observing, and governing agents.

Combined:

> MCP connects agents to tools and data. A2A connects agents to other agents. ADK builds the agent. Agent Engine runs it in production.

## Agent / GenAI products

| Product | What it does | When you'd mention it |
|---|---|---|
| **Vertex AI** | Umbrella managed ML/GenAI platform | First time you mention Google Cloud for ML |
| **Gemini** | Google's foundation model family (Pro, Flash, Flash-Lite, Ultra) | Model selection |
| **Gemini 2.5 Pro** | High-reasoning, multimodal, higher cost | Complex tasks, high-value |
| **Gemini 2.5 Flash** | Fast, general-purpose, cheaper | Default for production assistants |
| **Gemini 2.5 Flash-Lite** | Cheapest, highest throughput, up to ~1M token context | Batch extraction, classification, routing |
| **Vertex AI Agent Builder** | Low-code agent UI + infrastructure | When the customer wants non-engineer self-serve |
| **ADK** | Code-first Python SDK for agents | When the team is shipping production code |
| **Agent Engine** | Managed runtime — deploy, scale, memory, telemetry | For ADK-based agents going to prod |
| **Agent Studio** | Low-code visual builder | Prototyping by non-engineers |
| **Agent Garden** | Samples and reusable patterns | Starter kit |
| **Memory Bank** | Long-term agent memory (per-session, persistent) | Multi-turn conversations, user profiles |
| **Agentspace** | Enterprise agent discovery + governance + identity layer (now part of Gemini Enterprise) | Large enterprise with multiple agent teams |
| **RAG Engine** | Managed RAG workflow + connectors | "I need RAG without building ingest pipes" |
| **Vector Search** | Scalable vector retrieval | Large-scale embedding retrieval with private endpoints |
| **Model Garden** | 200+ models (Gemini, Anthropic, Meta, Mistral, etc.) | When you need a non-Google model on Vertex |

## Compute products (know the decision tree)

| Product | Pick when |
|---|---|
| **Cloud Run** | Simple, autoscaled container. Good for APIs/agents when you want control without Kubernetes. Scale-to-zero, pay-per-use. |
| **GKE** | Kubernetes. Pick when the customer has K8s already, or you need fine control (custom schedulers, stateful workloads). |
| **App Engine** | Managed app platform. Less likely for custom agent infra — consider only when customer is already on it. |
| **Compute Engine** | VM-level control. Pick only when Cloud Run / GKE don't fit. |
| **Agent Engine** | Opinionated managed runtime for ADK agents. Pick when you want Google-managed sessions, memory, eval, governance. |

### Decision tree you can say aloud

> For an agent, I'd default to Agent Engine if the customer is ADK-native and wants managed telemetry + governance. Cloud Run is the right escape hatch when they want custom sidecars, their own network controls, or scale-to-zero. GKE is for when the customer is already invested in Kubernetes.

## Data products

| Product | Use |
|---|---|
| **BigQuery** | Analytics, warehouse, structured grounding for agents |
| **Cloud SQL** | Relational OLTP (Postgres, MySQL) |
| **AlloyDB** | High-performance PostgreSQL-compatible |
| **Spanner** | Globally distributed relational with strong consistency |
| **Firestore** | Document database |
| **Bigtable** | High-throughput wide-column, low-latency |
| **Cloud Storage (GCS)** | Object storage for documents, artifacts, model weights |

### Decision one-liners

- **BigQuery vs. Cloud SQL:** BQ for analytics/warehouse, Cloud SQL for OLTP. Don't use BigQuery for high-frequency transactional reads.
- **Spanner vs. Cloud SQL:** Spanner for global strong-consistency at scale; Cloud SQL for regional standard use.
- **Firestore vs. Bigtable:** Firestore for document apps; Bigtable for time-series / massive throughput.

## Integration / Security / Networking

| Product | Purpose |
|---|---|
| **IAM** | Identity + permissions + service accounts |
| **OAuth 2.0 / OIDC** | Delegated user authorization; enterprise identity integration |
| **IAP (Identity-Aware Proxy)** | Adds identity-aware access to Cloud Run / App Engine / GCE apps without writing auth code |
| **VPC Service Controls** | Service perimeter — reduces data exfiltration risk around Google Cloud services |
| **Private Service Connect** | Private connectivity to managed services / APIs without public IPs |
| **Apigee** | API management — policies, quotas, auth, analytics |
| **Workload Identity Federation** | Access Google Cloud from external identity (Okta, Azure AD, GitHub) without long-lived service-account keys |
| **Cloud KMS / CMEK** | Customer-managed encryption keys |
| **Security Command Center** | Security posture, vulnerability scanning, threat detection |

### Senior phrases to use

- *"I'd put IAP in front of the Cloud Run service to get identity-aware access without writing auth plumbing."*
- *"For a regulated customer, I'd use VPC Service Controls to reduce data exfiltration risk around BigQuery and Cloud Storage."*
- *"Private Service Connect lets the customer hit our managed service from their VPC without public IPs."*
- *"Workload Identity Federation avoids shipping long-lived service-account keys to external systems."*
- *"I'd use Apigee as the policy/quota/auth layer between the customer's client and the agent backend."*

## Observability

| Product | Use |
|---|---|
| **Cloud Logging** | Structured logs |
| **Cloud Monitoring** | Metrics, dashboards, alerting |
| **Cloud Trace** | Distributed request tracing |
| **OpenTelemetry** | Vendor-neutral tracing/metrics; emit OTel, ingest in any backend |

Senior line:

> I'd instrument with OpenTelemetry and ship to Cloud Trace. That way the customer can swap observability backends later without re-instrumenting.

## The FDE-specific JD vocabulary (phrases to mirror, not parrot)

From the official JD — use 1–2 times each, naturally:

- *"Builder-consultant"* / *"innovator-builder"*
- *"Embedded with the customer, inside their perimeter"*
- *"White-glove deployment"*
- *"Production-grade, beyond the wrapper phase"*
- *"Convert field friction into reusable modules or product feature requests"*
- *"Accuracy, safety, and latency"* (the JD's three eval dimensions — verbatim)
- *"Frontier AI to production reality"*

Don't force all of these. Pick the 2–3 that feel natural in your answer.

## Phrases that sound senior

- *"I'd measure cost per successful task, not cost per request."*
- *"The model is one part of the production system."*
- *"I'd default to a workflow and introduce agent autonomy only where the variability justifies it."*
- *"I'd treat retrieved content as untrusted input."*
- *"I'd start with recommendation plus human override, then graduate to automation."*
- *"I'd separate user-perceived latency from backend latency."*
- *"The agent should never be more privileged than the user or workflow it represents."*
- *"I'd start from the customer workflow, not the model."*

## Phrases that sound junior (avoid)

- *"We'd just use Gemini."* (as a first sentence)
- *"Let me jump into the design."* (before clarifying)
- *"I'm not sure, but I think..."*
- *"I'm rusty at this."*
- *"We can add security later."*
- *"The model will figure it out."*

## If asked about a product you don't know

Honest and senior:

> I haven't shipped with that specific product, but I understand the pattern. I'd map it to the integration, identity, observability, eval, and rollback concerns, and validate the product-specific mechanics with the docs or a Google specialist.

This reads better than faking expertise. Calibration earns trust.

## A cleaner mental map of GCP

Think of GCP for an FDE in 4 layers:

```
┌─────────────────────────────────────────────────────┐
│  AGENT LAYER:  ADK → Agent Engine / Cloud Run /GKE │
├─────────────────────────────────────────────────────┤
│  GenAI LAYER:  Vertex AI → Gemini + RAG Engine +   │
│                Vector Search + Model Garden        │
├─────────────────────────────────────────────────────┤
│  DATA LAYER:   BigQuery + Cloud SQL + Firestore +  │
│                Cloud Storage                        │
├─────────────────────────────────────────────────────┤
│  SECURITY:     IAM + IAP + VPC-SC + PSC + Apigee + │
│                Workload Identity Federation         │
└─────────────────────────────────────────────────────┘

Cross-cutting:  Cloud Logging + Monitoring + Trace +
                OpenTelemetry (observability everywhere)
```

If you remember this stack top-to-bottom, you can answer almost any GCP architecture question by walking down the layers and mentioning which product fits each concern.

## 5-second answer skeleton for "How would you build X on GCP?"

> For X on Google Cloud, I'd put the agent on [Agent Engine / Cloud Run] depending on how much custom infra the customer needs. Model is [Gemini Flash / Pro tier] depending on task complexity. Data layer is [BigQuery for structured / Vector Search for embeddings / Cloud Storage for docs]. Security: IAM for internal, OAuth for customer users, VPC-SC / PSC if they're in a regulated perimeter. Observability: OpenTelemetry + Cloud Trace. Rollout: pilot → shadow → canary.

Practice saying that sentence 3 times. It's the default shape.
