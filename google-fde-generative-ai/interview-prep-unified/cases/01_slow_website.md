# Case 01 — Slow Company Website

Tags: Troubleshooting, Distributed Systems, Observability. Likelihood: HIGH (the canonical RRK sample prompt from the official Google recruiter PDF).

## 1. The Prompt

> "Your marketing manager complains that the new company website is slow. What would you do?"

Google asks this to test troubleshooting under ambiguity, not GCP trivia. There is no stack, no metric, no geography, no baseline. A weak candidate names a tool; a strong candidate names a method. The interviewer is listening for: do I scope before I touch a keyboard, do I separate perceived from measured slowness, do I split the stack into layers, do I mitigate before chasing root cause, and do I close the loop with instrumentation so the same ticket does not come back. I treat the marketing manager as a customer proxy (their pain is real even when their diagnosis is wrong) and apply structured diagnosis.

## 2. Customer Context

I am embedded with Lumora Retail: a mid-market DTC apparel company, ~500 employees, ~$200M ARR, 70% North American traffic, 20% EMEA. Three weeks ago they cut over from a Magento monolith to a Next.js 14 storefront on Cloud Run, fronted by Cloud CDN and Cloud Load Balancing, backed by a Fastify BFF (also Cloud Run) talking to Cloud SQL for PostgreSQL 15 (16 vCPU, 64 GB). Static assets live in GCS behind Cloud CDN. Telemetry flows to Cloud Monitoring, Cloud Logging, and Cloud Trace, with Sentry for client errors. Third-party scripts load through Google Tag Manager: Segment, Intercom, Meta pixel, TikTok pixel, and a recently added Hotjar session recorder.

Priya (marketing manager) pinged me: "the site feels slow, bounce rate is up 12% week-over-week on the homepage." Marco (engineering lead) suspects caching; Dana (analytics) suspects the CDN cut-over. Nobody has shown me a number. My first job is to turn "feels slow" into a measurement and three competing theories into a ranked list of hypotheses I can falsify in 30 minutes.

This matters for the account: Lumora enters a Q4 code freeze in six weeks. If I do not ship a credible diagnosis and prevention plan before then, they carry an unknown regression into peak season. That is the real stake.

## 3. Discovery Phase (first 2-3 minutes)

I open with: "Priya, I believe you. Help me scope it in eight questions before I touch a terminal."

1. "Slow for whom: geography, device, browser?" → "US and UK, mostly mobile Safari and Chrome, some Windows desktop."
2. "Which pages: home, PLP, PDP, checkout?" → "Homepage and PLP; checkout seems fine."
3. "When did it start? Does it line up with a deploy or traffic spike?" → "Last Thursday, same week we pushed the new hero video and the network team touched the CDN."
4. "What metric are you looking at: LCP, TTFB, p95 API latency, GA4 bounce?" → "Bounce rate and support tickets; no LCP handy."
5. "Baseline before the change?" → "CrUX showed LCP ~2.1s on mobile, now 3.4s."
6. "Any third-party scripts added recently through GTM?" → "Hotjar went in ten days ago."
7. "What does 'slow' mean to the users: first paint, interactivity, checkout hang?" → "Page takes forever to become interactive; the hero video loads late."
8. "Is it correlated with revenue: conversion, cart abandonment, AOV?" → "Mobile conversion down 0.4 points, roughly $40k/week at risk."

Two I sneak in if time allows: "Error rates up in Sentry or Cloud Logging?" and "Intermittent or constant?" By the end I have a one-line problem statement: "Mobile LCP on home and PLP rose from 2.1s to 3.4s p75 since Thursday, correlated with a CDN change and a Hotjar rollout, costing ~$40k/week."

## 4. Layered Diagnosis Framework

I split the request path into seven layers. For each: what can break, how to measure, typical fix.

**Browser and rendering.** Large JS, render-blocking CSS, oversized hero images, hydration cost. Measure with DevTools, Lighthouse CI, web-vitals.js piped to Cloud Monitoring. Fix by code-splitting, deferring non-critical JS, preloading the LCP image.

**CDN and static assets.** Hit-rate drops, wrong Cache-Control, Vary exploding the cache key, uncompressed objects. Measure via Cloud CDN hit ratio in Cloud Monitoring, edge logs in Cloud Logging, `curl -I` on headers. Fix by restoring headers and pre-warming after deploys.

