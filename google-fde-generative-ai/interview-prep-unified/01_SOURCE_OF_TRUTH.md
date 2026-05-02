# Source of Truth — What Is Actually Known

This is the factual spine. When other docs conflict, defer to this file. When this file conflicts with the **recruiter PDF** or the **shortlisting email**, defer to those.

## Interview Loop (confirmed)

From the recruiter's official prep PDF and the April 30 shortlisting email:

- **Role:** Forward Deployed Engineer, GenAI, Google Cloud — Bengaluru / Mumbai / Gurugram.
- **Rounds:** 2 virtual interviews.
  - **RRK** (Role-Related Knowledge): **60 minutes.**
  - **Coding:** **60 minutes.**
- **Same day** (confirmed by candidate).
- **Coding environment:** plain Google Doc, whiteboard-style (confirmed by HR on the recruiter call). No code execution. No syntax highlighting promised. Treat it exactly as a blank Doc.
- **Coding scope:** LeetCode/HackerRank-style + object-oriented programming. Expect ~30–50 lines of Python.
- **Cadence:** Interviews happen Wed/Thu from May 6 onward.
- **Recruiter contact:** Priyanka Biswas (bipriyanka@google.com). Harish introduced the handoff on April 30.
- **Final review:** independent calibrated management panel after both rounds.

## RRK Scope (from the official PDF)

The RRK round can cover any of these. Practice them all:

- **AI/ML engineering:** how models become functional systems.
- **Operational excellence:** reliability, resilience, performance.
- **Security, privacy, compliance:** especially for sensitive customer data.
- **Scalability:** from 10K internal users to millions external.
- **Performance and cost optimization.**
- **GenAI:** LLM training/serving/troubleshooting, NLP, hands-on GenAI work.
- **Application development:** design, build, test, deploy, explain demo value to a customer.
- **Consulting:** uncover stakeholder needs, make recommendations.
- **Cloud technology:** not strictly GCP-specific, but know the Google Cloud products and value proposition.
- **Troubleshooting:** distributed systems, network, web scenarios.
- **System design:** clarify broad asks, state constraints, explain tradeoffs, discuss robustness.

Sample troubleshooting prompt from the PDF: *"Your marketing manager complains that the new company website is slow. What would you do?"*

## Coding Scope (from the official PDF)

- Virtual interview platform, plain Google Doc style.
- Formatting and syntax highlighting may be present, but **you cannot run or deploy the code.**
- Code size: **~30–50 lines of Python.**
- Object-oriented programming is explicitly mentioned.
- Protocol expected:
  1. Ask clarifying questions and devise requirements.
  2. Explain the algorithm before or while coding.
  3. Prefer real code over pseudocode unless explicitly asked otherwise.
  4. Start with a working solution, then refine.
  5. Cover edge cases, bugs, and optimization.

## The Role (from official postings and recruiter materials)

One-sentence definition that appears verbatim across 8 of 10 live FDE postings:

> An embedded builder who bridges the gap between frontier AI products and production-grade reality within customers.

Variant framings (use interchangeably): builder-consultant, innovator-builder, high-agency engineer with a founder's mindset.

**Four universal responsibilities** (near-verbatim on every posting):

1. Lead developer for AI applications, transitioning from rapid prototypes to production-grade agentic workflows (multi-agent systems, MCP servers) that drive measurable ROI.
2. Architect and code the connective tissue between Google's AI products and the customer's live infrastructure: APIs, legacy data silos, security perimeters.
3. Build high-performance evaluation pipelines and observability frameworks. Agentic systems must meet requirements for accuracy, safety, and latency.
4. Identify repeatable field patterns and friction points in Google's AI stack, converting them into reusable modules or formal product feature requests for engineering teams.

## Minimum Qualifications (from recruiter invite PDF)

- Bachelor's in Science, Technology, Engineering, Mathematics, or equivalent.
- **3 years** of experience in Python and ML packages (keras, HF transformers).
- Applied AI experience: prompt engineering, fine-tuning, RAG, tool orchestration.
- Multi-agent system experience using LangGraph, CrewAI, etc., with patterns like ReAct, self-reflection, hierarchical delegation.

## Preferred Qualifications

- Master's in CS, Engineering, or related technical field.
- Training/fine-tuning models in large-scale environments with accelerators.
- Systems design: data pipelines, ML pipelines, training + serving.
- Customer-facing technical experience.
- **LLM-native metrics:** tokens/sec, cost-per-request, state management, granular tracing.
- Action-oriented customer problem-solving.

## Level Expectation

The recruiter invite PDF lists **3 years** as the minimum qualification. Adjacent live FDE postings (Staff FDE, FDE IV, Telecom FDE) list 6–8+ years. The Indian role you were invited to is at the lower end.

**Plan for a mid-to-senior IC bar.** Prepare answers that *can scale up* to senior signal (judgment, stakeholder framing, tradeoffs) without overclaiming years. Let the interviewer calibrate up if they want to. Don't self-anchor to a level you haven't been told is yours.

## Compensation Benchmarks

**Anchor from your recruiter call (Priyanka / HR):** base capped around ₹40L, stocks "similar added" on top. Level is decided by interview performance.

