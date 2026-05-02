# 14 — Narrated Walkthroughs

## Why this file exists

You already have the templates. You know the RRK scaffold (clarify, restate, architect, secure, evaluate, roll out, cost, risk, reuse, feedback, close). You know the coding protocol (clarify, approach, code with narration, dry-run, discuss). What you do not yet have, sitting in one place, is an example of a full round spoken out loud end to end. That is what this file is. Two fully narrated rehearsal transcripts, timestamp by timestamp, so you can hear the pacing in your head before you hear it in the actual room on May 13.

## How to use this file

Read each walkthrough aloud, twice, at roughly the speed you expect to talk in the real interview. Then close the file and try to reproduce the pacing from memory on a fresh prompt. Record yourself on your phone while you do it. Play the recording back and compare your narration density, your clarification depth, and your tradeoff surfacing to the transcript. Do not try to memorize the exact words. Internalize the rhythm.

## What to look for when you compare

Narration density first. One sentence of spoken thought every 8 to 15 seconds of active thinking. Long silences make the panel nervous; constant talking without thinking makes you sound shallow. Second, clarifying questions before diving. The transcript has 4 to 5 in coding and 10 in RRK. If you are jumping to an answer inside the first minute, stop and restart. Third, explicit tradeoffs. You should hear yourself say "the tradeoff here is" at least twice per round. Fourth, the FDE close. Product feedback to Google and two questions back at the interviewer. If you skip the close, you left points on the table. Everything else is detail.

---

## Walkthrough 1 — Coding Round (40 min): Rate Limiter class

### Round setup

**00:00 — Interviewer:** Hey Kaustabh, thanks for joining. I am going to share a prompt in the doc. Take a minute to read it, then think aloud as much as you can. This is a plain Google Doc, no execution, no autocomplete. I care more about how you think than whether the code compiles on the first try.

**00:00 — Interviewer (prompt in the doc):**

> Design a rate limiter class. It should support one method, `allow(user_id, timestamp)`, that returns `True` if the user is within their rate limit and `False` otherwise. Start with a basic version and then we can extend.

**00:01 — Candidate:** Got it, thanks. Let me read it once more and then I will ask a few clarifying questions before I write anything.

### Candidate response

#### 00:03 — CLARIFY

**00:03 — Candidate:** Okay, five questions. First, is this a fixed window limiter or a sliding window limiter? The choice changes the data structure. Second, what is the rate, say N requests per W seconds, and are those numbers configurable in the constructor or hardcoded? Third, is `timestamp` in seconds, milliseconds, or something else, and can I assume it is monotonically non-decreasing across calls for a given user? Fourth, is this running in a single process, or do I need to think about multiple processes or machines sharing state? And fifth, what is the memory budget, because if we have a million users and we keep every event forever, that matters.

**00:04 — Interviewer:** Good questions. Sliding window. Make the rate and window configurable in the constructor, go with N requests per W seconds. Timestamps are integer seconds and yes, you can assume they are non-decreasing per user. Single process for now, we will extend to distributed in the discussion. Memory, assume a few hundred thousand users at most, and you can prune aggressively.

**00:05 — Candidate:** Perfect. One more, sorry. If a user has never called before, `allow` should return `True` for the first call, right, as long as it is within the limit of one. I just want to confirm there is no warmup.

**00:05 — Interviewer:** Correct. First call for a new user is always `True` as long as one is within the limit.

**00:05 — Candidate:** Great. Then I think I have enough to sketch.

#### 00:06 — APPROACH

**00:06 — Candidate:** Two approaches I want to compare out loud before I pick one.

Approach A, fixed window counter. For each user, I keep a counter and the window start. If the current timestamp is inside the window, I increment and compare to the limit; if it is outside, I reset. Very simple, O of 1 time, O of number of users space. The tradeoff is the boundary burst problem. A user can send N requests in the last second of one window and N more in the first second of the next, effectively 2N in two seconds, which violates the intent of N per W.

Approach B, sliding window with a deque of timestamps per user. For each call, I drop timestamps older than `timestamp - W` from the front of the deque, then if the deque length is below N, I append the current timestamp and return `True`, else I return `False`. Time is amortized O of 1 per call because each timestamp gets pushed and popped once. Space is O of N per active user, worst case, with N being the rate limit, not the number of requests.

Given the interviewer said sliding window explicitly and the rate is small, I am going with B. The invariant I want to maintain is, after every call, the deque for a user contains exactly the timestamps of calls that were allowed within the last W seconds and nothing older.

**00:08 — Interviewer:** Sounds good. Go ahead.

#### 00:08 — CODE

**00:08 — Candidate:** I am going to write the class in one shot and narrate as I type.

```python
from collections import defaultdict, deque
from typing import Dict
```

*"I will use defaultdict so I do not have to check whether the user exists before pushing. Deque gives me O of 1 pops from the front, which is what makes the amortized bound work. Typing just for clarity, this is a doc not an IDE, so I will keep annotations light."*

```python
class RateLimiter:
    """Sliding-window rate limiter: at most `limit` calls per `window_seconds`."""

    def __init__(self, limit: int, window_seconds: int) -> None:
        if limit <= 0:
            raise ValueError("limit must be positive")
        if window_seconds <= 0:
            raise ValueError("window_seconds must be positive")
        self.limit = limit
        self.window = window_seconds
        self._events: Dict[str, deque] = defaultdict(deque)
```

