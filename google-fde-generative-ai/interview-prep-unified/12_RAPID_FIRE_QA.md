# 12 — Rapid-Fire Q&A Drill (RRK Between-Topic Probes)

## How to use this file

This deck contains 70 short probes Google FDE interviewers commonly throw between main topics in the RRK round. The goal is not depth; it is reflex. The interviewer is calibrating how fast and how confidently I can move between RAG, agents, eval, cost, security, GCP, and personal framing without stalling.

Drill mechanics. I cover the answer block with my hand or a sticky note. I read the question, start a 20-second mental timer, and speak the answer aloud as if the interviewer just asked it. Then I uncover, compare, and move on. I do not rewrite the answer in my head; I speak, compare, next.

Organization. 70 probes in 7 buckets of 10. One bucket per day from May 3 through May 9 so every topic gets a dedicated pass. May 10 is a mixed shuffle. May 11 and May 12 are timed speed drills using the routine at the end of this file.

Day assignment. May 3 Bucket 1 RAG. May 4 Bucket 2 Agents. May 5 Bucket 3 Eval. May 6 Bucket 4 Cost. May 7 Bucket 5 Security. May 8 Bucket 6 GCP. May 9 Bucket 7 Personal. May 10 shuffle all 70. May 11 and May 12 speed drill plus HIGH LIKELIHOOD set.

Traffic light. Each probe is tagged green, yellow, or red. Green means I can say it cold. Yellow means I can say it but I stumble on one phrase. Red means I am not confident yet and need another pass. I update these daily on my practice copy.

Voice. Every answer is first person, present tense, confident but calibrated. No "I think", no "maybe". If I do not know something, I name the missing artifact and say how I would resolve it.

---

## Bucket 1 — RAG and Retrieval

### Q1.1 — When do you pick RAG over fine-tuning? 🟢

**15-second answer:**
> RAG when the knowledge is fresh, auditable, or permission-scoped; fine-tune when the model needs a new skill, a new format, or lower latency on a stable task. Most enterprise asks are RAG because the ground truth lives in docs, tickets, or a warehouse, and it changes weekly.

**If they push:**
> On Gracenote I layered both: RAG for catalog facts, DSPy MIPROv2 and GEPA to compile prompts, and a small fine-tune only for a structured extraction step that was latency bound.

**Evidence tie:** Gracenote LangGraph migration; EmbeddingGemma fine-tune as the counter-example.

### Q1.2 — Walk me through your chunking strategy. 🟢

**15-second answer:**
> I default to semantic chunking on section headers with a 200 to 500 token window and 10 to 15 percent overlap, then I attach document-level metadata like ACL, source, and last-modified to every chunk. If the corpus is code or tables, I switch to structure-aware splits so a function or a row never breaks across chunks.

**If they push:**
> For the EmbeddingGemma fine-tune I used 4-directional GTE pairing, query-to-doc and doc-to-query both ways, so chunk boundaries had to respect heading hierarchy or recall collapsed at k=1.

**Evidence tie:** EmbeddingGemma 300M fine-tune, +12 points acc@1/@5.

### Q1.3 — Hybrid search in one breath. 🟢

**15-second answer:**
> BM25 for lexical, dense vectors for semantic, combined with reciprocal rank fusion or a weighted score, then a cross-encoder reranker on the top 50 to pick the final k. Lexical catches exact IDs, part numbers, error codes; dense catches paraphrase. You need both or you leak precision.

**If they push:**
> On Vertex I would use Vector Search for dense, BigQuery or Elastic for BM25, and a Gemini Flash or a small cross-encoder as the reranker behind RAG Engine.

**Evidence tie:** General knowledge plus Gracenote retrieval stack.

### Q1.4 — How do you preserve ACLs through retrieval? 🟡

**15-second answer:**
> ACLs ride on the chunk as metadata at ingest, and I filter the vector query by the caller's group membership before scoring, not after. Post-filtering is the classic leak. For Google Workspace sources I would hydrate ACLs through Drive APIs at index time and refresh on a schedule, with OAuth 2.0 delegation so the query runs as the user.

**If they push:**
> I built the OAuth-against-Microsoft-Graph half in Data Sentry for IAM onboarding, so enterprise identity propagation is familiar; the ACL-filter-at-retrieve half is the pattern I would bring, with the Google equivalent being Workspace APIs plus IAP at the edge.

**Evidence tie:** Data Sentry OAuth on Microsoft Graph (identity side only).

### Q1.5 — Do I really need a reranker? 🟢

**15-second answer:**
> Yes once recall at 50 is good but precision at 5 is weak. The reranker is where faithfulness comes from because the generator only sees the top k. I measure the lift with a golden set: if rerank adds more than 5 points of precision at 5, it pays for itself; if not, I cut it for latency.

**If they push:**
> On Gracenote DeepEval's golden set showed rerank worth roughly 8 points of contextual precision, so it stayed.

**Evidence tie:** Gracenote DeepEval harness.

### Q1.6 — How do you evaluate retrieval in isolation? 🟢

**15-second answer:**
> Golden set of queries with known relevant chunks, then I track recall at k, MRR, and nDCG for the retriever alone, separate from generation. For generation I layer faithfulness and answer relevancy on top. Separating the two is the only way to know whether a regression is retrieval or the model.

