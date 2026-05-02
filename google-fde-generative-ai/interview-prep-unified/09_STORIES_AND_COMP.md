# Stories + Compensation

Eight STAR stories (60–90 seconds each) + the comp negotiation script. Rehearse **aloud**, standing, no notes. The lesson at the end is what makes each story senior.

## Story format

- **Situation** — context + stakes (2 sentences)
- **Task** — what YOU personally owned (1 sentence)
- **Action** — what YOU did (4–5 sentences)
- **Result** — measurable outcome + lesson (2 sentences)

Never say "we" when you mean "I". Interviewers count the "we"s.

## Quick map — which story for which question

| Cue | Use this story |
|---|---|
| "Why Google? Why FDE?" | Story 0 |
| "Tell me about ownership beyond your scope" | Story 1 — Data Sentry |
| "Time requirements changed" / "ambiguous problem" | Story 2 — J&J approval heuristics |
| "Diagnose unfamiliar system" / "troubleshoot" | Story 3 — Gracenote ingestion |
| "Disagreement with stakeholder" / "pushback" | Story 4 — hard-gate disagreement |
| "Convert field friction into tool" / "side projects" / "how do you work?" | Story 5 — AutoResearch + MCP ⭐ |
| "Big bet / new tech" / "cost vs. quality" | Story 6 — Sonnet → Haiku |
| "Simplify for non-technical stakeholders" | Story 7 — J&J ML explanation |
| "Failure" | Story 8 — overclean metric |

---

## Story 0 — Why FDE, Why Google (60 seconds)

### Cue
*"Why this role? Why Google?"*

### Script

> The FDE role is the clearest label for the work I already gravitate toward. At J&J MedTech I was embedded with business, legal, security, and engineering teams, turning an undocumented approval workflow into a production ML decision-support system inside their existing AWS footprint. At Gracenote I'm doing the same pattern for production GenAI: LangGraph workflows, eval gates, cost optimization, and tools that come from field friction.
>
> Google is interesting because the agentic stack is being defined there — the Gemini Enterprise Agent Platform, ADK, Agent Runtime, Agent Gateway, managed MCP servers, enterprise connectors, observability, governance. I don't want to just build demos around frontier models. I want to make them work in messy enterprise environments, learn from the blockers, and feed those patterns back into reusable products.

### Follow-up
*"Why not stay where you are?"*

> The work is good, but the FDE role gives me a steeper version of the same curve — harder customer environments, stronger platform surface area, and a clearer mandate to turn implementation lessons into reusable assets.

---

## Story 1 — Ownership: Data Sentry (90 sec)

### Cue
*"Tell me about a time you took ownership beyond your job."*

### Script

> At TCS while supporting J&J, I noticed the IAM team was spending days onboarding and offboarding users across AWS, Azure, and GCP. My formal role was data engineering and ML delivery, but this manual identity work was slowing every cross-cloud project around us.
>
> I shadowed the IAM team, mapped the repetitive steps, and built Data Sentry — a Python automation around AWS Lambda and Microsoft Graph OAuth that handled onboarding and offboarding for about 500 users. I did it alongside my regular work because the pain was obvious and repeatable.
>
> The cycle time went from days to minutes, and other teams adopted it without me pushing. The lesson was that the best engineering opportunities often sit one layer outside your formal ticket queue.

### Follow-ups
- *"What was the hardest part?"* → "Figuring out Microsoft Graph OAuth without documentation. I spent two evenings reverse-engineering the token flow by reading Microsoft's sample apps."
- *"How did you know it wasn't wasted?"* → "Two signs: the IAM team asked me for weekly status updates within three weeks, and other groups adopted it unprompted."

### FDE signals
Embedded in customer environment. OAuth/integration depth. Field friction → reusable tool.

---

## Story 2 — Ambiguity: J&J Approval Heuristics (90 sec)

### Cue
*"Describe a time requirements changed significantly mid-delivery"* / *"ambiguous problem"*

### Script

