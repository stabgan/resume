# Source of Truth — What Is Actually Known

This is the factual spine. When other docs conflict, defer to this file. When this file conflicts with the **recruiter PDF** or the **shortlisting email**, defer to those.

## Interview Loop (confirmed)

From the recruiter's official prep PDF and the April 30 shortlisting email:

- **Role:** Forward Deployed Engineer, GenAI, Google Cloud — Bengaluru / Mumbai / Gurugram.
- **Rounds:** 2 virtual interviews.
  - **RRK** (Role-Related Knowledge): **60 minutes.**
  - **Coding:** **60 minutes.**
- **Same day** (confirmed by candidate).
- **Coding environment:** virtual platform with formatting/syntax highlighting, but **no code execution**. Treat as a whiteboard-style **Google Doc**. You will not run the code.
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

For the India market (Google SWE bands via levels.fyi, mid-2025):

| Level | Total Comp Range | Base | Stock | Bonus |
|---|---|---|---|---|
| L4 | ₹65–85L | ~₹42–52L | ~₹15–25L/yr | ~₹5–8L |
| L5 | ₹95L–₹1.3Cr | ~₹55–70L | ~₹30–50L/yr | ~₹8–12L |
| L6 | ₹1.3Cr–₹1.8Cr+ | ~₹70–85L | ~₹50–80L/yr | ~₹12–18L |

FDE typically pays at or slightly above SWE bands because it's customer-facing.

**Your current comp:** ₹33L fixed only, no stock. Any Google offer is a 2–4× jump. **Your anchor should be market for the level**, not current comp.

Negotiation stance (from `09_STORIES_AND_COMP.md`):
- First response: *"I'd want to understand the level this role is being scoped at before putting a number on it."*
- If pushed: Give a range tied to L4/L5 market data.
- If forced to one number: ~₹1Cr total.
- Never: apologize for current ₹33L.

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

## What You Don't Know (and shouldn't pretend to)

These come up in the JD but aren't load-bearing in your actual experience. Be honest if asked.

- **CrewAI:** know what it is (Python multi-agent framework, competes with LangGraph, different mental model — roles + tasks vs. graph + state). Don't claim you've shipped with it.
- **Google ADK:** know the role (code-first Python agent framework, deploys to Agent Engine). Don't claim hands-on.
- **Specific Vertex AI products** beyond Gemini API (Agent Builder, RAG Engine, Vector Search): know what they do, not how you used them. Say "I've used Gemini via Vertex AI; I've read the architecture docs for the rest but haven't shipped with them."
- **Deep OAuth 2.0 internals:** you used Microsoft Graph OAuth for Data Sentry. You're not an OAuth architect. Say "I've used OAuth flows in production for IAM automation; happy to talk about that, but for deep protocol design I'd want to work with a security specialist."

Honesty here is a feature, not a bug. Interviewers calibrate trust based on whether you over-claim.

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
- Whether Round 2 coding is in a **plain Google Doc** (most likely, per your confirmation) or **CoderPad in a locked-down mode**. Prepare for the Doc. If it turns out to be CoderPad, that's easier, not harder.
