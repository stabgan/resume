# Behavioral Index — 30 Prompts, 13 Stories, 11 Nights

## Why this file exists

Google's behavioral bar for an FDE is not a separate interview. It is stitched into the RRK round. In a 60-minute RRK expect 15 to 20 minutes of behavioral probing woven between the technical work: the interviewer will interrupt a system-design narrative to ask "tell me about a time the customer said no to that," or pivot from a cost discussion into "walk me through a disagreement you lost." The goal is to test Googleyness (humility, customer focus, collaboration, bias for action) and probe the Leadership bar (ownership, ambiguity navigation, influence without authority, bar-raising).

The candidate profile here is concrete. Kaustabh Ganguly, 5.5 years experience, senior AI/ML engineer, interviewing for Google FDE GenAI L4/L5 on May 13. Same-day format: RRK 60 min + Coding 60 min. I have 8 existing STAR stories in `09_STORIES_AND_COMP.md`. This file adds 5 new career-arc stories (9 to 13), maps all 13 across 30 common Google behavioral prompts, gives a rehearsal schedule aligned with `00_EXECUTION_PLAN.md`, and ends with red flags and a between-rounds reset.

How to use it. When a prompt lands, do not hunt for the "perfect" story. Go to the Section A table, find the prompt, grab the Primary story, deliver it with the angle noted. The secondary is your fallback if the interviewer has already heard the primary earlier in the loop. Rehearse aloud, standing, no notes.

---

# Section A — The 30-Prompt Index

Columns: Prompt | Primary story | Secondary story | Angle to emphasize.

Story numbers: 1 Data Sentry, 2 J&J approval heuristics, 3 Gracenote ingestion, 4 hard-gate disagreement, 5 AutoResearch/MCP flagship, 6 Sonnet to Haiku, 7 J&J ML explanation, 8 overclean metric failure, 9 career arc / why FDE, 10 strongest critic, 11 GEPA recent learning, 12 DSPy adoption mentorship, 13 customer said no on automation.

## Ownership (5)

| # | Prompt | Primary | Secondary | Angle |
|---|---|---|---|---|
| 1 | Tell me about a time you took on something outside your formal scope. | 1 Data Sentry | 5 AutoResearch | Formal role was data/ML; identity-ops pain was a layer out; I shadowed IAM, built it on my own time, then it got adopted. Emphasize the "nobody asked me" part. |
| 2 | Describe something you built that wasn't asked for. | 5 AutoResearch | 1 Data Sentry | The harness fell out of friction, not from a spec. Two npm MCP servers came from the same instinct. Emphasize field friction to reusable tool. |
| 3 | A time you fixed a process nobody owned. | 1 Data Sentry | 3 Gracenote ingestion | IAM onboarding across three clouds had no owner; I mapped the steps and automated it. For Gracenote version, the ingestion pipeline's ex-owner had left. |
| 4 | When did you know you had over-committed, and what did you do? | 2 J&J approval | 8 Overclean metric | Three weeks into training, I realized the data contradicted the documented process. I stopped, wrote a new spec, got legal and CAB signoff in a week. Emphasize "stop and reframe" over "push through." |
| 5 | Biggest risk you took in your career so far. | 9 Career arc | 6 Sonnet to Haiku | Leaving a safe ML path to deliberately chase customer-facing ambiguity (J&J embed). The Haiku migration is the technical-risk version of the same instinct. |

## Ambiguity (4)

| # | Prompt | Primary | Secondary | Angle |
|---|---|---|---|---|
| 6 | A time requirements changed significantly mid-delivery. | 2 J&J approval | 3 Gracenote ingestion | Spec said "predict approvals"; reality was undocumented tribal heuristics. Reframed as decision support with confidence + override. |
| 7 | When you had to deliver with incomplete information. | 3 Gracenote ingestion | 2 J&J approval | Ex-owner gone, no docs, 1500+ partner catalogs flowing. I debugged the top 20 false positives, found the temporal pattern, shipped a fix in 6 weeks. |
| 8 | Tell me about a project where the goal itself was unclear. | 5 AutoResearch | 9 Career arc | Started as "stop doing annoying manual literature search." The goal clarified into "a reusable research-first harness" only after version 2. Emphasize discovery by building. |
| 9 | A time you had to choose between two equally good paths. | 6 Sonnet to Haiku | 2 J&J approval | Stay on Sonnet and pay the bill, or migrate to Haiku with DSPy + GEPA. Both defensible; I picked migration because the eval suite de-risked it. Emphasize decision framing. |

