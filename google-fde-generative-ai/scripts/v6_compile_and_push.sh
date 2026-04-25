#!/usr/bin/env bash
# v6 compile + push: factual corrections from user
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
echo "=== SANITY CHECKS (both files) ==="
for f in resume_single.tex google-fde-generative-ai/resume_google_fde.tex; do
  echo "--- $f ---"
  echo -n "  SSRF / OAuth in summary (should be 0): "
  awk '/Professional Summary/,/%-----------/' "$f" | grep -c -iE 'SSRF|OAuth' || echo 0
  echo -n "  'Netflix and Amazon catalog' (should be 0): "
  grep -c 'Netflix and Amazon catalog' "$f" || echo 0
  echo -n "  '1500\+ partner catalogs' (should be 1): "
  grep -c '1500\+ partner catalogs' "$f" || echo 0
  echo -n "  GEPA mentions (should be >=1): "
  grep -c 'GEPA' "$f" || echo 0
  echo -n "  Karpathy AutoResearch mentions (should be >=1): "
  grep -c 'Karpathy AutoResearch\|Karpathy.*AutoResearch\|karpathy' "$f" || echo 0
  echo -n "  kiro-cli mentions (should be 1): "
  grep -c 'kiro-cli' "$f" || echo 0
  echo -n "  Firecrawl mentions (should be 1): "
  grep -c 'Firecrawl' "$f" || echo 0
done

echo ""
echo "=== COMMIT + PUSH ==="
git reset HEAD .DS_Store ".kiro/" "cert page scrap.txt" 2>/dev/null || true

git add resume_single.tex resume_single.pdf \
        google-fde-generative-ai/resume_google_fde.tex \
        google-fde-generative-ai/resume_google_fde.pdf \
        google-fde-generative-ai/scripts/

git commit -m "fix: v6 factual corrections from owner review

Applied to both resumes (base and FDE-tailored):

Summary rewrite
- Dropped SSRF/OAuth mention (owner does not claim deep expertise on
  those; they live inside the published MCP packages but shouldn't be
  advertised as a core skill)
- Reframed the Claude 3.7 Sonnet -> 4.5 Haiku migration around HOW it
  was made possible: DSPy prompt optimization (MIPROv2, GEPA, and an
  InferRules-style rule miner over live production traces) pushed a
  cheaper model to match the expensive one's quality, gated by DeepEval

Entity resolution + classifier tightening were the same system
- Merged into one bullet
- Corrected scope: '1500+ partner catalogs' (was incorrectly narrowed
  to 'Netflix and Amazon')
- Tells the progression honestly: took over the pipeline, tightened the
  ML model (HP search + XGBoost -> LightGBM = 2x faster, -58% FP), then
  layered temporal heuristics on top (97% precision, -40% FP vs
  rules-only baseline)

AutoResearch blurb corrected
- This is a fork/extension of Karpathy's AutoResearch (credit given)
- Owner added: hypothesis logs, memory logs, research-plan-then-execute
  loop per experiment step
- Swapped in kiro-cli as the research agent, wired to Firecrawl MCP
  (web search) and steelmind-thinking MCP (structured reasoning)
- Used to drive fine-tunes of production-deployed embedding models,
  including the EmbeddingGemma 300M result

EmbeddingGemma bullet updated to point at the corrected AutoResearch
description ('more on that below') instead of the old inaccurate blurb.

Still 3 pages on both files."

git push origin main
echo ""
echo "done."
