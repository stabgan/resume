# Coding Round Protocol

There are **two shapes of coding round** the Google FDE loop might throw at you. Prep for both.

| Shape | Likelihood | What it tests |
|---|---|---|
| **Classic DSA on a Google Doc** | ~60% | Medium-hard problem on a plain editor, no IDE, 35–45 min. |
| **Debug an unfamiliar codebase** | ~40% | Palantir-style "re-engineering" round. 500–1000 lines of code, broken somewhere, 45 min. |

Both reward the same meta-skill: **systematic thinking out loud**. Your job in both is to make the interviewer confident you'd be trustworthy in their codebase.

---

## Shape 1 — Classic DSA on a Google Doc

### What actually happens

You join a Google Meet. The interviewer shares a Google Doc or a CoderPad link in "plain text" mode. You get a problem statement (usually 4–8 lines of text). You have 35–45 minutes to produce working Python (or Go/Java/C++). The environment is brutal:

- **No syntax highlighting**
- **No autocomplete**
- **No compiler** — you cannot run your code
- **No find/replace reflex** — `Ctrl+F` on Google Docs just searches the problem text
- **You cannot navigate by keyboard shortcut** the way you do in VS Code

The interviewer is watching you think. **Their rubric is 70% how you think, 30% the final code.**

### The 5-phase protocol (practice every time)

```
 0:00        Arrive, greet. Say "let me read the problem out loud."
 0:00–0:03   CLARIFY. Restate problem in your own words. Ask about:
             - Input shape (list of ints? ints can be negative? duplicates?)
             - Size (N up to 10^3? 10^5? 10^9?)
             - Edge cases (empty input? one element? all equal?)
             - Output shape (indices or values? sorted?)
 0:03–0:08   APPROACH. Propose ONE idea out loud. State:
             - The algorithm in one sentence
             - Time complexity
             - Space complexity
             If brute force: "O(n²). Can we do better?" Then propose it.
 0:08–0:28   CODE. Write it. Talk as you go. Indent. Use full variable names.
 0:28–0:35   DRY RUN. Walk 2 test cases by hand:
             - One ordinary case
             - One edge case (empty? single element? all same?)
             Track variable state as strings ON THE DOC (yes, in text — interviewer watches)
 0:35–0:40   DISCUSS. Trade-offs, bigger input, memory bounds, what you'd change.
```

### The 10 phrases to use (really, just these)

Google interviewers have told candidates for years that these are the phrases that signal senior thinking. Use them naturally — don't force it, but know they're your tools.

1. *"Let me restate the problem so I make sure I understand."*
2. *"What's the expected size of N?"*
3. *"Can I assume the input is valid, or do I need to handle bad input?"*
4. *"The brute force is O(n²). Let me think about whether we can do better."*
5. *"I'm going to use a hash map here to get O(1) lookup — the trade-off is O(n) extra space."*
6. *"Let me walk through an edge case first to make sure my approach handles it."*
7. *"I'm going to skip the imports / helper boilerplate and focus on the logic — we can add it at the end."* (*This saves 30 seconds and signals senior judgment.*)
8. *"Before I write more, let me dry-run what I have."*
9. *"If N were 10⁹ instead of 10⁵, I'd switch to X."*
10. *"One thing I'd add in production: a test for the empty-input case."*

### The 5 classic failure modes (do NOT do these)

| ❌ | What it looks like | What it signals |
|---|---|---|
| Silent typing for 5 minutes | You start coding without saying anything | "Can't communicate under pressure" |
| `l` for left, `r` for right, `a` for array | Single-letter variable names on a plain Doc | "Doesn't care about readability" |
| Fixing syntax errors in real-time | Discovering you missed a colon 30 lines in | "Doesn't think in full before writing" |
| Skipping the dry run | "I think this works, let me add one more optimization" | "Overconfident; doesn't validate" |
| Apologizing repeatedly | "Sorry, I'm rusty at this, I usually use AI tools" | **Never apologize.** Not even once. |

### How to practice for THIS shape

- **Every DSA problem in `DSA_RECOVERY.md` — solve on a plain Google Doc.** Not a VS Code tab. Literally a Google Doc.
- **Record yourself** solving one problem per week. Play it back. You'll cringe at the silences and filler words. That's the point.
- **Do 1 Pramp mock per week.** The Pramp interface is a plain code editor — close enough.

---

## Shape 2 — Debug an unfamiliar codebase (Palantir-style)

### What actually happens

You're given 500–1000 lines of code. You're told what it's supposed to do. You're told the output is wrong. You have 45 minutes. Find and fix the bug.

This shape is now showing up in FDE interviews specifically because **it tests what FDEs actually do**: walk into a customer's broken system, figure out what's happening, propose a fix. Palantir pioneered this; Google FDE teams have started using variants.