## Conflict (4)

| # | Prompt | Primary | Secondary | Angle |
|---|---|---|---|---|
| 10 | Tell me about disagreeing with a senior stakeholder. | 4 Hard-gate | 13 Customer said no | Program Director wanted a hard gate. I wrote a 1-page memo with a 4-mode decision matrix. The memo changed the decision without a confrontation. |
| 11 | A time you had to tell a customer their plan was wrong. | 13 Customer said no | 4 Hard-gate | Partner team wanted to automate before evals existed. I pushed back in writing, proposed a phased rollout, held my position, and kept the relationship. |
| 12 | Most difficult teammate you had to work with. | 12 DSPy adoption | 4 Hard-gate | One team I tried to teach the eval-first pattern to kept pushing to skip eval setup. I held the line, but I also respected their final "not right for us" and didn't escalate. |
| 13 | A disagreement you lost, and what you learned. | 10 Strongest critic | 4 Hard-gate | Early at J&J, I lost an argument because I jumped to architecture before discovery. The feedback changed how I run engagements. |

## Failure (3)

| # | Prompt | Primary | Secondary | Angle |
|---|---|---|---|---|
| 14 | Tell me about a failure you own. | 8 Overclean metric | 10 Strongest critic | 100% pass rate on a small friendly sample. Real rate was 95% on N=500. Now I put the denominator next to every percentage I report. |
| 15 | A decision you regret. | 10 Strongest critic | 8 Overclean metric | At J&J, I skipped deep discovery in the first two weeks and jumped to architecture. It cost us three weeks of rework. Now I always run 2 weeks of structured discovery. |
| 16 | A time you shipped something that had to be rolled back. | 8 Overclean metric | 6 Sonnet to Haiku | Not a full rollback, but a public correction: I reported a number that didn't hold at larger N. I reissued the result and changed how I write metrics. |

## Learning (3)

| # | Prompt | Primary | Secondary | Angle |
|---|---|---|---|---|
| 17 | Most important thing you learned in the last year. | 11 GEPA | 6 Sonnet to Haiku | Reflective prompt optimization (GEPA) as a replacement for scalar-reward RL on small-N tasks. Explain where it fits and where it doesn't. |
| 18 | A skill you deliberately built recently. | 11 GEPA | 5 AutoResearch | Prompt-optimization toolchain: DSPy, MIPROv2, GEPA, DeepEval regression gating. Built through actual use on the Haiku migration. |
| 19 | What do you know now that you wish you knew 3 years ago. | 10 Strongest critic | 8 Overclean metric | Discovery before architecture. Memos beat meetings. Sample size next to every metric. Three lessons that would have saved me months. |

## Customer / translation (3)

| # | Prompt | Primary | Secondary | Angle |
|---|---|---|---|---|
| 20 | Explain something technical to a non-technical stakeholder. | 7 J&J ML explanation | 11 GEPA | Two contracts, no math. The regional manager coined the team's internal explanation. |
| 21 | A time you said no to a customer request. | 13 Customer said no | 4 Hard-gate | "We don't have eval coverage for that yet. Here is what I can ship this quarter instead." Say the no in writing, then offer a concrete alternative. |
| 22 | How do you handle a customer who doesn't know what they want. | 2 J&J approval | 9 Career arc | Discovery mode. Two weeks of shadowing, mapping decisions, finding the contradiction. Reframe the problem in a 2-slide deck with real examples. |

## Leadership / influence (3)

| # | Prompt | Primary | Secondary | Angle |
|---|---|---|---|---|
| 23 | A time you convinced someone without authority over them. | 4 Hard-gate | 12 DSPy adoption | Memo, decision matrix, dollar cost of each mode. Give the other person a public path to change their mind. |
| 24 | How you mentor junior engineers. | 12 DSPy adoption | 7 J&J ML explanation | Teach the playbook, pair on first eval run, then step back. Respect "no" when a team decides the pattern isn't right for them. |
| 25 | When you had to drive adoption of something. | 12 DSPy adoption | 1 Data Sentry | Rolled out DSPy + DeepEval eval-first pattern across adjacent Gracenote teams after Haiku worked. 2 of 3 adopted. |