**DNS and network.** DNS propagation, TLS handshake cost, bad Anycast. Measure with `dig`, `curl -w` timing, WebPageTest from multiple locations. Rarely the culprit three weeks post-launch; rule out in 5 minutes.

**Frontend server (Cloud Run SSR).** Cold starts, SSR blocking on a slow upstream, missing `revalidate`, CPU throttling. Measure via Cloud Run latency dashboards, cold start count, Cloud Trace SSR spans. Fix with min-instances, ISR, higher concurrency.

**Backend APIs (Fastify BFF).** N+1 queries, chatty hops, missing connection pooling, serialization cost. Measure with p50/p95/p99 per route, Cloud Trace waterfalls, Cloud Profiler flame graphs. Fix by batching, read-through cache in Memorystore Redis, tighter payloads.

**Database (Cloud SQL Postgres).** Missing index, plan regression, lock contention, connection exhaustion, replica lag. Measure with Cloud SQL Query Insights, `pg_stat_statements`, `EXPLAIN (ANALYZE, BUFFERS)`. Fix by adding the index, rewriting the query, or adding PgBouncer.

**Third-party scripts.** A tag blocks the main thread; a pixel makes a sync request; a recorder ships 800KB. Measure with Chrome Performance insights, `PerformanceObserver` long tasks, GTM firing order. Fix by loading async, gating on consent, or swapping the vendor.

**Model/LLM calls (if a GenAI feature is on the critical path).** A synchronous LLM call on render, no streaming, retries stacking, long prompts blowing up TTFT. Measure via Vertex AI latency, token counts, per-call trace spans. Fix by moving LLM calls off the critical path, streaming, caching completions for identical inputs, and setting tight timeouts with graceful fallback.

## 5. The 5 Most Likely Root Causes (probability order)

**H1 (40%): Hotjar blocks the main thread.** Recently added recorders are the most common "suddenly slow" cause. Check INP, TBT, long-tasks, GTM firing sequence, script size. Fix: load after `window.load` via GTM, or remove.

**H2 (25%): CDN change broke the cache key.** Symptom started the same day. Check Cloud CDN hit ratio (a drop from ~92% to <60%), Cache-Control and Vary on HTML, origin egress. Fix: roll back the rule, restore headers, invalidate and pre-warm.

**H3 (15%): New hero video is the LCP element and is not optimized.** Check web-vitals LCP element, asset size (4MB MP4?), missing `<link rel="preload">` for the poster. Fix: small poster image as LCP, lazy video, serve through CDN with correct content-type.

**H4 (10%): Cloud Run cold starts.** New service, default min-instances=0. Check cold_start_count correlated with slow requests, p99 >> p50. Fix: `min-instances=2`, shrink container, reduce cold-start work.