**If they push:**
> DeepEval on Gracenote gave me this split; when faithfulness dropped I could point at the retriever, not the prompt.

**Evidence tie:** Gracenote DeepEval golden set.

### Q1.7 — RAG Engine or roll your own? 🟡

**15-second answer:**
> RAG Engine when the customer wants managed chunking, managed embeddings, and Vertex-native grounding with minimal ops; DIY when I need custom rerankers, exotic chunkers, or tight coupling to an existing feature store. I start on RAG Engine, profile the eval gap, and only peel off if a component is the bottleneck.

**If they push:**
> Vector Search plus RAG Engine covers maybe 80 percent of enterprise asks; the rest usually want custom chunking for code or tables.

**Evidence tie:** General knowledge, Vertex product map.

### Q1.8 — Freshness versus cost, how do you pick the re-index cadence? 🟡

**15-second answer:**
> I tie cadence to the document's change velocity and the cost of a stale answer. Policy docs maybe weekly; ticketing data hourly; streaming sources through a CDC path. I put a last-modified field on every chunk and expose it in the answer so the user sees the age.

**If they push:**
> For Gracenote catalog refreshes I batched the embedding regeneration at night to keep A100 cost flat while tickets and notes ran near real-time.

**Evidence tie:** Gracenote catalog plus EmbeddingGemma batch reindex.

### Q1.9 — Multimodal RAG, how would you index PDFs with tables and images? 🟡

**15-second answer:**
> I extract text, tables, and image regions separately; text and table rows get embedded with a text model, images with a vision embedding, and each chunk carries a type tag. At query time I retrieve across both spaces and let a Gemini Flash model compose the final answer from mixed evidence.

**If they push:**
> The ingestion piece here is table-aware parsing plus joint text-image embeddings, which I would build on Document AI plus Vertex multimodal embeddings. My @stabgan/openrouter-mcp-multimodal MCP server handles the tool-side SSRF-safe routing of multimodal inputs at inference, not the ingestion pipeline.

**Evidence tie:** @stabgan/openrouter-mcp-multimodal MCP server.

### Q1.10 — Top three RAG failure modes in production? 🟢

**15-second answer:**
> One, missing or stale chunks so the model hallucinates confidently. Two, ACL leakage because filtering happened post-rank. Three, context stuffing where I shove 20 chunks in and the model loses the needle. Fixes are golden-set eval, pre-filter on metadata, and a reranker with a hard k cap.

**If they push:**
> On Gracenote I caught mode one with faithfulness scoring and mode three by capping k at 5 after rerank; latency dropped and accuracy held.

**Evidence tie:** Gracenote DeepEval plus p95 latency -50%.

---

## Bucket 2 — Agents and Orchestration

### Q2.1 — Agent or workflow, how do you decide? 🟢

**15-second answer:**
> If the steps are known and ordered, it is a workflow; I use LangGraph or a DAG and save the token cost. Agents only when the path is genuinely branching on tool output and I cannot enumerate states ahead of time. Most "agent" asks are actually workflows wearing an agent hat.

**If they push:**
> Gracenote moved from a loose agent loop to a LangGraph state machine with a bounded agent node inside; cost per request dropped roughly 3x.

**Evidence tie:** Gracenote LangGraph migration, cost/req -3x.

### Q2.2 — ADK or LangGraph, when do you pick which? 🟡

**15-second answer:**
> ADK when the customer is committed to Vertex and wants Agent Engine for managed deployment, tracing, and A2A across agents; LangGraph when the control flow is complex, the team already knows it, or I need fine-grained state machines. I can bridge both with MCP tools so the choice is not lock-in.

**If they push:**
> On a Google engagement I would default to ADK plus Agent Engine for the deploy story and wrap existing LangGraph nodes as tools.

**Evidence tie:** Gracenote LangGraph plus ADK general knowledge.

### Q2.3 — MCP versus A2A versus plain tool-calling? 🟢

**15-second answer:**
> Tool calling is the model asking for a function; MCP is the protocol that lets any model talk to any tool server with a shared schema; A2A is one agent delegating to another agent. MCP standardizes the tool surface, A2A standardizes the agent surface. I use both in the same stack.

**If they push:**
> I ship two npm MCP servers today, @stabgan/openrouter-mcp-multimodal and @stabgan/steelmind-mcp, so MCP is not theory for me.

**Evidence tie:** Published npm MCP servers.

### Q2.4 — Multi-agent coordination, what is the pattern? 🟡

**15-second answer:**
> Supervisor plus specialists is my default: one planner agent decomposes, specialists own domains, the supervisor aggregates. I keep shared state explicit, not implicit, and I use A2A or a bus so specialists do not call each other directly unless the graph says they can.

**If they push:**
> I have not shipped a pure multi-agent supervisor in production; on Gracenote the LangGraph migration is the closest, with a bounded agent node inside a deterministic graph. J&J MedTech CCP was classical ML, so I draw the governance lessons from there and the orchestration lessons from Gracenote.

**Evidence tie:** Gracenote LangGraph migration; J&J governance experience.

### Q2.5 — An upstream tool returns garbage. What happens? 🟢

**15-second answer:**
> Every tool call is wrapped in a timeout, retry with jitter, and a schema validator; on failure the agent gets a structured error, not the raw exception, so it can reason about a fallback. I log the failure to Cloud Trace with a correlation ID and I cap retries at two to avoid loop blowup.