> At J&J MedTech, I was three weeks into building an ML model for contract approvals. The spec looked clean: predict analyst decisions from historical approvals. A few weeks in, I found the real blocker — the approval rules weren't documented anywhere. NA, LATAM, and APAC analysts had tribal heuristics, and similar cases could be handled differently.
>
> I paused and pulled in the program Director. I explained the data reality and proposed a different shape: instead of predicting approvals, we'd build a decision-support model that scored confidence and let the analyst accept or override. I rewrote the ML spec in one afternoon, got it signed off by legal, security, and the change-advisory board within a week, and we were back to shipping.
>
> The model hit AUROC 0.95 with isotonic calibration and a leakage audit, and it's now the default decision path across NA and APAC. The lesson was: when the data contradicts the documented process, stop training models and fix the operating model first.

### Follow-ups
- *"Why didn't the original spec work?"* → "The historical dataset had a 12% disagreement rate across regions on identical contract types. Training on that without a reconciliation mechanism would have encoded the inconsistency."
- *"How did you explain it to the program Director?"* → "I built a 2-slide deck with two real contracts where analysts in different regions reached different decisions. One image closed the argument faster than any memo."

### FDE signals
Discovery before architecture. Customer-risk judgment. Regulated environment.

---

## Story 3 — Diagnosed Unfamiliar System: Gracenote Ingestion (90 sec)

### Cue
*"Tell me about diagnosing a system you didn't know."*

### Script

> I joined Gracenote about a year ago. In my first month, I was handed the ingestion-classification pipeline that feeds 1500+ partner catalogs into Gracenote's database — about 1.5M records a month. The previous engineer had left. The pipeline was rules-only and had been limping along with a false-positive rate high enough to generate partner escalations every week.
>
> I didn't know the codebase. I didn't know the product. I started by tracing the top 20 false-positive cases from source catalog through transformation to final match. About halfway through, I noticed a pattern — temporal ambiguity. When a partner added a new episode before our metadata pipeline had seen the show, we were matching it to the wrong series.
>
> I did two things in parallel. Short-term: temporal heuristics on top of the existing rules. Medium-term: replaced the classifier core — proper hyperparameter search plus a swap from XGBoost to LightGBM. Inference got 2× faster, false positives dropped 58%, precision settled at 97%, and partner escalations eased off within six weeks.
>
> The lesson: the fastest way to understand a system you didn't build is to debug its actual failures, not to read the docs.

### Follow-ups
- *"How did you know temporal was the right hypothesis?"* → "The false-positive rate correlated with new-content weeks. Once I plotted it, the correlation was obvious."
- *"Why XGBoost → LightGBM?"* → "Single-entry inference latency. XGBoost was doing the work fine, but the single-entry path was over budget. LightGBM's leaf-wise growth is faster on the shape of features we had."

### FDE signals
Troubleshooting. Production-system thinking. Structured diagnosis.

---

## Story 4 — Disagreement: Hard Gate vs Override (75 sec)

### Cue
*"Tell me about disagreeing with a senior stakeholder."*

### Script

> At J&J MedTech, the program Director wanted to deploy the contract-approval model as a hard gate — every case auto-decided. I thought that was premature. AUROC 0.95 in a holdout is not the same as zero risk in production, especially in a regulated business.
>
> I didn't push back verbally. I wrote a 1-page memo with a decision matrix showing cost of false positives vs. false negatives for four deployment modes: hard gate, recommendation with override, confidence-gated automation, and human-in-the-loop. I showed the estimated dollar and compliance cost of each.
>
> I sent it the evening before our next review. The Director came back the next morning and said *"this is what we needed — let's do recommendation with override for three months, then revisit."* We ran a 2-month A/B pilot with no rollbacks. It became the default decision path.
>
> What I learned: disagreement works better in writing than in conversation, and it works better when you give the other person the tools to change their mind publicly without losing face.

### Follow-up
- *"Would you handle it differently today?"* → "Probably surface the memo earlier. It saved the discussion, but if I'd shown a 30-second version in the first meeting, it would have saved two weeks of ambiguity."

### FDE signals
Influence without authority. Customer-risk judgment. Written decision-making.

---

## Story 5 — Field Friction → Tool: AutoResearch + MCP ⭐ (90 sec)

### Cue
Anything about *"how do you work day to day"*, *"tell me about your side projects"*, *"how did you find those new techniques"*.