## Career arc / self-reflection (3)

| # | Prompt | Primary | Secondary | Angle |
|---|---|---|---|---|
| 26 | Why FDE, not staff MLE or founding engineer. | 9 Career arc | 5 AutoResearch | The pattern across J&J, Gracenote, Data Sentry, MCP servers is already FDE. Founding engineer would narrow surface area; staff MLE would pull me away from customer context. |
| 27 | What would your strongest critic say about your work. | 10 Strongest critic | 8 Overclean metric | "He moves to architecture too fast." True early career; changed behavior now includes 2-week discovery window. |
| 28 | Five years from now, what do you want to be known for. | 9 Career arc | 5 AutoResearch | "The person who turned messy customer environments into patterns others reuse." Concrete artifacts: AutoResearch harness, MCP servers, Data Sentry. |

## Google-specific (2)

| # | Prompt | Primary | Secondary | Angle |
|---|---|---|---|---|
| 29 | Why Google, and why now. | 0 Why Google | 9 Career arc | The agentic stack is being defined at Google right now. Gemini, Vertex AI, ADK, Agent Engine, A2A. I want to be inside the feedback loop, not consuming it from outside. |
| 30 | What's Google doing well in AI, and what's it missing from a customer's perspective. | 11 GEPA | 5 AutoResearch | Doing well: model quality, Vertex RAG Engine, governance surface. Missing from the field: an opinionated "research-first" pattern in ADK, sharper pre-deploy eval tooling integrated with Agent Engine. |

---

# Section B — 5 New Career-Arc Stories

Same format as the existing 8. Cue, Script, Follow-ups, FDE signals. First-person, no em-dashes, 60 to 90 second delivery.

---

## Story 9 — Career Arc / Why FDE, Not Staff MLE (90 sec)

### Cue
*"Why FDE specifically? Why not a staff MLE role or a founding engineer role at a startup?"*

### Script

> The honest answer is that FDE is the formal label for the work I have already been gravitating toward for five years. I keep ending up as the person who goes to the customer's environment, maps messy context, and brings back a reusable artifact. At TCS I was embedded with J&J MedTech for almost two years on a contract-approval system that had to live inside their AWS and compliance boundary. Before that I built Data Sentry, a cross-cloud identity automation for 500 users that came from shadowing their IAM team. At Gracenote I am doing the same pattern for production GenAI: LangGraph workflows, eval gates, cost migrations, MCP tooling.
>
> The moment it clicked was during the EmbeddingGemma 300M fine-tune this year. I wasn't trying to build a reusable research harness; I was annoyed at repeating the same literature search. A few weeks in, the harness had a hypothesis log, a memory log, a plan-then-execute loop, and two MCP servers wired in. I realized that's the artifact. The fine-tuned model was almost the byproduct.
>
> Staff MLE would pull me away from customer surface area. Founding engineer would narrow me to one product. FDE is the steepest version of the curve I am already on, with a stronger platform behind me and an explicit mandate to turn implementation lessons into reusable assets.

### Follow-ups
- *"What would you lose by going this route?"* → "Depth in a single codebase. At Gracenote I have been inside one system for a year. FDE rotates faster. I accept that trade because the range of environments and the pattern library I'd build is worth more to me right now."
- *"Have you considered Google as a staff MLE instead?"* → "Yes. Same work, narrower surface area. The reason FDE wins is customer contact. I learn best in environments where I don't control the variables, and FDE is that by design."
- *"What's the strongest argument against FDE for you?"* → "Burnout risk. Customer-embedded work is high context-switch. I handle it now because I set 2-week discovery windows and written memos as boundaries. I would carry those habits in."

### FDE signals
Career pattern recognition. Self-awareness. Customer obsession. Clear trade reasoning.

---

## Story 10 — Strongest Critic / Discovery Before Architecture (75 sec)

### Cue
*"What's the most important feedback you've received? What would your strongest critic say about you?"*

### Script

