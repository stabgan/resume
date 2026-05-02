# Interview Day — Same-Day Logistics

You confirmed: **both rounds on the same day.** Two 60-minute technical rounds back to back. This doc is your playbook for that reality.

Read it on May 12 night and May 13 morning. Do not use it to cram.

## The schedule

- **Round 1 — RRK:** 60 minutes
- **Round 2 — Coding:** 60 minutes, plain Google Doc, no IDE, no execution

Same-day format means:
- You will be tired by Round 2.
- You have limited recovery time between them.
- Your energy management is as important as your technical prep.

## The night before (May 12)

**Do:**
- [ ] Read this document once.
- [ ] Set 2 alarms for the morning.
- [ ] Lay out: computer, headphones, water, notebook + pen, interview link in a starred tab, resume open in another tab.
- [ ] Test camera + mic.
- [ ] Check internet + backup hotspot.
- [ ] Tell your household you're not available tomorrow morning.
- [ ] Heavy meal by 8 PM. No alcohol.
- [ ] Sleep by 22:30.

**Don't:**
- Read new material. If you don't know it by May 12, you won't know it by May 13.
- Grind LeetCode. The muscle is built or it isn't.
- Drink caffeine past 5 PM if you're caffeine-sensitive.
- Rehearse your stories in your head for hours. Say them aloud ONCE, then stop.

## Morning of May 13

### 90 min before Round 1 — wake up and fuel

- [ ] Wake with 90 min of buffer, minimum.
- [ ] Solid breakfast: eggs, oats, protein. **Not sugary.** Sugar spikes = 45-min-later crash = the middle of your coding round.
- [ ] Water (500 ml over the first 60 min; no chugging right before the round).
- [ ] Shower. Get dressed for camera. Shirt with a collar.
- [ ] 10-min walk outside if you can — sunlight + movement activates the brain better than caffeine alone.

### 45 min before Round 1 — warm up the brain

- [ ] Open a blank Google Doc titled `warmup`.
- [ ] Type these 3 lines verbatim (muscle memory for the plain-Doc environment):
  ```python
  from collections import defaultdict, Counter, deque
  import heapq
  from typing import List, Optional
  ```
- [ ] Type one small class skeleton:
  ```python
  class RateLimiter:
      def __init__(self, limit: int, window: int):
          self.limit = limit
          self.window = window
          self.events = defaultdict(deque)
  ```
- [ ] Say your 60-sec opener aloud **once**. Time it.
- [ ] Read `10_INTERVIEW_DAY.md` (this file) — specifically the "cheat sheet" section below.
- [ ] **Stop.** Close all other tabs. No more input.

### 10 min before Round 1 — final prep

