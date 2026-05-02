# Behavioral Stories - Compact FDE Bank

These are the stories to keep hot for May 13. Each should fit in 60-90 seconds.

Use STAR, but do not announce STAR. Tell it naturally:

- Situation: context and stakes.
- Task: what you personally owned.
- Action: what you did.
- Result: measurable outcome and lesson.

## Story Map

| Cue | Story |
|---|---|
| Why Google / why FDE | Story 0 |
| Ownership beyond scope | Story 1 - Data Sentry |
| Ambiguity / changing requirements | Story 2 - J&J approval heuristics |
| Customer/system troubleshooting | Story 3 - Gracenote ingestion |
| Disagreement / influence | Story 4 - recommendation over hard gate |
| Field friction to reusable tool | Story 5 - AutoResearch and MCP |
| Cost/performance tradeoff | Story 6 - Sonnet to Haiku |
| Failure / humility | Story 7 - overclean metric |
| Simplifying complexity | Story 8 - explaining ML to workflow owners |

## Story 0 - Why FDE, Why Google

Cue:

> Why this role? Why Google?

Script:

> The FDE role is the clearest label for the work I already gravitate toward. At J&J MedTech I was embedded with business, legal, security, and engineering teams, turning an undocumented approval workflow into a production ML decision-support system inside their existing AWS footprint. At Gracenote, I am doing the same pattern for production GenAI: LangGraph workflows, eval gates, cost optimization, and tools that come from field friction.
>
> Google is interesting because the agentic stack is being defined there: Gemini, Vertex AI, ADK, Agent Engine, enterprise connectors, observability, and governance. I do not want to just build demos around frontier models. I want to make them work in messy enterprise environments, learn from the blockers, and feed those patterns back into reusable products.

Follow-up:

> Why not stay where you are?

Answer:

> The work is good, but the FDE role gives me a steeper version of the same curve: harder customer environments, stronger platform surface area, and a clearer mandate to convert implementation lessons into reusable assets.

## Story 1 - Ownership Beyond Scope: Data Sentry

Cue:

> Tell me about a time you took ownership outside your job.

Script:

> At TCS, while supporting J&J, I noticed the IAM team was spending days onboarding and offboarding users across AWS, Azure, and GCP. My formal role was data engineering and ML delivery, but this manual identity work slowed every cross-cloud project around us.
>
> I shadowed the IAM team, mapped the repetitive steps, and built Data Sentry: a Python automation around AWS Lambda and Microsoft Graph OAuth that handled onboarding and offboarding for about 500 users. I did it alongside my regular work because the pain was obvious and repeatable.
>
> The cycle time went from days to minutes, and other teams adopted it without me pushing. The lesson was that the best engineering opportunities often sit one layer outside your formal ticket queue.

FDE signal:

- Embedded in customer environment.
- OAuth/integration.
- Field friction became reusable automation.

## Story 2 - Ambiguity: J&J Approval Heuristics

Cue:

> Tell me about a time requirements changed or the problem was ambiguous.

Script:

> At J&J MedTech, I was building an ML model for contract approvals. The initial spec looked clean: predict analyst decisions from historical approvals. A few weeks in, I found the real blocker: the approval rules were not documented. NA, LATAM, and APAC analysts had tribal heuristics, and similar cases could be handled differently.
>
> I paused the original modeling plan and brought the program Director into the data reality. I showed examples where the stated process did not match historical decisions, then proposed a safer shape: decision support with confidence, override, and manual review for disagreement cases.
>
> That revised spec cleared legal, security, and CAB review. The model reached AUROC 0.95 on a temporal holdout with leakage audit and became the default decision path across NA/APAC. The lesson was: when the data contradicts the process, stop and fix the operating model before training a model on it.

FDE signal:

- Discovery before architecture.
- Judgment under ambiguity.
- Regulated customer environment.

## Story 3 - Troubleshooting Unknown System: Gracenote Ingestion

Cue:

> Tell me about diagnosing a system you did not know.

Script:

> When I joined Gracenote, I inherited an ingestion-classification pipeline feeding 1500+ partner catalogs and about 1.5M records per month. I did not know the codebase or product history, but partner escalations were coming from false positives.
>
> I started from actual failures, not documentation. I traced the top false-positive cases from source catalog through transformation and match. The pattern was temporal ambiguity: new episodes or titles arrived before our metadata pipeline had enough context, so rules matched them incorrectly.
>
> I layered temporal heuristics on the rules engine and tightened the ML core with proper hyperparameter search and an XGBoost to LightGBM switch. Single-entry inference became 2x faster, false positives dropped 58%, and precision settled around 97%. The lesson was: the fastest path into an unfamiliar system is through its real failures.

FDE signal:

- Troubleshooting.
- Production system thinking.
- Structured diagnosis.

## Story 4 - Disagreement: Human Override Instead Of Hard Gate

Cue:

> Tell me about a disagreement with a senior stakeholder.

Script:

> In the J&J contract-approval project, the program Director initially wanted the ML model to act as a hard gate. I thought that was risky. AUROC 0.95 is strong, but in a regulated approval process, a confident model is not the same as zero operational risk.
>
> I wrote a one-page decision matrix comparing four rollout modes: hard gate, recommendation with override, confidence-gated automation, and human-in-the-loop. I framed it around false-positive and false-negative cost instead of arguing from intuition.
>
> The Director chose recommendation with override for the pilot. We ran a two-month A/B pilot without rollback, and it became the default path. The lesson was that principled pushback works best when you give the stakeholder a way to change direction without losing face.

