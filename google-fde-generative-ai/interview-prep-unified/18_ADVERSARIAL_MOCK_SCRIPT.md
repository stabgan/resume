# 18 — Adversarial Mock Script

## Why this file exists

The AI-agent review flagged that solo mocks lack interruption pressure. Real Google interviewers don't sit quietly while you deliver a polished answer — they interrupt with "why not simpler?", "what if the data is sensitive?", "how do you know this actually worked?". If your rehearsal is monologue-only, your interview feels like an ambush.

This file gives you **30 interruption prompts** organized by where they land in an RRK answer and **15 "gotcha" challenges** for coding rounds. Use them to script adversarial pressure into your solo mocks. Two ways:

1. **Self-play:** during a mock, pick 5 interruption prompts from this file in advance. Set a timer to randomly interrupt your answer at the 2-minute, 5-minute, and 12-minute marks. Read the prompt out loud, then respond as the candidate.
2. **Pair with a friend:** hand this file to a non-technical friend, tell them to pick 5-6 prompts from Sections A/B/C at random timestamps, read them at you mid-answer.

Either way, the goal is to make you **recover mid-thought**, not to deliver scripted answers.

---

## Section A — RRK interruption prompts (30 total, organized by answer stage)

### Stage 1: During discovery (first 3 minutes) — "why are you asking that?"

**Prompt A1.** *"I don't have time for ten questions. Just tell me how you'd architect this."*

How to recover: "Sure. I'll propose an MVP now, but I want to flag three assumptions I'm making so we can course-correct. First, I'm assuming [X]. Second, [Y]. Third, [Z]. If any of those are wrong, the architecture shifts."

**Prompt A2.** *"Why do you care about regulatory constraints here? Isn't that something legal handles?"*

Recovery: "Because regulatory is the first thing that kills a GenAI project in a regulated industry, and it's the hardest to retrofit. If data can't leave a region, the architecture changes fundamentally. I'd rather know that in minute three than in month three."

**Prompt A3.** *"You're over-thinking this. We just need a Gemini call with a system prompt. Why complicate it?"*

Recovery: "Totally fair for a prototype. For production, three things change: we need observability so a bad answer in minute one doesn't go unseen, we need a rollback path, and we need eval coverage so we can ship improvements without regressing. Happy to start with the single call and layer those on, if that's the preferred ramp."

### Stage 2: During architecture (minutes 3-10) — "is that the right choice?"

**Prompt A4.** *"Why not simpler? Why an agent and not a single LLM call with tool use?"*

Recovery: "Most problems framed as 'agentic' are actually workflow problems. If the interviewer told me the tools are fixed and the order is fixed, I'd use LangGraph with function calling, not an agent loop. Agents earn their cost when the path genuinely branches on tool output. I default to workflow unless there's evidence I need autonomy."

**Prompt A5.** *"You said Vertex AI RAG Engine. Have you shipped with it?"*

Recovery: "No. I've shipped production RAG on LangGraph with custom retrieval at Gracenote, including four-directional GTE loss fine-tuning on EmbeddingGemma. RAG Engine is the pattern I'd reach for on Google Cloud because of the managed governance, but if the evaluation of the built-in citation correctness doesn't match our custom format, I'd swap in my own verification layer. I prefer to honestly map my pattern to Google's managed offering than overclaim experience."

**Prompt A6.** *"What if the customer refuses to migrate to GCP?"*

Recovery: "Honest answer, this happens. My fallback: run the agent on a Cloud Run container inside their existing cloud via Workload Identity Federation, keep the model call on Vertex but route through their network, and deploy the eval harness on whatever orchestration they already use. The customer doesn't have to leave their cloud; we meet them at the network boundary. The tradeoff is we lose some Agent Engine governance features, but we can layer them manually."

**Prompt A7.** *"Why Gemini 2.5 Flash? Gemini 2.5 Pro is stronger."*

