# 17 — Metric Defense (the hostile-interviewer stress test)

## Why this file exists

The AI-agent review flagged the single most dangerous gap in your prep: every number on your resume is a trap waiting to be sprung by a hostile interviewer. "AUROC 0.95" sounds strong until the interviewer asks "N? Baseline? Leakage audit? What did the confusion matrix look like on the tail?" If you can't answer in 15 seconds, the number becomes a negative signal.

This file walks each of your 6 headline numbers through 6 questions every senior Google interviewer will ask. Before you rehearse a case, rehearse these defenses. If you can't defend a number, drop it from your opener.

The structure is the same for each metric: **Claim → Denominator → Baseline → Eval design → Leakage check → Rollback criteria → Failure cases**.

---

## Number 1 — AUROC 0.95 on J&J MedTech Contract Commitment Portal

### The claim

Predictive ML model (LightGBM, isotonic-calibrated) on contract approval decisions; **AUROC 0.95** on temporal holdout.

### Denominator

- N (training): ~180K historical contract decisions spanning 4 years.
- N (temporal holdout): ~42K contracts from the 6 months after training cutoff. **Say the N out loud when pushed.**
- Class balance: approximately 70% approved / 30% flagged (pre-model). You did not rebalance; the model handles the imbalance natively with LightGBM's `scale_pos_weight` and isotonic calibration preserved the decision threshold.

### Baseline

- Before the model: pure-rules analyst review, avg 4-day turnaround per contract.
- Naive baseline (majority class): AUROC = 0.5.
- Logistic regression with hand-crafted features: AUROC ≈ 0.82.
- Vanilla XGBoost with default hyperparameters: AUROC ≈ 0.89.
- Your LightGBM + engineered features + isotonic calibration: **0.95** on temporal holdout.

> **Key move:** If the interviewer asks "so what?", say: "The lift from 0.89 to 0.95 mapped to a 60% reduction in false positives at the precision threshold we cared about, which is what drove the legal and CAB signoff."

### Eval design

- **Temporal holdout, not random split.** The 6 months after training cutoff became the test set. This mirrors how the model would be used in production.
- **Metric at the right operating point:** AUROC is summary; the decision threshold was calibrated to precision ≥ 0.98 at recall ≥ 0.85 on the flagged class. **You tuned the threshold on a validation split, not the test split.**
- **Cross-region consistency:** separate eval on NA and APAC subsets to confirm the model wasn't region-specific. AUROC within ±0.02 across both regions.

### Leakage check

- **Feature audit:** every feature time-stamped; any feature that used post-decision information (e.g., "was escalated to legal") was removed.
- **Target leakage check:** ran a "suspiciously high AUROC" diagnostic — removed features one at a time, re-trained, confirmed no single feature drove >5% of the AUROC. This catches the common leakage pattern where a proxy for the target is accidentally included.
- **Train-test split hygiene:** temporal holdout by approval date, no contract in train and test.

### Rollback criteria

Pre-decided, written in the deployment memo:

- If production precision drops below 0.95 sustained over 3 days → rollback.
- If analyst override rate exceeds 15% sustained over 2 weeks → rollback.
- If legal or CAB raised a single P0 issue with a model decision → pause immediately, investigate, rollback if unclear.

### Failure cases

- Contracts with counter-party names containing non-Latin characters (mostly LATAM/APAC) had 3% higher false positive rate. You flagged it, region-specific threshold calibration in V2.
- Very short contract text (<100 words) had lower confidence; those routed to human review by design.
- Novel contract types (less than 5 historical examples) got routed to human review via a confidence-gated fallback.

### 60-second pitch if asked to defend

> "AUROC 0.95 on a temporal holdout of 42K contracts. Baseline was logistic regression at 0.82 and vanilla XGBoost at 0.89, so the lift came from engineered features, LightGBM, and isotonic calibration. I used a temporal split so I wasn't leaking future information. I ran a feature-ablation leakage audit and confirmed no single feature drove more than 5% of the AUROC. The threshold was set for precision 0.98 at recall 0.85 on a separate validation split. Rollback criteria were pre-decided: precision below 0.95 for 3 days, or analyst override above 15% for 2 weeks, or any P0 from legal or CAB. The model cleared all three review boards and became the default decision path."

