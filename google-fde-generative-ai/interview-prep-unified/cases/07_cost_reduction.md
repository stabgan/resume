# Case 07: Cost Reduction Without Quality Loss

Tags: Cost Optimization, LLM-native metrics, DSPy, Eval-Gated Migration, FDE Signature. Likelihood: VERY HIGH.

## 1. The Prompt

"A customer's LLM workload is too expensive. How do you reduce cost without hurting quality?"

This is my Gracenote Haiku migration in a different wrapper. I moved Claude 3.7 Sonnet to 4.5 Haiku with DSPy MIPROv2, GEPA, and InferRules-style rule mining over production traces, gated the cutover on a DeepEval canary against a golden set, and landed p95 latency minus 50 percent and cost per request minus 3x with quality within one point of baseline. The senior move is not "switch to Flash." It is to refuse to change a model until instrumentation and a golden set exist, then pull 7 levers in order with an eval gate on every step.

## 2. Customer Context

"Assume we are embedded with Crescent Digital, a mid-market CX platform. They run a customer-facing chatbot and an internal knowledge assistant on Gemini 2.5 Pro. Volume is 20K requests per day. Inference spend is 8K USD a month, up 15 percent MoM. The CFO is alarmed. Engineers are nervous because the last Flash attempt got killed when support said answers felt 'off,' and no one had measured what 'off' meant. I have 4 weeks. Stakeholders: CFO, CTO, Head of Support, Product."

The "off" detail matters. The real problem is not the model. It is the missing eval discipline that would let the team distinguish "worse" from "different in ways that do not matter."

## 3. Discovery Phase

Ten questions, each paired with the assumption I default to.

1. What makes up the 8K. Routing, generation, tool calls, refusals. Assume 70/20/10.
2. Token distribution, in/out, p50/p95. Assume p50 in 500, p50 out 200, p95 in 2500, p95 out 700. These drive the bill.
3. Latency SLOs. Assume p95 under 3s chatbot, 6s internal assistant.
4. Current model. Assume Pro for everything, including queries Flash-Lite would answer identically.
5. Existing evals. Assume none beyond CSAT and thumbs. This is the gap.
6. Quality tolerance. User-facing: low. Internal: medium, experts compensate.
7. What does "off" mean. I want 10 real examples. Assume tone drift, missed entity references, over-apologetic refusals.
8. Rollback authority. Assume CTO with Head of Support signoff. Pre-decided, not discovered mid-incident.
9. Query segmentation. Assume 70/25/5 easy/medium/hard from past traces. Drives the router.
10. Trace access. Assume yes, 30 days in BigQuery. If no, week 1 changes.

By question 10 I have the shape of the plan.

## 4. MVP Proposal: A 4-Week Plan

"I will not change a model in week 1. The last attempt failed because no one could measure quality. Skip that step and I ship the same failure with a worse bill."

- Week 1: Measure and baseline. Instrumentation, golden set, cost decomposition.
- Week 2: Design alternatives. Router, DSPy-compiled prompts, context trimming, caching.
- Week 3: Golden-set regression plus 5 percent canary with automatic rollback.
- Week 4: Progressive cutover 5 to 25 to 50 to 100 percent with a live dashboard.

## 5. Week 1: Measure and Baseline

I cannot optimize what I do not measure. I deploy OpenTelemetry with GenAI semantic conventions, mirror spans to Cloud Trace, sink logs to BigQuery.

Per request I capture: tokens in/out separately per model call; pinned model version and prompt version hash; cost per request; latency p50/p95/p99 split across retrieval and generation; user feedback; request classification.

In parallel I build the golden set. 500 real conversations from BigQuery stratified by topic, language, segment, and outcome. Add 100 known-failure cases. Hand to 3 domain annotators who rate correctness, faithfulness, and tone on a 1 to 5 scale. Compute Cohen's kappa. I only quote scores when kappa clears 0.7. That baseline is the floor I cannot fall below.