**This is your FLAGSHIP story.** It literally demonstrates the core FDE capability — converting field friction into reusable tools and product feedback.

### Script

> A few months into the EmbeddingGemma fine-tuning work at Gracenote, I realized I was re-doing the same literature search for every experiment — surveying relevant arxiv papers, checking hard-negative mining strategies that worked on similar tasks, looking up whether Matryoshka was appropriate.
>
> Karpathy had open-sourced a project called AutoResearch — a harness that uses an LLM to scout literature and generate hypotheses before experiments. I forked it and extended it for production use: I added hypothesis logs, memory logs, and a research-plan-then-execute loop so each experiment step is deliberate. I swapped the default research agent for kiro-cli, which runs locally, and wired up two MCP servers — Firecrawl for web search, and my own steelmind-thinking MCP for structured reasoning and steel-manning.
>
> That harness drove the technique picks on EmbeddingGemma — curriculum hard-negative mining, 4-directional GTE-style loss, Matryoshka with weighted dimension slices. Accuracy@1 and accuracy@5 each improved by 12 points on a temporally-split holdout.
>
> What I liked about this is I didn't set out to build a "tool." I set out to stop doing annoying manual work, and the tool fell out. That's how my best side projects have happened — my two published MCP servers on npm came from this same pattern.

### Follow-ups
- *"What did you build on top of Karpathy's base?"* → "Four things: hypothesis log, memory log, research-plan-then-execute loop per step, and MCP server integration for live search and structured reasoning."
- *"Why kiro-cli specifically?"* → "It runs locally, it has a clean MCP integration, and the agent loop is simple enough to reason about. I wanted something I could debug if the research step produced bad hypotheses."
- *"Do you think Google should build something like this?"* → **Gift question. Answer:** "Yes — I think ADK could absorb a 'research-first' pattern for agentic experiments. It's a field pattern I've seen across the ML team at Gracenote. I'd happily write that up as a product feedback doc if I joined."

### FDE signals
Product feedback loop. High agency. Agentic tooling. Tool reuse.

---

## Story 6 — Cost/Performance: Sonnet → Haiku (90 sec)

### Cue
*"Tell me about a technical tradeoff"* / *"cost optimization"*

### Script

> At Gracenote we had a 10K request/day media-description generation workflow on Claude 3.7 Sonnet. Quality was good, but cost and latency were too high. The team had looked at cheaper Haiku and assumed the quality drop was too risky to migrate.
>
> I argued we could close the quality gap with DSPy. Specifically: compile the prompts on Haiku using MIPROv2, then bring in GEPA — which had just come out of Stanford/Berkeley in 2025 — for reflective prompt evolution. And an InferRules-style miner to extract editorial patterns from live production traces.
>
> I pitched it with a DeepEval regression suite that I'd gate the migration on — if quality stayed within one point of baseline on the golden set, we'd proceed. If not, we'd roll back. It ran as a canary first, then full traffic.
>
> Quality held. p95 latency fell 50%. Cost per request dropped 3×. Two adjacent teams picked up the same pattern. The lesson: a cheap model with good prompt optimization often beats an expensive model with default prompts — if and only if you have the eval discipline to prove it.

### Follow-ups
- *"What would you have done if quality regressed?"* → "Rolled back on the spot. The DeepEval regression suite had an automated fail flag. That was the whole point — we decided ahead of time what unacceptable looked like."
- *"Explain GEPA in one minute"* → "GEPA is a prompt optimizer from Stanford/Berkeley, 2025. Instead of gradient-based updates, it samples trajectories — the agent's reasoning and tool calls — and reflects on them in natural language to diagnose failures. It maintains a Pareto frontier of prompt candidates and combines complementary lessons across them. On six tasks it beats GRPO by 6–20% using 35× fewer rollouts, and beats MIPROv2 by over 10%. The key insight is that natural-language reflection is a richer learning medium for LLMs than sparse scalar rewards."

### FDE signals
LLM-native metrics. Eval discipline. Production cost optimization.

---

## Story 7 — Simplified Complexity: J&J ML Explanation (75 sec)