*"Two constructor validations. I am being explicit that zero or negative values are not valid, because a limit of zero would make the class useless and a zero window would divide-by-nothing in the math sense. The underscore on `_events` signals this is internal state; users of the class should not poke at it directly."*

```python
    def allow(self, user_id: str, timestamp: int) -> bool:
        """Return True if this request is within the user's rate limit."""
        window_start = timestamp - self.window
        events = self._events[user_id]

        # Drop timestamps that fell off the back of the sliding window.
        while events and events[0] <= window_start:
            events.popleft()
```

*"I compute the window start once. Then I pull the deque for this user. The defaultdict creates an empty deque on first access, which is exactly what I want for a new user. The while loop is the amortized-O-of-1 part. Each timestamp gets popped at most once across the lifetime of the user, so even though the loop looks unbounded, the total work is bounded by the total number of events."*

*"Quick note on the comparison. I am using less-than-or-equal, not strictly less-than, because if the event is exactly `timestamp - window` old, it is no longer inside the window. That is the kind of off-by-one the interviewer will probe on, so I want to be explicit."*

```python
        if len(events) < self.limit:
            events.append(timestamp)
            return True
        return False
```

*"Now the decision. If the deque has fewer than `limit` timestamps, this request fits, I record it and allow. Otherwise I reject. I do not append on reject, which is deliberate: if I appended on every call, a user who is already over the limit would stay over forever."*

*"Let me also add a small helper for cleanup, because otherwise the dict grows unbounded as users come and go. I will mark it as optional, the core contract is just `allow`."*

```python
    def gc(self, now: int) -> int:
        """Remove users with no recent activity. Returns number of users evicted."""
        window_start = now - self.window
        stale = [uid for uid, ev in self._events.items()
                 if not ev or ev[-1] <= window_start]
        for uid in stale:
            del self._events[uid]
        return len(stale)
```

*"Garbage collection pass. I collect stale user IDs into a list first, then delete, because mutating a dict while iterating is a bug waiting to happen. A user is stale if their deque is empty or their most recent event is older than the current window. In production I would call this on a timer, maybe every minute, not on every `allow` call."*

```python
    def __repr__(self) -> str:
        return (f"RateLimiter(limit={self.limit}, "
                f"window={self.window}s, users={len(self._events)})")
```

*"Dunder repr is cheap insurance during debugging. If somebody prints the object in a notebook or a log, they see the configuration and the user count immediately instead of a memory address."*

**00:26 — Candidate:** That is the class. Let me pause on the complexity before I run examples. Time per `allow` call is amortized O of 1, worst case O of N where N is the limit. Space per active user is O of N. Total space is O of U times N where U is the number of active users. That matches what I promised at the start.

#### 00:28 — DRY-RUN

**00:28 — Candidate:** I am going to walk through two cases by hand. Assume `RateLimiter(limit=3, window_seconds=10)`.

**Case 1, first request for a new user.**

```
allow("alice", 100)
  window_start = 90
  events = deque([])   # new user, defaultdict created empty deque
  while loop: events is empty, skip
  len(events) = 0 < 3, so append 100 and return True
  events is now deque([100])
```

*"First call for a new user. The defaultdict gives me the empty deque, the while loop is a no-op because there is nothing to pop, the length check passes, I append and return True. Matches the expected behavior I confirmed with the interviewer."*

**Case 2, steady-state with window sliding.**

```
allow("bob", 100) -> True,  events = [100]
allow("bob", 102) -> True,  events = [100, 102]
allow("bob", 103) -> True,  events = [100, 102, 103]
allow("bob", 105) -> False, events unchanged, 3 >= limit
allow("bob", 111) -> True,  100 falls out (100 <= 111 - 10),
                            events = [102, 103, 111]
```

*"This is the case I care about. Bob fires three requests in quick succession and fills his bucket. His fourth call at timestamp 105 is rejected because the deque already has three entries and none of them have aged out yet. At timestamp 111, the window start is 101, so the event at 100 falls off the front, the deque drops to two, and the new request is allowed. That is the sliding behavior working correctly, and critically, Bob never got 2N in 2W because the oldest event has to actually leave the window before a new one can enter."*

**00:32 — Interviewer:** Nice, I like that you walked through the sliding case explicitly. Let me poke at one thing. What if two calls come in with the exact same timestamp?

**00:32 — Candidate:** Good catch. They both go through the same logic independently. The first one sees a deque of length K and either allows or rejects. If allowed, it appends. The second one sees a deque of length K plus one, or K if the first was rejected. So same-timestamp calls are serialized by the order of the calls themselves, not by the timestamp. In a single-threaded model that is fine. In a multi-threaded model I would need a lock around the critical section, which is a good segue to the distributed question.

#### 00:33 — DISCUSS

**00:33 — Candidate:** Let me surface five production concerns I would want to talk through before shipping this.

One, memory cleanup. The `gc` method is good but not enough. In a real service I would run it on a ticker, and I would also cap the maximum number of users in memory, evicting the oldest by last-seen timestamp if I hit the cap. That turns a potential memory leak into a bounded LRU.

