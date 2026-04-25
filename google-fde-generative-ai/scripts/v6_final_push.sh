#!/usr/bin/env bash
# Final compile + push for v6 (after trim pass to keep FDE at 3 pages).
set -euo pipefail
cd "$(dirname "$0")/../.."

echo "=== COMPILE FDE ==="
cd google-fde-generative-ai && tectonic resume_google_fde.tex 2>&1 | tail -2 && cd ..

echo ""
echo "=== COMPILE BASE ==="
tectonic resume_single.tex 2>&1 | tail -2

echo ""
echo "=== PAGE COUNTS ==="
echo -n "  FDE:  "
mdls -name kMDItemNumberOfPages google-fde-generative-ai/resume_google_fde.pdf | awk -F'= ' '{print $2}'
echo -n "  Base: "
mdls -name kMDItemNumberOfPages resume_single.pdf | awk -F'= ' '{print $2}'

echo ""
echo "=== COMMIT + PUSH ==="
git reset HEAD .DS_Store ".kiro/" "cert page scrap.txt" 2>/dev/null || true

git add resume_single.tex resume_single.pdf \
        google-fde-generative-ai/resume_google_fde.tex \
        google-fde-generative-ai/resume_google_fde.pdf \
        google-fde-generative-ai/scripts/

# Only commit if there are staged changes
if git diff --cached --quiet; then
  echo "nothing to commit, skipping."
else
  git commit -m "fix(fde): trim to stay at 3 pages after v6 corrections

Merged the two DSPy-translator bullets (prompt compilation + 12M-scale
execution) into one. Tightened the Open Source blurbs, dropped
awesome-loss-functions from the FDE/base resumes, trimmed the two
recommendation quotes to one tight sentence each. EmbeddingGemma
bullet slightly condensed (the technique list reads as a sentence now
rather than prefaced by 'Technique stack:').

No content removed that wasn't also in Technical Skills or that the
owner flagged as low-value."
fi

git push origin main
echo "done."