> The most useful feedback I ever got came in my first three months at J&J MedTech. My skip-level pulled me aside and said I was jumping to architecture too fast. I had arrived with a clean ML design in week two, before I actually understood how the analysts made decisions. He told me directly that the design was elegant and irrelevant, because I hadn't earned the right to propose it yet. That stung, because I thought moving fast was the point.
>
> I sat with it and owned it. The pattern I saw, once I looked honestly, was that my best work had always followed discovery and my weakest work had always followed me assuming I knew enough. I changed how I start engagements. Now the first two weeks are structured discovery: shadow 5 real decisions, read 3 postmortems, map the data lineage by hand, write a 1-page "current state" memo. Only after that do I propose architecture.
>
> That habit is what let me catch the approval-heuristics inconsistency at J&J in week three instead of month three. It is what let me diagnose the temporal-ambiguity bug at Gracenote in my first month. If my strongest critic today said "he still moves too fast sometimes," I would accept it. But the 2-week discovery window is a deliberate counter-behavior I run on every engagement now.

### Follow-ups
- *"Who was this skip-level? Would they still say the same thing today?"* → "He was a program director at J&J, and no, I don't think he would. He approved the rewritten ML spec a month later and said the discovery memo was the turning point. But the version of me he saw first would have shipped a mismatched system."
- *"What's a piece of feedback you rejected?"* → "Someone once told me I write too much for a meeting. I considered it, but the memo pattern is how I drive decisions without authority. I kept it."

### FDE signals
Humility. Behavior change. Discovery discipline. Coachability.

---

## Story 11 — Recent Learning / GEPA and Prompt Optimization (75 sec)

### Cue
*"What's the most important thing you've learned in the last year? What have you deliberately built as a skill?"*

### Script

> The most important thing I learned in the last year is a specific prompt-optimization technique called GEPA, which came out of Stanford and Berkeley in 2025. It caught my attention because of how it differs from MIPROv2, which is what DSPy ships with by default. MIPROv2 uses scalar reward signals to update prompts: you score an output, the optimizer updates the prompt candidate pool, you iterate. GEPA does something different. It samples trajectories, the full reasoning and tool-call sequence, and then reflects on them in natural language to diagnose failures. It maintains a Pareto frontier of prompt candidates and combines complementary lessons across them.
>
> Why that matters for my work: on small-N or high-cost rollout regimes, reflective natural-language diagnosis is a richer learning medium than sparse scalar rewards. The paper shows it beats GRPO by 6 to 20 percent using 35 times fewer rollouts, and beats MIPROv2 by over 10 percent on six tasks.
>
> I used it on the Sonnet to Haiku migration at Gracenote. The pipeline was: MIPROv2 for initial prompt compilation, then GEPA on the hardest 15 percent of cases from the DeepEval regression suite, then a final DeepEval gate before canary. Quality held within baseline, p95 latency dropped 50 percent, cost fell 3x. The real lesson is more general: when your eval signal is rich, you want an optimizer that can read it. When it's sparse, you fall back to scalar.

### Follow-ups
- *"Where does GEPA not fit?"* → "Large-N tasks with cheap rollouts and good scalar reward signals. There, GRPO or MIPROv2 are fine. GEPA is for when each rollout is expensive and the failure modes are diagnosable in language."
- *"How did you decide when to learn it?"* → "The Haiku migration gave me a concrete pull. I don't learn papers well in the abstract. I learn them when a project needs the answer."

### FDE signals
Frontier awareness. Applied learning. Evaluation rigor. Honest scoping of technique applicability.

---

## Story 12 — Mentorship / Driving Adoption of DSPy + DeepEval (75 sec)

### Cue
*"How do you mentor other engineers? Tell me about driving adoption of a pattern or tool."*

### Script

> After the Sonnet to Haiku migration worked at Gracenote, three adjacent teams asked how we'd done it. I treated this as an adoption problem, not a teaching problem, because the pattern only works if they actually run the eval-first playbook end to end.
>
> I wrote a short internal doc, about two pages, with the playbook: build the golden set first, wire DeepEval as a regression gate, compile prompts with MIPROv2 on the cheaper model, run a canary, gate full traffic on regression thresholds. Then I offered 90-minute pairing sessions with each team's lead to set up the first eval run. That was the key move. The doc alone would not have landed.
>
> Two teams adopted it within a month. The content-tagging team cut their cost 2.2x with no quality regression. The media-summarization team found a subtle prompt dependency the eval surfaced, and they caught it before production. The third team pushed back. Their argument was that their workload was small enough that eval setup would cost more than the savings. I disagreed internally but they were right about their specific constraints. I didn't escalate. I marked it down, moved on, and they came back six months later when their volume grew.
>
> The lesson was about calibration, not persuasion. When you are driving adoption, the teams that say no for good reasons are a signal, not a failure. Respect the no. It protects the pattern's credibility.