**This is the shape you're secretly good at.** You debug codebases daily with AI agents. Lean in.

### The 5-phase protocol (Palantir-style)

```
 0:00–0:03   ORIENT. Ask:
             - "What's this system supposed to do?"
             - "What's the broken output I should reproduce?"
             - "Is there an input I can use to trigger the bug?"
 0:03–0:10   READ. Skim the whole codebase. Understand the shape.
             DON'T START FIXING YET. Find:
             - Entry point (main function, run(), etc.)
             - Data flow (what transforms what)
             - Obvious areas of concern (nested conditionals, state mutations)
 0:10–0:25   HYPOTHESIZE + TEST. For each suspected bug, VERBALIZE:
             - "I think X might be wrong because Y."
             - "Let me trace the input through the function."
             Use print-debugging or manual tracing ON THE SHARED SCREEN.
 0:25–0:40   FIX. Propose the minimal change. Explain why.
             - "The fix is changing line 42's `<=` to `<`."
             - "This also means line 67 needs the boundary check updated."
             THEN: trace the fix through the failing input to confirm.
 0:40–0:45   GENERALIZE. Ask:
             - "What other inputs could trigger a similar bug?"
             - "Are there tests I'd add to prevent regression?"
```

### The critical trap — finding the wrong bug first

From the Palantir guide (and confirmed by FDE Academy): **the #1 failure mode in this round is fixing the FIRST thing that looks wrong, then finding the output is still broken because the real bug is elsewhere.**

Palantir's bugs are logically subtle, not syntactically obvious. Example: the contact-tracing bug might look like a HashMap typo, but is actually an off-by-one in the infected-count increment.

**Counter this by:** after you find your first candidate bug, always trace the corrected code end-to-end through the failing input BEFORE declaring victory. If the output is still wrong, you haven't found the real bug.

### What interviewers grade (Palantir rubric, leaked)

1. **Scope control** — did you try to understand the whole system before diving in, or did you go straight to line-by-line reading?
2. **Hypothesis quality** — are your theories about what's wrong specific and testable, or vague?
3. **Verification discipline** — do you confirm your fix works before moving on?
4. **Communication** — are you saying what you're thinking, or silently scrolling?
5. **Ownership** — when you find the real bug, do you suggest what *else* might be affected?

### How to practice for THIS shape

You can practice this. Here's how:

1. **Find a small open-source project you didn't write.** Something you can clone and run in 10 minutes. Examples: a small FastAPI app, a LangChain example repo, a util library.
2. **Introduce a bug manually.** Add a subtle off-by-one, swap a `+` for `-`, or change a boundary condition.
3. **Wait 3 days.**
4. **Clone a fresh copy, load it in a code editor without your git history.** Treat it as a black box.
5. **Debug out loud, screen recording.** Give yourself 45 min.

Do this 2–3 times during the 2-week prep and you'll be fluent.

### Your AI-agent workflow helps here — BUT

You debug codebases daily using Claude, Cursor, kiro-cli, etc. The skill you're actually practicing in that workflow is *asking good diagnostic questions* — which is exactly the skill the debug round tests. You'll be better at this shape than at classic DSA.

**Caveat:** during the interview you cannot have the AI there. So practice the VERBAL diagnostic pattern without it. Instead of typing into Claude, *say aloud to yourself*:
- "What's this function supposed to return?"
- "What does the type system tell me here?"
- "If I traced input X through this, what would the state be at line 30?"

Those are the same questions you'd ask an AI. The AI was typing them for you. Now you type them for yourself.

---

## The one universal rule across both shapes

**Say what you're thinking, always.** Silence for more than 15 seconds means you've lost the interviewer. Narrate. Even "hmm, I'm thinking about whether to use a hash map or a sorted list" is better than silence.

Your Gracenote-era verbal muscle is strong from doing design reviews. This is just that, applied to a smaller problem.

---

## The 2 things to do before EVERY mock/interview

1. **Open a blank Google Doc. Type 3 lines of Python.** Let your fingers remember that the Doc isn't auto-indenting or auto-completing. This takes 30 seconds and saves you from "wait, how do I indent nested for loops here" during the real thing.
2. **Say your name, role, 2 recent projects out loud.** Re-activates the part of your brain that does verbal narration. 60 seconds.

Do these before Pramp. Do them before the real loop.

---

## What if you freeze mid-interview?

Everyone does. The senior move is:

1. **Acknowledge it.** *"Let me pause for 30 seconds and think about this."*
2. **Restate what you know.** *"So I have X input, I need Y output, I've been trying approach Z."*
3. **Ask a narrow question.** *"Can I assume the list is sorted, or would I need to sort it first?"*

Interviewers expect pauses. They reward structured pauses. They penalize silent panic.

You've got this. Go type on a Google Doc right now for 30 minutes. Build the muscle.
