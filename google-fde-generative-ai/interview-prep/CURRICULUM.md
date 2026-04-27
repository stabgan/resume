# Google FDE GenAI — Interview Curriculum (6-Week Plan)

**Target loop (Indian candidates report 3 rounds + 1 recruiter screen):**
1. Recruiter screen (tomorrow — handled)
2. **Round 1 — AI/ML deep dive** (45–60 min)
3. **Round 2 — DSA / live coding** (45 min)
4. **Round 3 — Googleyness + customer scenario** (45 min)

**5 evaluation dimensions (Sundeep Teki):** Technical Conceptual 25% • System Design 20% • Customer Scenario 30% • Live Coding 15% • Behavioral 10%

**What Google will actually probe (from Harish's email):**
- Production-grade AI beyond "wrapper" phase
- LLM-native metrics: tokens/sec, cost-per-request, granular tracing
- Multi-agent systems: ReAct, hierarchical delegation
- OAuth-based integration with customer infrastructure
- Converting field friction → product feature requests

---

## Your strength map vs. the bar

| JD requirement | Your current evidence | Gap to close |
|---|---|---|
| Multi-agent in production | LangGraph 30%→40% at Gracenote; MCP servers on npm | Weak on **Google ADK + Vertex AI Agent Engine + A2A protocol**. Must close. |
| LLM-native metrics | DeepEval, p95, cost-per-request (Haiku migration) | Solid. Deepen on **Vertex AI tracing / OpenTelemetry GenAI conventions**. |
| ReAct / hierarchical delegation | LangGraph supervisor/specialist; Karpathy AutoResearch extension | Needs sharp vocabulary: self-reflection loops, reflection patterns. |
| OAuth + customer APIs | J&J Data Sentry (MS Graph OAuth 2.0) | Weak in the interview context. Revisit OAuth 2.0 flows cold. |
| DSPy + prompt optimization | MIPROv2, GEPA, InferRules-style | Strong. Must be able to explain GEPA paper end-to-end. |
| Embedding fine-tuning | EmbeddingGemma 300M, Matryoshka, GTE-style loss | Strong. Know **why** curriculum + hard-neg works; know trade-offs. |
| Customer-embedded delivery | J&J MedTech NA+APAC, 2 years | Strong. Prep STAR stories. |
| DSA | J&J SQL, Python in production | **Real gap.** Round 2 is LeetCode medium-hard on Google Docs. Needs drilling. |

---

# Weekly plan (today = Day 0)

Assume the recruiter screen goes well → hiring-manager invite lands in 3–7 days → loop scheduled 2–4 weeks after that. You have **~5–6 weeks of realistic prep time**. If it's faster, compress Weeks 4–5.

## Week 1 — Google Cloud surface area (urgent — biggest gap)

**Goal:** Walk in fluent in Vertex AI agents the way you're already fluent in LangGraph.

### Must read / watch

- [ ] **Google Cloud — "Build and manage multi-system agents with Vertex AI"** (blog, ~20 min). Anchor piece.
- [ ] **ADK docs — "Get started"** + one multi-agent sample. Clone `adk-samples` repo, run one end-to-end.
- [ ] **Vertex AI Agent Engine** overview — managed runtime, context, evaluation, scaling. Know when you'd use Agent Engine vs. Cloud Run vs. Kubernetes for an agent.
- [ ] **A2A protocol** (Agent-to-Agent) — 1-page read. Understand how cross-framework agents talk.
- [ ] **Gemini Enterprise / Agentspace** — know the naming: Agent Studio (low-code), ADK (code-first), Agent Engine (runtime), Agent Garden (samples), Memory Bank (long-term memory).

### Hands-on (this is non-negotiable)

- [ ] **Project A: Port your LangGraph Gracenote-style workflow to ADK.** Take a simplified supervisor/specialist pattern and build it in Python ADK. Deploy to Vertex AI Agent Engine. Time: 6–8 hours.
- [ ] Observability: instrument it with Vertex AI's tracing so you can see tokens/sec, cost-per-request, per-step latency.

### Prep questions to be able to answer in one breath

1. "Walk me through how you'd take your LangGraph Gracenote system and rebuild it on ADK + Vertex AI Agent Engine. What changes, what stays?"
2. "When would you pick Agent Engine vs. Cloud Run for an agent?"
3. "What's the A2A protocol and why does Google need both A2A and MCP?"
4. "Gemini 2.5 Pro vs. Flash vs. Flash-Lite — when do you pick which?"

### Deliverable
**Open-source project #1** (GitHub): `adk-langgraph-bridge` — a small repo showing a LangGraph-style supervisor/specialist workflow reimplemented in ADK, deployed to Agent Engine. **This alone is worth it** — Google recruiters Google you, and seeing a public ADK project from a candidate one week before the interview is a strong signal.

---

## Week 2 — DSA revival (Round 2 is real)

**Reality check:** the Medium candidate's account says Round 2 was a DSA round. Google runs it on a Google Doc (no IDE autocomplete). You **will** get medium-hard questions. Ignoring this is the #1 failure mode for senior AI/ML candidates.

### Scope (medium-hard, no hard-hard)
Focus on **patterns**, not volume. 4–6 problems/day, ~60–90 min each, on a blank Google Doc.

| Pattern | Core problems (LeetCode #) |
|---|---|
| Arrays + two pointers | 15, 42, 76, 239 |
| Hashing | 128, 49, 560 |
| Sliding window | 3, 424, 1004, 567 |
| Binary search | 33, 153, 410, 4 |
| Trees (DFS/BFS) | 124, 236, 102, 543 |
| Graphs | 200, 207, 994, 787, 127 |
| Dynamic programming | 300, 322, 416, 72, 198 |
| Backtracking | 39, 46, 79, 51 |
| Heap / priority queue | 215, 23, 347, 295 |
| Intervals | 56, 57, 253, 435 |

**Goal by end of Week 2:** You can solve a medium cleanly on a Google Doc in 25–30 min, explaining trade-offs while you type. Target: **40 problems completed** (not watched — solved).

### Resources
- NeetCode 150 (not 250; stay focused)
- Google-tagged LeetCode set

### Drill protocol
Each problem: 5 min clarify, 10 min approach + complexity, 15 min code, 5 min test. Use a plain Google Doc — no IDE. This is exactly how Round 2 is run.

---

## Week 3 — AI/ML Round 1 prep (your strongest round)

**This is the round you win.** Frame every topic through the lens of your Gracenote/J&J/EmbeddingGemma work.

### 3A — LLM production systems (cost, latency, tracing)

- [ ] Know cold: **tokens/sec, TTFT (time-to-first-token), p50/p95/p99 latency, cost-per-request, context-window cost math.**
- [ ] How to compute cost: $(input_tokens × $/1M_in) + (output_tokens × $/1M_out)$. Memorize the math, not the current prices.
- [ ] Vertex AI pricing tiers for Gemini 2.5 Pro / Flash / Flash-Lite — the order of magnitude, not exact numbers.
- [ ] KV-cache, prefix caching, structured output (JSON schema / grammar-constrained), batching, streaming.
- [ ] Speculative decoding — what it is, why it reduces latency.

### 3B — Multi-agent patterns (the headline of the JD)

- [ ] **ReAct** (Yao et al. 2022) — reason + act loop. Know the trace format.
- [ ] **Self-reflection loops** — agent critiques its own output before emitting.
- [ ] **Hierarchical delegation** — supervisor routes, specialists execute. This is what you already built in LangGraph. Be able to draw the state graph on a whiteboard.
- [ ] **Planner / caller / summarizer decomposition** ([Small LLMs Are Weak Tool Learners](https://arxiv.org/abs/2401.07324)).
- [ ] **A2A vs. MCP** — A2A is agent-to-agent messaging, MCP is agent-to-tool/data. Different layers.
- [ ] Failure modes: infinite loops, oscillation, prompt injection in tool outputs, tool-poisoning.
- [ ] State management: checkpointers (Postgres/SQLite), HITL interrupts, deterministic replay.

### 3C — Prompt optimization + evaluation (your differentiator)

- [ ] **DSPy** — Signatures, Modules, Teleprompters. Know: BootstrapFewShot, BootstrapFewShotWithRandomSearch, MIPROv2, COPRO, GEPA.
- [ ] **GEPA paper** ([arXiv 2507.19457](https://arxiv.org/abs/2507.19457)) — read it end to end. Be ready to:
  - Explain the Pareto-frontier mechanism in 60 seconds
  - Describe when GEPA beats MIPROv2 and when it doesn't
  - Compare to RL (GRPO) and explain the 35x-fewer-rollouts claim
- [ ] **DeepEval, Arize Phoenix, Langfuse, OpenLLMetry** — know one well (DeepEval), name the others.
- [ ] **OpenTelemetry GenAI semantic conventions** — Google is pushing this, worth naming.
- [ ] **LLM-as-a-Judge** — pairwise vs. pointwise, IRR (inter-rater reliability), κ coefficient, bias mitigations (position bias, verbosity bias).

### 3D — Embedding fine-tuning (you did this — own it)

- [ ] **Contrastive training**: positive/negative sampling, temperature τ, InfoNCE loss.
- [ ] **Hard-negative mining**: how you pick them (top-k from base model, BM25, in-batch), pitfalls (false negatives).
- [ ] **Curriculum learning**: easy → hard, why it works, scheduling strategies.
- [ ] **Matryoshka Representation Learning** ([Kusupati et al. 2022](https://arxiv.org/abs/2205.13147)) — one model, many dim slices. Weighted-dim loss. Useful for cost/latency trade-offs at retrieval time.
- [ ] **GTE-style 4-directional contrastive loss** — q↔d, q↔q, d↔d directions.
- [ ] **Distillation / teacher-student**: cross-encoder → bi-encoder.
- [ ] **Evaluation**: recall@k, MRR, nDCG. BEIR, MTEB. Temporal holdout vs. random split — why temporal is harder and more honest.

### 3E — RAG specifics

- [ ] Chunking strategies: fixed, semantic, parent-child, proposition-based.
- [ ] Retrieval: dense, BM25, hybrid (RRF), reranker cascade.
- [ ] Query rewriting, HyDE, multi-query expansion.
- [ ] Evaluation: RAGAS metrics (faithfulness, answer relevancy, context precision/recall).

### Prep questions to drill

1. "Your Haiku migration — how did you design the DeepEval regression suite so you didn't regress on edge cases that aren't in the golden set?"
2. "Explain GEPA to me like I've never seen the paper." (60 seconds)
3. "Your EmbeddingGemma fine-tune went from recall@1 0.85 to 0.95 — walk me through how much came from hard-neg mining vs. curriculum vs. Matryoshka."
4. "Design a multi-agent system where a customer's data lives in their VPC, they use Okta for SSO, and they need sub-second responses. Walk me through it on ADK."
5. "Your LangGraph production system — if it starts oscillating (agent A → B → A → B), how do you detect and break the loop?"

---

## Week 4 — System Design (customer-infrastructure scenarios)

**This is the FDE-specific round.** Not "design Twitter." It's "your customer wants an agent to answer questions over their 20M documents across Snowflake, SharePoint, and a legacy Oracle DB. They use Okta SSO, they're in a VPC, and they have a 2-second SLA. Build it."

### Must know patterns

| Scenario | Core answer shape |
|---|---|
| Agent + customer VPC | Private Service Connect, Cloud Run with IAP, PrivateLink; run Gemini via Vertex AI with VPC-SC (VPC Service Controls) |
| Customer SSO | OIDC federation, identity pool, service-account impersonation, short-lived tokens |
| Large document retrieval | Vertex AI Search or custom: chunking + hybrid retrieval + reranker cascade |
| Agentic guardrails | Input/output filters, tool allowlists, rate-limits, cost-per-request ceilings |
| Multi-tenancy | Per-tenant embedding namespace, per-tenant audit logs, per-tenant cost accounting |
| Observability | OpenTelemetry GenAI traces; per-span token/cost; per-tenant dashboards |

### Book / resource
- [DDIA](https://dataintensive.net/) — Chapters 1–5, 9 (only if rusty; skim)
- [Google Cloud Architecture Center — Gen AI patterns](https://cloud.google.com/architecture) — read the GenAI reference architectures
- Sundeep Teki's FDE Career Guide (paid, ~$200 — **worth it** given the stakes)

### Practice prompts (whiteboard these)

1. Build a customer-support agent for an enterprise with 50M tickets in Zendesk, Okta SSO, data must stay in their region.
2. Design a document Q&A agent over 10M pages of contracts. Legal team requires citations to exact page + paragraph. Latency budget: 3s p95.
3. Design an eval harness for an agent system where "correctness" depends on customer-specific business rules that change monthly.
4. You deployed Agent A for Customer X. Customer Y wants a similar agent but with different policies. Design the cross-customer reusability.
5. Your agent needs to call 6 customer APIs, some with OAuth 2.0, some with API keys, some with mTLS. Design the auth layer.

### Deliverable
**Open-source project #2** (GitHub): `fde-reference-architecture` — a small repo with: architecture diagrams (drawio or mermaid), a README that walks through trade-offs, and a stub ADK implementation showing: VPC-friendly deployment + auth abstraction + per-tenant tracing. Doesn't need to run end-to-end — the README is the deliverable.

---

## Week 5 — Customer scenario + Googleyness (Round 3)

**This round gets candidates rejected more than technical rounds.** Google cares that you can operate with integrity, collaborate, and handle ambiguity.

### Googleyness — what it actually tests

From Harish: *"Product Feedback Loop: Identify technical friction points and convert them into formal product feature requests for our engineering teams."* That's the key behavior they're screening for.

- **Ownership of ambiguous problems** — you pick it up, not wait to be assigned
- **Collaboration across skill levels** — you can work with non-technical stakeholders
- **Comfort with no-right-answer situations** — customer says X, you know X is wrong, what do you do?
- **Converting field pain → product feature requests** — show you've done this

### 10 STAR stories to have ready

Prepare one 90-second STAR story for each of these. Write them down in a Google Doc. Rehearse them out loud.

1. **A time you took ownership of a problem that wasn't your responsibility.** (J&J: MS Graph OAuth shadowing → Data Sentry)
2. **A time a customer's requirements changed mid-deployment.** (J&J CCP — undocumented heuristic)
3. **A time you diagnosed a problem in an environment you'd never seen.** (first weeks at Gracenote, LangGraph in prod)
4. **A time you disagreed with a senior stakeholder and had to navigate it.** (propose one from J&J — contract approval logic)
5. **A time you converted field friction into a tool for your team.** (AutoResearch MCP harness + kiro-cli + Firecrawl + steelmind-thinking)
6. **A time you simplified something complex for a non-technical audience.** (J&J MedTech — approval workflow owners)
7. **A time you made a big bet on a technology that wasn't proven yet.** (Claude Haiku migration with DSPy)
8. **A time you shipped something with incomplete data.** (J&J CCP heuristic → ML spec)
9. **A time you failed, and what you changed after.** (any — have one ready; don't pick something trivial)
10. **Why FDE, and why Google specifically?** (not STAR, but rehearse a 60-sec answer)

### Customer-scenario mock

Practice this scenario out loud with a friend or ChatGPT:

> *"You're embedded with a Fortune 500 insurance customer. They've been trying to build an agent for claims summarization for 6 months using LangChain and an internal prompt library. The agent hallucinates dollar amounts. Their VP of Claims is frustrated. The POC is due in 3 weeks. Walk me through your first week on-site."*

Expected shape of a strong answer:
1. Week 1 morning: sit with 3–5 claims analysts, shadow the actual workflow, find the 5 most common claim types
2. Build golden eval set from 50 real cases (anonymized) with correct dollar amounts
3. Run their current prompt against the golden set — quantify the hallucination rate
4. Propose: (a) structured output with JSON schema forcing dollar amounts to cite page+line, (b) reranked retrieval over the claim document with a reranker, (c) DeepEval regression gate
5. MVP on day 5, analyst UAT on day 10, VP demo on day 15
6. Field note back to Google product team: "Vertex AI Search needs better page+line citation primitives for financial docs" → feature request

### Resources
- [Google's Googleyness guidance](https://www.google.com/about/careers/applications/how-we-hire) — official page
- Sundeep Teki's FDE Career Guide — behavioral STAR templates mapped to OpenAI/Palantir/Google values

---

## Week 6 — Mocks, polish, recovery

- **3 technical mocks** on Pramp, interviewing.io, or with a friend
- **2 system-design mocks**
- **1 behavioral mock** (record yourself, play back)
- Review all resume bullets — for each bullet, have 3 follow-up questions answered ("what was the baseline?", "what would you change?", "what did you learn?")
- Sleep: 8h/night for the last 3 days
- Skim DDIA Ch.9, Google ADK quickstart, GEPA paper one more time
- Update your LinkedIn with the open-source projects you built

---

# Open-source projects to build (the fastest credibility-boosters)

These aren't just practice — they're public signal that Google will see when they Google you during the loop. Build at least **two** of these.

## Priority 1 — `adk-langgraph-bridge` *(Week 1–2)*

**What:** A reference implementation that takes a LangGraph supervisor/specialist workflow and reimplements it in Google ADK, deploying to Vertex AI Agent Engine. README shows side-by-side code.

**Why it lands:** Directly addresses the JD gap. Shows you didn't just read the ADK docs — you built with them. Google reviewers who open your GitHub will see this and tick the "knows Google tooling" box instantly.

**Effort:** 8–12 hours. Worth every minute.

## Priority 2 — `fde-reference-architecture` *(Week 4)*

**What:** A GitHub repo with architecture diagrams (mermaid) + README for a "customer-embedded AI agent" reference: VPC-friendly deployment, OAuth 2.0 customer auth, per-tenant tracing, Vertex AI Agent Engine runtime. No full impl needed; the README is the deliverable.

**Why it lands:** Most FDE candidates can say "I've done customer deployments." Very few walk into the interview with a *public* reference architecture for one. You stand out immediately.

**Effort:** 6–8 hours.

## Priority 3 — `gepa-cookbook` *(Week 3, optional but potent)*

**What:** A hands-on tutorial + runnable notebook showing GEPA vs. MIPROv2 vs. BootstrapFewShot on a non-trivial task (e.g., medical Q&A using MIMIC-IV snippets — ties back to your thesis). Include the Pareto-frontier visualization from the paper.

**Why it lands:** Your resume already name-drops GEPA. A public notebook showing you actually *used* it turns that from claim into proof. Plus it fits the "FDE = shows field-level mastery of cutting-edge tools" archetype.

**Effort:** 10–15 hours.

## Priority 4 — `vertex-agent-eval` *(optional)*

**What:** A small Python package that wraps DeepEval + OpenTelemetry GenAI conventions + Vertex AI tracing into a drop-in "agent regression suite" for ADK agents. If it's genuinely useful, publish to PyPI.

**Why it lands:** This is what an FDE actually builds for customers. Shipping even a rough version to PyPI says "I know what enterprise customers need and I ship it."

**Effort:** 15–20 hours. Skip if time-constrained.

---

# The must-read list (if you only have 10 hours)

1. **GEPA paper** (30 min) — [arXiv 2507.19457](https://arxiv.org/abs/2507.19457)
2. **Google Cloud Agent Engine blog** (20 min) — [link](https://cloud.google.com/blog/products/ai-machine-learning/build-and-manage-multi-system-agents-with-vertex-ai)
3. **ADK quickstart + one multi-agent sample** (2 hours) — [adk-samples GitHub](https://github.com/google/adk-samples)
4. **Sundeep Teki FDE Career Guide** (3 hours if you buy it; otherwise read the free blog posts)
5. **FDE Academy question guide** (1 hour) — [link](https://fde.academy/blog/forward-deployed-engineer-interview-questions)
6. **Small LLMs Are Weak Tool Learners** (30 min) — [arXiv 2401.07324](https://arxiv.org/abs/2401.07324)
7. **Matryoshka Representation Learning** (30 min) — Kusupati et al. 2022
8. **NeetCode 150 — pick 20 problems across patterns** (2–3 hours)

---

# What to do tonight (the night before the recruiter call)

- Sleep at normal time; no cramming
- Re-read your own resume out loud, once
- Re-read the JD in Harish's email, once
- Have: your current comp (₹33L fixed) and 10 good questions ready
- Set up the Google Meet link at 9:25am; close other tabs; full-screen

Tomorrow's call is a fit screen, not a technical round. Everything in this curriculum is for **after** Harish says "I'm passing you to the hiring manager." Don't worry about the GEPA paper for tomorrow.

---

# Bottom-line priority ordering if time is short

If you end up with only 3 weeks, not 6, do exactly this in exactly this order:

1. **Week 1:** ADK + Agent Engine fluency. Build `adk-langgraph-bridge`.
2. **Week 2:** DSA drills on Google Docs. 30 problems.
3. **Week 3:** STAR stories + 3 mock interviews. Re-read GEPA paper.

Everything else is nice-to-have. The three above are the minimum viable prep.
