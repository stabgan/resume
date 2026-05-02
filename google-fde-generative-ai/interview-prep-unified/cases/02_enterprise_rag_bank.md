# Case 02 — Enterprise RAG Assistant for a Bank
Tags: RAG, Enterprise Integration, Security, Regulated Environment. Likelihood: VERY HIGH.

## 1. The Prompt
"A bank wants an internal assistant over policies, product docs, and support tickets. Design it."

## 2. Customer Context
I am embedded with "Meridian Banking", a regional Indian bank, ~8,000 employees, retail plus SMB lending, branches across six cities (Mumbai, Pune, Bengaluru, Hyderabad, Chennai, Kolkata). The Head of Contact Center sponsors the engagement and wants an internal assistant for 2,500 support agents. Knowledge lives across four silos: Confluence (product docs); SharePoint (policy PDFs, RBI circular summaries, KYC SOPs); Freshdesk (historical ticket resolutions); and nightly mainframe-extracted CSVs with customer-account data. Data residency is India only. Compliance: RBI data protection plus ISO 27001. They killed an "OpenAI over your data" pilot in week three because an agent quoted the wrong interest rate on a personal-loan call that went to the Ombudsman. Numeric correctness is non-negotiable; my first job is trust, not cleverness.

## 3. Discovery Phase
I would not whiteboard anything before I have answers. Likely customer responses in parentheses.

1. Read-only or actions like updating tickets or issuing refunds? (Read-only v1; write-path is a separate governance review.)
2. Which cohort pilots, exec sponsor? (Contact center; Head of Contact Center; senior agents in Mumbai.)
3. What counts as a good answer? (Cites a clickable source; stays within regulatory wording; no invented numbers.)
4. Unacceptable failure mode? (Hallucinated interest rate, fee, or policy clause; anything numeric wrong is regulatory exposure.)
5. Sources and ACLs? (Confluence role-based; SharePoint by AD groups; Freshdesk queues by product; CSVs restricted to agents with customer-data entitlement.)
6. Refresh cadence? (Confluence near real-time; SharePoint monthly; Freshdesk streaming; CSVs nightly at 02:00 IST.)
7. Identity propagation? (Azure AD SSO via OIDC; every API call carries a user token; ACL groups in AD.)
8. PII exposure? (Only when the customer is on the line and the ticket is open; PII must be masked in prompts and logs.)
9. Regulatory? (RBI data protection, draft DPDP Act, ISO 27001; nothing leaves India; audit retained seven years.)
10. Post-pilot ownership? (Platform team under the CTO; I leave runbooks and an on-call rotation.)
11. GCP footprint? (Landing zone in asia-south1; Vertex AI approved; BigQuery already holds mainframe extracts.)
12. Sponsor's CEO metric? (Average handle time reduction, first-call resolution lift, zero regulatory incidents.)

## 4. MVP Proposal
Scope aggressively. One team (customer-service agents in Mumbai), one knowledge slice (savings and personal-loan policies plus top fifty product pages), one language (English). Goal: deflect two shapes, "how do I set up X for a customer" and "what is our policy on Y"; every answer carries a citation. Not in MVP: actions, multilingual, voice-to-text, proactive suggestions. Success metrics: 70% agent acceptance of surfaced answers, zero numeric hallucinations on a 200-question golden set, p95 latency under 4 seconds. If those hold two weeks in shadow mode, expand. Any numeric fact wrong in production, we stop and debug.

## 5. Full Architecture

```
 [Confluence]   [SharePoint]   [Freshdesk]   [Mainframe CSV]
      |              |              |                |
      v              v              v                v
   +--------------------- Ingestion Workers ----------------+
   | Cloud Run jobs; per-source connector; delta detection  |
   +--------------------------------------------------------+
      |              |              |                |
      v              v              v                v
 [Document AI Layout Parser for PDFs / tables]        |
      |              |              |                |
      v              v              v                v
 [Chunker + Metadata Extractor (ACL, version, date)]  |
      |                                                |
      v                                                v
 [Vertex AI Embeddings: textembedding-gecko]      [BigQuery]
      |                                          structured
      v                                          account data
 [Vertex AI Vector Search, private endpoint, CMEK]    |
      |                                                |
      +------------> [Retrieval Orchestrator] <--------+
                            |
                  hybrid: dense + BM25
                  ACL filter at retrieve time
                            |
                            v
                 [Cross-encoder Reranker]
                            |
                            v
                 [Gemini 2.5 Flash generator]
                    (Pro for flagged escalations)
                            |
                            v
                 [Output Validator: numeric regex +
                  source cross-check + citation builder]
                            |
                            v
                 [Agent UI in Freshdesk sidebar]
```

