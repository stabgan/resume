# Behavioral, Presentation, And Compensation

FDE behavioral answers must not sound like generic SWE stories. Every story needs customer pain, technical action, production result, and reusable lesson.

## 60-Second Opener

> I am a senior AI/ML engineer focused on production GenAI systems. At Gracenote, I run a LangGraph multi-agent workflow with stateful checkpointing and HITL interrupts, and I recently migrated a 10K request/day generation service from expensive Sonnet to cheaper Haiku using DSPy optimization and DeepEval gates, cutting p95 latency 50% and cost per request 3x. Before that, I spent two years embedded with J&J MedTech teams, turning undocumented approval heuristics into a production decision-support model that cleared legal, security, and CAB review inside their existing AWS footprint. The common thread is exactly what this FDE role asks for: enter a messy customer environment, build the connective tissue, evaluate it rigorously, and turn repeatable friction into reusable tools.

## Story Bank

### 1. Ownership - Data Sentry

Use for:

- Ownership.
- Security/integration.
- OAuth.
- Field friction.

Core:

- IAM onboarding across AWS/Azure/GCP took days.
- You shadowed IAM team.
- Built Python + AWS Lambda + Microsoft Graph OAuth automation.
- 500 users.
- Days to minutes.
- Reusable across teams.

Lesson:

> The most valuable problems are often one layer outside your formal scope.

### 2. Ambiguity - J&J Approval Heuristics

Use for:

- Ambiguous requirements.
- Data readiness.
- Customer discovery.
- Regulated rollout.

Core:

- Contract approval model initially looked like prediction.
- Historical decisions encoded undocumented regional heuristics.
- You paused, showed evidence, reframed as decision support.
- Legal/security/CAB approved.
- AUROC 0.95, default path, no new infra.

Lesson:

> If data contradicts process, fix the operating model before training the model.

### 3. Troubleshooting - Gracenote Ingestion

Use for:

- Debug unknown system.
- Production troubleshooting.
- Partner escalations.

Core:

- 1500+ catalogs, 1.5M records/month.
- False positives and escalations.
- Traced real failures.
- Found temporal ambiguity.
- LightGBM + heuristics.
- 2x faster, false positives down 58%, precision 97%.

Lesson:

> Debug real failures before reading architecture diagrams forever.

### 4. Disagreement - Hard Gate vs Human Override

Use for:

- Pushback.
- Stakeholder management.
- Ethical/safety judgment.

Core:

- Director wanted hard gate.
- You saw regulated risk.
- Wrote decision matrix.
- Recommendation with override.
- A/B pilot no rollback.

Lesson:

> Strong pushback gives the stakeholder a safer option, not just a no.

### 5. Field Feedback - AutoResearch/MCP

Use for:

- FDE product loop.
- High agency.
- Agentic tooling.

Core:

- Repeated manual research friction.
- Forked AutoResearch.
- Added hypothesis logs, memory logs, plan-then-execute.
- Wired kiro-cli, Firecrawl MCP, steelmind-thinking MCP.
- Influenced EmbeddingGemma techniques.
- +12 accuracy@1/@5.

Lesson:

> Repeated field friction should become a reusable tool.

### 6. Cost/Latency - Sonnet To Haiku

Use for:

- LLM-native metrics.
- Production eval.
- Tradeoff.

Core:

- 10K req/day on expensive Sonnet.
- Migrate to Haiku with DSPy optimization.
- DeepEval regression gate.
- Canary.
- p95 down 50%, cost/request down 3x, quality held.

Lesson:

> Cheaper models can win when eval discipline is strong.

### 7. Failure - Overclean Metric

Use for:

- Humility.
- Evaluation rigor.
- Learning.

Core:

- Early synthetic translation eval overstated as 100%.
- Broader sample found edge cases.
- Reworked to N=500, >=95%.
- Now always report denominator/confidence/sample.

Lesson:

> Clean numbers are suspicious until the denominator is visible.

### 8. Communication - Explaining ML To Workflow Owners

Use for:

- Non-technical communication.
- Customer adoption.

Core:

- Needed to explain abstention/confidence.
- Used two real contracts, no equations.
- Stakeholder said it behaves like best analyst, faster.

Lesson:

> The right example beats the right equation when people need to act.

## Behavioral Question Map

- Why Google/FDE: opener + AutoResearch/MCP.
- Ownership: Data Sentry.
- Ambiguity: J&J heuristics.
- Failure: overclean metric.
- Conflict: hard gate vs override.
- Troubleshooting: Gracenote ingestion.
- Customer impact: J&J or Data Sentry.
- Innovation: AutoResearch/MCP.
- Cost tradeoff: Sonnet to Haiku.
- Communication: explaining ML.
- Security/privacy: Data Sentry or J&J.

## Presentation Defense

If asked to present or deep-dive, use one of:

1. J&J decision-support model.
2. Gracenote Haiku migration.
3. AutoResearch/MCP tool loop.

Structure:

- Context.
- Stakes.
- Constraints.
- Architecture.
- Tradeoffs.
- Eval/observability.
- Rollout.
- Result.
- Reusable lesson.

## Questions To Ask Interviewers

Pick based on interviewer:

- "What are the most common blockers between GenAI prototype and production for this FDE team?"
- "How does the team decide when to build bespoke customer code versus reusable assets?"
- "How do FDEs feed product gaps back to ADK, Agent Engine, or Vertex AI teams?"
- "What would excellent performance look like in the first 6 months?"
- "How much of the work is embedded customer delivery versus internal product/reference architecture work?"

## Compensation Script

Do not negotiate too early.

If asked current:

> My current fixed compensation is INR 33L, with no equity component.

If asked expectations:

> I would like to understand the level and ladder first. For Google, I would anchor on market and level rather than current compensation, and I am flexible on base, stock, and bonus split.

If pressed:

> For Google India, public L4/L5 technical IC data points suggest a broad range from around INR 70L to INR 1.2Cr+ total compensation depending on level. I would want to calibrate against the role's actual level.

If recruiter says base cap:

> That helps. I would still want to understand total compensation, including equity, bonus, and joining bonus, because base alone does not describe the full Google package.

## Leveling Script

Ask:

> Is this mapped to L4, L5, or a Google Cloud customer-engineering ladder? I am asking because I want to calibrate expectations and interview performance against the right bar.

## Red Flags To Avoid

Do not say:

- "I am preparing 18 hours/day because I am desperate."
- "I am too smart for the current role."
- "I mainly use AI agents, so manual coding is not my thing."
- "I want Google for compensation."
- "The business was wrong."
- "I would just use Gemini/RAG."

Say:

- "I am using the time to prepare across fundamentals and production design."
- "I am looking for a steeper embedded-builder role."
- "I use AI tools heavily, and I have been deliberately practicing no-run fundamentals for this format."
- "The compensation should match level and market."
- "The business constraints were not yet represented in the data."
- "The system needs data, integration, eval, security, and rollout, not only a model."