### Follow-ups
- *"What did the friction look like at first?"* → "Teams wanted to skip the golden-set step because it felt like overhead. I held the line on that one because without the golden set the whole pattern is theater."
- *"Did the team that said no ever come around?"* → "They came back six months later when their traffic tripled. By then I had better examples to show them."

### FDE signals
Influence at scale. Written playbooks. Respect for other teams' judgment. Adoption as product thinking.

---

## Story 13 — Customer Said No to Automation Before Evidence (75 sec)

### Cue
*"Tell me about a time you said no to a customer, or pushed back on a partner's plan."*

### Script

> At Gracenote, one of our internal partner teams, the one that owns a downstream content-quality surface, asked us to fully automate a classification decision point that our pipeline was feeding them. Their pitch was reasonable on the surface: our ingestion classifier was hitting 97 percent precision, so why was a human still approving the top-tier partners? They wanted to cut their reviewer queue by 70 percent.
>
> I said no, and I said it in writing. My memo had three parts. First, the 97 percent number was aggregated across all partners, but the tail distribution mattered: new partners and rare-language catalogs were closer to 91 percent, and those were the cases the human reviewers were catching. Second, we had no regression eval that would catch a drift from 97 to 93 before it showed up in customer complaints. Third, I proposed a staged plan: add a partner-tier confidence gate, build a DeepEval regression suite on the tail distribution, run a 60-day shadow mode, and only then revisit the automation ask.
>
> They pushed back in the meeting. They had a reviewer-cost target they were trying to hit. I held the position, but I acknowledged their constraint and offered to co-own the shadow-mode metrics so they could see the cost trajectory in real time. That unlocked it. We ran the 60-day shadow, found two drift events we'd have missed without it, and automated only the confidence-gated tier.
>
> The lesson connects to the hard-gate memo at J&J. In both cases, the right answer was phased automation gated on eval evidence, and the right medium was a written memo. Customers remember the memos. They don't remember the verbal pushback.

### Follow-ups
- *"What would have happened if you'd agreed to the full automation?"* → "We'd have shipped it, hit one of the drift events in about three weeks, and taken a partner escalation. I can trace the cost: one of the drift events touched a top-5 partner. That's a support ticket I don't want."
- *"How did you keep the relationship?"* → "By co-owning the metric. I didn't just say no and walk away. I offered them visibility into the data and made it a shared decision."
- *"Would you do anything differently?"* → "Surface the memo one week earlier. We lost a few days to ambiguity that the memo closed the minute it landed."

### FDE signals
Customer trust under pressure. Written decision-making. Phased de-risking. Evidence-gated automation.

---

# Section C — "What Would Your Worst Critic Say" Rehearsal

Three 60-second self-critiques. The format is: honest weakness, concrete evidence, current counter-behavior. Do not soften. Google interviewers can smell a fake weakness. The way to pass this one is to name something real and show the active repair.

## Critique 1 — Technical: AI agent dependency

> Honestly: I lean on AI coding agents heavily in my day-to-day work. At Gracenote I'm in a Kiro-cli plus MCP loop for most non-trivial changes. The critique is fair. Over the last 18 months my raw whiteboard coding muscle has atrophied, because I have built a workflow where the agent writes the scaffolding and I review. That works beautifully in a plain IDE. It does not work in a 60-minute Google Doc coding round with no execution.
>
> I spotted this when I started prep for the May 13 interview. What I'm actively doing: 22 timed problems on a bare Google Doc, two per day, think-aloud protocol, no autocomplete. I reread Python dict, set, heapq, deque semantics from memory. I write the sliding-window, two-pointer, BFS, DFS, and binary-search templates from scratch every morning as warmup. By interview day I will have logged over 40 hours of no-IDE coding. The agent stays useful for production work. The interview is a separate mode, and I've rebuilt the muscle deliberately.

## Critique 2 — Collaboration: I write before I talk