Two, distributed rate limiting. A single-process deque does not work across replicas behind a load balancer. I would move state to Redis, either with a sorted set per user where the score is the timestamp, or with a Lua script that does the window-prune-and-check atomically. The tradeoff is a network round trip per `allow`, which blows up latency if you are doing this inline on every request. A common pattern is a local in-memory limiter with a lenient bound, plus a Redis-backed global limiter with the strict bound, so you catch most of the traffic locally and only pay the network cost in the rare case.

Three, clock skew. If the timestamp comes from the client, a malicious or misconfigured client can game the system by sending timestamps far in the past or far in the future. I would take the timestamp server-side, typically from the gateway, and reject client-supplied timestamps entirely. If clocks across replicas drift, use a monotonic time source on a single clock authority or an NTP-synced cluster.

Four, token bucket variant. The sliding window is fair but it does not allow bursts. Some APIs want to let users burst up to the limit and then refill smoothly. Token bucket gives you that with a capacity and a refill rate. The class shape is almost identical, the only difference is the data is two numbers per user, tokens and last refill, instead of a deque. I would expose both as strategies behind a common interface if the product wanted both behaviors.

Five, per-endpoint versus per-user. Real APIs rate-limit on a tuple of `(user_id, endpoint)` or `(api_key, tier)` rather than on user alone, because a cheap endpoint and an expensive endpoint deserve different limits. The fix is the key becomes a composite and the constructor takes a map of endpoint to limit. The deque structure does not change.

**00:37 — Interviewer:** Good list. If you had to pick one of those to actually implement right now in the remaining time, which would you pick and why?

**00:37 — Candidate:** I would pick the distributed version in Redis, because it is the one that actually determines whether this class is usable in production. Memory cleanup and token bucket are refinements; distributed correctness is a go or no-go. The sketch would be a Lua script that takes `user_id`, `timestamp`, `limit`, `window`, does a `ZREMRANGEBYSCORE` to drop old entries, then a `ZCARD` to count, then either a `ZADD` and return 1 or return 0. That gives me atomicity without a separate lock. I would also add a TTL on the key equal to the window so orphaned keys expire automatically, which is the Redis equivalent of the `gc` method I wrote above.

**00:39 — Interviewer:** Great, that is what I wanted to hear. We are at time. Thanks, Kaustabh.

**00:40 — Candidate:** Thanks for the round. Quick question back, is the distributed variant the kind of follow-up you usually see candidates miss, or is it more the dry-run part? Just calibrating.

### Post-round self-eval

- **What went well.** The clarifying block at 0:03 had five questions, not three, and they covered data structure choice, configurability, timestamp semantics, concurrency, and memory. That set up every tradeoff later in the round.
- **Filler phrase to watch.** "Perfect" and "Great" appeared three times in the first 6 minutes. One is fine, three sounds like a verbal tic. Replace with a brief pause and the next sentence.
- **Narration line to copy.** "The invariant I want to maintain is, after every call, the deque for a user contains exactly the timestamps of calls that were allowed within the last W seconds and nothing older." That single sentence is worth more than any line of code, because it is the thing a reviewer reads to decide whether you understand the problem. Say something like it in every coding round.
- **Tradeoff surfaced.** The fixed-window-vs-sliding-window comparison at 0:06, and the boundary burst example, is the kind of specificity that separates a pass from a strong-pass. Keep that habit.
- **Time budget.** 20 minutes coding, 5 dry-run, 7 discussion is a healthy split. If coding eats into dry-run time, the follow-up probes suffer. Protect the last 10 minutes.

---

## Walkthrough 2 — RRK Round (60 min): Enterprise RAG for an Indian bank

### Round setup

**00:00 — Interviewer:** Hi Kaustabh, I am Priya, senior FDE on the Gemini team here at Google. I work with large enterprise customers, mostly in APAC, to take GenAI prototypes into production on Vertex. This round is 60 minutes. I will give you a customer scenario and we will talk through how you would approach it. Before that, take two minutes and tell me about yourself and the most interesting thing you have shipped.

**00:01 — Candidate:** Thanks Priya. Kaustabh Ganguly, five and a half years in AI and ML, senior ML engineer at Gracenote where I own the agentic metadata pipeline. The thing I shipped most recently that I am proud of is the Sonnet to Haiku migration on a ten-K-request-per-day production workflow. I used DSPy with MIPROv2 and GEPA to compile the prompts on the smaller model and gated the cutover on a DeepEval regression suite; quality held within a point, p95 latency dropped fifty percent, cost per request fell threefold. Before Gracenote I spent two years embedded with J&J MedTech through TCS, on their Contract Commitment Portal, building an analyst decision-support model for contract approvals. LightGBM, isotonic-calibrated, AUROC point-nine-five on a temporal holdout; cleared legal, security, and their CAB review; now the default decision path on the portal. On the side I publish two npm MCP servers, `@stabgan/openrouter-mcp-multimodal` and `@stabgan/steelmind-mcp`, and I forked Karpathy's AutoResearch and wired it to kiro-cli plus a Firecrawl MCP for a hypothesis-first research loop. I used that loop to drive an EmbeddingGemma 300M fine-tune, four-directional GTE-style loss with Matryoshka truncation; got twelve points of accuracy at one and at five on a temporal holdout. What I like about this work is the messy-problem-to-shipped-system translation, which is the FDE loop. That is why this role.