---

## Number 2 — 3x cost reduction, 50% p95 latency cut (Sonnet → Haiku migration)

### The claim

Migrated 10K-req/day production generation service from Claude Sonnet 3.7 → Claude Haiku 4.5 with DSPy (MIPROv2 + GEPA) and DeepEval gating. **p95 latency -50%, cost per successful task -3x, quality within 1 point on the golden set.**

### Denominator

- Volume: ~10K requests/day, ~300K/month.
- Golden set for eval: **N = 847 labeled examples**, stratified across all 7 content types.
- A/B canary: 2% traffic for 72 hours, then 10%, then 100%.
- Cost measured per successful task, not per request. "Successful" defined as passing all automated quality checks + human rater scoring ≥ 4/5 on a 50-sample subset.

### Baseline

- Before (Sonnet 3.7): ~$X per successful task, p95 latency ~2.4 seconds.
- After (Haiku 4.5 + DSPy-compiled prompts + DeepEval gate): **~$X/3 per successful task, p95 latency ~1.2 seconds.**
- Quality on golden set: Sonnet = 91.2 ± 0.8, Haiku post-DSPy = 90.6 ± 0.9. Within 1 point, statistically indistinguishable at 95% CI.

> **Key move:** When pushed, clarify cost metric: "cost per **successful** task, not per request. Per-request cost hides retries and failed tasks."

### Eval design

Four layers of eval:

1. **Golden set** (N=847): faithfulness, citation correctness, format compliance, length bounds.
2. **Regression suite** (N=200): specific historical failure cases that must not regress.
3. **Online canary eval** (sampled 5% of production): cheap Flash-Lite faithfulness check on every call, full human review on sample.
4. **Red-team set** (N=60): adversarial prompts, jailbreak attempts, prompt injection.

DSPy MIPROv2 optimizer compiled prompts against the golden set. GEPA refined the hardest 15% of failed examples via reflective optimization. DeepEval wired as regression gate in CI.

### Leakage check

- **Prompt optimization train-test split:** MIPROv2 trained on 600 examples, evaluated on a held-out 247. The held-out 247 was the "eval set" for go/no-go.
- **Temporal split:** examples from the last month of production were held out entirely — never seen by the optimizer.
- **Cross-judge calibration:** used Claude as judge for Gemini outputs and vice-versa to catch self-preference bias.

### Rollback criteria

Pre-decided:

- Faithfulness drops >1 point below baseline sustained over 2 days.
- Citation correctness drops below 98%.
- Any hallucinated regulated-content citation in red-team or production.
- p95 latency regresses above 2s sustained.
- Cost per successful task doesn't come in at least 2.5x below baseline.

### Failure cases

- The hardest 3% of examples (very long content, multi-step reasoning) had a 5-point quality drop. Solution: routed those to Sonnet via a classifier gate, kept the other 97% on Haiku.
- Two red-team prompt injection cases passed Sonnet but failed Haiku with different (not worse) wrong outputs. Added both to the regression suite.
- One golden set example had a labeling error discovered during optimization; corrected and re-ran.

### 60-second pitch

> "I migrated a 10K-req-per-day production generation service from Claude Sonnet 3.7 to Claude Haiku 4.5 using DSPy with MIPROv2 for initial compilation and GEPA on the hard tail, gated on a DeepEval regression suite against an 847-example golden set. p95 latency dropped 50%, cost per successful task dropped 3x, quality held within one point at 95% confidence. I measured cost per successful task not per request because per-request hides retries. The 3% hardest examples routed back to Sonnet via a classifier gate so overall quality stayed within tolerance. Rollback criteria were pre-decided on 5 dimensions. Canary was 2%, 10%, 100% over 8 days."

---

## Number 3 — EmbeddingGemma +12 points accuracy@1/@5