> Fair critique: my memos are stronger than my in-meeting advocacy. Multiple peers have told me that the version of an idea in my writing is sharper than the version I deliver verbally in a room. The hard-gate memo at J&J and the shadow-mode memo at Gracenote are examples: they did the persuasion work, and I leaned on them because I knew the verbal version would be weaker.
>
> That's a real gap. What I'm working on: I now prep a 3-sentence "verbal headline" for every meeting where a memo is in play, so the room hears the thesis before they read it. I record myself on the opener and the 8 STAR stories and watch the recordings for filler words and unclear transitions. And in the last four months I have deliberately taken the first speaking slot in design reviews instead of saving my position for a follow-up memo. It's still not my strongest surface, but the gap is narrower than it was a year ago, and I keep measuring it.

## Critique 3 — Career: I have stayed IC too long

> At 5.5 years, most of my peers have either gone into management or joined an early-stage startup as a founding engineer. I have deliberately stayed IC and hands-on. The honest critique is that I could have moved into a tech lead or EM role 18 months ago and I chose not to. Someone could reasonably read that as risk-averse.
>
> My counter: the FDE role is what I actually want. It keeps me hands-on, puts me in front of customers, and gives larger surface area than founding engineer. I have watched peers go founding-engineer at seed-stage and the surface narrows to one product. I want breadth across hard enterprise environments for three years, then revisit tech-lead scope. Choosing FDE now is the active decision. The comfort zone I am walking away from is a familiar Gracenote codebase I know cold.

---

# Section D — 11-Night Rehearsal Schedule (May 3 to May 13)

Aligned with `00_EXECUTION_PLAN.md`. Each night: one story, aloud, standing, timed, no notes. Total time: 10 to 15 minutes per night. Record when possible and listen back for filler words and time overruns.

| Date | Story | Paired prompt from Section A | Why tonight |
|---|---|---|---|
| Fri May 2 | Story 0 Why Google + Story 9 career arc | Prompts 26, 29 | Anchor the narrative. Everything else hangs off the "why" answer. |
| Sat May 3 | Story 1 Data Sentry | Prompts 1, 3 | Ownership spine. Easy win to build confidence. |
| Sun May 4 | Story 2 J&J approval heuristics | Prompts 4, 6, 22 | Ambiguity spine. Highest-reused story. |
| Mon May 5 | Story 5 AutoResearch flagship ⭐ | Prompts 2, 8 | The flagship. Do it twice tonight. This is the differentiator. |
| Tue May 6 | Story 6 Sonnet to Haiku + Story 11 GEPA | Prompts 9, 17, 18 | Technical depth night. Rehearse the 60-second GEPA explanation until it's crisp. |
| Wed May 7 | Story 3 Gracenote ingestion | Prompts 7, 3 secondary | Unfamiliar-system story. Practice the "how did you know" follow-up. |
| Thu May 8 | Story 4 hard-gate + Story 13 customer said no | Prompts 10, 11, 21, 23 | Conflict night. Back-to-back because the memo pattern is the same instinct. |
| Fri May 9 | Story 7 simplify + Story 12 DSPy adoption | Prompts 20, 24, 25 | Translation and influence. Lighter cognitive load before mock-day Saturday. |
| Sat May 10 | Story 8 overclean metric + Story 10 strongest critic | Prompts 14, 15, 16, 19, 27 | Failure and self-critique. Practice delivering without softening. |
| Sun May 11 | Pick the two weakest from the last nine nights | Varies | Fix what's brittle. Re-record. |
| Mon May 12 | Full recital: all 13, each under 90 sec | All 30 | Taper. Whole set once. No new material. Lights out by 22:30. |
| Tue May 13 | Opener + Story 5 + Story 9 out loud once, 30 min before round 1 | 29, 26, flagship | Calm retrieval only. Warm the voice. Nothing more. |

Each rehearsal ends with a one-line note in the error log: "What wobbled tonight?" The error log from `00_EXECUTION_PLAN.md` is where the week compounds.

---

# Section E — 5 Behavioral Red Flags (Never Say These)

These are phrases that move an interview from "this person is senior" to "this person is excuse-making." If any of them start to come out, stop and rephrase. Practice this until the red-flag phrase triggers an automatic replacement.

## 1. "We didn't have time for eval."

Why it's fatal: eval discipline is the FDE differentiator. Saying you skipped it tells the interviewer you deprioritize the one thing that keeps production agentic systems honest.

Replace with: "The eval budget was tight, so I scoped the golden set down to the 50 cases that covered 80 percent of the traffic, and gated on regression against those." You had eval. You were pragmatic about its shape.