### Cue
*"Explain something technical to a non-technical stakeholder."*

### Script

> At J&J MedTech I ran a monthly sync with the approval workflow owners — finance leads and regional operations managers. None had ML backgrounds. In one session, I had to explain why our model sometimes flagged a high-confidence approval and other times abstained, even when the contracts looked superficially similar.
>
> I realized they didn't need probability theory. They needed a mental model they could act on. I showed them two contracts I'd picked from the last month. For each, I walked through what the model saw, what made one confident and the other ambiguous, and what their own analysts would likely have flagged. No math, no graphs — just two examples.
>
> By the end, one regional manager said *"oh, so it's doing what my best analyst does, just faster."* That became the team's internal explanation of the model. Nobody ever asked me about probability again.
>
> The lesson: the right analogy is more valuable than the right equation when the audience has to act on it.

### FDE signals
Customer communication. Adoption. Translation between engineering and business.

---

## Story 8 — Failure: Overclean Metric (75 sec)

### Cue
*"Tell me about a failure."*

Use this one — it's real, shows calibration, and is recoverable.

### Script

> Early in a synthetic-data pipeline for translation, I described a reviewer result too cleanly — effectively a 100% pass rate. It was based on a small friendly sample, and once the pipeline saw more realistic cases, reviewers started finding edge cases in rare languages and domain-specific terms. The real acceptance rate was closer to 95% on a realistic N=500 sample.
>
> I should have known better. I got caught by the "suspiciously clean number" trap. I went back and redid the evaluation with proper sample sizes, reported the true acceptance rate, and recalibrated my confidence bounds.
>
> Since then, I distrust any result that looks too round — 100%, 2×, 3×. I always ask "what sample size, and what's the confidence interval." It also changed how I write — I now put the denominator in every bullet that has a percentage. Small thing, but it's a tell that the writer respects the reader.

### Follow-up
- *"What would you do differently from day one?"* → "Lead with sample sizes on every metric I report. And separate 'golden set accuracy' from 'field acceptance rate' as two distinct numbers."

### FDE signals
Humility. Evaluation rigor. Calibration.

---

# Rehearsal protocol

For 11 days, rehearse one story per night. Schedule from `00_EXECUTION_PLAN.md`:

| Day | Story |
|---|---|
| 2 | #1 Ownership |
| 3 | #2 Ambiguity |
| 4 | **#5 Field friction ⭐** (do twice — this is your flagship) |
| 5 | #7 Big bet (Haiku migration) |
| 6 | #3 Unfamiliar system |
| 7 | #4 Disagreement |
| 8 | #7 Simplify complexity |
| 9 | Pick the weakest from above |
| 10 | #8 Failure |
| 11 | #0 Why Google + **#5 again** |
| 12 | Full recital — all 8, each under 90 sec |

Each rehearsal: standing, no notes, timed. Record if you can.

Count filler words — "um", "like", "you know", "basically". These double under interview pressure. Practice replacing them with **pauses**.

---

# Compensation Script

Use this when Priyanka (or any interviewer) raises compensation.

## Anchor you already have (from HR call)

HR told you: **base capped around ₹40L, stocks "similar added" on top, level determined by interview performance.** Decoded, this maps to Y1 total around ₹85-90L, which reads closer to L4 than to standard L5 India bands.

Don't treat the HR anchor as the final number. The compensation committee sets the final offer after the loop based on your actual level signal. Your job at any comp conversation now is to leave room for L5 upside without fighting the base.

## Current comp

> My current fixed is ₹33L. No variable or stock — Gracenote is a fixed-pay structure.

Say it calmly. Don't apologize. Don't explain.

## Expected comp — first response (redirect to interview performance)

> I'd rather focus on nailing the interviews and let the level set the comp. My read of the market based on public data is that L4 in this function lands around ₹75-85 lakh total, and L5 at ₹1.0-1.2 crore total, with FDE typically running slightly above SWE because of the customer-facing element. I'm comfortable working within whichever level the interview process calibrates to, as long as the offer reflects that level.

This acknowledges the HR anchor without accepting it as a cap. Plants the L5 ceiling without demanding it.

## If she asks you to commit to one number

