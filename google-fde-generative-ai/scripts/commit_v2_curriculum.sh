#!/usr/bin/env bash
# Commit the unified 2-week curriculum + supporting docs.
set -euo pipefail

cd "$(dirname "$0")/../.."

# Keep local-only files out
git reset HEAD .DS_Store ".kiro/" "cert page scrap.txt" 2>/dev/null || true

git add google-fde-generative-ai/interview-prep/ \
        google-fde-generative-ai/scripts/

if git diff --cached --quiet; then
  echo "nothing to commit."
  exit 0
fi

git commit -m "docs(fde): simplified 2-week day-by-day curriculum + DSA pattern drill + STAR scripts

Re-scoped from the 6-week plan to a pragmatic 2-week day-by-day
schedule for a rusty-at-DSA, heavy-AI-agent-user senior. Three new docs,
old curriculum archived.

New research applied
  * FDE coding rounds can take two shapes: classic DSA (Google Doc,
    no IDE) or debug-an-unfamiliar-codebase (Palantir re-engineering
    round). Plan now covers both with a protocol.
  * Pattern-first beats volume for rusty seniors -- 30 deeply-understood
    problems across 10 patterns replaces the 40-60 problem grind.
  * The candidate's heavy use of AI agents for daily coding is a
    SUPERPOWER for the behavioral/customer-scenario rounds (directly
    evidences capability #6: field-insights->product-requests).
    Plan leans into this explicitly rather than treating it as a weakness.
  * 2-week realistic scope per Alex Wang's Medium guide, reconfirmed
    by Alex Kelber (Meta 2024) -- 50-60 problems is the ceiling;
    30 is the sweet spot for preservation of quality.
  * Customer-scenario + Googleyness is 30% of evaluation weight --
    the highest single bucket -- and most AI/ML candidates under-prep it.

Files
  * CURRICULUM.md -- rewritten as a day-by-day 14-day plan with a
    morning DSA + deep work + evening STAR story rhythm. Explicit
    1-week fallback plan if loop lands fast.
  * DSA_RECOVERY.md -- 30 problems across 10 patterns, each with:
    why the pattern exists, the signal to recognize it, a canonical
    template, and 3 graded problems. Pattern-first, not volume-first.
  * CODING_ROUND_PROTOCOL.md -- two shapes (classic DSA + debug-
    codebase), 5-phase protocol for each, the 10 phrases Google
    interviewers recognize as senior thinking, how to practice
    debug-codebase rounds with your own setup.
  * STAR_STORIES.md -- all 10 stories with full 90-second scripts,
    FDE-capability mapping, follow-up answers ready. Story #5
    (Karpathy AutoResearch + kiro-cli + Firecrawl + steelmind MCPs)
    is flagged as the candidate's flagship story because it literally
    demonstrates the core FDE capability the JD calls out.
  * README.md -- re-routed to prioritize CURRICULUM.md as the daily
    driver. Short and directive.

Archived
  * CURRICULUM.md (old 6-week) -> CURRICULUM_6WEEK_archive.md
    (kept for reference in case the loop lands late)

Key strategic framing the candidate should internalize
  * His AI-agent workflow isn't a problem for the interview -- it's
    exactly the FDE profile Google is hiring for. The prep gap is
    ONLY that the solo live-coding round happens without an agent,
    so 30 min/day of muscle-memory rebuild on a plain text editor
    closes that specific gap.
  * If asked 'do you use AI for coding?', answer: 'Yes, heavily.
    I treat it like a staff engineer pairing with me. For this
    interview I've been practicing without it to make sure the
    fundamentals are sharp.' Don't apologize. Don't over-share.

Sources (beyond previously-cited)
  * datainterview.com FDE prep guide -- surfaced the debug-a-codebase
    round shape
  * Mahima Hans LinkedIn post on Google-Doc coding mechanics
  * Alex Wang Medium 2-week plan
  * Palantir Software Engineer guide on Prepfully (re-engineering round)
  * Grapevine Google 2024 candidate account
  * InterviewCoder 12-patterns analysis
  * Beyz AI 2025 Google coding prep guide"

git push origin main
echo ""
echo "done."
