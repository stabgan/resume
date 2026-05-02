# STAR Stories — Full Scripts

10 stories that cover the 6 capabilities Google grades FDEs on. Each one runs 60–90 seconds when told aloud. Rehearse in front of a mirror until you can tell them without looking.

## The STAR structure (non-negotiable)

- **S**ituation — 2 sentences: the context, the stakes
- **T**ask — 1 sentence: what specifically YOU had to deliver
- **A**ction — 4–5 sentences: what YOU did (not the team)
- **R**esult — 2 sentences: the number + the lesson

Never say "we" when you mean "I". Interviewers will count the "we"s.

## How to use this file

Each story below has:
- **The cue** — the question shape that triggers this story
- **The 90-second script** — practiced prose, not notes
- **The FDE capability it demonstrates** (from `CANONICAL_JD.md`)
- **Follow-up answers** — what to say if the interviewer drills in

---

## Story 1 — Ownership beyond responsibility

### Cue
*"Tell me about a time you took ownership of a problem that wasn't technically your responsibility."*

### Capability
#6 — Field insights → product requests. #4 — Discovery + ownership.

### 90-second script

> At TCS I was technically a data engineer — my job was ETL pipelines feeding ML models for J&J Vision and later the Contract Commitment Portal at J&J MedTech. But about six months in, I noticed our IAM team was spending days onboarding and offboarding users across AWS, Azure, and GCP. It wasn't my scope, but it was slowing every cross-cloud project I cared about.
>
> I asked to shadow the IAM team for two days. I watched them click through three different consoles for every single user. Then I built a tool called Data Sentry — a Python wrapper around AWS Lambda and Microsoft Graph OAuth that automated the whole onboarding and offboarding flow across about 500 users. I didn't ask for time to do it; I did it in parallel with my day job.
>
> The cycle time went from days to minutes. More importantly, when we later scaled to other J&J business units, they adopted it without my involvement. The lesson I took was that the most interesting problems usually aren't in your current JD — they're one layer over, where someone else is stuck.

### Follow-ups
- *"What was the hardest part?"* → "Figuring out Microsoft Graph OAuth without documentation. I spent two evenings reverse-engineering the token flow by reading Microsoft's sample apps."
- *"How did you know it wasn't wasted effort?"* → "Two things: the IAM team asked me for weekly status updates within three weeks, and other groups started asking to adopt it unprompted."

---

## Story 2 — Requirements changed mid-delivery

### Cue
*"Describe a time a customer's requirements changed significantly mid-deployment."*

### Capability
#4 — Discovery → spec → ship with C-suite.

### 90-second script

> At J&J MedTech, I was three weeks into building an ML model for the Contract Commitment Portal. The spec was: predict analyst approval decisions from historical data, AUROC as the primary metric. Clean problem.
>
> Week three, I discovered something that broke the spec. The "rules" the business was describing weren't actually documented anywhere — they were tribal knowledge that differed across the NA, LATAM, and APAC teams. The analysts followed heuristics nobody had ever written down. I couldn't just train on historical decisions because the historical decisions were inconsistent across regions.
>
> I paused and pulled in the program Director. I explained the data reality and proposed a different shape: instead of predicting approvals, we'd build a decision-support model that scored confidence and let the analyst either accept or override. I rewrote the ML spec in one afternoon, got it signed off by legal, security, and the change-advisory board within a week, and we were back to shipping.
>
> The model hit AUROC 0.95 with isotonic calibration and a leakage audit, and it's now the default decision path across NA and APAC. The real lesson was: if the documented rules don't match the observed data, stop training models until someone answers why.

### Follow-ups
- *"Why didn't the original spec work?"* → "The historical dataset had a 12% disagreement rate across regions on identical contract types. Training on that without a reconciliation mechanism would have encoded the inconsistency."
- *"How did you explain this to the program Director?"* → "I built a 2-slide deck with two sample contracts where analysts in different regions reached different decisions. One image closed the argument faster than any memo."

---

## Story 3 — Diagnosed a problem in an unfamiliar environment

### Cue
*"Tell me about a time you diagnosed a problem in an environment you'd never seen before."*

### Capability
#2 — Messy customer infrastructure. #6 — Field insights.

### 90-second script