Recovery: "Correct, and I'd use Pro for the hardest 10-15% of queries via a classifier gate. For most traffic, Flash is fast enough to hit the latency SLA, and quality matches Pro within 2 points on a typical customer golden set. The cost difference at 100K queries per day is the difference between shipping the pilot and having the CFO veto it."

**Prompt A8.** *"You mentioned OAuth. Walk me through the flow in 45 seconds."*

Recovery: (memorized from Q5.1 in 12_RAPID_FIRE_QA.md) "OAuth 2.0 with PKCE: client generates code verifier and challenge, sends challenge to authorize endpoint, user authenticates, client exchanges code plus verifier for access and refresh tokens. PKCE removes the need for a client secret on public clients and prevents code interception."

**Prompt A9.** *"What's the difference between MCP and A2A, in one breath?"*

Recovery: "MCP connects agents to tools and data. A2A connects agents to other agents. MCP standardizes the tool surface, A2A standardizes the agent surface. I ship two MCP servers on npm, so MCP isn't theory for me."

**Prompt A10.** *"Let me stop you. That's the standard pattern. What would you do that's not standard?"*

Recovery: "Fair question. Two things I'd do differently from a typical blueprint. First, I'd start with an eval harness on day one, not day thirty — most RAG projects I've seen fail because evals come last. Second, I'd treat the retrieval layer and the generation layer as separable bets, evaluated independently, so regressions can be attributed cleanly. Those aren't novel, but they're skipped often enough to count as differentiation."

**Prompt A11.** *"Why not just use Agent Engine for everything?"*

Recovery: "For a greenfield Google-native customer, I would. For a customer with existing investment elsewhere — say, a K8s-heavy SRE team — forcing them onto Agent Engine creates political resistance that tanks adoption. I'd host the agent on GKE, use Vertex for model calls, and bring Agent Engine in for specific features like memory bank when the customer asks. Path of least resistance first, governance earned later."

### Stage 3: During security / evaluation (minutes 10-20) — "prove it"

**Prompt A12.** *"What if the model hallucinates a regulatory citation? How does your system catch that?"*

Recovery: "Three layers. First, the prompt restricts the model to citing only from the retrieved chunks. Second, the structured output requires every citation to be a provenance object that gets validated against the actual chunk set; if it doesn't match, the request is rejected and retried with a reminder. Third, post-generation, a faithfulness pass confirms the quoted span is actually present in the source. For regulated industries, I also maintain a canonical list of valid circular numbers and block any citation that doesn't match."

**Prompt A13.** *"How do you know the eval set is representative?"*

Recovery: "I don't fully. But I mitigate three ways. First, I stratify the eval set across query categories the customer cares about most. Second, I size the eval set so confidence intervals are tight: 500 examples is my floor, 800-1000 my preference. Third, I replay production traffic weekly and sample novel query types into the eval set, so it grows with usage. The eval set is a living artifact."

**Prompt A14.** *"Your eval set was labeled by a single annotator. How is that trustworthy?"*

Recovery: "It's not, entirely. That's why I use LLM-as-judge with a cross-family model (for example, Claude judging Gemini output) and calibrate it against a human-rater sample of 50 every quarter. If the LLM judge disagrees with humans on more than 15%, I retrain the judge prompt. For a production golden set I'd push for multi-annotator agreement on at least 10% of labels."

**Prompt A15.** *"What happens when the eval set gets stale?"*

Recovery: "Two triggers: fixed schedule (quarterly refresh) and signal-driven (if production faithfulness score starts drifting without a model change, the eval set is likely stale). The hard part is budget — labeling costs real money. I keep a sampling strategy that biases toward novel queries and reported errors, so the refresh cost scales sub-linearly with usage."

**Prompt A16.** *"You said p95 latency. What about p99?"*

Recovery: "p99 is usually 2-3x p95 in generation systems because of tail latency from context length outliers and occasional cold-start. For the Haiku migration, p99 dropped from ~6s to ~3s. For user-facing systems I'd set SLO on p95 and report p99 separately so tail regressions don't hide."