**00:02 — Interviewer:** Great intro. Let us dive in.

### Main prompt

**00:03 — Interviewer:** Here is the scenario. A large Indian bank wants to build an internal assistant that their relationship managers and compliance officers can query over internal policy documents, regulatory filings, and customer correspondence. They have already tried a vendor tool. It hallucinated citations. Walk me through how you would approach this.

### Candidate response

#### 00:03 — DISCOVERY

**00:03 — Candidate:** Let me not start with an architecture diagram. The vendor hallucinated citations, which tells me this project will be judged on correctness and trust, not on model capability. Before I propose anything I want to pin down ten things.

**00:04 — Candidate:** First, regulatory posture. Is the bank regulated by the RBI, and does the RBI data localisation circular apply to the document corpus in scope? That determines where compute and storage can live.

**00:04 — Interviewer:** RBI regulated. All data must stay in India. Mumbai region, no cross-border egress including model calls.

**00:04 — Candidate:** Second, user scale and concurrency. How many relationship managers and compliance officers, and what is the expected queries per user per day?

**00:04 — Interviewer:** About 5000 users total. Assume 20 queries per user per day at peak.

**00:04 — Candidate:** Third, document corpus. Rough size in gigabytes, how many documents, and how often do they change? Is there a mix of structured and unstructured?

**00:05 — Interviewer:** Roughly 2 million documents, 300 GB. Policy docs update monthly, regulatory filings quarterly, customer correspondence streams in daily. Structured data lives in a Teradata warehouse they are migrating to BigQuery over the next year.

**00:05 — Candidate:** Fourth, language. Pure English, or Hinglish and Hindi as well?

**00:05 — Interviewer:** Policies are English. Customer correspondence is English and Hindi, some Hinglish. Retrieval needs to handle both.

**00:05 — Candidate:** Fifth, latency SLA. What is acceptable from question submitted to answer rendered?

**00:05 — Interviewer:** Under 10 seconds p95 for a typical query. Under 20 for long-context compliance queries.

**00:06 — Candidate:** Sixth, access control. Does every document have ACLs, and do those ACLs need to be enforced at retrieval time?

**00:06 — Interviewer:** Yes. Every document has a business-unit tag and a clearance level. A retail RM must never see corporate banking policies they are not cleared for. ACLs are in an internal AD group store.

**00:06 — Candidate:** Seventh, PII posture. I am assuming customer correspondence has PAN numbers, Aadhaar, account numbers. Is PII allowed to transit to the model, or do we need to redact first?

**00:07 — Interviewer:** PII cannot leave the bank perimeter at all. Redaction before retrieval or generation is mandatory.

**00:07 — Candidate:** Eighth, citations. You mentioned the vendor hallucinated citations. What does a correct citation look like for this bank, document ID plus page, or something finer?

**00:07 — Interviewer:** Document ID, section heading, and a quoted span the RM can click to open the source PDF at the right page. Anything less is not usable.

**00:07 — Candidate:** Ninth, evaluation buy-in. Is there a team of SMEs, compliance officers probably, who can label a few hundred question-answer pairs for a golden set, or do I need to bootstrap?

**00:08 — Interviewer:** They have committed 4 compliance officers for 3 weeks. You get them.

**00:08 — Candidate:** Tenth, success criteria for the pilot. What does a go decision at the end of the pilot look like, numerically?

**00:08 — Interviewer:** Faithfulness over 95 percent on the golden set, citation correctness over 98 percent, zero hallucinated regulatory citations in red-team, and user-reported usefulness above 4 on a 5-point scale.

**00:08 — Candidate:** Perfect, I have enough. Those four numbers become the north star for everything I am about to describe.

#### 00:09 — PROBLEM RESTATEMENT AND SUCCESS METRIC

**00:09 — Candidate:** Let me play the problem back in one paragraph. The bank needs an internal Q and A assistant over a heterogeneous corpus of policies, regulatory filings, and customer correspondence, bilingual English and Hindi, serving 5000 users with roughly 100K queries a day, inside a Mumbai-region RBI data boundary, with strict ACL enforcement and PII redaction, returning answers with clickable section-level citations. The acceptance bar is 95 percent faithfulness, 98 percent citation correctness, zero hallucinated regulatory citations, and 4 out of 5 user usefulness on a 20-user pilot over 3 weeks.

The three dimensions I will evaluate on are, one, faithfulness, defined as every claim in the answer supported by a retrieved passage, measured with an LLM-as-judge calibrated against human ratings. Two, citation correctness, defined as the cited span actually contains the claim it is cited for. Three, coverage, defined as the fraction of questions for which the retriever surfaces at least one genuinely relevant passage in the top K.

The one failure mode I consider unacceptable is a hallucinated regulatory citation, because a fabricated RBI circular number can cause a compliance officer to file the wrong disclosure. That failure is a P0 and blocks the rollout regardless of any other metric.

**00:12 — Interviewer:** Good framing. Keep going.

#### 00:15 — ARCHITECTURE: data layer

**00:15 — Candidate:** Walking from the data layer outward. Three inbound connectors to start. A SharePoint connector for the policy library, with an incremental sync driven by SharePoint change tokens so we pull only deltas. A filesystem-plus-metadata connector for the regulatory filings drop zone, where the bank drops PDFs from the RBI portal. And a BigQuery connector for the customer correspondence that is already landed into their warehouse. All three connectors preserve the source ACLs as metadata on every row they emit, because if ACLs are bolted on later they will be wrong.

