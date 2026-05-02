# Case 08 — Scale From 10K Internal to Millions External

Tags: Scale, Production Hardening, External User Handling, Abuse Mitigation. Likelihood: VERY HIGH (explicit in recruiter PDF).

## 1. The Prompt

"Your internal GenAI tool works for 10,000 employees. What changes before launching to millions of external customers?"

## 2. Customer Context

I would anchor against a concrete customer. Example: "Nebula Insurance" built an internal claims-drafting AI agent for 10,000 adjusters. 9 months in production, CSAT 4.5 of 5. Leadership now wants a consumer-facing variant "NebulaAssist" where policyholders can ask about their policy, file claims, update info. Target: roughly 5M registered users, 500K DAU at launch, 50M globally within 3 years. 6 months to GA. Current team: 6 engineers. Stack: LangChain plus Claude on AWS.

## 3. Discovery Phase

Before I propose anything I would ask business, product, legal, and SRE a set of questions. The answers change the architecture more than the scale number does.

1. SLO target? I would push for 99.95% on API, 99.99% on auth, p95 under 2 seconds.
2. Regulatory footprint: which geographies at launch, GDPR, CCPA, DPDP, or sector constraints like HIPAA or PCI?
3. Age policy: 13 plus, 16 plus in EU, 18 plus for insurance products?
4. Abuse posture: existing trust and safety team, or building it from scratch?
5. Support escalation: call center, chat, ticketing, and how does the agent hand off?
6. Billing model: free tier, metered, or bundled?
7. SLA penalties with downstream partners?
8. Multilingual needs and which languages first?
9. Mobile or web first, which native platforms?
10. Launch markets and rollout order?
11. Model deprecation policy and freeze windows for Gemini upgrades?
12. Content policy: what is in scope, what is out, who owns the refusal taxonomy?
13. Data retention defaults and user control requirements?
14. GA success metrics: CSAT, deflection rate, incident count, p95 latency, cost per DAU?

## 4. The Critical Shift

The framing I would push back with up front: internal to external is not a scaling problem, it is a different system. Treating it as "just add nines" is the top reason these launches fail.

Concrete differences:

- Identity: SSO with a known directory becomes consumer auth with email and password, 2FA, social login, account linking.
- Abuse: trusted employees become adversarial users. Prompt injection, jailbreak, scraping, credential stuffing, denial of wallet.
- Reliability: internal tolerates 99.9% and ticket-based recovery. Consumer expects 99.95% plus, with graceful degradation.
- Support: internal is a Slack message. Consumer is 24/7 call center, chat, tickets, social escalations.
- Privacy: internal is employee data under an employment contract. Consumer is PII under GDPR, CCPA, DPDP, with the right to erasure and portability.
- Cost: internal is fixed per seat. Consumer is metered and unit economics matter from day one.
- Ops: internal is US business hours. Consumer is follow-the-sun.
- UX: internal power users will work around rough edges. Consumers will not.

## 5. MVP Proposal — 6-Month Path

- Month 1: Architecture redesign, team build out, vendor selection for abuse and moderation.
- Month 2 to 3: Core hardening. Auth, API gateway, rate limiting, abuse detection, per-user quotas.
- Month 4: Closed beta with 1K invited users to close the feedback loop.
- Month 5: Open beta with 100K users, staged rollout by region.
- Month 6: GA launch with progressive ramp, kill switches, and pre-agreed rollback criteria.

## 6. Architecture

```
Mobile (React Native) + Web (React)
       |
   Cloud CDN (static + edge cache)
       |
   Apigee (external API gateway)
       |  rate limit, quota, DDoS, abuse signals
       |
   Identity Platform  ---- 2FA, social login, session JWT
       |
   Cloud Run / GKE (ADK agent backend, multi-region)
       |            |                |
   Gemini 2.5      Vertex AI        Cloud SQL (regional)
   Flash / Pro     Vector Search    Cloud Spanner (global)
   (router)        (private EP)     BigQuery (analytics)
       |
   Safety: input classifier + Perspective API + Cloud DLP + output validator
       |
   OTel GenAI -> Cloud Trace + Cloud Logging + BigQuery
```