FDE signal:

- Influence without authority.
- Customer-risk judgment.
- Written decision-making.

## Story 5 - Field Friction To Reusable Tool: AutoResearch And MCP

Cue:

> How do you work day to day? Tell me about your side projects.

Script:

> During EmbeddingGemma fine-tuning at Gracenote, I found myself repeatedly doing the same research loop: reading papers, checking hard-negative strategies, deciding whether Matryoshka or other techniques fit, then translating that into experiments.
>
> I forked Karpathy's AutoResearch and hardened it for production ML use. I added hypothesis logs, memory logs, and a research-plan-then-execute loop. Then I wired it to kiro-cli, Firecrawl MCP for web search, and my own steelmind-thinking MCP for structured reasoning and steel-manning.
>
> That workflow influenced the technique selection for our EmbeddingGemma run: curriculum hard-negative mining, 4-directional GTE-style contrastive loss, and Matryoshka with weighted dimension slices. Accuracy@1 and accuracy@5 improved by 12 points on a temporal holdout. The broader lesson is the FDE pattern: repeated field friction should become a reusable tool.

FDE signal:

- Product feedback loop.
- MCP/tooling.
- High agency.

## Story 6 - Cost And Performance: Sonnet To Haiku

Cue:

> Tell me about a technical tradeoff or cost optimization.

Script:

> At Gracenote we had a 10K request/day media-description generation workflow on Claude 3.7 Sonnet. Quality was good, but cost and latency were too high. The team had looked at cheaper Haiku but worried about quality loss.
>
> I proposed treating it as an eval-gated migration, not a model swap. I compiled prompts on Haiku with DSPy techniques like MIPROv2 and GEPA, mined editorial rules from live traces, and used a DeepEval regression suite as the go/no-go gate. We canaried first, with rollback criteria decided before traffic moved.
>
> Quality held within one point on the golden set, p95 latency fell 50%, cost per request dropped 3x, and two adjacent teams adopted the pattern. The lesson was: cheaper models can win if the eval discipline is strong enough.

FDE signal:

- LLM-native metrics.
- Production evals.
- Cost/performance tradeoff.

## Story 7 - Failure: Overclean Metric

Cue:

> Tell me about a failure.

Script:

> Early in a synthetic-data pipeline for translation, I described a reviewer result too cleanly: effectively a 100% pass rate. It was based on a small friendly sample, and once the pipeline saw more realistic cases, reviewers found edge cases in rare languages and domain-specific terms.
>
> I corrected the evaluation, moved to a larger N=500 spot-check, and reported the more honest result: at least 95% acceptance, with the failure cases documented. I also separated golden-set quality from field acceptance instead of blending them.
>
> The lesson changed how I report metrics. I now distrust round numbers unless I can explain the denominator, sample design, and confidence. That is why my resume now qualifies metrics with holdout type and sample size where possible.

FDE signal:

- Humility.
- Evaluation rigor.
- Calibration.

## Story 8 - Simplifying Complexity: J&J ML Explanation

Cue:

> Tell me about explaining something technical to non-technical stakeholders.

Script:

> At J&J MedTech, I had to explain why the approval model sometimes made a high-confidence recommendation and sometimes abstained. The audience was finance and regional operations leaders, not ML engineers.
>
> Instead of explaining probability calibration, I picked two real contract examples. For each, I showed what the model saw, what a strong analyst would notice, and why one case was safe to recommend while another needed review.
>
> One manager summarized it as: "It is doing what my best analyst does, just faster." That became the internal explanation. The lesson was that the right concrete example beats the right equation when the audience has to act.

FDE signal:

- Customer communication.
- Adoption.
- Translation between engineering and business.

## Behavioral Questions And Which Story To Use

- "Tell me about yourself." Use Story 0 plus one technical proof.
- "Why Google?" Story 0.
- "Why FDE?" Story 0 plus Story 5.
- "Time you showed ownership." Story 1.
- "Ambiguous problem." Story 2.
- "Difficult stakeholder." Story 4.
- "Technical failure." Story 7.
- "Customer problem." Story 2 or 8.
- "Debugging." Story 3.
- "Cost/performance." Story 6.
- "Innovation." Story 5.
- "Security/privacy." Story 1 or 2.
- "Leadership without authority." Story 4.

## Phrases To Avoid

Do not say:

- "We just used an LLM."
- "I am rusty at DSA."
- "I mostly use AI agents so I may be slow."
- "It was easy."
- "I do not know GCP deeply."
- "The business did not understand."

Say instead:

- "The model was one part of the production system."
- "I have been practicing no-run coding because that is the interview format."
- "I use AI tools heavily in daily work, and I have been rebuilding manual fundamentals for the interview."
- "The hard part was the integration/evaluation/customer constraint."
- "My production depth is stronger on AWS and enterprise environments, and I have mapped those patterns to Google Cloud primitives."
- "The business had valid constraints that were not yet encoded in the data."

## Rehearsal Protocol

Every night:

1. Pick one story.
2. Say it standing, no notes.
3. Time it.
4. Cut anything beyond 90 seconds.
5. End with one lesson.

The lesson is what makes it senior.