**If they push:**
> On Gracenote I added a circuit breaker per tool; when the upstream flapped, the agent degraded to a cached answer rather than spinning.

**Evidence tie:** Gracenote LangGraph migration.

### Q2.6 — How do you handle agent state and memory? 🟡

**15-second answer:**
> Short-term state lives in the graph; long-term memory is a typed store, either Firestore for per-user preferences or a vector index for episodic recall, always keyed by user ID with TTLs. I never let the agent accumulate unbounded conversation history in context; I summarize on a rolling window.

**If they push:**
> Agent Engine's session state plus Firestore covers most cases; for semantic recall I bolt on Vector Search.

**Evidence tie:** General knowledge, Agent Engine map.

### Q2.7 — How do you prevent cost blowup in a loop? 🟢

**15-second answer:**
> Hard step budget per run, token budget per step, and a cost ceiling in dollars tracked in the trace. If the budget trips, the agent returns a structured "insufficient budget" response, not a partial hallucination. I also log cost per successful task, not per request, so spinning agents show up as red.

**If they push:**
> This is how I held Gracenote at 3x cost reduction; the budget gate caught two runaway loops in the first week.

**Evidence tie:** Gracenote cost/req -3x.

### Q2.8 — CrewAI versus ADK, your take? 🟡

**15-second answer:**
> CrewAI is fast to prototype role-based crews but thin on production ops; ADK is heavier but ships with Agent Engine, Cloud Trace, and A2A so it earns its weight in a Google customer stack. I would prototype in either and graduate to ADK for anything customer facing.

**If they push:**
> For an internal hackathon CrewAI is fine; for a J&J-grade deployment I want the audit and CMEK story ADK gives me.

**Evidence tie:** J&J MedTech CCP, ADK general knowledge.

### Q2.9 — Deterministic fallback, what does that look like? 🟢

**15-second answer:**
> Every agent path has a non-LLM fallback: a SQL query, a rules engine, or a cached answer. If the model times out, violates schema, or breaches the budget, I return the deterministic answer with a degraded-mode flag so the UI can say so. Customers trust systems that fail predictably.

**If they push:**
> On the 1500+ partner catalog takeover the LightGBM model was the deterministic floor; the LLM path sat on top and could always fall back to it.

**Evidence tie:** 1500+ partner catalog, XGBoost to LightGBM, 97% precision.

### Q2.10 — When would you NOT use an agent? 🟢

**15-second answer:**
> When the task is single-turn, the tools are two or fewer, and latency matters. That is a function call, not an agent. Wrapping it in a planner costs tokens and introduces failure modes for zero benefit. I push back on customers who want "agents" for what is really a form submission.

**If they push:**
> I killed an agent loop on Gracenote for catalog lookups; a direct Gemini Flash call with a typed tool beat it on latency and cost.

**Evidence tie:** Gracenote Haiku migration, p95 -50%.

---

## Bucket 3 — Evaluation and Observability

### Q3.1 — Walk me through your eval layers. 🟢

**15-second answer:**
> Three layers. Unit tests on prompts and tools; golden set for retrieval and end-to-end quality; online metrics on live traffic with sampling. Unit catches regressions in minutes, golden set gates releases, online catches drift. DeepEval plus Cloud Trace gives me all three on Gemini.

**If they push:**
> On Gracenote this three-layer stack is what let me ship the Haiku migration without a quality regression.

**Evidence tie:** Gracenote DeepEval plus LangGraph migration.

### Q3.2 — LLM-as-judge, what are the risks? 🟡

**15-second answer:**
> Bias toward longer answers, toward the same model family, and toward verbose reasoning even when wrong. I mitigate with pairwise comparisons instead of absolute scores, a different judge model than the generator, and calibration against a human-labeled subset every release.

**If they push:**
> On Gracenote I used Claude as the judge for a Gemini-generated output and vice versa; that cross-family pairing caught a self-preference leak.

**Evidence tie:** Gracenote DeepEval cross-model judging.

### Q3.3 — Faithfulness versus helpfulness, how do you score both? 🟢

**15-second answer:**
> Faithfulness is a per-claim check against retrieved context; helpfulness is a task-level judgment against the user intent. They can move in opposite directions: a terser answer is more faithful but less helpful. I report both and set a faithfulness floor before optimizing helpfulness.

**If they push:**
> DeepEval on Gracenote surfaced exactly this tradeoff when I tuned for concision; I put a floor at 0.9 faithfulness and the rest followed.

**Evidence tie:** Gracenote DeepEval metrics.

### Q3.4 — Trace correlation IDs, why do they matter? 🟢

**15-second answer:**
> Without a correlation ID I cannot stitch a user complaint back to the exact retrieval, the exact prompt, the exact tool calls, and the exact tokens. With OpenTelemetry and Cloud Trace, one ID threads the whole stack and I can reproduce the failure in minutes, not days. It is the single highest-leverage piece of plumbing.

**If they push:**
> On Gracenote that one ID cut incident triage from hours to minutes.

**Evidence tie:** Gracenote LangGraph plus Cloud Trace.

### Q3.5 — Canary rollout with a rollback gate, what does it look like? 🟢

**15-second answer:**
> New prompt or model goes to 5 percent of traffic behind a feature flag, I watch faithfulness, latency, and cost for an hour against a control slice; if any tripwire fires, the flag flips back automatically. Full rollout only when the golden set and the canary both pass.