From Gracenote: "This is the order I used. Before I touched a prompt I built the DeepEval regression suite on the golden set. That artifact became the gate for the whole migration; two adjacent teams reused it."

## 6. Week 2: Design and Compile Alternatives, the 7-Lever Framework

In the order I pull them.

### Lever 1: Tiered model router

A cheap classifier routes each request to the cheapest model that can handle it.

- Simple, 70 percent, FAQ and lookups: Gemini 2.5 Flash-Lite, roughly 0.10 per 1M input, 0.40 per 1M output.
- Medium, 25 percent, multi-step reasoning with short context: Gemini 2.5 Flash, roughly 0.30 and 1.20.
- Complex, 5 percent, long context and nuanced policy: Gemini 2.5 Pro, roughly 5 and 15.

Savings versus all-Pro: 60 to 80 percent before any other lever. The classifier runs on Flash-Lite with a 50-token prompt, cost is a rounding error.

### Lever 2: Prompt optimization via DSPy on the cheaper model

A raw swap from Pro to Flash-Lite regresses. DSPy closes most of the gap by compiling against the cheaper model directly. MIPROv2 searches over few-shot examples and instructions jointly. GEPA, the genetic-Pareto optimizer from Google Research, pushes further on the Pareto frontier. InferRules-style rule mining over live production traces extracts patterns the compiled prompt encodes as guidance.

From Gracenote: "I used this stack. MIPROv2 compiled prompts on Haiku with DeepEval as signal. GEPA pushed past the MIPROv2 plateau. The rule miner turned Sonnet-trace patterns into prompt clauses. Haiku landed within one point of Sonnet, p95 latency minus 50 percent, cost per request minus 3x."

### Lever 3: Context trimming

The second largest bill line is wasted input tokens. Retrieve top-k chunks, rerank before generation. 30 to 50 percent input-token savings.

### Lever 4: Caching

Retrieval cache keyed by query, 60-second TTL. Generation cache keyed by (query, retrieved chunks) for FAQ traffic. Response cache partitioned by user-id where personalized. 20 to 40 percent hit rates realistic. Staleness controlled with TTLs and explicit invalidation on the source of truth.

### Lever 5: Batch where possible

Offline jobs (summarization, backfills, evals) on the batch API at roughly 40 percent cheaper than synchronous. Online, vLLM continuous batching if self-hosting.

### Lever 6: Quantization for self-hosted workloads

FP8 on L40S gives roughly 2x throughput per dollar on vLLM with minimal quality loss.

From my translation job: "I ran 12M multilingual rows on vLLM with FP8 on 4x L40S. Total was about 460 USD. That is the pattern if Crescent scales 10x and managed-API economics stop working."

### Lever 7: Fine-tuning

Last resort. Only when the task is stable, volume is high, and a compiled prompt on the cheapest viable model still misses the gate. Fine-tuning locks prompt shape, complicates rollback, adds retraining cadence.

## 7. Week 3: Golden-Set Regression and Canary

Before moving a single percent of traffic I run the proposed architecture end to end against the 600-case golden set.

Accept criteria, pre-registered with the customer:

- Correctness within 1 point on the 1 to 5 scale.
- Faithfulness within 0.2 points.
- Refusal correctness 95 percent or better.
- Tone within 1 point.

If any dimension fails, I do not ship.

Then 5 percent canary for 24 hours with automatic rollback on: quality drop on live thumbs beyond threshold; p95 latency regression above 20 percent; handoff rate up more than 2 pp. Automatic rollback is non-negotiable. The previous attempt failed because rollback was a meeting, not a trigger.

## 8. Week 4: Cutover and Monitor

Progressive rollout: 5 to 25 to 50 to 100 percent over 4 days. At each step I re-run the golden set and check live metrics. Dashboard shows cost and quality per dimension on the same screen. Daily 15-minute stand-up with CFO, CTO, Head of Support.

## 9. Architecture Diagram