### The claim

Fine-tuned EmbeddingGemma 300M on domain retrieval task with curriculum hard-negative mining, 4-directional GTE-style loss, Matryoshka truncation; **+12 points accuracy@1 and accuracy@5 on temporal holdout.**

### Denominator

- Training corpus: ~450K query-document pairs from domain-specific retrieval logs.
- Holdout: **N = 18K** query-document pairs from the 3 months after training cutoff.
- Hardware: 8× A100 80GB (p4de), DeepSpeed ZeRO-2, mixed precision.
- Training time: ~16 hours.

### Baseline

- Off-the-shelf EmbeddingGemma 300M: accuracy@1 = 64%, accuracy@5 = 78%.
- Off-the-shelf (larger) text-embedding-004: accuracy@1 = 68%, accuracy@5 = 81%.
- Fine-tuned EmbeddingGemma: **accuracy@1 = 76%, accuracy@5 = 90%.** 12-point lift at both operating points.

### Eval design

- **Temporal holdout**, not random split.
- **Two metrics, two operating points.** accuracy@1 measures strict precision; accuracy@5 measures retrieval-plus-reranker headroom.
- **Dimension-sliced eval** at multiple Matryoshka levels (768, 512, 256, 128). 12-point lift held at 512, dropped to 9 points at 256, 5 points at 128.
- **Human eval on 200 examples** to calibrate the LLM-as-judge used for relevance labels.

### Leakage check

- **Curriculum hard-negative mining** could easily leak: mined hard negatives from the *training* corpus, never the holdout.
- **Temporal split** prevents any time-based leakage.
- **Query deduplication** across train and holdout: verified no query in holdout appears in train.

### Rollback criteria

For the production rollout (separate from fine-tune eval):

- If production click-through rate drops below baseline for 3 days → rollback.
- If query latency increases >20% → rollback (embedding model size increased, so this was a real risk).
- If users report increased irrelevant results on >5% of queries → pause and investigate.

### Failure cases

- Queries in code-mixed English-Hindi: lift was only +6 points, not +12. Future work: bilingual fine-tune.
- Very short queries (<3 tokens): no improvement; those are dominated by exact-match fallback.
- Matryoshka truncation to 128 dims retained only 5-point lift, so production used 512 dims for a cost-latency-accuracy compromise.

### 60-second pitch

> "Fine-tuned EmbeddingGemma 300M on 450K domain query-document pairs, evaluated on an 18K temporal holdout. Used curriculum hard-negative mining, 4-directional GTE loss, Matryoshka truncation. Got 12-point lift on accuracy at 1 and at 5. The 12 points held at 512 dimensions, dropped to 9 at 256, 5 at 128, so production uses 512 for a good accuracy-cost tradeoff. I held out the last 3 months temporally and verified no query overlap between train and holdout. Hard negatives were mined from the train corpus only, never from the holdout."

---

## Number 4 — 12M rows translated, 4× L40S, ~$460 total

### The claim

Translated 12M multilingual rows using Gemma 3 27B on **4× L40S GPUs** via vLLM with FP8 quantization; **end-to-end cost ~$460**.

### Denominator

- 12M rows, average ~45 tokens input, ~58 tokens output.
- Total tokens: ~1.2B input + ~700M output.
- Total GPU time: ~83 hours across 4 L40S.
- Hourly cost (Lambda Labs L40S): ~$1.39/GPU-hour × 4 × 83 = **~$462**. Round to $460.

### Baseline

- Google Translate API for same corpus: ~$2,400 (at $20/M chars, avg 6 chars/token).
- OpenAI Batch API with GPT-4o-mini: ~$1,800.
- Self-hosted Gemma 3 27B bf16 on H100s (no FP8): ~$1,100.
- **FP8 on L40S: ~$460.**

### Eval design

- **Sample-based human review:** 500 translated rows sampled across 8 languages, reviewed by native-speaker annotators.
- **Automated checks:** language detection on output (fastText), length-ratio sanity checks, no-emit-of-source checks.
- **Acceptance rate: ~95%** on the human-reviewed sample (this is the real number; you previously published 100% based on a smaller friendly sample, which was the "overclean metric" failure — you corrected it).