**If they push:**
> That is exactly how I shipped Haiku on Gracenote without a rollback.

**Evidence tie:** Gracenote Haiku migration.

### Q3.6 — LLM-native metrics beyond accuracy? 🟡

**15-second answer:**
> Tokens per second for throughput, cost per successful task, time-to-first-token for perceived latency, and groundedness rate for trust. Accuracy alone hides a 10x cost regression. I put cost per successful task on the same dashboard as p95 latency so no one optimizes one in isolation.

**If they push:**
> On Gracenote this dashboard is what surfaced the 3x cost cut alongside the latency win.

**Evidence tie:** Gracenote p95 -50%, cost/req -3x.

### Q3.7 — DSPy versus prompt engineering by hand? 🟡

**15-second answer:**
> DSPy compiles prompts against a metric instead of me tweaking strings; MIPROv2 and GEPA optimize few-shot and instructions jointly, and InferRules extracts rules I can audit. Hand prompting works for one shot; DSPy wins once I have a golden set and a clear metric to optimize.

**If they push:**
> Gracenote used MIPROv2 then GEPA on top of InferRules; that pipeline is what delivered the quality floor for the Haiku migration.

**Evidence tie:** Gracenote DSPy MIPROv2, GEPA, InferRules.

### Q3.8 — GEPA in 60 seconds. 🟡

**15-second answer:**
> GEPA is a reflective prompt optimizer; it uses language feedback from failures to evolve prompts instead of just bandit-style search. It beats MIPROv2 on my harder Gracenote tasks because the reflection step captures why a prompt failed, not just that it did.

**If they push:**
> I chained MIPROv2 first for coarse search, GEPA second for reflective refinement; that combo is what hit our quality target.

**Evidence tie:** Gracenote GEPA plus MIPROv2.

### Q3.9 — How do you use DeepEval day to day? 🟢

**15-second answer:**
> Golden set as fixtures, metrics as assertions: faithfulness, contextual precision, contextual recall, answer relevancy, and task-specific G-Eval checks. Runs in CI on every PR that touches a prompt or a retriever. Failures block the merge.

**If they push:**
> On Gracenote DeepEval caught two regressions before they shipped; that is the value.

**Evidence tie:** Gracenote DeepEval harness.

### Q3.10 — Red-teaming, how do you approach it? 🟡

**15-second answer:**
> Curated attack set of prompt injection, jailbreak, PII exfiltration, and tool abuse prompts; automated runs on every release; human review on any new class of failure. I treat it like security testing, not a one-off. For customer-facing agents I also run static checks on tool outputs before they reach the model.

**If they push:**
> For J&J MedTech the red-team set had to pass legal and security review before clearance; that discipline carries over.

**Evidence tie:** J&J MedTech CCP clearance.

---

## Bucket 4 — Cost and Performance

### Q4.1 — Cost per successful task versus cost per request, why does it matter? 🟢

**15-second answer:**
> Per-request cost hides retries, tool loops, and failed tasks; per-successful-task exposes them. A system can look cheap on requests and be expensive on outcomes. I standardize on cost per successful task in dashboards and tie it to the SLO.

**If they push:**
> That framing is how I justified the Gracenote migration: 3x cost reduction measured per successful task, not per token.

**Evidence tie:** Gracenote cost/req -3x.

### Q4.2 — Model routing tiers, walk me through it. 🟢

**15-second answer:**
> Flash-Lite for classification, extraction, and tool routing; Flash for most generation; Pro for complex reasoning or long context. A thin classifier picks the tier per request and I log the tier with the trace so I can audit. Most traffic lands on Flash-Lite or Flash; Pro is the exception.

**If they push:**
> On Gracenote that three-tier split is where most of the cost win came from.

**Evidence tie:** Gracenote Haiku migration, general Gemini tiering.

### Q4.3 — Context compression, what works? 🟡

**15-second answer:**
> Summarization of old turns with a rolling window, extractive compression on retrieved chunks, and a hard token cap per section. I never pass raw history past a few turns; I pass a summary plus the last two turns verbatim. Compression is cheaper than a bigger model.

**If they push:**
> On Gracenote this cut prompt tokens by roughly half without measurable quality loss on the golden set.

**Evidence tie:** Gracenote token reduction.

### Q4.4 — Caching safely for LLMs? 🟡

**15-second answer:**
> Cache on a deterministic key: model ID, prompt hash, tool signature, user or tenant scope when relevant. Semantic cache with an embedding similarity threshold for near-duplicate queries, with ACL as part of the key. Never cache across tenants and always TTL.

**If they push:**
> Gemini's context caching for long shared prompts is a separate lever; I use it for system prompts and stable few-shots.

**Evidence tie:** General knowledge, Gracenote stack.

### Q4.5 — Streaming or batch, when which? 🟢

**15-second answer:**
> Streaming when a human is watching; batch when the output feeds another system. Streaming pays for perceived latency, batch pays for throughput and cost. I would never stream a nightly translation job and I would never batch a chat response.

**If they push:**
> On the 12M translation job batching on vLLM with FP8 is what made the cost math work.

**Evidence tie:** 12M vLLM FP8 translation, 4xL40S, ~$460.

### Q4.6 — FP8 quantization, what do you lose? 🟡