Why each piece. Cloud Run jobs because ingestion is bursty and per-source; Composer is overkill for four connectors. Document AI Layout Parser because policy PDFs are table-heavy (fee grids, rate cards) and naive extraction shreds tables. Vertex AI textembedding-gecko for v1: managed, 768-dim, removes operational burden; door open to EmbeddingGemma fine-tune in phase 2. Vertex AI Vector Search with private endpoint and CMEK for residency and key control. BigQuery for structured account CSVs because chunking tabular data into a vector index is the wrong abstraction; retrieve via parameterised SQL. Hybrid retrieval because BM25 catches exact identifiers like "RBI/2023-24/47" that dense misses, and dense catches paraphrases. Cross-encoder reranker to fix the recall-precision tradeoff; fine-tuned on labelled ticket pairs once we have a few thousand. Gemini 2.5 Flash as default for cost and latency; router escalates to Gemini 2.5 Pro on ambiguity signals (conflicting retrieved claims, high complexity score). Output validator is non-negotiable: regex extracts every number from the answer and cross-checks against retrieved chunks; on fail, refuse.

## 6. Chunking Strategy (deep dive)
Default is 2,000 chars with 200-char overlap; I would not ship that. Bank docs deserve structure-aware chunking. Policies: chunk by section heading then clause, one chunk per clause, parent-section metadata attached so a sub-clause hit carries section context. Tickets: semantic chunking; customer question plus final agent resolution collapse into one chunk, intermediate back-and-forth summarised in metadata. CSVs: no chunking; BigQuery rows keyed by account number and product, retrieved with parameterised SQL after authorisation. Tables in policy PDFs (fee schedules, rate cards): Document AI Layout Parser to structured JSON; each row becomes a chunk with column headers duplicated into the body so embedding similarity picks up "personal loan" plus "processing fee" co-occurring in one unit. Every chunk carries: source URI, ACL group list, effective-from date, effective-to if superseded, content hash for change detection.

## 7. Security and Privacy
This is the bar. Identity propagates via OAuth/OIDC from Azure AD; every RAG API call carries a user token, and retrieval filters vector hits by intersecting AD group memberships with each chunk's ACL list. Filtering happens at retrieve time, not generate time, because a chunk the user cannot see must never enter the prompt. Per-user trace IDs and rate limits prevent cross-cohort leakage. For prompt injection, retrieved content is wrapped in a delimited, labelled block the system prompt treats as untrusted; the system prompt instructs the model to ignore embedded instructions. When the agent fetches customer context from BigQuery, Cloud DLP masks account numbers and names before text enters the prompt; unmasked values render in the agent UI outside the model path. Every query is audit-logged (user, query, chunk IDs, answer, validator verdict, timestamp); retention is seven years in Cloud Logging with export to BigQuery. Vector Search, BigQuery, Cloud Storage all use CMEK via Cloud KMS. A VPC-SC perimeter wraps Vertex AI, BigQuery, Cloud Storage. Private Service Connect exposes the RAG API to the bank's internal network. Service accounts are least-privilege, scoped per ingestion source, so a compromised Confluence connector cannot read SharePoint.

## 8. Evaluation Strategy
I care about three metric families. Retrieval: recall@5, NDCG@5 on the golden set. Generation: faithfulness (answer supported by retrieved chunks) and citation correctness (cited chunk actually contains the claim). Task-level: agent acceptance, override, escalation rates. Safety: numeric hallucination rate (target zero) and policy-violation rate from a classifier. The golden set is 200 anonymised ticket questions, stratified by product and difficulty, gold answers by two senior agents, adjudicated by a compliance SME. I use Gemini as an LLM judge for faithfulness, sample 20% weekly for human review, and track Cohen's kappa between judge and humans; if kappa drops below 0.7, I retrain the judge prompt. Every index refresh triggers a golden-set replay; deployment fails if recall@5 drops more than 5 points or numeric hallucination rate rises above 0.1%. This is the same DSPy plus DeepEval shape I ran on the Gracenote Haiku migration.