- [ ] Bathroom.
- [ ] Water in reach but not in your hand.
- [ ] Notebook on desk (for scribbling during RRK — interviewer can't see it).
- [ ] Join the Meet 2 minutes early, camera on.
- [ ] Breathe. Four seconds in, four seconds out, four times.

---

## Round 1 — RRK (60 min)

### Opening (the first 3 minutes)

- Smile. Warm greeting. *"Hi [interviewer name], good to meet you."*
- Let them drive. They'll likely ask you to introduce yourself.
- **60-second opener** — from `02_RRK_MASTER_GUIDE.md`, not a reading of your resume.
- Ask a clarifying question if they describe the round: *"Would you like me to focus on a specific scenario, or are we doing a walkthrough first?"*

### When they give you a problem

**Always, always, always start with:**

> Let me first clarify the user workflow, success metric, data boundary, and unacceptable failure modes. Then I'll propose an MVP and harden it for production.

Then use the 10-step RRK answer shape from `02_RRK_MASTER_GUIDE.md`.

### Mid-round recovery phrases (if you stall)

- *"Let me slow down and restate what we're solving for."*
- *"Let me separate the business workflow from the model workflow."*
- *"Can I check: is the constraint here cost, latency, or compliance?"*

### End-of-round close

Always end with the FDE-specific product-feedback line:

> If I kept hitting the same integration / eval / data pattern, I'd capture it as a reusable module and send it back as a feature request to the Google Cloud engineering team.

That sentence is literally one of the 4 JD responsibilities. Don't skip it.

### Questions you should ask at the end (pick 1)

- *"For this FDE team, what are the most common blockers between prototype and production?"*
- *"How much of the role is embedded customer delivery vs. building reusable assets for the broader Google Cloud field?"*
- *"How does the FDE team feed product gaps back into ADK, Agent Engine, or the broader Vertex AI roadmap?"*
- *"What does success look like for the first six months?"*

**Don't ask:**
- Comp (save for the recruiter).
- WLB (reads junior).
- "Is there anything I can clarify about my experience?" (weak close).

---

## Between Rounds — the 15-minute reset

This is critical. Same-day back-to-back rounds drain you. Reset properly.

### Do (in order, 15 min total)

1. **Close the Round 1 tab.** Don't replay the answers in your head. The round is over.
2. **Stand up.** Move away from the desk.
3. **Walk 5 minutes.** Outside if possible. Not on your phone.
4. **Water + light snack** — a banana, nuts, something not sugary. NOT a full lunch. Lunch = blood rush to digestion = cognitive crash.
5. **30 seconds of deep breathing** — same box breathing (4 in, 4 out, ×4).
6. **Sit back down. Re-type the 3-line warmup on the Google Doc.** Muscle memory reset for Round 2.
7. **Say the opener once more** (same opener works for Round 2 if they ask for an intro).
8. **Bathroom.**
9. **Join the Meet 2 min early.**

### Don't

- Review notes. You won't absorb anything in 15 min; you'll only confuse fresh memory with fresh anxiety.
- Eat a heavy meal.
- Start coding a warm-up problem from scratch.
- Check Slack / email.
- Talk to anyone about the first round.

### If you feel Round 1 went badly

**It probably didn't.** Candidates over-estimate failure in real time. The only thing that matters now is Round 2. Do NOT carry Round 1 anxiety into Round 2. Same energy, same confidence, clean slate.

If you need a mantra: *"Round 1 is done. Round 2 is a new round."* Say it once. Move on.

---

## Round 2 — Coding (60 min)

### Opening

Same greeting warmth as Round 1. New interviewer (probably). Don't assume they read Round 1's notes.

- They'll likely ask for a brief intro. Use a 30-second version of the opener (not the full 60).
- They'll describe the problem. **Listen fully before starting.**

### The 40-minute protocol (from `04_CODING_PROTOCOL.md`)

```
 0:00 – 0:03   CLARIFY        Restate. Ask input size, edge cases, output.
 0:03 – 0:08   APPROACH       State brute force + optimized + complexity.
 0:08 – 0:28   CODE           Plain Google Doc. Say each line aloud.
 0:28 – 0:35   DRY-RUN        2 test cases by hand, on the Doc.
 0:35 – 0:40   DISCUSS        Trade-offs, bigger N, tests in production.
```

### You will be tired. Compensate by:

- **Budgeting 2 extra minutes at the start** just to breathe and clarify. A Round 2 clarification phase that took 3 min cold takes 5 min tired — and that's fine.
- **Typing more slowly than you want to.** Typos on a plain Doc can't be auto-fixed. Slow = correct = faster overall.
- **Saying each line as you type it.** Verbal muscle memory carries you when mental muscle memory is depleted.
- **Asking for a 30-second bathroom break if you NEED one.** Rare, but valid. *"Would it be okay if I took a 30-second break to get water?"*

### If stuck

Say one of these aloud:

- *"Let me step back and identify the invariant."*
- *"I'll write the brute force first so we have a correct baseline, then optimize."*
- *"This feels like [a graph / sliding window / binary search] because [reason]."*

### If you freeze mid-problem

From `04_CODING_PROTOCOL.md`:

1. Acknowledge: *"Let me pause for 30 seconds."*
2. Restate: *"So I have X input, need Y output, I've been trying Z."*
3. Ask a narrow clarifying question: *"Can I assume the list is sorted?"*

Interviewers reward structured pauses. They penalize silent panic.

### End-of-round close

- Name 3 tests you'd add in production.
- Name one thing you'd change if N were 10⁹.
- Thank them for the problem.

### Final question you should ask

Only if there's time. Pick 1:

- *"What does the team's coding culture look like day-to-day — more shipping, more reviewing, more research?"*
- *"What language and tooling do FDEs typically use in customer engagements?"*

---

## Post-interview — within 2 hours

### Send the thank-you email

To Priyanka, cc'd on the original thread:

> Hi Priyanka,
>
> Thank you for coordinating today's interviews. Really enjoyed the conversations on [one concrete topic from Round 1, e.g., "designing agent workflows for regulated customers"] and [one concrete coding topic, e.g., "the class-design problem"].
>
> Happy to answer any follow-up questions from the hiring team. Looking forward to next steps.
>
> Best,
> Kaustabh

Short. Warm. Concrete. Don't reopen technical debates.

### Then stop

- Close the laptop.
- Go for a walk.
- Eat dinner.
- Don't replay the rounds in your head for 3 hours. You can't change anything now.

---

## The cheat sheet (read during morning prep and between rounds)

### One sentence
> An FDE is an embedded builder who turns frontier AI into production reality inside a customer's actual environment.

### RRK default opening
> Let me first clarify the user workflow, success metric, data boundary, and unacceptable failure modes. Then I'll propose an MVP and harden it for production.

### RRK 10-step answer shape
1. Business goal.
2. Users + stakeholders.
3. Data + integration.
4. Architecture.
5. Security / privacy.
6. Evaluation + observability.
7. Latency + cost.
8. Rollout + rollback.
9. Reusable asset or product feedback.

### Coding default opening
> Let me restate the problem and clarify input size, edge cases, and expected output.

### If stuck
> Let me step back and identify the invariant.

### If you don't know a Google product
> I haven't shipped with that specific product, but I understand the pattern. I'd map it to integration, identity, observability, eval, and rollback requirements, and validate the product mechanics with docs or a specialist.

### MCP / A2A / ADK / Agent Engine one-liner
> MCP connects agents to tools and data. A2A connects agents to other agents. ADK builds the agent. Agent Engine runs it in production.

### RAG vs. fine-tune
> I'd start with RAG and evals if the problem is knowledge access. I'd fine-tune only if the failure is behavior, format, or domain representation after retrieval is solid.

### Cost-optimization one-liner
> I'd measure cost per successful task, not cost per request. Route easy tasks to cheaper models, cache safe repeated work, and use eval gates before migration.

### Security one-liner
> The agent should never be more privileged than the user or workflow it represents.

### Your three hot stories
1. **J&J approval heuristics** — ambiguity, customer discovery, regulated rollout.
2. **Haiku migration** — eval discipline, latency / cost, production GenAI.
3. **AutoResearch / MCP** — field friction → reusable tool, FDE product feedback loop.

### What to NOT say
- "I'd just use Gemini."
- "I'm rusty."
- "I mostly use AI agents so coding may be hard."
- "We can add security later."
- "The model should decide."
- "The business didn't understand."

### Closing FDE line (end every RRK case with this)
> If I kept hitting the same integration / eval / data pattern, I'd capture it as a reusable module and send it back as a feature request to the Google Cloud engineering team.

---

## Energy management — the underrated factor

Two 60-min technical rounds on the same day is the equivalent of a 3-hour exam with 15 min of break. You will feel Round 2 harder than Round 1 even if the problem is easier.

**Pre-empt the crash:**
- Protein breakfast, not sugar.
- Banana or nuts between rounds, not lunch.
- Water throughout, but paced.
- Walk between rounds, don't sit at the desk.
- Round 2 starts with 2 extra min of clarifying, not with speed.

**Mental framing for Round 2:**
- "Round 1 happened, whatever it was. Round 2 is a fresh round."
- "I'm tired. That's expected. I'll compensate by slowing down and narrating more."
- "The code doesn't need to be fast. It needs to be correct and clear."

---

## You're ready

You have:
- A resume that got you shortlisted.
- 11 days of structured prep (or whatever fraction of that you completed — it's enough).
- Real production experience at Gracenote and J&J.
- Two published MCP servers on npm.
- An M.Tech from IIT Madras.
- A clear understanding of the role from the official PDF.

The interview is not a test of whether you're good enough. It's a conversation about whether your work maps to what Google Cloud needs. Your work does. Go have the conversation.

**Breathe. Slow down. Narrate. Close with the FDE product-feedback line.**