> I joined Gracenote about a year ago. In my first month, I was handed the ingestion pipeline that feeds 1500+ partner catalogs into Gracenote's production database — about 1.5M records a month from Netflix, Amazon, and many others. The previous engineer had left. The pipeline was rules-only and had been limping along with a false-positive rate high enough to generate partner escalations every week.
>
> I didn't know the codebase. I didn't know the product. I started the only way I know how: I took the top 20 false-positive cases from the last month and traced each one by hand from source catalog through transformation to final match. About halfway through, I noticed a pattern — temporal ambiguity. When a partner added a new episode before our metadata pipeline had seen the show, we were matching it to the wrong series.
>
> I did two things in parallel. Short-term, I proposed temporal heuristics on top of the existing rules engine. Medium-term, I replaced the classifier core — proper hyperparameter search plus a swap from XGBoost to LightGBM. Inference got 2x faster, false positives dropped 58%, precision settled at 97%, and partner escalations eased off within six weeks.
>
> The lesson: the fastest way to understand a system you didn't build is to debug its actual failures, not to read the docs.

### Follow-ups
- *"How did you know temporal was the right hypothesis?"* → "The false-positive rate correlated with new-content weeks. Once I plotted it, the correlation was obvious."
- *"Why XGBoost → LightGBM?"* → "Inference latency. XGBoost was doing the work fine but the single-entry path was over budget. LightGBM's leaf-wise growth is faster on the shape of features we had."

---

## Story 4 — Disagreed with a senior stakeholder

### Cue
*"Tell me about a time you disagreed with a senior stakeholder and had to navigate it."*

### Capability
#4 — Discovery + stakeholder navigation.

### 90-second script

> At J&J MedTech, the program Director wanted to deploy the contract-approval model as a hard gate — every case would be auto-decided. I thought that was premature; AUROC 0.95 in a holdout is not the same as zero risk in production, especially in a regulated business.
>
> I disagreed with the approach. But I didn't push back verbally — I wrote a 1-page memo with a decision matrix showing cost of false positives versus false negatives for four deployment modes: hard gate, recommendation with override, confidence-gated automation, and human-in-the-loop. I showed the estimated dollar and compliance cost of each.
>
> I sent it the evening before our next review. The Director came back the next morning and said "this is what we needed — let's do recommendation with override for three months, then revisit." We ran a 2-month A/B pilot with no rollbacks. It became the default decision path on the portal.
>
> What I learned: disagreement works better in writing than in conversation, and it works better when you give the other person the tools to change their mind publicly without losing face.

### Follow-ups
- *"Would you handle it differently today?"* → "Probably surface the memo earlier — it saved the discussion, but if I'd shown a 30-second version in the first meeting it would have saved two weeks of ambiguity."

---

## Story 5 — Converted field friction into a tool ⭐ (your flagship story)

### Cue
Anything about: *"how do you work day to day"*, *"tell me about your side projects"*, *"how did you find those new techniques"*.

### Capability
#6 — Field insights → product requests. **This is THE capability the Google FDE JD calls out: "Convert field friction → product feature requests." Your story is a literal match.**

### 90-second script

> A few months into the EmbeddingGemma fine-tuning work at Gracenote, I realized I was re-doing the same literature search for every experiment — surveying relevant arxiv papers, checking what hard-negative mining strategies worked on similar tasks, looking up whether Matryoshka was appropriate.
>
> Karpathy had open-sourced a project called AutoResearch — a harness that uses an LLM to scout literature and generate hypotheses before experiments. I forked it and extended it for production use: I added hypothesis logs, memory logs, and a research-plan-then-execute loop so each experiment step is deliberate. Then I swapped the default research agent for kiro-cli, which runs locally, and wired up two MCP servers — Firecrawl for web search, and my own steelmind-thinking MCP for structured reasoning and steel-manning.
>
> That harness ended up driving the technique picks on EmbeddingGemma — curriculum hard-negative mining, 4-directional GTE-style loss, Matryoshka with weighted dimension slices. Accuracy@1 and accuracy@5 each improved by 12 points on a temporally-split holdout.
>
> What I liked about this is that I didn't set out to build a "tool." I set out to stop doing annoying manual work and the tool fell out. That's how my best side projects have happened — my two published MCP servers on npm also came from this pattern.