**Prompt A17.** *"You said cost dropped 3x. What was the denominator?"*

Recovery: "Cost per successful task, not per request. Per-request hides retries and failed tasks. The volume was 10K requests per day; total monthly inference spend went from roughly $X to $X/3. I measured 'successful' as passing the automated quality gate plus a 5% human rater sample at 4-of-5 or better."

**Prompt A18.** *"How did you know the 3x wasn't just luck?"*

Recovery: "Canary at 2% for 72 hours before moving to 10%, then to 100%, each stage gated on pre-decided regression thresholds. If quality regressed more than one point or if cost improvement wasn't at least 2.5x, the rollback triggered automatically. I also replayed 500 production traces to confirm the cost cut held across the full query distribution, not just the top of it."

### Stage 4: During rollout / cost (minutes 20-30) — "what breaks?"

**Prompt A19.** *"What's your rollback strategy if something goes wrong?"*

Recovery: "Pre-decided criteria, written in the deployment memo. For this case, four: faithfulness below 92% for two days, any P0 from legal or compliance, p95 regressing above 15s, cost per successful task not hitting 2.5x improvement. Rollback is a feature flag flip, not a re-deploy. Takes under a minute. I test the rollback path weekly."

**Prompt A20.** *"Your rollout plan says three weeks. What if the customer wants two?"*

Recovery: "I'd push back in writing. Two weeks is enough for shadow mode plus 10% canary but doesn't leave room for the 100% rollout window where you actually see production-scale problems. If they insist, I'd compress shadow mode to three days, expand canary to 30% at day five, and make the rollback criteria tighter. But I'd name the risk explicitly: we catch regressions late, and the first big customer is the one that pays for it."

**Prompt A21.** *"What if the pilot fails the go/no-go? What do you do?"*

Recovery: "I treat it as data, not a failure. The go/no-go is explicitly designed so 'no-go' is an acceptable outcome; if it weren't, the criteria were wrong. My next move: run the failure analysis against the three dimensions (faithfulness, citations, usefulness), identify whether it's a retrieval problem, a generation problem, or a product-fit problem, propose a scoped fix with a new timeline. I'd never soft-fail a pilot — that loses customer trust."

**Prompt A22.** *"The CFO is asking for cost projections at 10x current scale. What do you tell them?"*

Recovery: "I give them three numbers: today's cost per successful task, linear-scale projection (what happens if nothing changes), and optimized projection (what happens with the two or three biggest cost levers — model routing, context compression, caching). For the Haiku migration, moving to 10x volume without further optimization would have been $X, with optimization roughly $X/2 because caching pays back more at scale."

**Prompt A23.** *"Your rollout depends on evals. What if the customer doesn't have labeled data?"*

Recovery: "Then the first two weeks are bootstrap labeling. I work with the three most engaged SMEs to label 200-300 examples stratified across their key query types. That's our baseline golden set. It's small, but it's better than no eval. Concurrently I set up LLM-as-judge with the SMEs calibrating on a 50-example sample. Over the first month the set grows to 500-800, which is the floor for production gating."

**Prompt A24.** *"What if the customer keeps pushing for more features and the pilot scope balloons?"*

Recovery: "I say no in writing, with alternatives. The pilot scope is the contract with the customer. If they ask for more, I scope it as a follow-on phase with its own timeline. The worst outcome is a pilot that ships late because scope crept, because then we can't prove the original value and the whole program loses momentum. I've done this at J&J with a 1-page memo. Written 'no' lands better than verbal 'no'."

### Stage 5: Behavioral pressure — "I'm not convinced"

**Prompt A25.** *"Why FDE? You have solid engineering experience. Why not just go staff MLE?"*

Recovery: (from Story 9 career-arc) "Staff MLE pulls me away from customer surface area. Founding engineer narrows me to one product. FDE is the steepest version of the curve I'm already on. At J&J and Gracenote, the work I'm most proud of was translating messy customer context into shipped systems with an eval harness and a cost budget. FDE is the formal version of that, at Google scale, with the platform I want to work on."

