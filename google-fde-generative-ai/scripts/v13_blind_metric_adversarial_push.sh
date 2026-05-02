#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

echo "== HEAD before: $(git log --oneline -1)"

UNIFIED="google-fde-generative-ai/interview-prep-unified"

git add "$UNIFIED/16_BLIND_INTEL.md"
git add "$UNIFIED/17_METRIC_DEFENSE.md"
git add "$UNIFIED/18_ADVERSARIAL_MOCK_SCRIPT.md"
git add "$UNIFIED/05a_CODING_SOLUTIONS.md"
git add "$UNIFIED/README.md"

echo ""
echo "== Staged:"
git diff --cached --name-status

if git diff --cached --name-only | grep -E '(\.DS_Store|\.kiro/|cert page scrap\.txt)' ; then
  echo "!! FORBIDDEN FILE STAGED. Aborting."
  exit 1
fi

COMMIT_MSG="feat(fde): blind intel + metric defense + adversarial mocks + 2 new OOP solutions

Addresses 5 gaps flagged in the external AI-agent review:

1. 16_BLIND_INTEL.md (harvested from teamblind.com via Playwright MCP):
   - Google India L5 FDE comp target: Rs 1.0-1.3 Cr Y1, base Rs 60.5L fixed,
     variance in stock grant (\$100K-\$250K / 4yr, front-loaded 38% Y1)
   - Google Cloud CE L5 India (closest analog role) comp: base Rs 55-56L,
     42.86% target bonus, 38/30/20/12 vesting, Y1 TC ~Rs 1.2 Cr
   - Recruiter ceiling currently Rs 1.1 Cr for L5 SWE reqs
   - Confirmed pattern: FDE at Google is ~20% above SWE (from current Googler
     post), post-sales + hands-on engineering + solutions architect (from
     OpenAI FDE), LLM-focused system design interview (from OpenAI FDE poll)
   - Updated comp negotiation script with Blind-backed floor/target/ceiling

2. 17_METRIC_DEFENSE.md (addresses reviewer's metric cross-examination gap):
   - Each of 6 resume numbers defended with: denominator, baseline,
     eval design, leakage check, rollback criteria, failure cases,
     60-second pitch script
   - AUROC 0.95 on 42K contracts (N, temporal split, feature ablation
     leakage audit, 3-tier rollback)
   - 3x cost / 50% p95 Haiku migration (10K req/day, 847-example golden
     set, 4-layer eval, canary 2%/10%/100%, 5 rollback criteria)
   - EmbeddingGemma +12pts (450K train, 18K temporal holdout, Matryoshka
     eval at 768/512/256/128)
   - 12M rows / \$460 (~1.2B in / 700M out tokens, 95% human-reviewed
     acceptance on 500-row sample, owns the overclean 100% correction)
   - 58% FP drop / 97% precision (1.5M records/month, weekly 10K sliding
     eval, partner-level breakdown)
   - Data Sentry days to minutes (~500 users, 250 hrs/yr saved, drift
     detection, 2 drift cases in 6 months, OAuth scope hygiene)

3. 18_ADVERSARIAL_MOCK_SCRIPT.md (addresses reviewer's solo-mock gap):
   - 30 RRK interruption prompts organized by answer stage
     (discovery, architecture, security/eval, rollout, behavioral)
   - 15 coding-round gotchas with minute-marker timing
   - Full mock interruption template for May 9 and May 11
   - Debrief protocol: write down which prompt caught you off guard,
     first reaction, rewritten recovery, add it back to this file

4. 05a_CODING_SOLUTIONS.md extensions:
   - Added 26. Logger Rate Limiter (LC 359) - map msg to next-allowed timestamp
   - Added 27. File System (LC 588) - trie with _walk helper, __slots__
   - Updated intro: '27 total = 22 core + 5 OOP extensions' (was 25)

5. README.md: added rows 15-17 for the three new files.

Cross-referenced reviewer's 7 points against existing prep; confirmed 4
of 5 were already handled (mocks scheduled May 9+11, discovery scaffold
in master guide, coding drilled, customer discovery shape in every case).
Gap 5 (metric cross-examination) was the real miss; 17_METRIC_DEFENSE
closes it."

git commit -m "$COMMIT_MSG"
echo ""
echo "== Commit: $(git log --oneline -1)"
git push origin main
echo "== Pushed. HEAD: $(git log --oneline -1)"
