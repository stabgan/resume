#!/usr/bin/env bash
# Compile both resumes, check page counts, then commit + push.
set -euo pipefail

cd "$(dirname "$0")/../.."

echo "=== COMPILING FDE RESUME ==="
cd google-fde-generative-ai
tectonic resume_google_fde.tex 2>&1 | tail -3
cd ..

echo ""
echo "=== COMPILING BASE RESUME ==="
tectonic resume_single.tex 2>&1 | tail -3

echo ""
echo "=== PAGE COUNTS ==="
echo -n "  FDE resume:  "
mdls -name kMDItemNumberOfPages google-fde-generative-ai/resume_google_fde.pdf | awk -F'= ' '{print $2}'
echo -n "  Base resume: "
mdls -name kMDItemNumberOfPages resume_single.pdf | awk -F'= ' '{print $2}'

echo ""
echo "=== AI-TELL AUDIT (both files) ==="
for f in resume_single.tex google-fde-generative-ai/resume_google_fde.tex; do
  echo "--- $f ---"
  echo -n "  em-dashes (---): "
  grep -c -- '---' "$f" || echo 0
  echo -n "  'Bold Label:' pattern: "
  grep -o '\\textbf{[^}]*:}' "$f" | wc -l | tr -d ' '
  echo -n "  marketing-echo (white-glove/connective tissue/builder-doer/L400): "
  grep -c -i -E 'white-glove|connective tissue|builder-doer|L400-level' "$f" || echo 0
  echo -n "  stale artifacts (TranslateGemma 4B, ICD-CM-10, 100% pass rate, h-index, 43 followers, 19 stars, 6 stars, AIR 4,860): "
  grep -c -E 'TranslateGemma 4B|ICD-CM-10|100\\% pass rate|h-index|43 followers|19 stars|6 stars|AIR 4,860' "$f" || echo 0
done

echo ""
echo "=== COMMIT + PUSH ==="
git reset HEAD .DS_Store ".kiro/" "cert page scrap.txt" 2>/dev/null || true

git add resume_single.tex \
        resume_single.pdf \
        google-fde-generative-ai/resume_google_fde.tex \
        google-fde-generative-ai/resume_google_fde.pdf \
        google-fde-generative-ai/scripts/

git commit -m "feat: v5 -- new work (EmbeddingGemma deep fine-tune, 12M translation, ML tuning) + base resume sync

Added recent Gracenote work to both resumes:

1. EmbeddingGemma 300M deep fine-tune (replaces the old one-line bullet)
   - 8x A100 80GB (p4de), DeepSpeed ZeRO, Unsloth, mixed precision,
     evaluation across all 8 GPUs
   - Curriculum hard-negative mining, 4-directional GTE-style contrastive
     loss, LR annealing, Matryoshka representation learning with weighted
     dimension slices
   - Driven by an AutoResearch MCP harness that scouts literature before
     each experiment
   - Accuracy@1 and accuracy@5 each improved 12 points on temporally-split
     holdout data

2. 12M-row multilingual translation at ~\$460 (new bullet)
   - fastText language detection gate
   - Gemma 3 27B via vLLM on 4x L40S with FP8 quantization (hardware-level
     support on L40S); kept the Ollama + Gemma 3 4B teacher loop for golden
     eval references

3. Production classifier tightening (new bullet)
   - Hyperparameter search + XGBoost -> LightGBM swap
   - 2x faster single-entry inference, -58% false positives

4. Team enablement (added to Achievements)
   - Monthly tech talks on emerging tools
   - Internal MCP servers for the team

Also brought the base resume (resume_single.tex) fully in sync with the
v4 baseline that was previously only on the FDE file:
  - Factual: TranslateGemma 4B -> Gemma 3 4B; ICD-CM-10 -> ICD-10-CM
  - Metric honesty: 100% pass rate -> >=95% on N=500;
    100x -> ~30x per trial
  - Grammar: 'cost-per-request -3x' -> 'cut 3x' (negative-times was nonsense)
  - Humanized prose: dropped 'Bold Label: content' template, varied bullet
    openers, replaced most em-dashes with softer punctuation
  - Removed negative anchors (GATE DA AIR 4,860, WBJEE, PNTSE)
  - Removed vanity metrics (43 followers, 19 stars, 6 stars, h-index)
  - Removed Param.ai 2018 intern entry
  - Removed stale certs (Azure AI-900 2021, MIT 6.86x 2019)
  - Switched color package from color -> xcolor (for black!40 footer)

Both resumes: still 3 pages."

git push origin main
echo ""
echo "done."