**Prompt A26.** *"You've been IC for 5 years. Why haven't you moved to management?"*

Recovery: "Deliberate choice. I looked at moving into tech lead at Gracenote last year and decided I wasn't done being hands-on. I want 3-5 more years of building, then I'll revisit. The FDE role keeps me hands-on and gives me customer breadth, which is the direction I want to go, not away from code."

**Prompt A27.** *"Your Haiku migration saved 3x on cost. Why was that not already done?"*

Recovery: "Honestly, two reasons. First, the team had tried Flash once before and killed it when support reported 'off' feedback with no eval to back it up. So there was organizational scar tissue around migrations. Second, DSPy with MIPROv2 and GEPA wasn't mature a year earlier — GEPA landed in 2025. I didn't invent the opportunity; I combined a new optimizer with an eval-first discipline the team already respected."

**Prompt A28.** *"Tell me about a time you disagreed with your manager and were wrong."*

Recovery: (bridge to Story 8 or reframe Story 10) "At J&J my skip-level told me I was jumping to architecture too fast in discovery. I disagreed internally — I thought I'd done enough context work. Two weeks later my first design proposal got rejected because the approval workflow wasn't what I'd assumed. He was right. I changed my discovery process to include two weeks of shadowing before I propose architecture. That's a permanent behavior change."

**Prompt A29.** *"What's a technical opinion you hold that most people disagree with?"*

Recovery: "Most 'agent' problems are workflow problems wearing an agent hat. Teams reach for planners and loops when a LangGraph state machine or a typed function call would ship faster, be cheaper, and fail more predictably. I've cut cost 3x at Gracenote by taking agents out where they didn't belong, not by adding them."

**Prompt A30.** *"If we hire you, what will you screw up in the first 90 days?"*

Recovery: "Probably pace. I'll be tempted to ship fast because that's the Gracenote muscle. The FDE role at Google will reward patience more — the first customer engagement sets a template for the team, so over-shipping early can lock in patterns that need to be reworked. My plan is to deliberately slow down my first engagement, over-document the delivery process, and share it as a draft template with the rest of the FDE team before claiming it works."

---

## Section B — Coding round gotchas (15 total)

These are mid-problem interruptions. Use them during solo coding mocks. Script an alarm at minute 10, 20, 25 of a problem and have a prompt ready to read.

**Prompt B1 (minute 5).** *"Stop. Walk me through your invariant before writing another line."*

Recovery: Say the invariant aloud. If you can't, you weren't ready to code. Pause, think 30 seconds, say it, then continue.

**Prompt B2 (minute 8).** *"That's O(n²). Can we do better?"*

Recovery: "Yes. The brute force is O(n²). If I trade O(n) extra space for a hash map, I can get to O(n) time. Let me reset."

**Prompt B3 (minute 10).** *"I'm not sure that handles duplicates. Does it?"*

Recovery: Trace your code on `[1,1,2,1]` out loud. If it fails, say "it doesn't. Let me fix." If it works, say "yes, because [invariant-reason]."

**Prompt B4 (minute 12).** *"What if N is 10 million?"*

Recovery: "Same time complexity. Memory is the concern at 10M. If N×K doesn't fit in RAM, I'd switch to a streaming approach or chunked processing."

**Prompt B5 (minute 15).** *"What if the input is empty?"*

Recovery: "Let me add the edge case." Add the null check at the top. "Also for single-element input, the loop doesn't execute; output is the empty list. That's correct by my invariant."

**Prompt B6 (minute 17).** *"I don't like that variable name."*

Recovery: "Fair. I'll rename." Rename to the more descriptive option. Don't explain why the first name was worse; just change it.

**Prompt B7 (minute 20).** *"Are you sure that's correct? Walk me through test case 2."*

Recovery: Do the dry run on a specific example, out loud, step by step, updating variable state on the doc. Don't rush.

**Prompt B8 (minute 22).** *"Why did you use a deque and not a list?"*