Ingestion runs on Cloud Run jobs triggered by Cloud Scheduler for the periodic sources and by Pub Sub for the streaming correspondence. Each document goes through a pipeline. Step one is PII redaction using a deterministic PII detector for PAN, Aadhaar, IFSC, account numbers, augmented with a small model for free-text PII. Step two is layout-aware parsing, Document AI for PDFs because tables and signature blocks matter. Step three is chunking. I would not use a naive 500-token rolling window because a bank policy has section-level semantics that a flat window destroys. Table-aware semantic chunking, where tables stay whole up to a size bound, and prose is split at section boundaries with a 100-token overlap.

On embeddings, the interesting call. The default would be Gemini text embeddings, which are strong and native to the platform. The case for a fine-tuned EmbeddingGemma 300M is that bank policy language is domain-specific, and in my own work I fine-tuned EmbeddingGemma on a small domain corpus with Matryoshka truncation preserved and got about twelve points of accuracy lift over the stock model on a retrieval benchmark. For this engagement I would start with Gemini embeddings on Vertex AI, measure coverage against the compliance officers' golden set, and only fine-tune an EmbeddingGemma variant if the stock model is more than five points off the target. The reason is engagement velocity, not capability. A fine-tune adds three weeks; if we do not need them, we do not spend them.

Vector storage in Vertex AI Vector Search, single-region Mumbai, with CMEK on the underlying storage. Refresh cadence is, daily incremental for correspondence, weekly for policy, monthly for regulatory filings, with a manual override for urgent RBI circulars.

#### 00:22 — ARCHITECTURE: retrieval layer

**00:22 — Candidate:** Retrieval is where the vendor probably fell over. A pure dense retriever on a bilingual, heavily abbreviated corpus misses on acronyms, circular numbers, and product codes. I would run hybrid retrieval from day one. Dense via Vector Search for semantic recall. Sparse via BM25 over an ElasticSearch index on the same chunks for exact-match recall, so a query that mentions RBI circular DBR. No. BP. BC. 45 lands on the right chunk even if the embedding glosses over the punctuation.

Before retrieval fires, a metadata filter is applied based on the caller's identity. The user's OAuth token is exchanged for their AD group membership at the API boundary, and that membership is turned into a filter expression on document business unit and clearance level. A retail RM simply never sees corporate-banking chunks in their candidate set. That is non-negotiable for RBI.

After hybrid retrieval I get 50 candidates. A reranker model, Gemini-based, scores each candidate against the query and I keep the top 8. Reranking is where I recover the precision that BM25-plus-dense loses in the fusion step. Throughout, I propagate not just the chunk text but the chunk's provenance, document ID, section heading, page, and the offset of the span within the page. That provenance is what the generation layer will cite, and crucially, the generator will be prompted to cite only from that provenance set, not from memory.

**00:26 — Interviewer:** Quick question. What about when the user asks a vague or multi-part question? How do you handle that in the retrieval layer?

**00:26 — Candidate:** Good pushback. Two things. First, a lightweight query decomposer as a preprocessing step for any query that the router classifies as multi-intent, run a small Gemini Flash-Lite call that splits the query into two to three sub-queries, retrieves for each, and unions the candidate sets. Second, for vague queries with low retrieval confidence, defined as top-1 reranker score below a threshold calibrated on the golden set, the system refuses to answer and instead returns a clarifying question to the user. That is how we avoid the most common path to hallucination, which is trying to answer a question that the corpus does not support.

#### 00:28 — ARCHITECTURE: generation layer

**00:28 — Candidate:** Generation. The default model is Gemini 2.5 Flash on Vertex, Mumbai endpoint. Flash is fast enough to hit the 10-second p95 with room for retrieval, and its grounded-generation quality on short contexts is strong. For compliance-tagged queries, classified by an upstream router, I would escalate to Gemini 2.5 Pro because the cost of a wrong answer in compliance is much higher than the cost of an extra second of latency. I would also escalate when the retrieved context exceeds a length threshold where Pro's longer attention budget helps.

The prompt has four blocks. A system block with the bank's persona, refusal rules, and the exact citation format. A context block with the top-8 reranked chunks, each tagged with its provenance. A user block with the query, rewritten by the decomposer if needed. And a structured-output block asking for a JSON with `answer`, `citations` as a list of provenance objects, and `confidence` as one of low, medium, high.

Grounded generation is enforced at three layers. The prompt tells the model to cite only from the provided chunks. The structured output forces every citation to be a provenance object that the API will validate against the provenance set of the request; any citation that does not match a real chunk is rejected and the request is retried with a reminder. And post-generation, a citation-verification pass, essentially a faithfulness check, confirms that the quoted span in each citation is actually present in the source chunk. If any citation fails verification, the answer is blocked and the user sees an "I could not find a confident answer" message instead of a wrong one.

That three-layer belt-and-braces approach is exactly the pattern I used at Gracenote to drive DeepEval faithfulness regressions to zero in CI.

#### 00:33 — SECURITY