```
                   +------------------+
Ingress  ----->    |    Classifier    |  (Flash-Lite, 50-token prompt)
                   +---------+--------+
                             |
                             v
                   +------------------+
                   |      Router      |
                   +---+----+-----+---+
                       |    |     |
                       v    v     v
                  Flash-Lite Flash Pro
                       |    |     |
                       v    v     v
              [DSPy-compiled prompt per tier] -> [Output validator]
                       |    |     |
                       +----+-----+
                             |
                             v
                       Response + metadata
                 (model_version, prompt_version, trace_id, cost)

Telemetry: OTel GenAI -> Cloud Trace -> BigQuery
Cost + quality: per-request cost streamed to Cloud Monitoring
```

Every call carries model_version, prompt_version, and trace_id so every regression can be bisected back to a specific change.

## 10. Specific Numbers for Crescent Digital

Rate card approximated; I call that out.

Before: 8K USD/month on all-Pro. 20K requests/day at 500 in and 200 out tokens average. Input: 20K x 500 / 1M x 5 = 50 USD/day. Output: 20K x 200 / 1M x 15 = 60 USD/day. Roughly 110/day at average. The 8K actual includes the 2500-token p95 tail and the internal assistant.

After, projected:

- 70 percent Flash-Lite: 14K x (500 x 0.10 + 200 x 0.40) / 1M = about 1.8 USD/day.
- 25 percent Flash: 5K x (500 x 0.30 + 200 x 1.20) / 1M = about 2 USD/day.
- 5 percent Pro: 1K x (500 x 5 + 200 x 15) / 1M = about 5.5 USD/day.
- Router on Flash-Lite: under 1 USD/day.

Total at average: about 10/day. With p95 tail, 15 to 25/day, 700 to 800 USD/month. About 90 percent savings versus 8K. I mark this honestly. The Pro-only cohort drives residual cost; if the golden set forces it to 10 percent, savings compress. I quote 80 to 90 percent, gate the final number on the golden-set run, and show the sensitivity table to the CFO.

## 11. The Quality Anchor

Scar tissue I call out. "Early in my career I reported 100 percent pass rate on a small friendly sample. I do not do that anymore. I report N, kappa, and confidence intervals, and I would not green-light a migration on under 200 golden examples with under 3 annotators."

Quality gates, pre-registered:

- Regression: correctness within 1 point, faithfulness within 0.2, refusal 95 percent or better.
- Production: p95 latency regression under 20 percent; handoff rate rise under 2 pp.
- User-facing: CSAT drop under 0.2 over 7 days after cutover.

## 12. Tradeoffs

1. Router versus single model. Router adds operational complexity, a classifier to own, a routing table. At 20K per day it pays back within days. At 2K per day I would pick one tier and a compiled prompt.
2. Prompt compilation versus fine-tuning. Compile first. Cheap, reversible, sits outside model weights. Fine-tune only if the compiled prompt on the cheapest viable model still misses the gate.
3. Managed versus self-host. Managed for v1 because speed to production matters and Gemini tooling is tight. Self-host if cost at scale dominates and the customer has the muscle to operate vLLM.

## 13. Failure Modes

- Router misclassifies hard as simple. Feedback loop into classifier training; fallback to Pro on low confidence.
- Compiled prompt overfits. Cross-validation during DSPy compilation; hold out 20 percent as true test.
- Model deprecation. Version pinning plus eval gate on every upgrade.
- Cost drift creep. Daily dashboard with alerts on cost-per-successful-task.
- Silent provider changes. Monthly golden-set replay.
- Cache staleness. TTLs plus explicit invalidation on source changes.
- Latency regression per tier. p95 monitoring with fallback to previous pinned model.

## 14. Scale

At 10x volume, 200K per day: the classifier becomes cost-significant, so I pre-compute routing rules for frequent query shapes and only invoke the classifier on the long tail. Cache hit rate matters more in absolute terms. Fine-tuning on the 70 percent cohort starts to pencil out; a small fine-tuned Gemma or Flash variant may out-economize compiled-prompt Flash-Lite.