**15-second answer:**
> Usually under 1 percent on task quality if the calibration set matches the domain, and I verify on my golden set before rollout. The win is roughly 2x throughput on supported hardware and a memory footprint small enough to fit bigger batches. I always eval before trusting it.

**If they push:**
> On the vLLM translation job FP8 was the difference between four L40S fitting the workload and needing A100s.

**Evidence tie:** 12M vLLM FP8 translation.

### Q4.7 — Tell me about that 12M translation on 4xL40S for $460. 🟢

**15-second answer:**
> 12 million segments, vLLM with FP8 on four L40S cards, continuous batching, and a bounded context to keep throughput tight. Landed around 460 dollars end to end. The win came from right-sizing the hardware, FP8, and vLLM's scheduler, not from a bigger model or a longer context.

**If they push:**
> Same pattern scales to Cloud Run GPU or a GKE pool on GCP; the lesson is that batch translation is a throughput problem, not an intelligence problem.

**Evidence tie:** 12M vLLM FP8 translation on 4xL40S at ~$460.

### Q4.8 — Decompose end-to-end latency for me. 🟢

**15-second answer:**
> Network in, auth, retrieval, reranker, prompt build, first token, generation, tool round-trips, post-processing, network out. On an agent path I add planning cost and tool latency as separate spans. OpenTelemetry on every hop; Cloud Trace gives me the waterfall. You cannot fix what you cannot see.

**If they push:**
> On Gracenote that decomposition is what pointed me at the reranker and the retriever as the latency hotspots, not the model.

**Evidence tie:** Gracenote p95 -50%.

### Q4.9 — Distillation, when is it worth it? 🟡

**15-second answer:**
> When a specific task is stable, high volume, and latency or cost bound. I distill a Pro-quality teacher into a Flash-sized student on my golden set and I only ship if the student holds quality within a tight tolerance. For drifting tasks, distillation stales fast and is not worth the ops.

**If they push:**
> The EmbeddingGemma fine-tune was a similar philosophy: a small model purpose-trained for one retrieval task, +12 points acc@1/@5.

**Evidence tie:** EmbeddingGemma 300M fine-tune.

### Q4.10 — When does Flash-Lite win? 🟢

**15-second answer:**
> High-volume classification, routing, short extraction, and tool selection. Anywhere the output is short and the reasoning is shallow, Flash-Lite wins on cost and latency while holding accuracy. I reserve Flash for generation and Pro for reasoning.

**If they push:**
> On Gracenote Flash-Lite equivalents handled the router and extractor stages; that is where a big chunk of the 3x cost cut lived.

**Evidence tie:** Gracenote cost/req -3x.

---

## Bucket 5 — Security and Enterprise Integration

### Q5.1 — OAuth 2.0 with PKCE in 45 seconds. 🟡

**15-second answer:**
> Client generates a code verifier and a code challenge; sends the challenge on the authorize request; user authenticates; client exchanges the returned code plus the verifier for tokens. PKCE removes the need for a client secret on public clients and prevents authorization code interception.

**If they push:**
> I implemented the OAuth flow end to end for Data Sentry against Microsoft Graph, including refresh token handling and scope-minimization.

**Evidence tie:** Data Sentry Microsoft Graph OAuth.

### Q5.2 — OIDC versus OAuth? 🟢

**15-second answer:**
> OAuth 2.0 is authorization; OIDC is an identity layer on top that adds an ID token, a userinfo endpoint, and standard claims. If I need to know who the user is, I use OIDC; if I only need scoped access to an API, OAuth is enough. Most modern enterprise apps want both.

**If they push:**
> Google Sign-In and Workload Identity Federation both lean on OIDC; that is the shape I would use on Google Cloud.

**Evidence tie:** General knowledge, Data Sentry experience.

### Q5.3 — VPC Service Controls, what does it buy you? 🟢

**15-second answer:**
> A perimeter around GCP services that blocks data exfiltration across the boundary even if credentials are stolen. For a customer with regulated data it means Vertex, BigQuery, and Cloud Storage sit inside the perimeter and only approved projects and identities can cross. It is the "defense in depth" layer above IAM.

**If they push:**
> For a J&J-style deployment on GCP, VPC-SC plus CMEK is the baseline I would propose.

**Evidence tie:** J&J MedTech CCP compliance.

### Q5.4 — IAP, where does it sit? 🟡

**15-second answer:**
> Identity-Aware Proxy sits in front of HTTP workloads on App Engine, Cloud Run, or a load balancer and enforces identity plus context before the request reaches the service. It replaces the "put it on a VPN" pattern and plays well with BeyondCorp. For internal admin UIs on a customer agent, IAP is my default front door.

**If they push:**
> Pair IAP with VPC-SC and you have the user-facing and service-facing sides both covered.

**Evidence tie:** General knowledge, enterprise pattern.

### Q5.5 — Apigee, when do you pull it in? 🟡

**15-second answer:**
> When the customer has partner-facing or public APIs that need quotas, keys, transformation, monetization, or policy chains the app layer should not own. Apigee buys governance, not just a proxy. For internal service-to-service I stay with Cloud Run or GKE plus IAM; Apigee earns its license at the partner boundary.

**If they push:**
> Pairs naturally with Agent Engine when customer agents are exposed to third parties.

**Evidence tie:** General knowledge, enterprise architecture.

### Q5.6 — Workload Identity Federation, in one breath. 🟡