### Follow-ups
- *"What did you build on top of Karpathy's base?"* → "Four things: hypothesis log, memory log, a research-plan-then-execute loop per step, and MCP server integration for live search and structured reasoning."
- *"Why kiro-cli specifically?"* → "It runs locally, it has a clean MCP integration, and the agent loop is simple enough to reason about. I wanted something I could debug if the research step produced bad hypotheses."
- *"Do you think Google should build something like this?"* → **This is the gift question. The answer is:** "Yes — I think the Agent Development Kit could absorb a 'research-first' pattern for agentic experiments. It's a field pattern I've seen across the ML team at Gracenote. I'd happily write that up as a product feedback doc if I joined."

---

## Story 6 — Simplified complex for a non-technical audience

### Cue
*"Tell me about a time you had to explain something technical to a non-technical stakeholder."*

### Capability
#4 — Discovery with non-engineering stakeholders.

### 90-second script

> At J&J MedTech, I ran a monthly sync with the approval workflow owners — finance leads and regional operations managers. None of them had ML backgrounds. In one session, I had to explain why our model sometimes flagged a high-confidence approval and other times abstained, even when the contracts looked superficially similar.
>
> I realized they didn't need probability theory. They needed a mental model they could act on. So I showed them two contracts I'd picked from the last month. For each, I walked through what the model saw, what made one confident and the other ambiguous, and what their own analysts would likely have flagged. No math, no graphs — just two examples.
>
> By the end of the meeting, one of the regional managers said "oh, so it's doing what my best analyst does, just faster." That became the team's internal explanation of the model. Nobody ever asked me about probability again.
>
> The lesson: the right analogy is more valuable than the right equation when the audience has to act on it.

### Follow-ups
- *"What if the analogy breaks?"* → "Then I add a second one. The goal isn't a perfect model — it's a model good enough for the decisions the audience needs to make."

---

## Story 7 — Big bet on unproven technology

### Cue
*"Tell me about a time you took a risk on a new technology."*

### Capability
#3 — Eval + observability with LLM-native metrics. #1 — Production agentic systems.

### 90-second script

> At Gracenote we were running a 10K-request-per-day inference service on Claude 3.7 Sonnet for media-description generation. It was expensive. The team had looked at Haiku but assumed the quality drop was too risky to migrate.
>
> I argued we could close the quality gap with DSPy. Specifically: compile the prompts on Haiku using MIPROv2, then bring in GEPA — which had just come out of Stanford and Berkeley in 2025 — for reflective prompt evolution. And an InferRules-style miner to extract editorial patterns from live production traces.
>
> I pitched it with one DeepEval regression suite that I'd gate the migration on — if quality stayed within one point of baseline on the golden set, we'd proceed. If not, we'd roll back. It ran as a canary first, then full traffic.
>
> Quality held. p95 latency fell 50%. Cost per request dropped 3x. Two adjacent teams picked up the same pattern in the following month. The senior lesson: a cheap model with good prompt optimization often beats an expensive model with default prompts — if and only if you have the eval discipline to prove it.

### Follow-ups
- *"What would you have done if quality regressed?"* → "Rolled back on the spot. The DeepEval regression suite had an automated fail flag. That was the whole point — we decided ahead of time what unacceptable looked like."
- *"Explain GEPA in one minute"* → "GEPA is a prompt optimizer from Stanford/Berkeley. Instead of gradient-based updates, it samples trajectories — the agent's reasoning and tool calls — and reflects on them in natural language to diagnose failures. It maintains a Pareto frontier of prompt candidates and combines complementary lessons across them. On six tasks it beats GRPO by 6–20% using 35x fewer rollouts, and beats MIPROv2 by over 10%. The key insight is that natural language reflection is a richer learning medium for LLMs than sparse scalar rewards."

---

## Story 8 — Shipped with incomplete data

### Cue
*"Tell me about a time you had to ship something despite missing information."*

### Capability
#4 — Autonomy + judgment.

### 90-second script

> Same J&J MedTech engagement. When I discovered the approval heuristic wasn't documented, I had to make a call: wait weeks for the business to reconstruct the rules, or ship something useful with what I had.
>
> I chose to ship. I built the first version of the model on the subset of historical cases where NA and APAC had agreed on the decision — about 70% of the corpus. I explicitly excluded the disagreement cases and flagged them in the output as "manual review needed." It was a partial answer but it was honest about what it knew.
>
> Over the next two months, the analyst team used the outputs on the disagreement cases to actually reconcile the rules. By the time we retrained on the full corpus, the business finally had documented rules. The first model created the conditions for the second one.
>
> The lesson I keep coming back to: shipping the honest 70% sooner is almost always better than shipping the theoretical 100% later.