## 9. Observability
Cloud Trace spans wrap ingestion, retrieval, rerank, generation, each tagged with a per-query trace_id. Cloud Logging captures structured events with chunk IDs so any session can be rebuilt offline. Cloud Monitoring dashboards show per-cohort and per-question-type acceptance, latency percentiles, cost per query. I version-track embedding, reranker, generator, prompt template; every audit entry records which versions served the query. On model roll-forward, the prior version stays pinned two weeks to diff on the golden set before retiring.

## 10. Rollout Plan
Week 1-2: shadow mode, 10 senior agents in Mumbai; assistant surfaces a suggested answer; agent types their own reply; we log agreement. Week 3-4: 50 agents paste suggestions into tickets, marked "AI-assisted" for audit. Week 5-6: canary to 500 agents gated by SLOs (recall@5 above 0.85, numeric hallucination below 0.1%, p95 under 4s). Week 7+: full rollout to 2,500 with a platform-team-owned kill switch. Weekly one-page scorecard: acceptance, top failure modes, cost per agent per day, next week's remediation.

## 11. Tradeoffs
Three explicit. First, embeddings: managed gecko vs fine-tuned EmbeddingGemma. Start managed (one less thing to own); move to fine-tune in phase 2 if per-topic recall gaps appear. Same call as my EmbeddingGemma 300M fine-tune with Matryoshka heads and four-directional GTE-style loss, which gave +12 points acc@1/@5 in a narrow domain. Second, generation: Flash default vs Pro on flagged queries; two-tier routing keeps cost manageable while protecting quality on the hard 10%. Third, ACL enforcement: retrieve-time vs generate-time. Retrieve-time is strictly stronger because the model never sees a forbidden chunk; generate-time relies on self-censorship, which I cannot defend to a compliance auditor.

## 12. Failure Modes
Connector breaks when Confluence changes its API: per-connector SLOs, ingestion-lag alerts, dead-letter queue for replay. Hallucinated numeric fact: validator extracts numbers via regex, cross-checks against retrieved chunks; on mismatch the response becomes "I could not verify; please check source X." ACL chunk leaks: automated retrieval-filter tests in CI with synthetic tokens at different entitlement levels. Prompt injection via ticket body: input sanitisation at ingestion, system-prompt isolation, jailbreak classifier on queries. Index staleness: daily delta re-embedding, "last updated" badge in UI. Model deprecation: generator version pinned; new version held behind shadow eval gate for two weeks. Cost spike from long context: per-request context-size guardrails, k=8 cap after reranking.

## 13. Scale
At 10x (25,000 agents, 10 languages), the shape changes. Multilingual embeddings: multilingual base plus language-specific rerankers to keep per-language precision high. Regional replicas for residency: EU queries pinned to europe-west, India to asia-south1, routed by the API layer on user home region. Cost centre shifts from generation to retrieval because generation is linear in queries and retrieval can be sub-linear with quantisation; enable Vector Search scalar quantisation and revisit whether the managed Vertex AI Search is a better fit. Push ingestion into event-driven streams to keep freshness under 5 minutes.

## 14. Tie to Your Evidence
I have done versions of each piece. The EmbeddingGemma 300M fine-tune with Matryoshka and four-directional GTE-style loss is the move when managed embeddings stall; +12 points acc@1/@5 came from domain-specific hard negatives, same playbook as here. At J&J MedTech I spent two years embedded with a regulated customer, taking an undocumented approval heuristic to production ML, clearing legal, security, and CAB; that is the cadence Meridian will demand. My production LangGraph multi-agent workflow at Gracenote, with the Haiku migration backed by DSPy plus DeepEval, is how I structure the eval harness. My two npm MCP servers (openrouter-mcp-multimodal, steelmind-mcp) are how I think about secure tool-calling; if this evolves beyond read-only, MCP-style contracts are how I expose internal APIs.

