# Google Cloud + FDE Vocabulary

Speak these names correctly, sparingly, and with context. Never string together a list of GCP products without explaining what each does and why you'd pick it.

## 2026 rename to know cold

As of Google Cloud Next 2026 (April), **Vertex AI is officially rebranded as "Gemini Enterprise Agent Platform"**. The Vertex AI name still appears everywhere in docs, code samples, and SDK imports, so you should be fluent in both:

- **Old name (still valid):** Vertex AI, Vertex AI Agent Engine, Vertex AI RAG Engine, Vertex AI Vector Search.
- **New name:** Gemini Enterprise Agent Platform, and the same component names under it.
- **Safe phrasing in the interview:** *"Vertex AI, which Google has been renaming to Gemini Enterprise Agent Platform"* — shows you track releases without over-correcting an interviewer who says "Vertex AI."

The companion product **Gemini Enterprise** is a separate surface for registering, managing, and governing custom-built agents across the org.

**Current model generation:** Gemini 3 is the headline family (Gemini 3 Pro, Gemini 3 Pro Image / "Nano Banana Pro"). Gemini 2.5 Pro / Flash / Flash-Lite are still supported and widely deployed; both generations are valid to reference.

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
| **Gemini Enterprise Agent Platform** (formerly Vertex AI) | Umbrella managed ML/GenAI platform | First time you mention Google Cloud for ML |
| **Gemini Enterprise** | Enterprise-wide app to register, manage, and govern custom agents at org scale | Large customer with multiple agent teams |
| **Gemini** | Google's foundation model family | Model selection |
| **Gemini 3 Pro** | Current-gen high-reasoning multimodal. "Nano Banana Pro" = Gemini 3 Pro Image | Complex tasks, high-value, frontier reasoning |
| **Gemini 2.5 Pro** | Prior-gen high-reasoning, still supported and widely in production | Customers on existing Vertex stack |
| **Gemini 2.5 Flash** | Fast, general-purpose, cheaper | Default for production assistants |
| **Gemini 2.5 Flash-Lite** | Cheapest, highest throughput, up to ~1M token context | Batch extraction, classification, routing |
| **Vertex AI Agent Builder** | Low-code agent UI + infrastructure | When the customer wants non-engineer self-serve |
| **ADK** (Agent Development Kit) | Code-first Python SDK for agents (`pip install google-adk`) | When the team is shipping production code |
| **Agent Engine** | Managed runtime — deploy, scale, memory, telemetry | For ADK-based agents going to prod |
| **Agent Studio** | Low-code visual builder for Gemini prompts, agent design | Prototyping by non-engineers; same surface where Nano Banana Pro is tested |
| **Agent Garden** | Samples and reusable patterns | Starter kit |
| **Agent Search** | Managed discovery / retrieval surface for agents | When the customer needs enterprise search built in |
| **Memory Bank** | Long-term agent memory (per-session, persistent) | Multi-turn conversations, user profiles |
| **Agentspace** | Enterprise agent discovery + governance + identity layer (folded into Gemini Enterprise) | Large enterprise with multiple agent teams |
| **RAG Engine** | Managed RAG workflow + connectors | "I need RAG without building ingest pipes" |
| **Vector Search** | Scalable vector retrieval | Large-scale embedding retrieval with private endpoints |
| **Model Garden** | 200+ models. First-party: Gemini, Imagen, Lyria, Chirp, Veo. Third-party: Anthropic Claude family. Open: Gemma, Llama | When you need a non-Google or non-LLM model on the platform |
| **Gemini Code Assist** | AI coding assistant for IDEs and CLIs | Developer productivity conversations |
| **Agentic SOC** | Security-ops agents for threat detection and response | Security-team customer conversations |

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

Think of GCP for an FDE in 4 layers. Layer names reflect the 2026 rename.

```
┌──────────────────────────────────────────────────────────┐
│  AGENT LAYER:  ADK → Agent Engine / Cloud Run / GKE     │
│                Agent Builder / Agent Studio (low-code)   │
├──────────────────────────────────────────────────────────┤
│  GenAI LAYER:  Gemini Enterprise Agent Platform          │
│                (formerly Vertex AI) →                    │
│                Gemini 3 / 2.5 + RAG Engine +             │
│                Vector Search + Model Garden              │
├──────────────────────────────────────────────────────────┤
│  DATA LAYER:   BigQuery + Cloud SQL + Firestore +        │
│                Cloud Storage + AlloyDB + Spanner         │
├──────────────────────────────────────────────────────────┤
│  SECURITY:     IAM + IAP + VPC-SC + PSC + Apigee +       │
│                Workload Identity Federation + CMEK       │
└──────────────────────────────────────────────────────────┘

Cross-cutting:  Cloud Logging + Monitoring + Trace +
                OpenTelemetry (observability everywhere)
```

If you remember this stack top-to-bottom, you can answer almost any GCP architecture question by walking down the layers and mentioning which product fits each concern.

## "Interviews are not GCP specific" — the PDF's explicit cloud clause

From the recruiter PDF, verbatim:

> "Our interviews are not GCP specific, although it is recommended you familiarize yourself with the names of relevant GCP Cloud products. Questions will evaluate your general cloud knowledge, therefore answer these questions in the cloud platform you are most familiar with."

Translation: **you can frame answers in AWS when that's natural**, as long as you show awareness of Google's equivalents. Your J&J work was AWS-native; Data Sentry touched AWS + Azure + GCP. Use AWS framing when it anchors your real experience and follow with the Google equivalent:

- *"On J&J we used AWS KMS with CMEK-style customer-managed keys; the Google equivalent is Cloud KMS with the same CMEK model."*
- *"That project lived behind an AWS ALB with Cognito; on Google I'd put IAP in front of Cloud Run."*
- *"The data residency story on AWS was VPC endpoints plus resource policies; on GCP the same shape is VPC Service Controls plus Private Service Connect."*

You get full credit for the cloud knowledge and you don't lose points for not having shipped the exact Google product.

## 5-second answer skeleton for "How would you build X on GCP?"

> For X on Google Cloud, I'd put the agent on [Agent Engine / Cloud Run] depending on how much custom infra the customer needs. Model is [Gemini Flash / Pro tier] depending on task complexity. Data layer is [BigQuery for structured / Vector Search for embeddings / Cloud Storage for docs]. Security: IAM for internal, OAuth for customer users, VPC-SC / PSC if they're in a regulated perimeter. Observability: OpenTelemetry + Cloud Trace. Rollout: pilot → shadow → canary.

Practice saying that sentence 3 times. It's the default shape.
