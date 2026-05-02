# Google Cloud + FDE Vocabulary

Speak these names correctly, sparingly, and with context. Never string together a list of GCP products without explaining what each does and why you'd pick it.

## 2026 rename to know cold

As of Google Cloud Next 2026 (April), **Vertex AI is officially rebranded as "Gemini Enterprise Agent Platform"**. The Vertex AI name still appears everywhere in docs, code samples, and SDK imports, so you should be fluent in both:

- **Old name (still valid):** Vertex AI, Vertex AI Agent Engine, Vertex AI RAG Engine, Vertex AI Vector Search.
- **New name:** Gemini Enterprise Agent Platform, and the same component names under it.
- **Safe phrasing in the interview:** *"Vertex AI, which Google has been renaming to Gemini Enterprise Agent Platform"* — shows you track releases without over-correcting an interviewer who says "Vertex AI."

The companion product **Gemini Enterprise** is a separate surface for registering, managing, and governing custom-built agents across the org.

**Current model generation:** Gemini 3 is the headline family. Gemini 3 Flash is the new default in the Gemini app. Gemini 3.1 Pro is the latest frontier reasoning model (Gemini 3 Pro Preview has been shut down). Gemini 3 Pro Image / "Nano Banana Pro" is the image generation model. Gemini 2.5 Pro / Flash are still stable and widely deployed in production; all generations are valid to reference.

## The four one-liners you MUST memorize

Say these aloud 5× per day for 3 days. They become automatic.

1. **MCP** (Model Context Protocol) — connects agents to tools and data.
2. **A2A** (Agent-to-Agent) — connects agents to other agents.
3. **ADK** (Agent Development Kit) — code-first framework for building agents (Python, TypeScript, Go, Java).
4. **Agent Runtime** (formerly Agent Engine) — managed runtime on Google Cloud for deploying, scaling, observing, and governing agents.

Combined:

> MCP connects agents to tools and data. A2A connects agents to other agents. ADK builds the agent. Agent Runtime runs it in production.

## Agent / GenAI products

| Product | What it does | When you'd mention it |
|---|---|---|
| **Gemini Enterprise Agent Platform** (formerly Vertex AI) | Umbrella managed ML/GenAI platform | First time you mention Google Cloud for ML |
| **Gemini Enterprise** | Enterprise-wide app to register, manage, and govern custom agents at org scale | Large customer with multiple agent teams |
| **Gemini** | Google's foundation model family | Model selection |
| **Gemini 3.1 Pro** | Current frontier reasoning model (replaces Gemini 3 Pro Preview, which is shut down) | Complex tasks, high-value, frontier reasoning |
| **Gemini 3 Flash** | New default model in Gemini app; PhD-level reasoning at Flash speed | Default for most production workloads |
| **Gemini 2.5 Pro** | Prior-gen high-reasoning, still supported and widely in production | Customers on existing Vertex stack |
| **Gemini 2.5 Flash** | Fast, general-purpose, cheaper | Default for production assistants |
| **Gemini 2.5 Flash-Lite** | Cheapest, highest throughput, up to ~1M token context | Batch extraction, classification, routing |
| **Gemini 3 Pro Image** | "Nano Banana Pro" — studio-quality image generation + editing, 2K/4K, grounded via Google Search | Image generation, product mockups, technical diagrams |
| **Agent Designer** (formerly Agent Builder) | No-code visual builder for agent workflows; schedule- or trigger-based | When the customer wants non-engineer self-serve |
| **ADK** (Agent Development Kit) | Code-first SDK for agents — Python (`pip install google-adk`), TypeScript, Go, Java | When the team is shipping production code |
| **Agent Runtime** (formerly Agent Engine) | Managed container runtime — deploy, scale, memory, telemetry, governance | For ADK-based agents going to prod |
| **Agent Studio** | Prompt-testing and agent-design surface in the console | Prototyping; same surface where Nano Banana Pro is tested |
| **Agent Garden** | Samples and reusable patterns | Starter kit |
| **Agent Gateway** | Centralized security policy enforcement for all agent-to-agent and agent-to-tool comms; integrates Model Armor | Regulated customers, MCP security, least-privilege |
| **Agent Identity** | SPIFFE-based cryptographic identity per agent; mTLS + DPoP; IAM integration | Agent-level auth, delegated user access to MCP servers |
| **Agent Registry** | Central library of approved agents, tools, and third-party MCP servers | Enterprise governance, agent fleet management |
| **Agent Marketplace** | Third-party agents from Atlassian, Box, ServiceNow, Workday, Oracle, etc. | Rapid deployment of pre-built agent solutions |
| **Model Armor** | Runtime protection against prompt injection and data leakage; integrates with Agent Gateway | Security guardrails for production agents |
| **Managed MCP Servers** | Every Google Cloud service now exposed as MCP; Workspace MCP Server for Drive/Gmail/Calendar | Connect agents to any Google service via standard MCP |
| **Agent Search** | Managed discovery / retrieval surface for agents | When the customer needs enterprise search built in |
| **Memory Bank** | Long-term agent memory (per-session, persistent) | Multi-turn conversations, user profiles |
| **Agentspace** | Enterprise agent discovery + governance + identity layer (folded into Gemini Enterprise) | Large enterprise with multiple agent teams |
| **RAG Engine** | Managed RAG workflow + connectors | "I need RAG without building ingest pipes" |
| **Vector Search** | Scalable vector retrieval | Large-scale embedding retrieval with private endpoints |
| **Model Garden** | 200+ models. First-party: Gemini, Imagen, Lyria, Chirp, Veo. Third-party: Anthropic Claude family. Open: Gemma, Llama | When you need a non-Google or non-LLM model on the platform |
| **Gemini Code Assist** | AI coding assistant for IDEs and CLIs | Developer productivity conversations |
| **Agentic SOC** | Security-ops agents for threat detection and response | Security-team customer conversations |

