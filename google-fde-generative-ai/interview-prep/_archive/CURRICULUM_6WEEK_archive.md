# Google FDE GenAI — Refined Interview Curriculum

**Calibrated against the synthesized [`CANONICAL_JD.md`](./CANONICAL_JD.md)** (mined from 10 live Google FDE postings across India, US, UK, Singapore, Japan, DACH, Telecom, GenMedia, Applied AI, and Staff variants).

## The bar, stated honestly

Google hires FDEs against **6 capabilities** (per the canonical JD):

| # | Capability | Your evidence | Gap |
|---|---|---|---|
| 1 | Design production agentic systems on Google Cloud (ADK + Agent Engine + A2A) | LangGraph production, 2 npm MCP servers | **ADK hands-on gap** |
| 2 | Navigate messy customer infrastructure (OAuth 2.0, VPC-SC, legacy APIs, data silos) | J&J Data Sentry (MS Graph OAuth 2.0) | **Weak — need GCP-native security-perimeter fluency** |
| 3 | Build eval + observability pipelines with LLM-native metrics | DeepEval + Haiku migration; N=500 spot-checks | Polish: name OTel GenAI semantic conventions |
| 4 | Own discovery → spec → ship with C-suite stakeholders | J&J CCP NA/APAC, Director + CAB review | Good; prep STAR stories |
| 5 | Write + debug production Python under interview pressure | 5+ yrs Python production | **DSA on Google Doc is the real gap** |
| 6 | Translate field insights → product requests | Karpathy AutoResearch extension, kiro-cli + Firecrawl + steelmind MCPs | Strong — frame it as such |

**What's changed vs. v1 of this curriculum:** this version front-loads the Google-Cloud-specific integration patterns (capability #2) that the JD mining surfaced — **Terraform, Apigee, VPC-SC, IAP, Private Service Connect, OAuth 2.0 flows on GCP, Vertex AI Search, Memory Bank, Agentspace**. v1 treated these as afterthoughts; they're actually the thing Google will probe hardest in the system-design round.

---

## Your loop (from Indian candidate accounts + JD synthesis)

1. **Recruiter screen** (tomorrow 09:30 IST — handled)
2. **Round 1: AI/ML deep dive** — 45–60 min. Vertex AI + multi-agent + LLM-native metrics + DSPy + embeddings.
3. **Round 2: DSA on Google Doc** — 45 min. Medium-hard LeetCode in a plain Doc, no IDE. Non-negotiable drill-worthy round.
4. **Round 3: Customer scenario + Googleyness** — 45 min. The single highest-failure round for senior AI/ML candidates.

Some senior variants add a **Round 4: System design** (agentic architecture on GCP) — prepare for it regardless; if it doesn't happen, System Design content lifts Round 1 too.

---

## Evaluation weights (Sundeep Teki's FDE breakdown, reconfirmed by 10-JD mining)

- Customer Obsession: **30%**
- Technical Versatility: **25%**
- Communication: **25%**
- Autonomy / Judgment: **20%**

**Implication:** technical depth is <half. Don't over-index on DSPy papers; spend equal time on STAR stories and customer-scenario practice.

---

# Week-by-week plan (6 weeks, compressible to 3)

Assume the recruiter screen converts to a hiring-manager invite within 3–7 days; loop scheduled 2–4 weeks after that; you have **5–6 weeks of runway**.

## Week 1 — Google Cloud agentic surface area (urgent; biggest gap)

**Goal:** Walk into the AI/ML round fluent in Vertex AI Agent Engine + ADK + A2A the way you're already fluent in LangGraph.

### Must read (ordered by ROI)