**15-second answer:**
> External identities from AWS, Azure, GitHub, or any OIDC provider get mapped to a GCP service account without long-lived keys. The external token is exchanged for a short-lived GCP token at the STS endpoint. It is how I let a CI runner or an on-prem job hit GCP without a JSON key file.

**If they push:**
> Same primitive also powers cross-cloud agent deployments where the agent runs outside GCP but reads from BigQuery.

**Evidence tie:** General knowledge, GCP vocabulary.

### Q5.7 — Secret Manager versus environment variables? 🟢

**15-second answer:**
> Secret Manager for anything that is a credential; env vars for feature flags and config. Secrets get versioned, access-audited, IAM-scoped, and rotated. I never bake a key into an image and I never paste one into a prompt. Cloud Run and GKE both mount Secret Manager natively.

**If they push:**
> For the 1500+ partner catalog work the API keys were rotated on a schedule with Secret Manager equivalents; same pattern on GCP.

**Evidence tie:** 1500+ partner catalog rotation.

### Q5.8 — CMEK versus Google-managed keys? 🟡

**15-second answer:**
> CMEK gives the customer the key in Cloud KMS so they can rotate, audit, and revoke; Google-managed is simpler but does not satisfy some regulators. For regulated industries like healthcare and finance I default to CMEK on storage, BigQuery, and Vertex artifacts. HSM-backed keys when the compliance ask demands it.

**If they push:**
> J&J MedTech CCP needed exactly this level of key control before clearance.

**Evidence tie:** J&J MedTech CCP clearance.

### Q5.9 — Prompt injection mitigations, the short list. 🟢

**15-second answer:**
> Separate system, user, and tool roles strictly; sanitize and tag any text pulled from documents or the web before it enters the prompt; constrain tool outputs with schemas; keep a deny list of destructive actions that require confirmation; and never let the model pick the user it is acting as. Defense in depth, not one magic filter.

**If they push:**
> My @stabgan/openrouter-mcp-multimodal server ships SSRF-safe URL handling for exactly this class of risk on the tool side.

**Evidence tie:** @stabgan/openrouter-mcp-multimodal SSRF-safe.

### Q5.10 — Audit logging for agents, what do you capture? 🟡

**15-second answer:**
> Every user input, every tool call with inputs and outputs, every model call with model ID and token counts, every policy decision, and the correlation ID threading them. Logs go to Cloud Logging with access controls so only compliance and the on-call can read sensitive traces. That is what CAB review wants to see.

**If they push:**
> For J&J MedTech that log schema was part of clearance; same bar I would bring to a Google customer.

**Evidence tie:** J&J MedTech CCP clearance, CAB review.

---

## Bucket 6 — GCP Product Map

### Q6.1 — Cloud Run, GKE, or Agent Engine for an agent? 🟢

**15-second answer:**
> Agent Engine when the customer wants managed agent ops, session state, and A2A on Vertex; Cloud Run for stateless HTTP services with fast scale to zero; GKE when I need sidecars, custom networking, or GPU pools I manage. For a first-ship agent on Google, Agent Engine is my default.

**If they push:**
> If the customer already runs GKE for other workloads, I can host the agent as a service there and still call Vertex; not every shop will move to Agent Engine on day one.

**Evidence tie:** General knowledge, GCP map.

### Q6.2 — BigQuery versus Cloud SQL? 🟢

**15-second answer:**
> BigQuery for analytics, warehousing, and columnar scans over terabytes; Cloud SQL for transactional OLTP with rows, indexes, and foreign keys. They are not substitutes. If the customer wants both, I use a CDC pipeline to stream Cloud SQL into BigQuery.

**If they push:**
> BigQuery ML and the Gemini integration mean I can embed and even generate directly from the warehouse; that surprises customers in a good way.

**Evidence tie:** General knowledge, Vertex integration.

### Q6.3 — How do you pick between Gemini Pro, Flash, and Flash-Lite? 🟢

**15-second answer:**
> Start with Flash for general generation; drop to Flash-Lite for classification, routing, and short extraction; escalate to Pro only for long context or hard reasoning. I drive the split from the golden set, not from vibes. The cost delta is big enough that routing matters.

**If they push:**
> That tiering is the same pattern I used on Gracenote, and it is the fastest cost lever on most customer systems.

**Evidence tie:** Gracenote Haiku migration tiering.

### Q6.4 — Agent Builder versus ADK? 🟡

**15-second answer:**
> Agent Builder is the low-code, console-first surface for fast business-agent assembly; ADK is the Python SDK for engineers who need full control, testing, and CI. They share the Vertex runtime. I start customers on Agent Builder for prototypes and graduate production agents to ADK.

**If they push:**
> ADK plus Agent Engine is the production pairing; Agent Builder shortens the first demo.

**Evidence tie:** General knowledge, Vertex agent stack.

### Q6.5 — Vector Search versus Pinecone? 🟡

**15-second answer:**
> Vector Search when the customer is on Google Cloud and wants VPC-SC, IAM, and Vertex-native integration; Pinecone when they are multi-cloud or already committed. Technically both handle billion-scale ANN; the decision is usually governance and the rest of the stack, not raw performance.

**If they push:**
> For a regulated customer on GCP I would not bring Pinecone in; the perimeter story is cleaner with Vector Search.

**Evidence tie:** General knowledge, regulated-customer pattern.