**00:33 — Candidate:** Security posture. Everything lives inside a VPC-SC perimeter around the Mumbai project. BigQuery, Vector Search, Cloud Storage for the document lake, Vertex AI endpoints, all members of the same service perimeter. Egress to the public internet is denied. That is the RBI data-residency story, and VPC-SC is how I make it enforceable at the platform layer, not at the application layer where a misconfigured SDK call could leak.

The front door is a Cloud Run service fronted by IAP, Identity-Aware Proxy, which does the Google OAuth 2.0 handshake against the bank's workforce identity provider. IAP issues a signed header with the user identity that the service trusts. At the service I exchange that identity for the user's AD group membership via a cached lookup and attach it as the metadata filter for retrieval. No user token is ever forwarded to an external system because there is no external system, everything is Vertex-native.

Secrets, and there are very few, live in Secret Manager with automatic rotation. CMEK on Cloud Storage and BigQuery using keys the bank controls in Cloud KMS, so the cryptographic root of trust stays with them. Every query and every citation set is written to an audit log in BigQuery with the user ID, timestamp, query, retrieved chunks, and final answer, because compliance will want to be able to reconstruct any interaction for a regulator.

This is not a new security spine for me. The J&J MedTech CCP work ran under a regulated medical-device governance model, legal, security, and CAB review on every release, with classical-ML auditability rather than agent traces. The shape is different from RAG, but the discipline of "every production decision has an auditable provenance and a written go-no-go" carries over, and the Data Sentry work gave me the OAuth-and-enterprise-identity half in production. The RBI variant mostly changes the perimeter vocabulary and the residency constraint.

#### 00:39 — EVALUATION AND OBSERVABILITY

**00:39 — Candidate:** Four eval layers, bottom to top.

Layer one, unit evals on components. The chunker has a property-based test that says, for any input document, concatenating the chunks in order reproduces the original text minus whitespace. The PII redactor has a fixture corpus and a recall-and-precision target per PII type. The reranker has a pairwise-preference test against a small labeled set. These run on every PR.

Layer two, a golden set of 500 question-answer pairs curated by the 4 compliance officers over the first 3 weeks. Each example has a question, an ideal answer, and the set of source chunks that should appear in the retrieved context. I run two metrics against this set on every model or prompt change. Coverage, did any of the expected chunks appear in top-8. And faithfulness-plus-citation, an LLM-as-judge using Gemini 2.5 Pro with a tight rubric, calibrated quarterly against a 50-example human sample to keep the judge honest. This is DSPy-plus-DeepEval territory, the same harness I ran at Gracenote.

Layer three, online evals. Every production response is scored on a cheap proxy faithfulness check using Flash-Lite, logged, and sampled at 1 percent for heavy LLM-as-judge. A dashboard in Looker shows faithfulness, coverage, citation correctness, and refusal rate, broken down by business unit and query category, because an aggregate number will hide the one business unit where the system is quietly failing.

Layer four, red-team. A small internal team plus an external consultancy run adversarial queries weekly, targeting the known failure modes, hallucinated regulatory citations, cross-ACL leakage, PII in the output, Hindi-English mixed queries that confuse the router. Every red-team finding becomes a regression test in layer two. That is how the test set grows.

Observability. OpenTelemetry traces from the Cloud Run service through the retrievers to the model, shipped to Cloud Trace. Latency budgets per span so a slow reranker call shows up as a red span instead of a generic "slow query". Logs to Cloud Logging with structured fields matching the trace IDs, because you will be debugging cross-cutting issues on day two of the pilot and correlating traces and logs saves hours.

#### 00:44 — ROLLOUT

**00:44 — Candidate:** Three-week pilot, 20 users from the compliance team only. Week one is shadow mode. Users keep doing their normal work, the assistant runs in the background against a scraped stream of their queries, and we show the 4 compliance officers the outputs in a review UI. They rate them. We get a read on faithfulness and usefulness without any risk of a bad answer going to a real decision.

Week two is canary at 10 percent of real traffic for those 20 users. They see the assistant's answer alongside their own work. They can click a thumbs-up or thumbs-down and leave a one-line reason. We review ratings daily and hold a weekly decision meeting where the rollback criteria are pre-agreed. The rollback criteria are, faithfulness drops below 92 percent sustained over two days, any single hallucinated regulatory citation, p95 latency over 15 seconds for two consecutive days, or user-reported usefulness below 3.5.

Week three is the full cohort of 20 users on 100 percent. At the end of week three we have a go or no-go against the four success metrics the bank set up front.

Only after a successful pilot do we expand, and even then in waves. Corporate banking first because their document corpus is closest to policy in shape, then retail, then cross-business-unit queries. Each wave has its own go or no-go gate.

#### 00:48 — COST

**00:48 — Candidate:** Honest token math. 5000 users times 20 queries per day is 100K queries per day. Average context is about 3K tokens, retrieval plus system prompt plus history. Average output is about 500 tokens. So per day, 350M tokens, of which about 300M are input and 50M output. If the default is Gemini 2.5 Flash, published public pricing is in the low-single-digit dollars per million input tokens and roughly 4 to 5x that for output, so order of magnitude you are looking at four-figure dollars per day, low-five-figure per month in generation alone. Retrieval and embedding are negligible by comparison, maybe 5 to 10 percent of generation.