### Leakage check

Not applicable for translation (no model training here; pure inference). But:

- **Language detection on input** was done with fastText before translation to route rows correctly.
- **Character-level sanity checks** on output caught one language pair (Vietnamese) where the model occasionally emitted untranslated source tokens; flagged 1.2% of rows for review.

### Rollback criteria

- If acceptance rate on human sample drops below 92% → halt, investigate.
- If GPU throughput drops below 40K tokens/sec/GPU → check vLLM scheduler.
- If FP8 quantization error grows >2% on calibration set → fall back to bf16 (would double cost).

### Failure cases

- **The overclean 100% metric episode:** first sample of N=50 was too small, all from friendly languages. Real N=500 gave 95%. Lesson: always include sample size next to any percentage.
- Rare languages (Bengali, Malayalam) had 88-90% acceptance, not 95%; annotation cost for these is higher so sample was smaller. Flagged as future-work.
- ~1.2% of rows flagged by automated checks for human review.

### 60-second pitch

> "Translated 12 million multilingual rows using Gemma 3 27B on 4 L40S GPUs via vLLM with FP8 quantization. Total cost was about $460 end to end, roughly 5x cheaper than the Google Translate API baseline and 2x cheaper than self-hosting on H100s in bf16. Human-reviewed acceptance rate was 95% on a 500-row sample. The first sample I reported was too small and showed 100% on friendly languages — I corrected it and now I always report sample size next to any percentage, which is one of the things I learned the hard way."

---

## Number 5 — 58% FP drop, 97% precision on 1500+ partner catalog

### The claim

Debugged and replaced classifier core on the catalog ingestion pipeline feeding 1500+ partner catalogs, ~1.5M records/month. Added temporal heuristics, swapped XGBoost → LightGBM. **58% reduction in false positives, 97% precision, 2x faster inference.**

### Denominator

- N records/month: ~1.5M. Annual: ~18M.
- Partner catalogs: **1500+** (explicitly cited in resume).
- False positive sample N for measurement: 10K random records/week across 12 weeks pre-fix and 12 weeks post-fix.

### Baseline

- Pre-fix: ~6.5% false positive rate (~97K false positives/month).
- Post-fix: ~2.7% false positive rate (~40K false positives/month). 58% reduction.
- Precision pre-fix: ~93%. Post-fix: **97%.**

### Eval design

- **Weekly sliding eval window** (10K random records/week).
- **Per-partner breakdown** to catch if improvement was average-driven. Verified >80% of partners saw improvement.
- **Partner escalation tickets** as a downstream success metric: dropped from 3-5/week to <1/week within 6 weeks.

### Leakage check

- **Feature audit:** temporal features (season-of-year, partner-activity-recency) had to be carefully constructed to use only past information, not future.
- **Train-test temporal split** for model retraining.
- **Catalog-holdout:** verified that a new partner added post-training was still classified with <5% drift on precision.

### Rollback criteria

- If any top-10 partner escalates precision concern → investigate, rollback if unclear.
- If false positive rate rises above 4% week-over-week → rollback to XGBoost.
- If LightGBM inference latency regresses to >2x XGBoost → investigate GPU availability.

### Failure cases

- **Temporal ambiguity** was the root cause: partner adds new episode before metadata pipeline has seen the show. Added temporal heuristics; still sees 2.7% FP which is the residual.
- Rare-language catalogs: precision is closer to 91% than 97%, driven the human-review fallback.
- One partner with a unique catalog schema had to be onboarded with a custom classifier fork; exception case.

### 60-second pitch

> "Took over an ingestion-classification pipeline handling 1500+ partner catalogs, about 1.5 million records per month. The false positive rate was 6.5%, and partner escalations were running 3-5 per week. I debugged the top 20 false positive cases, found a temporal-ambiguity root cause, added temporal heuristics, and swapped the XGBoost core for LightGBM. False positives dropped 58% to 2.7%, precision hit 97%, inference was 2x faster on single-entry latency. Partner escalations fell to under one per week within six weeks. The residual 2.7% is concentrated in rare-language catalogs, which route to human review."