### Q6.6 — RAG Engine or self-built? 🟢

**15-second answer:**
> RAG Engine for managed chunking, embedding, and grounding when the customer wants speed to first value; self-built when I need custom chunkers for code or tables, custom rerankers, or a non-standard corpus. I always start on RAG Engine and peel off components only when eval demands it.

**If they push:**
> On Gracenote the retriever was custom because of the catalog structure; on a cleaner enterprise doc set I would not have rebuilt it.

**Evidence tie:** Gracenote custom retrieval.

### Q6.7 — When Spanner? 🟡

**15-second answer:**
> When the customer needs strong consistency, horizontal scale, and multi-region writes that Cloud SQL cannot give them. Financial ledgers, global inventory, anything where a stale read is a bug. It is premium spend, so I only propose it when the consistency and scale story actually requires it.

**If they push:**
> For most agentic workloads Cloud SQL or Firestore is enough; Spanner is a specific answer to a specific scale problem.

**Evidence tie:** General knowledge, GCP database map.

### Q6.8 — Firestore versus Bigtable? 🟡

**15-second answer:**
> Firestore for document-style data with real-time sync and SDK-friendly access; Bigtable for wide-row time-series and high-throughput analytics. Firestore is the friendly default for app state and user data; Bigtable is for telemetry, monitoring, and anything that looks like a log.

**If they push:**
> For agent session memory I use Firestore; for trace and metric storage at scale, Bigtable or BigQuery.

**Evidence tie:** General knowledge, agent state pattern.

### Q6.9 — OpenTelemetry wiring on GCP, what does it look like? 🟢

**15-second answer:**
> OTel SDK in the service, exporter to Cloud Trace and Cloud Logging, and every span carries a correlation ID plus model ID, tool name, token counts, and cost. For agents I add spans per plan, per tool call, and per model call. That dashboard is where I spot regressions before users do.

**If they push:**
> On Gracenote OTel plus the tracing dashboard is how I attributed the latency win to specific stages.

**Evidence tie:** Gracenote p95 -50%.

### Q6.10 — Gemini Enterprise, what problem does it solve? 🟡

**15-second answer:**
> A packaged enterprise surface for Gemini with data governance, private grounding, and admin controls customers need before they can turn Gemini on across the org. It saves the customer from stitching together IAM, VPC-SC, and grounding themselves for a first deployment.

**If they push:**
> For an FDE engagement Gemini Enterprise is often the fastest path to "we can use Gemini on our data this quarter"; custom Vertex builds come next.

**Evidence tie:** General knowledge, FDE engagement pattern.

---

## Bucket 7 — Personal and Behavioral Probes

### Q7.1 — Why Google, why FDE? 🟢

**15-second answer:**
> FDE is the only role I have seen that pairs deep ML engineering with real customer pressure. I have been the engineer who gets called when the Gracenote ingestion breaks and when the J&J approval workflow needs a hard answer before a compliance review; I want to do that with Gemini, ADK, and Vertex behind me instead of working around them. Google is where that combination actually exists.

**If they push:**
> I have shipped two npm MCP servers, an AutoResearch fork with kiro-cli, and production LLM work; the FDE loop is my natural speed.

**Evidence tie:** Published MCP servers, AutoResearch fork, Gracenote, J&J.

### Q7.2 — Why not stay on a staff ML engineer track? 🟢

**15-second answer:**
> Because my best work happens at the customer boundary, not behind it. On Gracenote and J&J the work I am proudest of is translating a messy business problem into a shipped system, not pure modeling. Staff MLE rewards depth alone; FDE rewards depth plus delivery, and that fits me.

**If they push:**
> I still do the modeling; EmbeddingGemma +12 points at acc@1 was mine. I just want the customer in the room.

**Evidence tie:** EmbeddingGemma fine-tune, Gracenote, J&J.

### Q7.3 — What tech have you learned recently that excited you? 🟢

**15-second answer:**
> GEPA for reflective prompt optimization. It was the first optimizer that gave me a quality lift past where MIPROv2 plateaued on Gracenote, because it reasons over failures in language instead of just searching parameters. I rewired the prompt pipeline around it.

**If they push:**
> On the infra side, vLLM with FP8 on L40S hardware is the other one; that combo made the 12M translation land at 460 dollars.

**Evidence tie:** Gracenote GEPA; 12M vLLM FP8 translation.

### Q7.4 — What is your strongest technical opinion? 🟢

**15-second answer:**
> Most "agent" problems are workflow problems wearing an agent hat. Teams reach for planners and loops when a LangGraph state machine or a typed function call would ship faster, be cheaper, and fail more predictably. I have cut cost 3x on Gracenote by taking agents out where they did not belong.

**If they push:**
> I am not anti-agent; I am anti-agent-as-default. Use one when the path is genuinely uncertain.

**Evidence tie:** Gracenote LangGraph migration, cost/req -3x.

### Q7.5 — Biggest mistake in the last year? 🟡

**15-second answer:**
> I over-invested in an agent loop before I had a golden set in place, so I could not tell if quality was drifting. I paid for that with a week of rework setting up DeepEval and rerunning experiments. The lesson is eval harness first, every time; I now refuse to start without one.

**If they push:**
> That discipline is what made the Haiku migration clean and the cost cut defensible.

**Evidence tie:** Gracenote DeepEval, LangGraph migration.

