# Google FDE Interview Prep

Research-backed prep artifacts for the **Google Forward Deployed Engineer, Generative AI, Google Cloud** role (Bengaluru / Mumbai / Gurugram).

Built from mining 10 live Google FDE postings across India, US, UK, Singapore, Japan, DACH, Telecom, GenMedia, Applied AI, and Staff variants — synthesized into a canonical JD, then calibrated the curriculum against it.

## Files

| File | When to read |
|---|---|
| [`CHEATSHEET_recruiter_call.md`](./CHEATSHEET_recruiter_call.md) | Tonight, before tomorrow's 9:30 IST call |
| [`CANONICAL_JD.md`](./CANONICAL_JD.md) | Once, now — the single source of truth for what Google is hiring for |
| [`CURRICULUM.md`](./CURRICULUM.md) | After the recruiter screen, once the hiring-manager round is scheduled |
| [`RESEARCH_SOURCES.md`](./RESEARCH_SOURCES.md) | Reference index — all sources cited in the other docs |

## Start-here workflow

1. **Tonight:** Read `CHEATSHEET_recruiter_call.md`. Nothing else.
2. **After the recruiter call converts:** Read `CANONICAL_JD.md` end-to-end. It's the contract.
3. **Once the loop is scheduled:** Follow `CURRICULUM.md`. Use the 3-week or 6-week track based on how fast the loop lands.

## The loop (from Indian candidate accounts + JD synthesis)

1. Recruiter screen (tomorrow)
2. Round 1 — AI/ML deep dive (45–60 min)
3. Round 2 — DSA on Google Doc, no IDE (45 min)
4. Round 3 — Customer scenario + Googleyness (45 min)
5. *Sometimes, at senior levels:* Round 4 — System design on GCP (45 min)

Total process: 4–6 weeks from recruiter screen to decision.

## The 6 capabilities Google grades against (from canonical JD)

| # | Capability | Your current evidence | Gap |
|---|---|---|---|
| 1 | Production agentic systems on Google Cloud (ADK + Agent Engine + A2A) | LangGraph, 2 MCP servers | **ADK hands-on** |
| 2 | Messy customer infrastructure (OAuth 2.0, VPC-SC, legacy APIs, data silos) | J&J MS Graph OAuth 2.0 | **GCP perimeter fluency** |
| 3 | Eval + observability with LLM-native metrics | DeepEval, Haiku migration | OTel GenAI conventions |
| 4 | Discovery → spec → ship with C-suite | J&J CCP NA/APAC | STAR stories prep |
| 5 | Python under interview pressure | 5+ yrs prod | **DSA on Google Doc** |
| 6 | Field insights → product requests | Karpathy AutoResearch + kiro-cli + Firecrawl + steelmind MCPs | Frame it as such |

## Evaluation weights (Sundeep Teki; 10-JD mining reconfirms)

- Customer Obsession: **30%**
- Technical Versatility: **25%**
- Communication: **25%**
- Autonomy / Judgment: **20%**

Technical depth < half of the evaluation. Most senior AI/ML candidates over-index on technical and under-prepare customer-scenario + communication.

## The 3-week crash-plan (if the loop lands fast)

1. Week 1: ADK + Agent Engine. Ship `adk-langgraph-bridge`.
2. Week 2: DSA — 30 problems on blank Google Docs.
3. Week 3: 10 STAR stories + 3 mocks.

Everything else is nice-to-have.

## Open-source projects (highest-ROI signal)

| Project | Priority | Effort |
|---|---|---|
| `adk-langgraph-bridge` | P0 | 8–12 hrs |
| `fde-reference-architecture` | P0 | 6–8 hrs |
| `gepa-cookbook` | P1 | 10–15 hrs |
| `vertex-agent-eval` | P1 (optional) | 15–20 hrs |