Decoded: base ₹40L + stock ~₹40L/yr equivalent over 4 yr (roughly $150-190K total) + 15% bonus ≈ Y1 total **₹85-90L**. This anchor reads closer to L4 than to standard L5 market data; the real L5 offer could be higher than what HR quoted if the committee reads strong L5 signal from your interview.

### How this compares to Blind / levels.fyi market data

| Level | Blind-verified 2026 India band | HR-quoted anchor |
|---|---|---|
| L4 | Y1 ₹65-85L total (base ₹42-52L, stock $100K/4yr, 15% bonus) | **Matches the HR anchor** |
| L5 SWE | Y1 ₹88-134L total (base fixed ~₹60.5L, stock $100-250K/4yr, 15% bonus). Recruiter ceiling currently ~₹1.1 Cr. | **HR anchor is 15-30% below this** |
| L5 FDE / CE | +20% above SWE per current Googlers (customer-facing premium). Y1 ₹1.0-1.3 Cr target. | **HR anchor is meaningfully below this band** |

### Your target numbers by interview outcome

**If interview signal is L4:**
- Fair Y1 target: ₹80-90L (matches HR anchor, don't push hard)
- Walk-away floor: ₹70L
- Base ₹40L acceptable; push slightly on stock

**If interview signal is L5:**
- Fair Y1 target: ₹1.0-1.3 Cr (per Blind, regardless of HR's earlier anchor)
- Walk-away floor: ₹95L
- Base: push for ₹50-60L; accept ₹45L floor
- Stock: $150-200K over 4 yr, front-loaded
- Counter once on stock if the first offer comes in at ₹85-90L for L5. Don't walk.

**Critical:** the HR anchor of ₹40L base "max" is real and probably firm for L4. For L5, push back respectfully. If they deliver an L5 offer with ₹40L base and still only ₹85L Y1, that is underbanded for the customer-facing FDE premium and worth a single counter.

**Your current comp:** ₹33L fixed only. HR anchor of ₹85-90L is still a 2.5-2.7x jump — life-changing. Accept if L4. Counter once then accept if L5 underbanded. Walk only if you have a competing offer.

Negotiation stance (full script in `09_STORIES_AND_COMP.md`, Blind-backed in `16_BLIND_INTEL.md` Part D):
- HR already gave you the anchor. Don't name a number first; instead say *"I'd rather nail the interviews and let the level set the comp. My market read is L4 around ₹75-85L and L5 at ₹1.0-1.2 Cr; I'm comfortable within that."*
- If forced to one number: ₹1.0 Cr for L5, ₹80L for L4.
- Never: apologize for ₹33L current comp.

## Your Evidence (anchor these in every answer)

| System | Signal |
|---|---|
| **Gracenote LangGraph** | Production multi-agent, stateful checkpointing, HITL interrupts; editorial no-touch approval 30% → 40%. |
| **Sonnet → Haiku migration** | DSPy (MIPROv2, GEPA, rule mining) + DeepEval canary; p95 latency −50%, cost-per-request cut 3×. |
| **EmbeddingGemma fine-tune** | 8× A100 80GB p4de, DeepSpeed ZeRO, Unsloth, mixed precision, curriculum hard-negative mining, 4-directional GTE-style loss, Matryoshka with weighted dim slices; +12 pts accuracy@1 / accuracy@5 on temporal holdout. |
| **Catalog pipeline (Gracenote)** | 1500+ partner catalogs, ~1.5M records/month; XGBoost → LightGBM + temporal heuristics; 2× faster inference, 58% fewer false positives, 97% precision. |
| **Translation at scale** | 12M multilingual rows; Gemma 3 27B on 4× L40S via vLLM + FP8; ~$460 total. fastText for language detection. |
| **J&J MedTech CCP** | 2 years embedded, NA + APAC; undocumented approval heuristic → scoped ML spec; LightGBM + isotonic calibration, temporal holdout, leakage audit; AUROC 0.95; no new infra. |
| **Data Sentry** | Multi-cloud IAM automation (AWS + Azure + GCP), MS Graph OAuth; days → minutes for ~500 users. |
| **Open source** | 2 MCP servers published on npm (`@stabgan/openrouter-mcp-multimodal`, `@stabgan/steelmind-mcp`). mcp-icd10. 8 Gemma 3 1B fine-tunes on HuggingFace. |
| **AutoResearch extension** | Forked Karpathy AutoResearch; added hypothesis logs, memory logs, research-plan-then-execute; wired kiro-cli + Firecrawl MCP + steelmind-thinking MCP. Drove the EmbeddingGemma technique selection. |
| **IIT Madras M.Tech** | Clinical ML on MIMIC-IV; done concurrently with full-time work. |

## Your Gaps Are Closeable — Build Plan

These come up in the JD but aren't load-bearing in your production history yet. You have 11 days. The strategy is not "hedge and avoid"; it's **build → push to GitHub → claim with evidence**. Each project below is scoped to 3 to 6 hours, publishable as a real repo with a README, a short demo video or GIF, and an evaluation note. Full schedule lives in `11_BUILD_PLAN.md`.

Ground rule: after you push the repo, you get to say "I built X" in the interview. Before you push, you say "I've read the docs, not shipped." No bluffing either way.

- **CrewAI**
  - Gap: framework fluency. You know LangGraph (graph + state). CrewAI is the roles + tasks mental model, and the JD names it explicitly.
  - What I'll build: `crewai-support-triage`. A 3-agent crew (Intake, Classifier, Responder) that triages a synthetic customer support queue, with a Manager agent doing hierarchical delegation. Includes a side-by-side note on when you'd pick CrewAI vs LangGraph.
  - What to say after building: "I shipped a small CrewAI triage crew last week to get the roles-and-tasks model in my hands. My production multi-agent work is LangGraph, but I can speak to the tradeoff: CrewAI is faster to stand up for role-shaped workflows, LangGraph wins when you need explicit state, checkpointing, or HITL interrupts."

- **Google ADK (Agent Development Kit)**
  - Gap: code-first Python agent framework that deploys to Vertex AI Agent Engine. Named on nearly every FDE posting.
  - What I'll build: `adk-research-assistant`. A single-agent ADK app with 2 tools (web search + a structured summarizer), deployed locally, with a README section on how it would deploy to Agent Engine and what the Agent Engine runtime buys you (managed sessions, tracing, scaling).
  - What to say after building: "I built a small ADK agent end to end this week. I haven't put one on Agent Engine in prod, but I understand the deploy story and the runtime surface, so I can map a customer's agent onto it on day one."

- **Vertex AI Agent Builder**
  - Gap: the low-code / managed side of Google's agent stack. Different audience than ADK.
  - What I'll build: `vertex-agent-builder-demo`. A Data Store agent + a tool-using agent in Agent Builder, wired to a small corpus and one external API. README covers when Agent Builder beats hand-rolling in ADK (time-to-value for non-engineering buyers, managed grounding).
  - What to say after building: "I stood up an Agent Builder demo so I could speak to the managed path, not just the code-first path. For an FDE conversation that matters because some customers want the console, not a codebase."

- **Vertex AI RAG Engine**
  - Gap: Google's managed RAG primitive. You've built RAG by hand; you haven't used the managed one.
  - What I'll build: `vertex-rag-engine-vs-diy`. Ingest the same 200-doc corpus into Vertex RAG Engine and a hand-rolled pgvector pipeline. Same eval set (20 questions, faithfulness + answer relevance via DeepEval). README is the comparison: latency, cost per query, recall, operational burden.
  - What to say after building: "I ran my own RAG pipeline against Vertex RAG Engine on the same corpus and eval set. I can tell you where the managed service earns its keep and where you still want to own the retrieval layer."

- **Vertex AI Vector Search**
  - Gap: the underlying ANN index product. Comes up in scale conversations.
  - What I'll build: Fold into the RAG Engine project above as a third arm: same corpus, Vertex Vector Search directly, with the retrieval layer hand-wired. Measure recall@k and p95 latency at 100k and 1M vectors (synthetic duplication).
  - What to say after building: "I benchmarked Vector Search against pgvector and Vertex RAG Engine on the same eval. Happy to walk through the numbers."

- **OAuth 2.0 depth**
  - Gap: you shipped Microsoft Graph OAuth in Data Sentry. You haven't designed an OAuth flow from the RFC down.
  - What I'll build: `mcp-oauth-tool-server`. An MCP server that exposes a third-party API (pick one: Notion or Linear) behind a proper OAuth 2.0 authorization code flow with PKCE, refresh token rotation, and per-user token storage. README walks through the flow end to end.
  - What to say after building: "I shipped an OAuth-authed MCP server last week. I can whiteboard auth-code-with-PKCE, refresh rotation, and the failure modes. For enterprise IdP federation I'd still pair with a security specialist, but I'm not handwaving the basics."

Calibration point: honesty still earns trust. The difference is what you're being honest about. It's no longer "I don't know this." It's "I shipped a small version last week to get it in my hands, and here's exactly where my depth ends." Interviewers reward that kind of precision far more than either bluffing or blanket hedging.

## Research Sources (reliability tagged)

**Highest reliability:**
- Recruiter prep PDF (official source for loop format).
- Shortlisting email (same-day, two rounds confirmed).
- Invite email with JD text.
- Live Google Careers FDE postings.

**Medium reliability:**
- Sundeep Teki's FDE guide (coaching source, matches public accounts).
- PracticeInterviews / CleverPrep CE interview write-ups.
- Medium and DEV candidate accounts.

**Lower reliability (signal, not certainty):**
- Blind threads on Google CE / RRK (anonymous).
- Individual Reddit posts.

## Key uncertainty

- Whether the two rounds are strictly **same-day back-to-back** or **split with a break** — you have confirmed same day. Ask Priyanka directly whether there's a 15+ min break between them. If yes, plan for a breath-reset; if no, plan for no downtime.
- **Level: L4 or L5 is decided by interview performance.** Priyanka confirmed this explicitly. You are interviewing for the level, not just for the role. Perform at staff-adjacent signal to land L5. Perform mid to land L4. Below mid = no offer.