Frontend. React Native mobile, React web, Cloud CDN for static assets and first-byte caching.

Auth. Identity Platform as the consumer identity layer. SMS and TOTP MFA. Social login with Google, Apple, Facebook, account linking. Short-lived JWTs with rotation and device binding.

API gateway. Apigee is the external surface. Rate limiting per user, per IP, per API key. Quota enforcement by tier. Abuse detection on velocity and pattern. Cloud Armor for DDoS.

Agent backend. Cloud Run for the stateless agent service because it autoscales cleanly for spiky consumer traffic. GKE for sustained-load components. Multi-region active in us-central1, europe-west1, asia-south1. Regional data residency enforced at routing, not in application code.

Model layer. Gemini 2.5 Flash as the primary workhorse because unit economics work at consumer volume. Gemini 2.5 Pro for the roughly 5% of queries that need deeper reasoning, routed by a classifier. Claude Haiku kept warm as a DR fallback. Model pinning by version with canary on upgrades.

Retrieval. Vertex AI Vector Search with a private endpoint. Multi-region index replicas, index versioning for safe rollback.

Data. Cloud SQL with regional replicas for user-state OLTP. Cloud Spanner for globally consistent data like entitlement and account status. BigQuery for analytics. Cloud Storage for user-generated content and document vectors.

Observability. OpenTelemetry GenAI semantic conventions from day one, shipped to Cloud Trace and Cloud Logging, long retention in BigQuery. Dashboards per region, per user tier, per query type.

Safety. Input classifier for topic, toxicity, PII leakage. Output validator for policy and numeric facts. Response rewrite for sanitization. User reporting UI wired into the moderation queue.

Cost controls. Per-user soft and hard budget. Query-type routing. Context trimming. A model router: Flash-Lite for easy lookups, Flash for normal turns, Pro only when the classifier scores it.

## 7. Abuse Mitigation

This is the single biggest shift from internal to external.

Threats: prompt injection ("ignore your system prompt"), jailbreak to extract private info or unsafe content, scraping by bots, credential stuffing, denial of wallet where a user deliberately triggers expensive queries, PII extraction, illegal content requests.

Controls I would layer:

- Input classifier in front of the model. Start with Perspective API for toxicity, layer custom classifiers as we learn from adversarial traffic.
- Output policy enforcement with a refusal prompt and content filter.
- Rate limiting per user per minute, per IP, per session.
- Anomaly detection on behavior baselines feeding a manual review queue.
- Per-user token quota per day with a hard cap so one user cannot run up a bill.
- CAPTCHA on suspicious patterns.
- User reporting UI plus ban and suspension flow with an appeal.
- Session hijacking detection using device fingerprinting.
- Audit log for every reviewed flag, retained for the compliance window.

## 8. Reliability

Consumer SLO target: 99.95% for the agent API (roughly 22 minutes per month), 99.99% for auth. Patterns:

- Multi-region active-active for read workloads.
- Circuit breakers on every downstream dependency including the model.
- Retry with exponential backoff and jitter, on idempotent calls only.
- Graceful degradation with cached fallback answers for popular queries.
- Queue-based processing for slow tasks like document upload and claim filing, so the synchronous path stays under 2 seconds.
- Monthly DR drill, RTO under 1 hour, RPO under 5 minutes.
- 24/7 on-call rotation with runbooks per component.
- Monthly chaos testing against the agent backend.

## 9. Privacy and Compliance

GDPR. Granular user consent, age gating at 13 plus (16 plus in some EU states), right to erasure backed by a real data deletion pipeline, data portability via export API, data processing agreements with every sub-processor, regional data storage so EU data stays in EU.

