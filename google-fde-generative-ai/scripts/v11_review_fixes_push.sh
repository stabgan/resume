#!/usr/bin/env bash
# Apply the candidate-POV reviewer fixes: strip fabrications, fix variable-name drift,
# integrate 05a/12/13/14 into the schedule, add night-before block.
# Excludes .DS_Store, .kiro/, cert page scrap.txt.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

echo "== Repo root: $REPO_ROOT"
echo "== HEAD before: $(git log --oneline -1)"

UNIFIED="google-fde-generative-ai/interview-prep-unified"

git add "$UNIFIED/README.md"
git add "$UNIFIED/00_EXECUTION_PLAN.md"
git add "$UNIFIED/05a_CODING_SOLUTIONS.md"
git add "$UNIFIED/10_INTERVIEW_DAY.md"
git add "$UNIFIED/12_RAPID_FIRE_QA.md"
git add "$UNIFIED/13_BEHAVIORAL_INDEX.md"
git add "$UNIFIED/14_NARRATED_WALKTHROUGHS.md"

echo ""
echo "== Files staged:"
git diff --cached --name-status

echo ""
echo "== Sanity check: confirm NO forbidden files are staged"
if git diff --cached --name-only | grep -E '(\.DS_Store|\.kiro/|cert page scrap\.txt)' ; then
  echo "!! FORBIDDEN FILE STAGED. Aborting."
  exit 1
fi
echo "   (none found)"

COMMIT_MSG="fix(fde): apply candidate-POV review fixes across drill materials

Three candidate-POV reviewers (coding + structural + RRK) reviewed the drill
materials. RRK reviewer caught 3 fabrications and 5 inflated claims against
the source-of-truth. Coding reviewer caught a variable-name drift between
05a and the walkthrough that would confuse muscle memory. Structural reviewer
caught that 05a/12/13/14 were invisible from 00_EXECUTION_PLAN and that the
README had no night-before navigation. All fixed.

Fabrications removed (must-fix before May 13):
- 14 walkthrough 2 opener: 'J&J clinical AI platform, surgical complication
  prediction, deployed in six hospitals' was invented. Replaced with the
  true Contract Commitment Portal / LightGBM / isotonic / AUROC 0.95 /
  default decision path description from 01_SOURCE_OF_TRUTH.md.
- 14 walkthrough 2 @ 00:33: 'J&J HIPAA per-hospital ACLs enforced at
  retrieval' was invented (CCP is classical ML, not RAG). Replaced with
  accurate 'legal / security / CAB governance discipline' framing.
- 12 Q2.4: 'J&J CCP supervisor pattern for CAB review' invented. CCP was
  not multi-agent. Replaced with honest gap acknowledgment + Gracenote
  LangGraph as the real reference.
- 12 Q1.4: 'Data Sentry did exactly this' for RAG ACL filtering was a
  category error (Data Sentry is IAM onboarding, not retrieval). Split
  into 'identity half I shipped' vs 'RAG-ACL half I would bring.'
- 12 Q7.1: '2am customer calls on Gracenote' was inflated for an internal
  platform role. Replaced with 'gets called when ingestion breaks /
  approval workflow needs a hard answer.'
- 12 Q1.9: 'multimodal MCP server so ingestion path is familiar' conflated
  inference routing with document ingestion. Split cleanly.
- 13 Story 12 Result: invented '2.2x cost cut' and 'content-tagging /
  media-summarization' team outcomes. Genericized to 'two teams, own
  metrics' and noted 'cannot quote their exact numbers.'
- 13 Story 13 Action: invented '91 percent on tail distribution' number.
  Genericized to 'the tail the human reviewers were catching.'

Behavioral mapping fixes (13_BEHAVIORAL_INDEX.md Section A):
- Prompt 11 primary swapped Story 13 → Story 4 (Story 13 is internal
  partner, not external customer).
- Prompt 12 reframed with honest acknowledgment of gap rather than
  forcing Story 12.
- Prompt 13 primary swapped Story 10 → Story 8 (Story 10 is received
  feedback, not a live disagreement).
- Prompt 24 reframed with honest 'horizontal not vertical' acknowledgment.

Coding consistency fixes:
- 05a Rate Limiter signature: max_requests/window_seconds: float/now: float
  → limit/window_seconds: int/timestamp: int to match walkthrough 1.
  Added cross-reference note.
- 05a intro: '25 problems' clarified as '22 core + 3 OOP extensions.'

Schedule + navigation:
- 00_EXECUTION_PLAN May 11: drill 10 Q&A probes, score against rubric.
- 00_EXECUTION_PLAN May 12: read 14 walkthroughs aloud, eyeball 13 map.
- 10_INTERVIEW_DAY: new 'TL;DR — what to open tonight and tomorrow morning'
  block at top with the 5-item night list and the 4-item morning list.
- README: flagship story locator (where the J&J, Haiku, AutoResearch
  stories live, with maps to behavioral prompts and cases)."

git commit -m "$COMMIT_MSG"

echo ""
echo "== Commit created:"
git log --oneline -1

echo ""
echo "== Pushing to origin main..."
git push origin main

echo ""
echo "== Done. HEAD after: $(git log --oneline -1)"
