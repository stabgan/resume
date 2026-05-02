#!/usr/bin/env bash
# Commit and push the 4 new drill-materials files + surgical edits to existing docs.
# Excludes .DS_Store, .kiro/, cert page scrap.txt.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

echo "== Repo root: $REPO_ROOT"
echo "== HEAD before: $(git log --oneline -1)"

UNIFIED="google-fde-generative-ai/interview-prep-unified"

# Stage only the files we want, never bulk add
git add "$UNIFIED/05a_CODING_SOLUTIONS.md"
git add "$UNIFIED/12_RAPID_FIRE_QA.md"
git add "$UNIFIED/13_BEHAVIORAL_INDEX.md"
git add "$UNIFIED/14_NARRATED_WALKTHROUGHS.md"
git add "$UNIFIED/09_STORIES_AND_COMP.md"
git add "$UNIFIED/10_INTERVIEW_DAY.md"
git add "$UNIFIED/README.md"

echo ""
echo "== Files staged for commit:"
git diff --cached --name-status

echo ""
echo "== Sanity check: confirm NO forbidden files are staged"
if git diff --cached --name-only | grep -E '(\.DS_Store|\.kiro/|cert page scrap\.txt)' ; then
  echo "!! FORBIDDEN FILE STAGED. Aborting."
  exit 1
fi
echo "   (none found)"

COMMIT_MSG="feat(fde): drill materials for same-day interview (solutions, Q&A, behavioral, walkthroughs)

4 new files, 2 surgical edits. Addresses candidate-POV gaps identified during review.

New drill materials:
- 05a_CODING_SOLUTIONS.md: reference Python solutions for all 22 LC + 3 OOP
  problems, with invariants, key insights, common bugs, narration lines, and
  morning warmup block. Checks your work after blank-Doc drilling.
- 12_RAPID_FIRE_QA.md: 70 one-line probes across RAG, agents, eval, cost,
  security, GCP, personal. 15-second answers with evidence ties. Day-by-day
  bucket assignment. HIGH LIKELIHOOD top-10 set for May 11-12 speed drills.
- 13_BEHAVIORAL_INDEX.md: 30 Google behavioral prompts mapped to 13 stories
  (8 existing + 5 new career-arc). Includes strongest-critic rehearsal,
  between-rounds reset, and 5 red-flag phrases to never say.
- 14_NARRATED_WALKTHROUGHS.md: Two full spoken transcripts. Rate Limiter
  coding round (40 min, line-by-line narration) + Enterprise RAG RRK round
  (60 min, 15 beats). Pacing model for narration density and FDE close.

Surgical edits:
- 09_STORIES_AND_COMP.md: 7 new comp-extension scripts (signing bonus,
  notice period, relocation, multi-offer, lateral offer, start date, flight
  risk concern).
- 10_INTERVIEW_DAY.md: per-interviewer-type closing questions (RRK /
  coding / HM), 7 recovery scripts for bad moments (interviewer says
  'wrong', wrong number given, blank on product name, cut off, overclaim,
  unknown question, freeze), self-eval rubric for mock recordings (20-point
  RRK + 20-point coding scorecard for May 9 and May 11).
- README.md: steps 5a, 11, 12, 13 added."

git commit -m "$COMMIT_MSG"

echo ""
echo "== Commit created:"
git log --oneline -1

echo ""
echo "== Pushing to origin main..."
git push origin main

echo ""
echo "== Done. HEAD after: $(git log --oneline -1)"