**H5 (10%): PLP query regressed.** Schema change three weeks ago, missing index. Check Query Insights (one query's p95 jumped from 20ms to 450ms), `EXPLAIN` shows a seq scan. Fix: add the index, ANALYZE, deploy behind a flag.

## 6. MVP Investigation Plan (first 30 minutes)

**Min 0-5.** Pull 7 days of Core Web Vitals from the RUM pipeline (web-vitals.js → Cloud Monitoring custom metrics), split by device and country. Confirm the regression and locate it to a page and a day.

**Min 5-10.** `git log --since="10 days ago"` on frontend, BFF, infra-as-code; open the last three Cloud Build runs. List anything that landed within 24 hours of the symptom.

**Min 10-15.** Cloud CDN dashboard: hit ratio, cache vs origin bytes, by path, week-over-week. If hit ratio dropped, that is H2.

**Min 15-20.** Cloud Monitoring: p50/p95/p99 per Cloud Run service and route. Flat p95 with spiking p99 points at tail-latency causes (cold start, one slow dep). Uniform rise across percentiles points at systemic regression.

**Min 20-25.** Cloud Trace: pick one slow homepage request; open the full waterfall; find the single longest span. That span names the layer.

**Min 25-30.** Classify and update Priya and Marco: "Regression confirmed, p75 mobile LCP 3.4s vs 2.1s baseline. Primary signal points at [layer]. Mitigating via [action] now; root cause within 4 hours."

## 7. Mitigation Before Root Cause

Mitigate first, because the business is bleeding money; root cause can wait an hour. In order of preference for this scenario:

- **Disable Hotjar via GTM.** One click, reversible, tests H1 in minutes. If LCP recovers, answer found; marketing keeps the other pixels.
- **Roll back the Cloud Run revision.** `gcloud run services update-traffic --to-revisions=rev-prev=100`; traffic-split flip back to last-known-good.
- **Roll back the CDN rule.** Revert the isolated infra-as-code commit; force-purge HTML paths.
- **Raise Cloud Run min-instances from 0 to 2** for 24 hours to eliminate cold starts as a confound.
- **Add a short-TTL Cloud CDN rule (60s) on homepage HTML** so repeat visitors get an edge hit even if origin is slower.

I do not scale up Cloud SQL without evidence of saturation. Vertical scaling under a misdiagnosis just raises the bill.

## 8. Root Cause Analysis

Once the bleeding stops I go deeper. I correlate the exact deploy SHA with the first minute RUM regressed (Cloud Monitoring overlays deploy markers on the LCP chart); I want SHA, author, PR. I use Cloud Trace to pick a representative slow trace and walk every span. If the slow span is SSR on the frontend, I attach Cloud Profiler to a running instance for five minutes and read the flame graph for the hot function. If the slow span is the BFF hitting Postgres, I go to Cloud SQL Query Insights, sort by total time, and find the regressed statement, then `EXPLAIN (ANALYZE, BUFFERS)` on a replica to confirm the plan. For a JS regression I diff the bundle (`next build --analyze`) against the prior release and look for a new dependency.

The write-up is one paragraph: commit, mechanism, and (critically) *why the guard did not catch it*. The second question matters more than the first.

## 9. Prevention and Instrumentation

- **Performance budgets in CI**: LCP p75 < 2.5s mobile, INP < 200ms, homepage JS < 180KB gzipped.
- **SLOs in Cloud Monitoring**: p95 homepage TTFB < 500ms (30-day, 99% target); p95 BFF < 300ms; error rate < 0.5%. Burn-rate alerts at 2% and 10%.
- **Synthetic checks**: Cloud Monitoring uptime checks from 5 regions every minute on home, PLP, PDP; nightly Lighthouse CI from GitHub Actions.
- **Pre-deploy Lighthouse CI gate**: block merge on LCP or bundle regression beyond budget.
- **Canary releases on Cloud Run**: 5% → 25% → 100% over 30 minutes with auto-rollback on SLO burn.
- **Third-party script governance**: every GTM tag reviewed for async, consent, size; recorders load on `requestIdleCallback`.
- **On-call runbook**: one page linked from the alert, exact `gcloud` commands for rollback, CDN purge, and the three dashboards to open first.
- **Blameless post-mortem** within 48 hours; one preventive action tracked.

## 10. Architecture Diagram

```
                         ┌─────────────────────┐
  User (Mobile/Desktop)  │  web-vitals.js  →   │──► Cloud Monitoring (RUM)
        │                │  Cloud Monitoring   │
        ▼
  Cloud DNS ──► Cloud Load Balancer ──► Cloud CDN ──► GCS (static assets)
                                            │
                                            ▼ (dynamic)
                                ┌───────────────────────┐
                                │ Cloud Run: Next.js    │──► Cloud Trace
                                │ SSR frontend          │──► Cloud Logging
                                └───────────┬───────────┘
                                            │
                                            ▼
                                ┌───────────────────────┐
                                │ Cloud Run: Fastify BFF│──► Cloud Profiler
                                └───────────┬───────────┘
                                            │
                               ┌────────────┴────────────┐
                               ▼                         ▼
                    Cloud SQL (Postgres 15)        Memorystore (Redis)
                    + Query Insights               (sessions, hot keys)
                               │
                               └─► Cloud Logging (slow query log)

  Third-party (GTM): Segment, Intercom, Meta Pixel, TikTok Pixel, Hotjar
  CI/CD: GitHub → Cloud Build → Artifact Registry → Cloud Run (canary 5/25/100)
  Alerting: Cloud Monitoring → PagerDuty → runbook
```

## 11. Failure Modes and How to Recognize Them

- **Intermittent in one geography** → CDN edge miss or regional POP. Signal: global hit ratio fine, one region shows elevated origin fetches.
- **Slow only on mobile** → third-party script bloat or unoptimized images. Signal: desktop LCP flat, mobile LCP up; long-tasks dominated by a vendor script.
- **Slow only after login** → authenticated path hits uncached DB query. Signal: anon TTFB fine, session-cookie TTFB high; trace shows extra post-login DB span.
- **First load slow, subsequent fast** → Cloud Run cold start. Signal: cold_start_count correlates with slow requests; p99 >> p95.
- **Tail latency only (p99)** → GC pause, one slow shard, one slow dep. Signal: p50/p95 flat, p99 clusters; one span outlying in traces.
- **Slow at the top of the hour** → cron overlapping user traffic. Signal: sawtooth latency aligned to Cloud Scheduler.
- **Gradual creep over days** → connection or memory leak, cache filling. Signal: instance memory climbing toward GC thrash or restart.

## 12. Tradeoffs

**Cache freshness vs hit rate.** For PLP I pick a 60-second edge TTL with stale-while-revalidate rather than a 24-hour cache. Marketing changes copy and prices; a short window hides the thundering herd after a deploy while keeping the storefront honest. Authenticated pages are not cached.

**Vertical vs horizontal scale.** Horizontal wins. Cloud Run charges per request-second and scales with concurrency; a 4-vCPU instance does not fix a cold start, and for CPU-bound SSR I get better tail latency from more small instances at concurrency=80 than from fewer large ones.

**Immediate rollback vs root-cause-first.** Rollback first, every time, when the customer is losing money. Root cause does not pay the bills; restoring the baseline does. The only exception is when rollback itself is risky (non-backward-compatible migration); then I mitigate with a feature flag or a narrow hotfix. I hold this line against engineering leads who want "just ten more minutes in prod."

## 13. Tie to My Evidence

In my Gracenote ingestion takeover, I inherited 1500+ partner catalogs flowing 1.5M records/month with no owner and no runbook. I did not start with the docs; I started from failing cases, built a stratified sample, and used temporal heuristics plus an XGBoost-to-LightGBM model to triage. Same mental model here: discovery first, falsifiable hypotheses next, mitigation before root cause, instrumentation so the next person does not inherit a mystery. In my J&J MedTech engagement I spent two years reverse-engineering an undocumented approval heuristic into production ML; the same discipline (turn vibes into measurements) is what I would bring to Priya. And the production LangGraph multi-agent workflow I migrated to Haiku at Gracenote, with DSPy plus DeepEval, runs on exactly this SLO-and-canary pattern: no model migration ships without a latency budget, a golden set, and a gradual rollout. That is the difference between a demo and a system an FDE can leave with the customer.

## 14. Follow-up Q&A

**Q: "Just add more servers."** "Happy to, once we know it helps. If the bottleneck is a DB query or a blocking script, more servers amplify cost without fixing the symptom. Thirty minutes to localize the layer; if it is CPU saturation on the frontend, I scale horizontally immediately."

**Q: CDN hit rate looks fine, users still complain.** Then CDN is not it. Pivot to RUM, split LCP by page/device/country. If LCP is fine but bounce is up, the slowness is perceived; look at INP and CLS. Business and performance metrics can disagree; do not force them to.

**Q: Rollback vs forward-fix?** Three questions: customer losing money now, rollback safe (no irreversible schema), forward fix under an hour with high confidence. If the first two are yes and the third is no, roll back. Forward-fixing looks heroic and is usually the wrong call.

**Q: Slow only on Safari mobile.** A vendor script using a Safari-hostile API, or a CSS feature triggering a repaint loop. Reproduce on a real iPhone, open Safari Web Inspector, look for long tasks and forced synchronous layout. Often a polyfill served to Safari that should not be.

**Q: Third-party script is the culprit but marketing needs it.** Do not remove; move. Load async after `window.load`, behind consent, or swap for a lighter vendor. Bring the tradeoff with numbers: "Hotjar costs 0.8s of mobile LCP, ~0.3 points of conversion, ~$30k/month. Three options."

**Q: On-call runbook structure.** One page. Symptom at the top, three dashboards to open first, five `gcloud` commands (traffic-split rollback, CDN purge, min-instances bump, concurrency, disable GTM tag), escalation path, post-mortem template. Longer than one page and nobody reads it at 3 AM.

**Q: 40 microservices, which is slow?** Distributed tracing. Pick one slow user-facing request in Cloud Trace, walk it, find the single longest span; that names the service. If tracing does not exist, I add it at the entry point first.

**Q: Which tracing tool?** Cloud Trace with OpenTelemetry instrumentation; integrates with Cloud Logging and Cloud Profiler. If the customer runs Honeycomb or Datadog, I keep it and ship OTel to both.

**Q: Cloud SQL query slow on some shards only.** Per-shard p95 from Query Insights to find the outlier. Usually data skew (one tenant dominates), missing index on a rebuilt shard, or stale statistics. Fix: `ANALYZE`, add index, or rebalance.

**Q: SLO post-fix.** p95 homepage TTFB < 500ms, LCP p75 < 2.5s over 30-day rolling window, 99% target; error rate < 0.5% on BFF; burn-rate alerts at 2% and 10% routed to PagerDuty.

**Q: "Competitor feels faster, match them."** Lighthouse under identical conditions (same device, same network via WebPageTest). Feelings are a starting point; numbers are the contract. Then scope the gap and give marketing a budget.

**Q: Where does GenAI help prevention?** Pipe Cloud Logging anomalies and deploy diffs into a Gemini-backed triage agent that suggests likely causes from the runbook corpus, like the LangGraph triage flow I built at Gracenote. Not auto-rollback; it drafts the incident summary and top three hypotheses before the on-call engineer finishes their coffee.

## 15. Red Flags — Phrases to Avoid

- "Let me just add more caching." (Caching hides problems; it does not diagnose them.)
- "I'd rewrite the frontend." (A rewrite is never the answer to a 3-week-old regression.)
- "I'll throw a bigger instance at it." (Vertical scale without evidence is a billing event.)
- "It's probably the database." (Probably is not a diagnosis. Show me the query.)
- "We need more telemetry before I can say anything." (Partial data plus structured reasoning is always available; I give a hypothesis and a plan, not a stall.)
- "Let me read the docs first." (On an FDE engagement I start from the failing case, not the manual.)

## 16. Senior Closing Line

"If I saw this same pattern across multiple customers, post-deploy frontend regressions with no owner and no automated latency gate, I would capture it as a reusable SRE runbook and feed it back to product as a feature request for a Cloud Deploy plus Cloud Monitoring canary template with a built-in Core Web Vitals SLO; that is the FDE loop, and that is how one customer's incident becomes every customer's prevention."

## 17. 90-Second Recall Summary

"Marketing says the site is slow. First I turn 'slow' into a measurement: who, where, which page, what metric, since when, what changed. For Lumora Retail on Next.js on Cloud Run behind Cloud CDN, the regression is p75 mobile LCP moving from 2.1s to 3.4s, starting the day a CDN rule changed and a Hotjar tag shipped. I split the stack into seven layers (browser, CDN, network, frontend server, backend API, database, third-party scripts, plus LLM calls if any) and rank five hypotheses: Hotjar blocking the main thread, a broken CDN cache key, an un-optimized hero video, Cloud Run cold starts, and a PLP query regression. In the first thirty minutes I pull RUM from Cloud Monitoring, diff the last three Cloud Build runs, check Cloud CDN hit ratio, review p95/p99 per route, and walk one slow request in Cloud Trace. Then I mitigate before I chase root cause: disable Hotjar via GTM, traffic-split back to the last-known-good Cloud Run revision, roll back the CDN rule, set min-instances to 2. Once the bleeding stops I use Cloud Trace, Cloud Profiler, and Cloud SQL Query Insights to find the real cause, and write a one-paragraph post-mortem including why the guard missed it. For prevention: Lighthouse CI gate, performance budgets, SLOs on p95 with burn-rate alerts, synthetic checks, canary deploys with auto-rollback. Explicit tradeoffs: freshness over hit rate with short TTLs, horizontal over vertical scale, rollback-first over root-cause-first. Same structured-diagnosis pattern I used at Gracenote on 1500+ partner catalogs and at J&J on an undocumented approval heuristic: start from failing cases, turn vibes into numbers, mitigate fast, instrument so it does not come back."