| Priority | Material | Time |
|---|---|---|
| P0 | [Google Cloud — "Vertex AI offers new ways to build and manage multi-agent systems"](https://cloud.google.com/blog/products/ai-machine-learning/build-and-manage-multi-system-agents-with-vertex-ai) | 20 min |
| P0 | [ADK quickstart + multi-agent tutorial](https://google.github.io/adk-docs/) — hands-on | 2 hrs |
| P0 | [A2A protocol announcement](https://developers.googleblog.com/en/a2a-a-new-era-of-agent-interoperability/) + [Vertex AI A2A docs](https://docs.cloud.google.com/agent-builder/agent-engine/develop/a2a) | 45 min |
| P1 | [MLOps Community — Deploying AI Agents with ADK + IAP on Cloud Run](https://mlops.community/deploying-ai-agents-in-the-enterprise-without-losing-your-humanity-using-adk-and-google-cloud) | 30 min |
| P1 | [Vertex AI Agent Builder 2026 guide (UI Bakery)](https://uibakery.io/blog/vertex-ai-agent-builder) | 30 min |
| P2 | [adk-samples GitHub repo](https://github.com/google/adk-samples) — clone, run 2 samples | 3 hrs |

### Know by end of Week 1

You should be able to answer these from memory in under a minute each:

1. **When Agent Engine vs. Cloud Run vs. GKE?** Agent Engine = opinionated managed runtime with built-in session/memory/eval. Cloud Run = flexible container w/ IAP. GKE = when the customer wants full control or has K8s already.
2. **A2A vs. MCP — what's the difference?** MCP = agent↔tools/data (Anthropic-led, Google adopted). A2A = agent↔agent messaging across frameworks/vendors (Google-led).
3. **What's in ADK vs. Agent Studio?** ADK = code-first Python framework. Agent Studio = low-code visual builder. Most teams prototype in Studio, ship in ADK.
4. **Gemini 2.5 Pro vs. Flash vs. Flash-Lite?** Pro = complex reasoning (higher cost/latency). Flash = general-purpose (fast, cheap). Flash-Lite = batch / very-long-context (cheapest, up to ~1M tokens).
5. **What's Agentspace / Gemini Enterprise?** The enterprise discovery + governance + identity layer on top of Agent Engine. Per-user agent access with IAM.

### Deliverable: Open-Source Project #1 — `adk-langgraph-bridge`

**Build this. Non-negotiable.** 8–12 hours well spent.

A GitHub repo that takes a simplified supervisor/specialist LangGraph workflow (modeled on your Gracenote pattern) and reimplements it in Google ADK, deploying to Vertex AI Agent Engine. README shows side-by-side:

- LangGraph code → ADK code
- LangGraph state graph → ADK flow
- DeepEval regression on both
- Per-step tracing comparison (LangGraph checkpointers vs. Agent Engine native tracing)

Why this works: when Google reviewers Google you before or during the loop (they will), they see you took their tooling seriously enough to ship a public comparison. It also becomes a conversation artifact in Round 1.

---

## Week 2 — Enterprise integration patterns on GCP (new — this was under-weighted in v1)

**Goal:** Stop being surprised by "the customer uses Okta, their data is in Snowflake inside their VPC, we have a 2-sec SLA" scenarios. The canonical JD lists this as a responsibility; **Round 4 system design tests it directly.**

### Must learn

**Network / security perimeter:**
- **VPC Service Controls (VPC-SC)** — how Google Cloud enforces data exfiltration boundaries
- **Private Service Connect (PSC)** — private connectivity to managed services
- **Identity-Aware Proxy (IAP)** — auth layer in front of Cloud Run / App Engine; free OAuth 2.0 / OIDC gateway
- **Workload Identity Federation** — no service account keys; federate Okta / Azure AD / GitHub
- **Customer-managed encryption keys (CMEK)** — how to tell a customer "your keys, not ours"

**API / integration layer:**
- **Apigee** — customer-facing API management; rate limits, quotas, transformations
- **OAuth 2.0 flows** — Authorization Code + PKCE, Client Credentials, Device Code. Know when to use each.
- **OIDC** — on top of OAuth; ID tokens vs. access tokens
- **API gateway patterns** — fan-out, circuit-breaker, retries with exponential backoff

**Data grounding:**
- **Vertex AI Search** — managed RAG on your data
- **Memory Bank** — agent long-term memory, per-session and persistent
- **BigQuery as agent grounding** — using BigQuery ML + grounding for factual answers
- Vector databases on GCP: **Vector Search (Vertex AI)** vs. **AlloyDB** vs. **Firestore** with vector support

**IaC:**
- **Terraform** on GCP (Applied AI variant names it as min-qual) — deploy agent stacks as code
- Module patterns for multi-tenant agent deployments

### Practice prompts (whiteboard these aloud for 30 min each)

1. *Customer uses Okta for SSO, data is in Snowflake, agent must never leave their AWS VPC. Design the agent deployment on GCP.* (Answer direction: Agent on Cloud Run in customer project → Private Service Connect → Okta federation via WIF → Snowflake access via Apigee proxy with mTLS)
2. *Build an agent for a European bank with GDPR constraints, data must stay in eu-west. How?* (Answer direction: Vertex AI regional endpoints, CMEK, VPC-SC perimeter, audit trails in Cloud Logging with export to customer's SIEM)
3. *Customer's legacy system is an on-prem Oracle DB. Agent needs to answer questions from it. Safe? Design it.* (Answer direction: Don't connect the agent directly; build a thin read-only data lake copy in BigQuery via Datastream, agent queries BigQuery)
4. *Same agent for 3 different customers with different data policies. Multi-tenancy design?* (Answer direction: Per-tenant project, per-tenant Memory Bank namespace, per-tenant tracing, per-tenant cost accounting via labels)

### Deliverable: Open-Source Project #2 — `fde-reference-architecture`

A GitHub repo with **mermaid diagrams and a long README** covering:

- Generic customer-embedded agent reference: ADK agent on Cloud Run, IAP fronting it, Workload Identity Federation for customer SSO, Apigee for customer APIs, Memory Bank for agent memory, Cloud Trace for observability
- A Terraform module for the whole thing (doesn't need to fully work; the code + README walkthrough is the deliverable)
- Variant diagrams: financial services, telecom, media

**This is the most FDE-flavored project you can ship.** It shows you've actually thought about the Google Cloud integration patterns that make up capability #2.

---

## Week 3 — DSA revival (Round 2 is real)

Round 2 is **medium-hard LeetCode on a blank Google Doc**. No IDE, no autocomplete. This is where strong AI/ML candidates get filtered out because they over-prepped technical depth and under-prepped algorithm muscle memory.

### Scope — patterns not volume

Aim for **40 problems solved** (not watched — actually coded in a plain Doc). Distribute across patterns:

| Pattern | Core problems (LeetCode #) |
|---|---|
| Arrays + two pointers | 15, 42, 76, 239 |
| Hashing | 128, 49, 560 |
| Sliding window | 3, 424, 567, 1004 |
| Binary search | 33, 153, 410, 4 |
| Trees (DFS/BFS) | 124, 236, 102, 543 |
| Graphs | 200, 207, 994, 787, 127 |
| Dynamic programming | 300, 322, 416, 72, 198 |
| Backtracking | 39, 46, 79, 51 |
| Heap / priority queue | 215, 23, 347, 295 |
| Intervals | 56, 57, 253, 435 |
| Strings | 5, 20, 22 |
| **Google-tagged set** | 20+ problems from the LC Google tag |

### Drill protocol (every problem)

1. 5 min: restate problem, clarify edge cases out loud
2. 10 min: propose approach, state complexity
3. 15 min: code on a plain Google Doc (no IDE)
4. 5 min: dry-run with 2 test cases
5. 5 min: optimize and discuss trade-offs

By end of Week 3, you should clear medium on a Doc in 25–30 min while talking through your thinking.

### One warning

At 5 years 6 months of experience, interviewers may give you a **medium-medium** not a medium-hard, but will expect cleaner code and sharper complexity discussion. Practice explaining your choice of data structure in one sentence — that's half of what gets graded here.

---

## Week 4 — AI/ML Round 1 prep (your strongest round — win this)

You're already above median for this round with your resume. The goal this week is **sharpening vocabulary and defensibility** on claims you've already made.

### 4A — LLM production systems (the JD's "LLM-native metrics" focus)

Know cold, with math:

- **tokens/sec** — both prefill (input) and decode (output); they're different
- **TTFT** (time-to-first-token), **TBT** (time-between-tokens), **p50/p95/p99** total latency
- **Cost formula:** `input_tokens × $/1M_in + output_tokens × $/1M_out` (know the *shape* not current prices)
- **KV-cache, prefix caching** — when they help, when they don't
- **Structured output** — JSON Schema, grammar-constrained decoding
- **Speculative decoding** — what and why
- **Batching** — static vs. continuous; impact on latency variance
- **Streaming** — trade-offs (better TTFT, harder to error-handle)

### 4B — Multi-agent patterns (the JD's central ask)

- **ReAct** — reason + act loop (Yao et al. 2022). Know the trace shape.
- **Self-reflection** — agent critiques its own output before emitting. Reflexion paper (Shinn et al. 2023).
- **Hierarchical delegation** — supervisor routes, specialists execute. Your LangGraph pattern.
- **Planner / caller / summarizer decomposition** — [Small LLMs Are Weak Tool Learners](https://arxiv.org/abs/2401.07324).
- **Failure modes**: oscillation, infinite loops, prompt injection in tool outputs, tool poisoning, context poisoning.
- **State management**: checkpointers (Postgres / SQLite), HITL interrupts, deterministic replay.
- **Multi-agent eval**: tau-bench, AgentBench, SWE-bench, GAIA.

### 4C — Prompt optimization + evaluation (your headline differentiator)

**Read cover-to-cover**, not skim:
- [**GEPA paper** (arXiv 2507.19457)](https://arxiv.org/abs/2507.19457) — Agrawal et al. 2025. *You cite this on your resume. Own it.*
- [DSPy Declarative Learning — use cases](https://arxiv.org/abs/2507.03620)
- [VISTA — multi-agent critique of GEPA](https://arxiv.org/abs/2603.18388) — know limitations
- [Automated Risk-of-Bias w/ GEPA](https://arxiv.org/abs/2512.01452) — clinical application (ties to your MIMIC-IV thesis)

Specifically for GEPA, drill these:
- Explain Pareto-frontier mechanism in 60s
- Compare to MIPROv2: when does GEPA win?
- Compare to GRPO / RL: the 35× rollout reduction
- Known limitations (VISTA shows GEPA can degrade from 23.81% to 13.50% with a defective seed)

### 4D — Embedding fine-tuning (you did it; own it)

You need to be able to answer "how much of the 12pp lift came from each technique" — a staff-level reviewer will ask.

- Contrastive learning: InfoNCE, temperature τ, batch size effects
- Hard-negative mining: how you picked them, false-negative risk
- Curriculum learning: easy→hard scheduling, why it works
- **Matryoshka Representation Learning** — [Kusupati et al. 2022](https://arxiv.org/abs/2205.13147); weighted dimension slices; cost/latency trade-offs
- **GTE-style 4-directional loss** — q↔d, q↔q, d↔d, d↔q
- Evaluation: recall@k, MRR, nDCG; BEIR, MTEB
- **Temporal holdout vs. random split** — temporal is harder and more honest (you used temporal — lean on this)

### 4E — RAG specifics (the Applied AI variant probes this)

- Chunking: fixed, semantic, parent-child, proposition-based
- Retrieval: dense, BM25, hybrid (RRF), reranker cascade
- Query rewriting: HyDE, multi-query expansion
- Evaluation: RAGAS (faithfulness, answer relevancy, context precision/recall)
- **Vertex AI Search** specifics — when you'd use it vs. building your own

### Rehearsal questions (drill aloud; 60s answers)

1. "Your Haiku migration — walk me through how you made the DeepEval suite production-ready."
2. "Explain GEPA like I've never read the paper."
3. "Your EmbeddingGemma fine-tune went +12pp on accuracy@1/@5 — break it down by contribution: curriculum vs. hard-neg vs. GTE-style loss vs. Matryoshka."
4. "Design a multi-agent system on Vertex AI where customer data stays in their VPC, they use Okta, and there's a 2-second SLA."
5. "Your LangGraph system starts oscillating between two agents. How do you detect and break it in prod?"
6. "What's an FDE-specific failure mode you've seen in your own customer work, and how did you diagnose it?"

---

## Week 5 — Customer scenario + Googleyness (Round 3 — highest fail rate)

From Harish's email: *"Identify technical friction points and convert them into formal product feature requests."* **That is the behavioral behavior being screened for.**

### The 10 STAR stories (write these down; rehearse them aloud)

For each, prepare a 90-second STAR (Situation → Task → Action → Result):

1. **Ownership beyond your responsibility** → J&J Data Sentry: shadowed the IAM team even though it wasn't in your scope; built an automation that cut onboarding from days to minutes.
2. **Requirements changed mid-delivery** → J&J CCP: discovered the approval heuristic was undocumented; you reframed the ML spec mid-flight; it still cleared legal/security/CAB.
3. **Diagnosed a problem in an environment you'd never seen** → First weeks at Gracenote: took over the catalog-ingestion pipeline (1500+ catalogs) with no context; your tightening took false positives down 58%.
4. **Disagreed with a senior stakeholder, navigated it** → Pick a J&J one where you pushed back on a spec; show structured disagreement.
5. **Converted field friction to a tool for your team** → Karpathy AutoResearch extension: hypothesis logs, memory logs, kiro-cli + Firecrawl + steelmind-thinking MCPs. **This one directly demonstrates capability #6 — prepare it well.**
6. **Simplified complex to non-technical audience** → J&J MedTech approval workflow owners.
7. **Big bet on an unproven technology** → Claude 4.5 Haiku migration via DSPy (MIPROv2 + GEPA + InferRules) — cheaper model, DSPy carried the quality.
8. **Shipped with incomplete data** → J&J undocumented heuristic → scoped ML spec.
9. **A failure and what changed** — pick a real one; don't pick something trivial. Show what you changed in your process afterwards.
10. **"Why FDE? Why Google?"** — 60-sec answer. Tie to: your two MCP npm packages = you already do the field→product thing; your J&J time = you already embed; Google FDE is the role that *rewards* this.

### Customer-scenario mock

**Practice the full scenario aloud, twice.** Pattern: a real live problem, ambiguous, with tight timeline. Strong answers always structure as:

1. **Week 1:** Sit with end users (not management). Find the real workflow, not the stated workflow.
2. **First artifact:** Golden eval set from real examples (anonymized).
3. **Quantify the gap:** Run current system against golden set, get a number.
4. **Propose MVP:** Structured output + constraint + eval gate.
5. **Ship short:** MVP day 5, UAT day 10, demo day 15.
6. **Feedback loop:** What Google product primitive would have made this easier? Write it up as a product feature request.

Practice with: *"You're embedded with a Fortune 500 insurance customer. They've tried LangChain for 6 months building a claims-summarization agent that hallucinates dollar amounts. The VP of Claims is frustrated. POC due in 3 weeks. What do you do in your first week?"*

---

## Week 6 — Mocks + polish

- 3 technical mocks (Pramp, interviewing.io, or a friend)
- 2 system-design mocks
- 1 behavioral mock (record yourself; play back — brutal but useful)
- For every resume bullet, answer 3 probing follow-ups: *"what was the baseline?"*, *"what would you change?"*, *"what did you learn?"*
- Re-read GEPA paper one more time
- Skim: ADK quickstart, A2A docs, one system-design canonical answer
- Sleep 8 hours for the last 3 days
- Update LinkedIn with the 2 open-source projects

---

## Open-source projects — refined priority order

Against the canonical JD, two projects are unambiguously high-ROI and two are nice-to-have.

### P0 — `adk-langgraph-bridge` *(Week 1)*
- Direct evidence for capability #1 (ADK production fluency)
- 8–12 hours
- Visible to Google reviewers when they Google you
- Anchor project for the AI/ML round

### P0 — `fde-reference-architecture` *(Week 2)*
- Direct evidence for capability #2 (enterprise integration on GCP)
- 6–8 hours (README + mermaid diagrams are the bulk; stub code is fine)
- Anchor project for system-design round + customer-scenario
- **Single project most correlated with "FDE fit" on a resume**

### P1 — `gepa-cookbook` *(Week 4, optional)*
- Strengthens capability #3
- 10–15 hours
- Turns your resume's GEPA name-drop into proof
- Skip if time-constrained

### P1 — `vertex-agent-eval` *(optional, stretch)*
- Python package wrapping DeepEval + OTel GenAI conventions + Vertex tracing for ADK agents
- 15–20 hours; publish to PyPI if genuinely useful
- Strong signal but skippable

---

## The 3-week crash plan (if the loop lands fast)

If you end up with 3 weeks instead of 6:

**Week 1:** ADK + Agent Engine fluency. Ship `adk-langgraph-bridge`. Re-read GEPA paper.
**Week 2:** DSA — 30 problems on blank Google Docs. Ship README-only `fde-reference-architecture`.
**Week 3:** 10 STAR stories + 3 mocks. Customer-scenario practice.

Skip Weeks 2 (GCP perimeter deep dive) and 4D (embedding fine-tuning refresh) — you already know enough for those without extra prep.

---

## Must-read list if you only have 10 hours total

1. **GEPA paper** — 30 min — your resume anchor, must defend
2. **Google Cloud Agent Engine blog** — 20 min — anchor read
3. **ADK quickstart + 1 multi-agent sample** — 2 hrs
4. **FDE Academy interview questions guide** — 1 hr — closest thing to question bank
5. **A2A protocol announcement** — 15 min
6. **10 STAR stories written down** — 2 hrs
7. **NeetCode 150 — 15 problems across patterns** — 3 hrs
8. **[`CANONICAL_JD.md`](./CANONICAL_JD.md) in this folder** — 15 min — re-read weekly

---

## What changed from v1 of this curriculum

1. **Added Week 2 (enterprise integration on GCP)** — the canonical JD revealed Terraform, Apigee, VPC-SC, IAP, Workload Identity Federation as directly required; v1 treated these as afterthoughts.
2. **Refined project #2** from "customer-embedded agent reference" to **`fde-reference-architecture` with real Google Cloud primitives** — mermaid diagrams + Terraform module + variant customer scenarios.
3. **Re-weighted the AI/ML round prep** — less time on generic LLM topics, more on Google-specific stack (Gemini 2.5 tier selection, Agent Engine, A2A, Memory Bank, Agentspace, Vertex AI Search).
4. **Added explicit vocabulary** — the 7 phrases recruiters and HMs will recognize from the JD (in `CANONICAL_JD.md` §Key phrases).
5. **Reorganized STAR stories** against the canonical JD's 6 capabilities rather than generic Googleyness.
6. **Added a 3-week crash-plan path** since your recruiter reached out unsolicited and the loop may land fast.