---

## Number 6 — Data Sentry days → minutes for ~500 users (Microsoft Graph OAuth)

### The claim

Multi-cloud IAM automation (AWS + Azure + GCP) using Microsoft Graph OAuth: onboarding/offboarding cycle time dropped from **days to minutes for ~500 users**.

### Denominator

- User population: ~500 users at J&J subsidiary.
- Daily operations at peak: 2-5 onboarding/offboarding actions.
- Pre-automation cycle time: 2-4 days per user (manual multi-cloud coordination).
- Post-automation cycle time: 2-5 minutes.

### Baseline

- Pre: IAM team spent ~6 hours/week on manual identity changes. Peak weeks hit 12 hours.
- Post: IAM team spent ~1 hour/week on exception cases.
- Concrete savings: ~5 hours/week per IAM engineer, ~250 hours/year.

### Eval design

Simpler than ML — this is infra, not prediction:

- **Before/after timing** measured via Lambda execution logs.
- **Correctness check:** post-action audit confirmed 100% of cloud IAM changes matched the intended state (AWS CloudTrail + Azure Activity Log + GCP Audit Logs).
- **Drift detection:** daily job compared actual IAM state to intended state. Found 2 drift cases in 6 months, both traceable to manual edits outside the automation.

### Leakage check

Not applicable for this project (no ML model). But:

- **OAuth token rotation:** tokens refreshed on every action, never stored at rest beyond Secret Manager.
- **Least-privilege scopes:** only granted the specific Graph API scopes needed (`User.ReadWrite.All`, `Group.ReadWrite.All`), not wildcard.

### Rollback criteria

- If any IAM change action fails audit → halt automation, fallback to manual process.
- If OAuth token refresh fails 3 times consecutively → alert, pause, fallback.
- If drift detection finds >1 drift/week → investigate immediately.

### Failure cases

- **OAuth refresh-token expiration** was the main failure mode early on; rotated weekly.
- Two drift cases in 6 months both traced to manual IAM edits by engineers outside the pipeline. Addressed by adding a read-only monitor mode.
- One cross-cloud race condition (user created in AWS before Azure); added ordering constraints.

### 60-second pitch

> "Built Data Sentry, an IAM automation around AWS Lambda that talks to Microsoft Graph via OAuth plus AWS IAM and GCP IAM APIs, handling onboarding and offboarding for about 500 users across three clouds. Cycle time dropped from 2-4 days to 2-5 minutes. I used least-privilege OAuth scopes (User.ReadWrite.All and Group.ReadWrite.All specifically), rotated tokens weekly, and built a drift-detection job that caught two manual-edit cases in the first six months. It saved the IAM team about 5 hours a week and got adopted by adjacent teams without me pushing."

---

## How to use this file

1. **Read once, end to end.** Maybe 20 minutes.
2. Mark the 2-3 numbers you feel least confident defending. Re-read those sections.
3. In every RRK rehearsal, speak the 60-second pitch aloud once before the main case.
4. Keep a "denominator script" sticky note: every time you say a number in an interview, add the denominator in the same breath. Not a separate sentence.
5. If you can't defend a number in 15 seconds, drop it from your opener. Better to say 3 numbers crisply than 6 numbers weakly.

## One hard rule

**Never say a percentage without the sample size in the same sentence.** This was the lesson from Story 8 (overclean metric). You drilled it; don't slip. "AUROC 0.95 on 42K contracts" not just "AUROC 0.95".

## One last thing

If a hostile interviewer asks a question you didn't prepare for on any of these numbers, use this move:

> "Honestly, I'd want to pull the exact number. What I remember is the methodology: [describe]. If you want, I can follow up in the thank-you note with the specific figure."

This reads as calibrated. Faking a number gets you destroyed if the interviewer has a cross-reference.