### Q7.6 — What makes a good FDE? 🟢

**15-second answer:**
> Technical range so no conversation is out of reach, a bias toward shipping a thin vertical slice over an elegant design doc, and calibration: knowing what is load-bearing versus what is decoration. The ability to say "I do not know, here is how I would find out" without losing the room.

**If they push:**
> That calibration is what got J&J MedTech through legal, security, and CAB without a rework cycle.

**Evidence tie:** J&J MedTech CCP clearance.

### Q7.7 — How do you handle a customer who wants to move slower than you? 🟡

**15-second answer:**
> I slow my pace and speed up theirs. Slow mine by shipping smaller increments so each one is digestible; speed theirs by giving them a crisp decision menu with tradeoffs, not a blank prompt. Customer pace is a constraint I design for, not a blocker I complain about.

**If they push:**
> On J&J the CAB cadence was the pacing constraint; I shaped the release plan around it and we still cleared on schedule.

**Evidence tie:** J&J MedTech CCP, CAB cadence.

### Q7.8 — How do you handle "I do not know"? 🟢

**15-second answer:**
> I say it directly, then I name the artifact that would resolve it: a benchmark, a doc, a spike. I do not bluff and I do not apologize. Interviewers and customers both trust "I have not tested that; I would measure it this way" more than a confident guess.

**If they push:**
> That habit is how I got through Gracenote without a regression; I measured instead of guessing.

**Evidence tie:** Gracenote DeepEval discipline.

### Q7.9 — What would you build at Google in your first 90 days? 🟡

**15-second answer:**
> A reference FDE delivery pattern: a reusable agent starter on ADK plus Agent Engine with RAG Engine, OpenTelemetry wiring, a golden-set eval harness, and a canary gate. Prove it on one customer, then template it. That cuts every subsequent engagement in half.

**If they push:**
> I would bring the DSPy plus DeepEval pattern from Gracenote and the MCP server pattern from my published work as the starting blocks.

**Evidence tie:** Gracenote DSPy plus DeepEval; published MCP servers.

### Q7.10 — Where do you see yourself in five years? 🟡

**15-second answer:**
> Leading FDE engagements that set the pattern for how enterprises deploy Gemini agents: grounded, governed, and measurable. Still writing code, still on customer calls, deeper on agent platforms and eval science. I do not want a role where I stop shipping.

**If they push:**
> Staff-plus scope is fine; ivory-tower scope is not.

**Evidence tie:** Career arc plus Gracenote and J&J pattern.

---

## Speed drill routine (May 11 and May 12)

Twenty minutes, daily, out loud, timed. Voice recorder on.

Minute 0 to 2. Pick 10 probes at random across buckets; a shuffled deck or a die works. Write the probe numbers on paper, not the answers.

Minute 2 to 14. For each of the 10 probes, 20 seconds speaking, 10 seconds silence to reset. Total 5 minutes of speech, 5 minutes of reset, 2 minutes of buffer. No rewinds, no restarts. If I stall, I skip and mark it red.

Minute 14 to 18. Play back the recording at 1x. Mark each probe green, yellow, or red. Note any probe that hit a filler word.

Minute 18 to 20. Re-speak the two worst ones cold, without rereading the answer block. If I still cannot hit them clean, they move to the May 12 slot.

Rules. No rereading the answer during the drill; only in the review. No slowing my natural pace to "get the words right"; speed is the point. Record every session; discomfort during playback is the signal.

---

## HIGH LIKELIHOOD set — the 10 most likely to come up

These are the probes I drill on May 11 morning and May 12 morning no matter what.

1. Q1.1 When RAG over fine-tuning.
2. Q1.4 ACL preservation through retrieval.
3. Q2.1 Agent or workflow, how do you decide.
4. Q2.3 MCP versus A2A versus tool calling.
5. Q3.1 Eval layers walk-through.
6. Q4.1 Cost per successful task versus per request.
7. Q4.7 The 12M translation on 4xL40S for $460.
8. Q5.1 OAuth 2.0 with PKCE in 45 seconds.
9. Q6.3 How do you pick between Gemini Pro, Flash, and Flash-Lite.
10. Q7.1 Why Google, why FDE.

If the interviewer asks one of these and I fumble, the rest of the round gets harder. These are non-negotiable.

---

## Do Not Say list

Phrases that tank credibility in the first five seconds. If I catch myself starting with any of these in practice, I restart the probe.

- "I think" or "I believe" as a hedge. I replace with "my read is" or "I would".
- "I am not sure but" as an opener. I replace with "I have not verified X; here is how I would".
- "I might be wrong". If I am genuinely not confident, I say what I do know and what I would check.
- "I am rusty on that". If I am rusty, I answer the principle and name the gap factually.
- "Can I skip this one?". I answer with what I know; skipping tells the interviewer I fold under pressure.
- "We just used an LLM". I name the model, the tier, and the reason.
- "It was not really my project". If I am in the room, I owned something; I name that something.
- "Basically" and "literally" as filler. They dilute technical claims.
- "To be honest". Everything I say should be honest; flagging it implies the rest was not.
- "Sort of", "kind of", "a little bit". Hedges signal I do not trust my own claim.

One more rule. If I start a sentence and realize it is going badly, I stop, take half a beat, and restart the sentence clean. A clean restart beats a rambling save every time.