CCPA. California-specific disclosures, opt-out of sale of personal info, annual privacy report.

DPDP (India). Matters because asia-south1 is in the plan. Consent framework and data principal rights.

Technical controls. PII encrypted at rest with CMEK. PII redaction in logs via Cloud DLP. Minimal retention, 90 days default for chat history. User controls to delete, download, opt out. Audit trail for every data access.

## 10. Cost Unit Economics

At 500K DAU and roughly 5 requests per user per day: 2.5M requests per day, 75M per month. With a model router at 70% Flash-Lite, 25% Flash, 5% Pro:

- Inference compute: around $150K per month.
- Embeddings and retrieval: around $20K per month.
- Infrastructure (Cloud Run, Cloud SQL, Spanner, networking): around $30K per month.
- Abuse prevention and moderation: around $15K per month.
- Total: roughly $215K per month, about $0.43 per DAU-month.

If the product captures $2 per DAU-month in revenue the margin works. If it is free, monetization or internal cross-subsidy has to be in the plan before GA.

At 50M DAU (3-year projection), 100x scale does not mean 100x cost because of cache hit rates, batching, and enterprise pricing. I would plan for roughly $5M per month and negotiate committed use discounts with Google well before we hit that volume.

## 11. Rollout Plan

- Month 1: Architecture and team build.
- Month 2: Core hardening. Auth, API gateway, rate limiting, abuse.
- Month 3: Content safety and privacy. Classifier, moderation, output filter, GDPR and CCPA wiring.
- Month 4: Closed beta, 1K invited users, tight feedback loop.
- Month 5: Open beta, 100K users, staged by region starting with US West.
- Month 6: GA launch with announcement and ramp controls.

Cutover safety. Progressive rollout by geography. Feature flags for kill switches. Pre-agreed rollback criteria tied to p95 latency, incident rate, CSAT.

## 12. Tradeoffs

1. Launch fast at lower quality vs slower at higher quality. For consumer I choose quality. Regulatory and brand risk outweighs a 4-8 week delay.
2. Build vs buy. Buy moderation, fraud detection, abuse signals from mature providers like Perspective and Cloud DLP. Build the core agent logic and the router, that is where differentiation lives.
3. Multi-region vs single-region. Multi-region for the three major markets at launch. Low-traffic markets run out of the nearest region until volume justifies a local footprint.

## 13. Failure Modes

- Abuse spike from a prompt injection wave: rate limit tightens automatically, triage queue fills, hotfix the classifier.
- Model failure in one region: automatic failover to the other region, capacity headroom pre-reserved.
- Vector Search index corruption: roll back to last-good snapshot, rebuild in the background.
- Cost spike from a malicious user: per-user cap trips, account auto-suspended, alert to on-call.
- Privacy incident: GDPR notification within 72 hours, audit log review, user comms.
- Latency spike from a CDN issue: fall back to origin, update status page.
- Model upgrade breaks quality: version pinning lets us roll back without a code change.
- Auth provider outage: secondary provider takes read traffic, login degrades gracefully.

## 14. Scale at 50M DAU

Key changes beyond GA:

- Dedicated reserved GCP capacity with committed use discounts.
- Per-geo deployment footprint with local ops.
- Fine-tuned own-model path because at this volume the economics justify it.
- Direct peering with mobile carriers in key markets.
- Custom embedding model via Vertex AI fine-tuning.
- Dedicated fraud and abuse ML team.
- 24/7 ops team, globally distributed on a follow-the-sun rotation.

## 15. Tie to My Evidence