> If I have to pick a single number for planning, I'd say ₹1.0 crore total for L5, around ₹80 lakh for L4. I'm flexible on the split between base, stock, and bonus.

**Then stop talking.** Silence is your friend. Don't walk the number back.

## If she says "base is capped at ₹40L, we don't move there"

Don't fight base. Fight stock and bonus.

> That's fair on base. Where I'd want to focus in the offer discussion is stock and bonus. For the level I end up at, I'd want the stock grant and bonus target to reflect the customer-facing nature of the role and market data for that level. Coming from a fixed-only pay structure, stock is where the total-comp story gets built for me.

## If the offer comes in at ₹85-90L for L5 (underbanded)

Don't accept verbally on the call. Say:

> I appreciate the offer. Can I take 48 hours to review the full breakdown? I want to make sure I understand the full vesting schedule and benefits before committing.

Then counter once with a single, specific ask:

> I've reviewed the package. Based on market data for L5 customer-facing engineering at Google India, I was expecting total comp closer to ₹1.0 crore. Is there room to move on the stock grant? I understand the base is fixed at ₹40L, so I'm focused on stock and bonus.

Accept whatever comes back. The base ₹40L is likely firm. The stock has some flexibility.

## If they say "that's a big jump from ₹33L"

> It is, and that's exactly why this conversation is useful. My current pay reflects Gracenote's fixed structure, not the market for the work I'm actually doing. Google's pay bands for this role reflect the market. I'd rather be honest about current than inflate — I trust the process to land on a fair number.

## Other comp questions you should be ready for

### "Are you in other processes?"

If yes, be honest without naming:

> I'm in late stages with one other process. I'm not rushing it, and my timeline with Google is whatever Google's timeline is. I mention it because it's factually true, not as a lever.

If no:

> I'm not. Google is the process I'm actively pursuing because the role fits what I want next.

### "What's your notice period?"

Straight facts:

> Two months at Gracenote. Standard Indian tech notice. I can negotiate a shorter exit if the offer timing requires it, but two months is the default.

### "Relocation?"

If remote/Hyderabad role:

> I'm in Hyderabad currently. No relocation needed unless the role requires Bangalore or Gurgaon on-site, in which case I'd want to understand the housing and relocation support.

If Bangalore/Gurgaon required:

> Open to relocating. I'd want to understand the package covers the move, temporary housing for 30-60 days, and any school/spouse considerations if applicable.

### "What about signing bonus and RSU refreshers?"

Don't ask for specific numbers in the first call. Say:

> I'd want to look at the total offer including signing, stock vest schedule, and refreshers once we're at that stage. For Indian L4/L5 at Google, I know the ranges are public on Levels and similar platforms; I'll be reasonable and I'd expect the same from Google.

### "Can you join in 30 days?"

Don't commit on a call. Say:

> My notice is 2 months, so realistically 45-60 days. If Google needs someone faster, I can ask Gracenote for an early release, but I'd rather not burn that bridge unless the offer is strong and final.

### "Would you take a lateral offer (no level bump)?"

Direct answer:

> It depends on total comp and scope. If the FDE role gives me the surface area I'm looking for — customer embedding, production agentic work, product feedback loop — and the comp matches L5 market for my experience, level title matters less. If the role is scoped below FDE IC, we'd need to talk more.

### "Are you a flight risk? You've moved every 2-3 years."

Own the pattern:

> I move when the work I want to do is no longer available where I am. At TCS→Gracenote the jump was from services to product GenAI. The FDE role at Google is a permanent step up in surface area and platform scope; I wouldn't move out of it for a lateral. I'm looking for a 4+ year home.

## Don't say

- *"Whatever Google pays is fine."* Kills your negotiating position.
- *"35–40% hike on current."* Anchors you at ~₹45L. Half of fair.
- *"I'm the cheapest option you'll find."* Tanks perceived level.
- *"I really need this role."* Reduces your leverage to zero.

## Remember

This is a recruiter screen, not the final negotiation. Your comp gets decided *after the loop* by Google's compensation committee, not Priyanka. Your job today is to set the expectation band, not to close a contract.

You are negotiating from strength even though your current looks small. Remember that.