### Follow-ups
- *"How did you decide 70% was enough?"* → "I calibrated against the manual analyst workload. At 70% coverage with 4–5 hours saved per automated case, the team recouped about a week of analyst time per month. That was enough to justify the deploy."

---

## Story 9 — A failure and what changed

### Cue
*"Tell me about a failure."*

Don't use a fluffy one. Pick something real. Below is a template — fill with your actual failure, OR use the one below adapted to something true.

### 90-second script (adapt to a real one)

> Early at Gracenote, I proposed a synthetic-data pipeline for the translation workstream. I built a first version using an Ollama + Gemma 3 4B teacher loop, MIPROv2-tuned on 50 human few-shots. When I showed it to the team, I claimed a "100% pass rate from human reviewers."
>
> The failure was that "100%" number. Once I pushed the pipeline into wider use, reviewers started finding edge cases — rare languages, domain-specific terms — where the outputs were subtly wrong. The real acceptance rate was closer to 95% on a realistic N=500 sample. My original claim had been based on too-small a sample that happened to all pass.
>
> I should have known better. I got caught by the "suspiciously clean number" trap. I went back and redid the evaluation with proper sample sizes, noted the true acceptance rate, and recalibrated my confidence bounds. Since then, I distrust any result that looks too round — 100%, 2x, 3x. I always ask "what sample size, and what's the confidence interval."
>
> It also changed how I write. I now put the denominator in every resume bullet that has a percentage. That's a small thing but it's a tell that the writer respects the reader.

### Follow-ups
- *"What would you do differently from day one?"* → "Lead with sample sizes on every metric I report. And I'd separate 'golden set accuracy' from 'field acceptance rate' as two distinct numbers."

---

## Story 10 — Why FDE, why Google? *(not STAR, but rehearse the answer)*

### Cue
*"Why are you interested in this role? Why Google?"*

### 60-second script

> Two reasons, honestly.
>
> First, the FDE role is the job I'm already doing, just with a clearer label. The open-source MCP work I do on the side — the two npm packages, the Karpathy AutoResearch extension — is the "convert field friction into reusable tools" pattern the JD calls out. My two years embedded with J&J MedTech teams was the "white-glove deployment" pattern. I don't want to stop doing this work. I want to do it full-time with a platform behind me.
>
> Second, Google specifically: Vertex AI, ADK, and Gemini Enterprise are where the frontier is moving for agentic systems. I've been building on LangGraph and shipping MCP servers, but the next generation of agentic infrastructure is being defined at Google right now — A2A, Agent Engine, Agentspace. I want to be on the team that embeds that at customers, not on the team that reads about it three quarters later.
>
> So that's it — the role fits how I already work, and Google is where the work happens.

### Follow-ups
- *"Why not Anthropic or OpenAI?"* → "I've thought about it. Honest answer: Google has the enterprise distribution that lets you embed with real Fortune-500 customers and see their actual constraints. That's the environment I want to learn in."
- *"Why now?"* → "I've been at Gracenote nine months and the work is good, but I can feel myself approaching the ceiling of what this product needs. FDE is a steeper curve."

---

# The rehearsal protocol

For 14 days, rehearse 1 story per night. Here's the schedule:

| Day | Story |
|---|---|
| 2 | #1 Ownership |
| 3 | #2 Requirements changed |
| 4 | **#5 Field friction → tool** (your flagship — do this on day 4 and again on day 13) |
| 5 | #7 Big bet |
| 8 | #3 Diagnosed unfamiliar |
| 9 | #4 Disagreed |
| 10 | GEPA explanation (from story 7 follow-up) |
| 11 | #6 Simplified complex |
| 12 | #8 Shipped incomplete / #9 Failure |
| 13 | #10 Why FDE + #5 Field friction (second pass) |

For each rehearsal: say the story aloud, standing, no notes, timed. Record if you can. Notice filler words ("um", "like", "you know") — these double under interview pressure.

## The one habit that wins behavioral rounds

**Pause before you start the story.** When asked a question, count to 2 silently. Then start. Every senior engineer who's been coached does this. It signals composure and that you're choosing the right story, not blurting the first one that comes to mind.