## 15. Tie to Evidence

- "This is my Gracenote Haiku migration. 10K-per-day service. I compiled prompts on Haiku using DSPy MIPROv2 and GEPA, with an InferRules-style rule miner that pulled patterns from live Sonnet traces. Cutover gated on a DeepEval regression suite requiring quality within one point on the golden set. p95 latency minus 50 percent, cost per request minus 3x. Canary then full traffic. Quality held. Two adjacent teams picked up the pattern."
- "On the 12M multilingual translation I ran vLLM with FP8 on 4x L40S for about 460 USD total. That is my reference for self-hosted economics."
- "For the router classifier I would use my AutoResearch harness: hypothesize features, run ablations, pick the simplest classifier that clears 95 percent before wiring it in."

## 16. Follow-up Q and A

- Open source. Llama, Mistral, Gemma viable on vLLM plus FP8. Only when managed economics break; op overhead is the tradeoff.
- Measuring "quality held." Golden-set score per dimension with N and kappa, LLM-judge with kappa over 0.7, live CSAT, handoff rate.
- Wrong routing. Feedback loop, retrain on misrouted cases, fallback to Pro on low confidence.
- Cost per request vs cost per successful task. Successful task is right; a cheaper request that escalates is more expensive.
- Pro-only cases. Router identifies them, they stay on Pro.
- Cost of evals. 1 to 5 percent of production cost, amortized.
- DSPy compilation too slow. GEPA faster than pure MIPROv2; parallelize candidates; cap compile budget.
- Temperature. Greedy or temperature 0 is cheapest and often indistinguishable. Test delta on the golden set.
- Streaming. Same tokens, better perceived latency, no direct cost difference.
- Prompt leaking customer data. Does not. Compiled on a scrubbed golden set; artifact is reviewed.
- Payback. Under a month at Crescent's volume.
- Fine-tuning. Last resort after Levers 1 through 3.
- Which cheaper model. Tier-matched: Flash-Lite simple, Flash medium, Pro complex, Gemma if self-host pencils.
- Multi-model evals. Separate scores per tier so Flash-Lite regression does not hide behind stable Pro.
- Customer on AWS. Bedrock plus vLLM on SageMaker; architecture translates.

## 17. Red Flags I Avoid

- "Let's just switch to Flash."
- "We'll run it on cheap hardware."
- "Cost optimization means giving up some quality."
- "Gemini is cheap enough already."
- "Let's fine-tune immediately."

Each skips measurement, skips a gate, or confuses a lever with a strategy.

## 18. Senior Closing

"If I kept hitting this pattern, customers running expensive models without eval discipline, I would package the 7-lever cost framework plus the DSPy compilation template plus the golden-set builder as a reusable FDE module. Product feedback to Google: the Gemini API should surface cost-per-successful-task as a first-class metric, not just cost per request, because that is the number a CFO makes decisions on."

## 19. 90-Second Recall Summary

Customer spends 8K/month on Gemini 2.5 Pro at 20K/day; a prior Flash attempt failed because no one measured quality. I refuse to change a model in week 1. Week 1: OTel GenAI instrumentation plus a 600-case golden set with 3 annotators and kappa over 0.7. Week 2: the 7-lever framework in order, tiered router (Flash-Lite, Flash, Pro), DSPy MIPROv2 plus GEPA plus InferRules-style mining to compile prompts on the cheaper tier, context trimming, caching, batching, FP8 on vLLM if self-hosting, fine-tuning only last resort. Week 3: golden-set regression gate plus 5 percent canary with automatic rollback on latency, handoff, or quality. Week 4: 5-25-50-100 cutover with a live cost and quality dashboard. Expected savings 80 to 90 percent. Quality held within one point. This is the Gracenote Haiku migration I already shipped: p95 latency minus 50 percent, cost per request minus 3x, quality within one point of Sonnet, two adjacent teams reused the pattern.