## 15. Follow-up Q&A
Q: Why not fine-tune instead of RAG? A: RAG is reversible, updatable, auditable; policies change monthly. Fine-tune for behaviour, not knowledge.
Q: Conflicting policy versions? A: Chunks carry effective-from/to dates; retrieval defaults to latest active; generator surfaces a deprecation warning if superseded.
Q: On-prem option? A: Anthos plus Vertex AI Private works, but eval iteration slows and hardware becomes critical path; push for VPC-SC plus India-region Vertex AI as the compromise.
Q: Jailbreak attempts? A: Input classifier, system-prompt isolation, full audit log; track attempts as a metric and tighten over time.
Q: Faithfulness at scale? A: Gemini-as-judge with 20% weekly human sample; track Cohen's kappa and retrain the judge prompt when it slips.
Q: Ingestion latency for a new Confluence page? A: 5 minutes via webhook-triggered delta re-embed; worst case 1 hour on the safety-net poll.
Q: Tables in policy PDFs? A: Document AI Layout Parser to structured JSON; each row a chunk with headers duplicated.
Q: Freshdesk tickets with PII? A: Cloud DLP on ingestion redacts account numbers, names, phones; redacted version is indexed.
Q: Preventing off-policy answers? A: Allowed-topics classifier on input, refusal template on output, both logged.
Q: Why Gemini over Anthropic? A: Policy (Google Cloud); technically Gemini 2.5 Flash is competitive on cost and latency, Pro gives headroom on hard queries.
Q: Monthly cost at 2,500 agents? A: ~50 queries per agent per day, 125k/day. Flash generation ~USD 3-4k/month, embeddings and reranking ~USD 1k, Vector Search ~USD 2k. ~USD 7-8k/month.
Q: Multi-turn? A: Memory Bank session memory; cap window at last three turns, summarise older.
Q: 1M Confluence pages? A: Incremental embedding by content hash, index sharding by space; evaluate Vertex AI Search at that scale.
Q: Retrieval bias? A: Per-topic recall@5; any topic trailing median by 10+ points goes on the remediation list.
Q: Voice? A: New scope. Speech-to-Text front, TTS back; speech-error eval harness is a separate build.

## 16. Red Flags: phrases to avoid
"We'd just throw it into a vector DB." "Gemini handles hallucinations." "Let's start with a demo and figure out security later." "The model will refuse unsafe queries." "Fine-tune on the policies and skip RAG."

## 17. Senior Closing
If I saw this pattern again (regulated customer, multi-source enterprise knowledge, agent productivity), I would capture two reusable modules for the FDE playbook. First, the ACL-aware ingestion template: a connector framework where every chunk inherits the source system's ACL and retrieval filters at query time. Second, the numeric-fact validator: a language-agnostic post-processor that regex-extracts numbers from generated answers and cross-checks them against retrieved chunks before the response ships. I would also feed back to the Vertex AI RAG Engine team that cross-source ACL propagation is the pain point most likely to stall regulated deployments; a first-class feature there would shorten time-to-pilot for every bank, insurer, and healthcare customer after Meridian.

## 18. 90-Second Recall Summary
Meridian Banking wants an internal assistant for 2,500 support agents over Confluence, SharePoint, Freshdesk, mainframe CSVs. India-only, RBI plus ISO 27001. Prior OpenAI pilot died on a hallucinated interest rate. MVP: one team, one knowledge slice, English, read-only, citations required, zero numeric hallucinations. Architecture: per-source Cloud Run ingestion, Document AI for table-heavy PDFs, structure-aware chunking, Vertex AI textembedding-gecko, Vertex AI Vector Search with private endpoint and CMEK, BigQuery for structured data, hybrid retrieval with retrieve-time ACL filter, cross-encoder reranker, Gemini 2.5 Flash default with Pro escalation, numeric-fact validator as the hard safety net. Security: Azure AD OIDC, VPC-SC, Private Service Connect, Cloud DLP PII masking, Cloud KMS CMEK, seven-year audit log. Eval: 200-question golden set, recall@5, Gemini-judge faithfulness with 20% human calibration, regression gate per index refresh. Rollout: shadow 10, then 50, then 500 behind SLO gates, then 2,500 with a kill switch. Anchored in my EmbeddingGemma fine-tune, J&J MedTech regulated governance, and Gracenote LangGraph plus DSPy plus DeepEval. I leave behind a reusable ACL-aware ingestion template and a numeric-fact validator for the next regulated RAG engagement.