Recovery: "`deque.popleft` is O(1) amortized. `list.pop(0)` is O(n). For a sliding window that pops from the front, the deque keeps the whole operation amortized O(1) per call. Otherwise I'd be at O(n²)."

**Prompt B9 (minute 24).** *"What's the time complexity?"*

Recovery: State it crisply. Example: "O(n) time, O(k) space where k is the size of the window. Each element enters and leaves the window at most once, so total work is 2n, which is O(n)."

**Prompt B10 (minute 25).** *"Change of requirements. Now the stream is distributed across 5 nodes. Does your solution still work?"*

Recovery: "No. The in-memory map doesn't work cross-node. Three options: sharded Redis with consistent hashing on user_id, a central coordinator (doesn't scale), or accepted staleness via eventual consistency if the business tolerates it. For rate limiting specifically, I'd use Redis ZSET with a Lua script for atomicity."

**Prompt B11 (minute 27).** *"I'd like to see you write a test for that."*

Recovery: "Sure." Write 2-3 lines of a test case as pseudocode or actual Python. Doesn't need to be in a test framework; just "if allow(x,1) == True and allow(x,2) == False, good."

**Prompt B12 (minute 28).** *"Do you think this is the best you can do?"*

Recovery: If yes, say so: "For this complexity class, yes. The lower bound is Ω(n) because we have to look at every element. We're at O(n)." If no: "No, I could improve X by Y."

**Prompt B13 (minute 30).** *"What if I told you this runs 100x slower than expected in production?"*

Recovery: "I'd profile first, guess second. Common culprits: Python overhead (could be C extension), GIL contention, I/O blocking, cache misses if data is large. I'd run cProfile, look at hot functions, and decide. Don't optimize without data."

**Prompt B14 (minute 32).** *"The class you just wrote has a bug."*

Recovery: Don't get defensive. Say: "I want to find it. Can you give me a test case that breaks it?" They'll tell you. Then fix.

**Prompt B15 (minute 35).** *"What other data structures could you use for this?"*

Recovery: Name 2-3 alternatives with tradeoffs. Example for LRU: "Instead of map + doubly-linked-list, I could use `OrderedDict` for less code (Python-specific). For a distributed version, a Redis sorted set with score = timestamp works. For concurrent reads heavy, a lock-free cache with sharding might be better, at the cost of more code."

---

## Section C — Full mock interruption template (use for May 9 and May 11 mocks)

For each 60-minute mock, pre-pick this exact set:

| Timestamp | Interruption | Source |
|---|---|---|
| 2:00 into RRK | Pick 1 from A1-A3 (discovery stage) | Section A |
| 7:00 into RRK | Pick 1 from A4-A11 (architecture stage) | Section A |
| 15:00 into RRK | Pick 1 from A12-A18 (eval stage) | Section A |
| 25:00 into RRK | Pick 1 from A19-A24 (rollout stage) | Section A |
| 45:00 into RRK (behavioral pivot) | Pick 1 from A25-A30 | Section A |

| Timestamp | Coding interruption |
|---|---|
| 5:00 into coding | B1 (invariant check) |
| 10:00 into coding | B2 or B4 |
| 20:00 into coding | B7 (dry run) |
| 25:00 into coding | B8 or B10 |
| 32:00 into coding | B14 (bug discovery) |

Total: 5 RRK interruptions + 5 coding interruptions across a full mock. That's the interruption density of a real round.

## One rule

Recovery from an interruption should feel natural, not aggressive. You're not defending a thesis; you're having a conversation with a senior peer who's testing the edges of your thinking. The tone is "good question, here's my read" — not "let me explain why you're wrong."

## Debrief after each mock

After every mock, write down:

1. Which interruption caught you off guard?
2. What was your first reaction — freeze, defend, or engage?
3. Rewrite the recovery in one sentence.
4. Add that recovery to this file under the relevant prompt.

This file should grow after every mock. By May 12, it should have at least 5 new recoveries added from your own practice.