- Gracenote is around 10K requests per day across 1500 plus catalogs and 1.5M records per month. I know the internal scale intimately. The jump to millions is not trivial. I would frame it as designing a new system for consumer reliability, not scaling the current one.
- I translated 12M multilingual rows on vLLM with FP8 in a single batch job for about $460. That scale economy is the mindset I bring to consumer volume. It is not about the model call, it is about the pipeline.
- J&J MedTech was regulated, large-scale ML with legal, security, and CAB review cycles. The same playbook transfers to GDPR, CCPA, DPDP.
- For abuse and safety I would start with Perspective API, Cloud DLP, Vertex AI output validation, and layer custom classifiers as we learn from adversarial traffic. AutoResearch is the systematic scale-up method I used for experiments and it generalizes here.

## 16. Follow-up Q&A

- "On-prem?" Anthos plus Vertex AI Private Endpoints. Possible, but the managed path is faster. Push for managed at GA, revisit on-prem for regulated tenants.
- "Multi-language?" Gemini native multilingual plus language-specific rerankers. Watch cost per language, tokenization inflates non-English.
- "SEO?" Static content for SEO. Agent responses are not indexed.
- "Mobile vs web cost?" Mobile push is cheaper than long web sessions. Tune per platform.
- "Cache hit rate target?" 50% plus for FAQ-style queries, much lower for personalized.
- "Fraud prevention?" Behavioral biometrics, device fingerprinting, velocity checks, payment signals.
- "Denial of wallet?" Per-user cost cap, auto-suspend on breach, alert with appeal.
- "API versioning?" Semantic versions, 6-month deprecation notice, abstraction layer in the SDK.
- "On-call load?" 24/7 rotation with regional primaries, SRE practices, blameless postmortems.
- "If Gemini is deprecated?" Pinned versions, abstraction layer, warm fallback provider.
- "Consumer trust?" Transparency UX, source citations, user feedback, one-click opt-out.
- "Localization?" India starts Hindi plus top regional. US defaults English. EU per member state for legal text.
- "PR and comms plan?" Yes, pre-drafted for privacy incident, data leak, misquote scenarios.
- "Compliance certs?" SOC 2 Type II, HIPAA if we touch health data, PCI if we touch payments, ISO 27001 for EU.
- "Rollout pacing?" KPI-gated on CSAT, incident rate, p95 latency. Open beta must meet criteria before GA unlocks.

## 17. Red Flags To Avoid

- "We will just scale the internal system." No. It is a different system.
- "GDPR is not our problem." It is, from the first EU user.
- "We will handle abuse after launch." Abuse shows up on day one.
- "Gemini is abuse resistant." No model is.
- "Rate limiting is enough." Rate limiting is table stakes, not a strategy.

## 18. Senior Closing

If I kept hitting this pattern, internal AI to external consumer, I would package the 6-month hardening template, the abuse mitigation playbook, and the GDPR-ready data pipeline as a reusable FDE module. Product feedback to Google: Gemini Enterprise SLOs need consumer-scale variants. Agent Engine today is optimized for enterprise batch and enterprise concurrency, not millions of concurrent consumer requests with sub-second p95 and per-user cost caps. That is a gap worth raising with product.

## 19. 90-Second Recall Summary

Internal to external is not a scaling problem, it is a different system. Identity becomes consumer auth with Identity Platform and 2FA. The API surface moves behind Apigee with rate limiting, quotas, and Cloud Armor. The agent runs on Cloud Run multi-region with Gemini 2.5 Flash as the router default and Pro for the hard 5%. Retrieval is Vertex AI Vector Search with a private endpoint. Safety is Perspective API plus Cloud DLP plus an output validator. Privacy is GDPR, CCPA, DPDP with CMEK, DLP redaction, real deletion pipeline. Reliability is 99.95% API, 99.99% auth, multi-region active-active, circuit breakers, queued slow paths. Rollout is 6 months: hardening, closed beta at 1K, open beta at 100K, GA with kill switches. At 500K DAU, around $0.43 per DAU-month. At 50M DAU, reserved capacity and a fine-tuned own-model path. Gracenote, 12M vLLM, J&J map directly. The red flag to avoid is treating this as "add nines." The real work is abuse, privacy, and unit economics.