The escalation to Pro for compliance queries, which I estimate at 10 to 15 percent of traffic, roughly triples the per-query cost for that slice, so call it a 30 to 40 percent cost uplift on the blended average. I would present the bank with two numbers, the Flash-only baseline and the Flash-plus-Pro target, and let them choose given the per-business-unit risk posture.

The template for this cost conversation is my Gracenote migration. We moved a Claude Sonnet stack to Haiku with DSPy-compiled prompts and shrunk serving cost roughly threefold while preserving quality. The same discipline applies here, prompt compression via DSPy-style bootstrapping, dynamic routing between Flash and Pro, aggressive caching of embeddings, and reranker pruning of the candidate set before the expensive generation call. I would expect to land 30 to 50 percent under the naive baseline within the first month of production operation.

#### 00:52 — RISKS AND MITIGATIONS

**00:52 — Candidate:** Five risks, each with a concrete mitigation.

One, hallucinated regulatory citations. Mitigation, the three-layer grounded-generation guard I described, plus weekly red-team specifically for fabricated circular numbers, plus a hard-coded block-list check against a canonical RBI circular registry. If a citation number does not match the registry, the answer is refused.

Two, ACL leakage across business units. Mitigation, filter-at-retrieval not filter-at-display, because a user can copy-paste what they see; never show them a chunk they should not have retrieved. Plus a nightly audit job that replays 1 percent of queries as a dummy user from each business unit and asserts that no forbidden chunks were returned.

Three, Hindi-English code mixing degrading retrieval. Mitigation, evaluate bilingual coverage on the golden set from day one, and be ready to fine-tune EmbeddingGemma 300M on a small bilingual bank corpus if coverage is more than five points off target. I have run that exact fine-tune loop before and it is about a week of work.

Four, cost overrun as usage scales past the pilot. Mitigation, per-user daily token budget enforced at the gateway, with a grace buffer for compliance queries; cost dashboards per business unit so the finance team sees the bill split the way they pay for it; quarterly re-benchmark of Flash versus Pro versus any new Gemini model to ensure we are on the cost-quality frontier.

Five, vendor lock-in concerns from the bank's side. Mitigation, keep the retrieval stack portable. Chunker, embedder, vector store, reranker, and prompt templates live in a service layer the bank owns, so if they ever want to swap Vertex for an on-premise alternative the migration is mechanical, not architectural. I would not build against proprietary Vertex features unless the productivity gain is obviously worth it.

#### 00:55 — REUSABLE ASSETS

**00:55 — Candidate:** Three things I would deliberately capture from this engagement as reusable assets for the next bank.

One, a bank-connector template. The SharePoint-plus-Document-AI-plus-ACL-preservation pipeline is going to be 80 percent of the work for every Indian financial services customer. If I package it as a Cloud Run jobs module with pluggable source types, the next bank engagement starts at week two instead of week five.

Two, an eval harness preset. The four-layer eval, the golden-set format, the LLM-as-judge calibration protocol, and the dashboards. I would publish this as a Vertex-compatible eval pipeline template, similar in spirit to the DeepEval-plus-DSPy setup I ran at Gracenote, with domain-specific rubrics for finance, healthcare, and retail slotting in as plug-ins.

Three, an OAuth-plus-VPC-SC Terraform module. The identity propagation, IAP, service perimeter, and CMEK wiring are genuinely fiddly and I would hate to make another team redo them. I have built the OAuth side of this as my Data Sentry MCP server; combining that with a Terraform module for the VPC-SC side gives me a one-line-provision security posture that is RBI-defensible out of the box.

#### 00:58 — PRODUCT FEEDBACK TO GOOGLE

**00:58 — Candidate:** Two specific gaps I would write up as feature requests, if I were on the FDE team delivering this.

One, on Vertex RAG Engine. The built-in citation correctness evaluator is not easily composable with a custom chunker or a bespoke citation format like the section-plus-span one this bank requires. I ended up rolling my own verification layer. It would be useful if RAG Engine let me inject a citation schema and get the built-in eval to respect it, or exposed the verification step as a callable so I could feed it my own chunks.

Two, on Agent Engine memory. The memory-bank feature is great for conversational state, but for a regulated customer with data-residency constraints I need an explicit guarantee that memory storage and retrieval happen inside the same regional perimeter as the rest of the workload. If that is already the case it is not well documented; if it is not, a regional memory bank variant is a blocker for Indian banking customers.

I would turn both into one-page write-ups, attach the customer evidence, and route them through the FDE product feedback channel. That is the kind of signal that I have seen, from the outside, make its way into the public roadmap, and it is one of the reasons the FDE role is interesting to me specifically.

#### 01:00 — CLOSE

**00:58 — Interviewer:** We have about two minutes left. What would you ask me?

**00:58 — Candidate:** Two questions. First, from your experience on the Gemini FDE team, what is the most common place you see customer engagements get stuck between prototype and production? I am trying to calibrate whether the pattern I see most often, which is eval infrastructure not being there when the pilot ends, is the same pattern you see.

**00:59 — Interviewer:** (answers, roughly 45 seconds about observability-and-eval gaps being the most common stall point)

**00:59 — Candidate:** Second, how does the FDE team feed product gaps like the two I just mentioned back to the Agent Engine and Vertex AI roadmap teams? Is there a formal channel, or is it more relationship-driven? I am asking because my instinct would be to invest time in whichever channel actually moves, and it would help me plan how to spend that time from day one.