## 2. "The business didn't understand."

Why it's fatal: blame-shifting dressed up as technical exasperation. Reads as a collaboration failure. Google weights customer obsession and collaboration heavily.

Replace with: "The business and I had different models of the risk. I wrote a 1-page memo that surfaced the trade, and we aligned on a phased rollout." You owned the translation.

## 3. "I let my manager decide."

Why it's fatal: FDE is an IC role with high agency. Deferring upward on a technical decision reads as low ownership. L4 minimum, L5 hopeful. Neither level should be punting.

Replace with: "I proposed the call with a written recommendation and a clear decision matrix, and my manager signed off the option I recommended." You drove the decision.

## 4. "That was the team's fault."

Why it's fatal: even if true, it breaks the Googleyness bar instantly. The candidate with ownership frames team failures as "what I could have done differently."

Replace with: "The integration point was brittle and I had underestimated the coordination cost. Next time, I would set up a weekly 30-minute sync and a written interface contract in week one." You absorb the responsibility and show the counter-behavior.

## 5. "I don't really have a weakness, I just..."

Why it's fatal: the weakness question is a calibration check. Every interviewer knows the humble-brag. Deflecting kills credibility for the rest of the round.

Replace with: one of the three critiques in Section C. Name a real weakness, give real evidence, give the current counter-behavior.

Bonus anti-pattern: the word "simply" when describing anything technical in front of a non-technical stakeholder. It reads as condescending, and it is the tell of someone who has not actually translated the idea.

---

# Section F — Between-Rounds Behavioral Reset

You have two 60-minute rounds back to back on May 13. Round 1 is RRK with behavioral woven in. Round 2 is coding. If a story wobbled in Round 1 and you know it, you have about 5 to 15 minutes between rounds to reset.

The temptation will be to replay the bad moment. Don't. Here's the 30-second reset protocol.

## The 30-second reset

1. **Stand up.** Away from the screen. Water.
2. **Name the wobble in one sentence, out loud, once.** "I rushed the Haiku story and skipped the GEPA explanation." That's it. Do not replay it.
3. **Say the opener aloud, once, from memory.** This re-anchors cadence. "I'm Kaustabh. I'm a senior ML engineer at Gracenote..." Just the first 30 seconds.
4. **Sit back down 5 minutes before Round 2.** Type a tiny Python class on a blank Doc as warmup. Not related to interview prep. Something like a counter or a queue. This activates coding muscle memory.

## The "which story next round" decision

Round 2 is coding, but behavioral can still show up in the final 5 minutes. If Round 1 went poorly on a specific story, you have two moves:

- **If the weak story was one of the flagship four (Story 2, 4, 5, 6):** do not re-attempt it in Round 2 unless directly asked. Switch to a secondary: Story 1 for ownership, Story 3 for diagnosis, Story 13 for conflict.
- **If the weak story was peripheral (Story 7, 8, 12):** forget it. The interviewer in Round 2 has not heard it and doesn't care. Just nail the coding.

## The "did I say a red flag" triage

If you replayed Round 1 and caught yourself in one of the Section E red flags, write it down in one line and move on. You cannot unsay it. What you can do: do not repeat it in Round 2. The worst thing would be carrying the shame into Round 2 and flubbing a tractable coding problem because your confidence is shot.

## The physical reset

- Walk 2 minutes if you can. Even pacing in a room resets cortisol.
- Do not scroll phones. Not Slack, not email, not Twitter.
- Do not eat heavy food between rounds. A piece of fruit or nuts is fine. No lunch carbs.
- Drink water. Not coffee. Your baseline caffeine from the morning is still active.

## The last 30 seconds before Round 2

Close your eyes. Think of one sentence: "I've done this work. I just need to show it." That's the whole reset. The work is done. The stories are rehearsed. The coding templates are muscle memory. What's left is retrieval under mild pressure, and retrieval works best when you are calm and slightly under-caffeinated.

---

# Closing note

Thirteen stories cover thirty prompts. Eleven nights of rehearsal. Five red flags. One 30-second reset. This file gets closed and set aside by May 12; by then the stories live in muscle memory. If on May 12 you still feel like rereading, rehearse the opener three more times and go to bed. Sleep is the highest-leverage prep intervention in the final 24 hours.
