# Google FDE Interview Prep

Research-backed prep artifacts for the Google Forward Deployed Engineer, Generative AI, Google Cloud role.

## Files

| File | When to read |
|---|---|
| [`CHEATSHEET_recruiter_call.md`](./CHEATSHEET_recruiter_call.md) | Tonight, before tomorrow's 9:30 IST call |
| [`CURRICULUM.md`](./CURRICULUM.md) | After the recruiter screen, once the hiring-manager round is scheduled |
| [`RESEARCH_SOURCES.md`](./RESEARCH_SOURCES.md) | Reference — all the sources the curriculum was built from |

## Quick-start if you only have 3 weeks

From `CURRICULUM.md` §"Bottom-line priority ordering":

1. **Week 1:** ADK + Vertex AI Agent Engine fluency. Build `adk-langgraph-bridge` open-source project.
2. **Week 2:** DSA drilling. 30 problems on a blank Google Doc (no IDE).
3. **Week 3:** STAR stories for the 10 Googleyness scenarios + 3 mock interviews. Re-read the GEPA paper.

## Loop structure (Indian candidates, 2026)

1. Recruiter screen (tomorrow)
2. Round 1: AI/ML deep dive (45–60 min)
3. Round 2: DSA on Google Docs (45 min)
4. Round 3: Googleyness + customer scenario (45 min)

Total process: ~4–6 weeks from recruiter screen to decision.

## Evaluation weights (from Sundeep Teki's FDE analysis)

- Customer Obsession: **30%**
- Technical Versatility: **25%**
- Communication: **25%**
- Autonomy & Judgment: **20%**

Note the distribution — technical depth is under half the evaluation. Most senior AI/ML candidates over-prep technical and under-prep customer scenario + communication.

## Open-source projects to build (order of ROI)

1. **`adk-langgraph-bridge`** — reimplement a LangGraph workflow in ADK, deploy to Agent Engine. 8–12 hrs. Highest-ROI signal.
2. **`fde-reference-architecture`** — mermaid diagrams + README for a customer-embedded agent reference. 6–8 hrs.
3. **`gepa-cookbook`** — notebook comparing GEPA vs. MIPROv2. 10–15 hrs.
4. **`vertex-agent-eval`** — DeepEval + OTel GenAI wrapper for ADK agents. 15–20 hrs, optional.

## Key gaps in your current profile (honest audit)

| Gap | Severity | Close via |
|---|---|---|
| Google ADK hands-on | HIGH | Week 1 of curriculum |
| Vertex AI Agent Engine | HIGH | Week 1 |
| A2A protocol | MEDIUM | Week 1 (read 1-page overview) |
| OAuth 2.0 flows cold | MEDIUM | Week 4 (system-design round) |
| DSA on Google Docs | HIGH | Week 2 (40+ problems) |
| STAR stories for FDE-specific scenarios | MEDIUM | Week 5 |