## Cloud Next 2026 — What Changed (April 22-24)

The biggest shift: Google is treating agents as **managed enterprise workloads** with identity, policy enforcement, observability, evaluation, and runtime controls — not one-off AI applications.

**Key renames:**
- Vertex AI → **Gemini Enterprise Agent Platform**
- Agent Builder → **Agent Designer**
- Agent Engine → **Agent Runtime** (the SDK concept of sessions/memory is still called Agent Engine in code; the managed deployment surface is Agent Runtime)
- Agentspace → folded into **Gemini Enterprise**

**New governance stack (memorize this):**
- **Agent Identity** — every agent gets a SPIFFE-based cryptographic identity
- **Agent Gateway** — air-traffic controller enforcing security policies across all agent comms
- **Model Armor** — prompt injection + data leakage protection, integrated with Agent Gateway
- **Agent Registry** — central library of approved agents and MCP servers

**New builder surfaces:**
- **Agent Designer** — no-code visual workflow builder (schedule/trigger-based)
- **Agent Marketplace** — third-party agents (Atlassian, ServiceNow, Workday, etc.)
- **Inbox in Gemini Enterprise** — monitor long-running agent workflows

**Infrastructure:**
- **Managed MCP Servers** — every Google Cloud service is now MCP-enabled by default
- **Workspace MCP Server** — Drive, Gmail, Calendar as MCP tools (public preview)
- **8th-gen TPUs** — dual-chip, powering the AI Hypercomputer
- **Virgo Network** — megascale data center fabric

**Senior phrase for the interview:**

> "At Cloud Next last month, Google shipped Agent Gateway and Agent Identity — that's the missing governance layer. Now an FDE can deploy an agent with cryptographic identity, least-privilege tool access via Agent Registry, and Model Armor protecting against prompt injection at the gateway level. That's the production story that was missing six months ago."

## Compute products (know the decision tree)

| Product | Pick when |
|---|---|
| **Cloud Run** | Simple, autoscaled container. Good for APIs/agents when you want control without Kubernetes. Scale-to-zero, pay-per-use. |
| **GKE** | Kubernetes. Pick when the customer has K8s already, or you need fine control (custom schedulers, stateful workloads). |
| **App Engine** | Managed app platform. Less likely for custom agent infra — consider only when customer is already on it. |
| **Compute Engine** | VM-level control. Pick only when Cloud Run / GKE don't fit. |
| **Agent Runtime** (formerly Agent Engine) | Opinionated managed runtime for ADK agents. Pick when you want Google-managed sessions, memory, eval, governance. |

### Decision tree you can say aloud

> For an agent, I'd default to Agent Runtime if the customer is ADK-native and wants managed telemetry + governance. Cloud Run is the right escape hatch when they want custom sidecars, their own network controls, or scale-to-zero. GKE is for when the customer is already invested in Kubernetes.

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

> For X on Google Cloud, I'd put the agent on [Agent Runtime / Cloud Run] depending on how much custom infra the customer needs. Agent Gateway handles security policy enforcement. Model is [Gemini Flash / Pro tier] depending on task complexity. Data layer is [BigQuery for structured / Vector Search for embeddings / Cloud Storage for docs]. Security: IAM for internal, OAuth for customer users, VPC-SC / PSC if they're in a regulated perimeter. Observability: OpenTelemetry + Cloud Trace. Rollout: pilot → shadow → canary.

Practice saying that sentence 3 times. It's the default shape.