**01:00 — Interviewer:** (answers briefly) We are at time. Thanks Kaustabh, this was a good conversation.

**01:00 — Candidate:** Thank you, Priya.

### Post-round self-eval

- **Narration density.** Roughly one sentence every 10 to 12 seconds throughout. A few stretches in the architecture beats ran a bit dense; breaking those with a one-word pause like "okay" or an explicit "moving on to retrieval" helps the interviewer track the section change.
- **Clarification-first.** Ten questions at 0:03, not a single architectural word before 0:09. That is the correct posture and it is the single biggest thing that separates an L5 from an L4 signal on this round.
- **Tradeoff surfaced.** At least four explicit tradeoffs called out: fixed versus sliding retrieval freshness, Gemini embeddings versus fine-tuned EmbeddingGemma, Flash versus Pro escalation, portability versus platform-native features. Keep the word "tradeoff" in circulation; panels listen for it.
- **FDE close used.** Reusable assets at 0:55, product feedback at 0:58, two questions back at 1:00. All three beats landed, which is the difference between an engineer who answered the question and an FDE who showed up.
- **Evidence tied.** Gracenote surfaced at opener, 0:28, 0:39, 0:48. J&J at 0:33. EmbeddingGemma at 0:15 and 0:52. Data Sentry at 0:33 and 0:55. MCP servers at opener and 0:55. AutoResearch and kiro-cli at opener. 1500-partner catalog did not come up naturally and that is fine; do not force an evidence hit if the beat does not want it.
- **Filler words.** "Perfect" appeared twice and "okay" three times. One "perfect" is charming, two is a tic. Swap one for silence.
- **Energy management.** The 30-minute mark, during security, is the known energy dip. Breathing twice and standing up briefly before that section helps. In a real round, a sip of water at 0:28 or 0:33 also resets.
- **Time discipline.** The architecture block ran just over target at 19 minutes combined against a 13-minute budget, which squeezed cost and risks. Next rehearsal, compress architecture by 3 minutes by pre-committing the embedding choice instead of debating it out loud.

---

## How to rehearse this file

**May 3.** Read Walkthrough 1 aloud once, slowly. Do not try to match pacing yet, just get the words in your mouth. Mark any sentence that feels awkward; rewrite it in your own voice in the margin.

**May 4.** Read Walkthrough 2 aloud once, slowly. Same treatment.

**May 5.** Read Walkthrough 1 aloud while timing yourself against the section timestamps. Record the audio. Play it back at 1.5x and listen only for narration density. Note the gaps.

**May 6.** Same drill with Walkthrough 2. The RRK is the higher-leverage round; budget an extra 30 minutes for the playback review.

**May 7.** Close the file. From memory, deliver Walkthrough 1 on a fresh prompt (rate limiter variant, token bucket). Record. Compare to the transcript afterward.

**May 8.** From memory, deliver Walkthrough 2 on a fresh prompt (insurance, not banking). Record. Compare.

**May 9.** Rest day on narration. Read the tradeoff catalogues in `02_RRK_MASTER_GUIDE.md` and `07_SYSTEM_DESIGN.md` out loud instead.

**May 10.** Full mock: 60-minute RRK on a cold prompt, 40-minute coding on a cold prompt, back to back. Record both. Review only the weakest 10-minute span.

**May 11.** Targeted re-rehearsal of whatever the May 10 review flagged. Read the relevant section of this file aloud twice.

**May 12.** Light touch. Read the openers and the closes out loud once. Early night.

## Red flags during mock recordings

- **Mumbled sections.** If you cannot hear yourself clearly on playback, the interviewer cannot either. Re-record that section standing up.
- **Skipped clarification.** If the first architectural word is before minute 3 of an RRK or before minute 2 of a coding round, you rushed. Reset and restart the clarification block.
- **Skipped tradeoff.** If a 10-minute stretch passes without you saying "the tradeoff is" or an equivalent, you sound like an implementer, not an architect. Revisit.
- **Missed FDE close.** If reusable assets, product feedback, and two questions back are not all present in the final 10 minutes of an RRK, you left the most differentiated signal unspoken. Non-negotiable on May 13.
- **Going over time on one beat.** Architecture, specifically, tends to eat 25 minutes if you let it. Hold to the 13-minute budget for the combined data-retrieval-generation block, even if you have to say "I will come back to this in the risks section".

## Two more prompts to self-rehearse after mastering these two

1. **Coding-adjacent debugging prompt.** "A production agent has been giving wrong answers for the last 3 hours. Walk me through what you do in the first 30 minutes." The shape is similar to the rate-limiter round but the "code" is a diagnostic plan, not a class. Practise narrating the observability tree, trace-first, log-second, eval-replay-third, without typing anything for the first 10 minutes.

2. **RRK system design prompt.** "Design a multi-tenant GenAI platform that hosts custom agents for each of our enterprise customers, with shared model capacity but isolated data." Use the same 15-beat structure. The interesting new beats are tenant isolation in the data layer, noisy-neighbour behaviour in the generation layer, and per-tenant eval dashboards. Record, compare against Walkthrough 2, and notice which beats transfer unchanged and which need rebuilding.
