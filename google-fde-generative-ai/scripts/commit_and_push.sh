#!/usr/bin/env bash
# Commit and push the Round 2 synthesized FDE resume changes.
# Run from repo root.
set -euo pipefail

cd "$(dirname "$0")/../.."

# Ensure we're not accidentally committing secrets or local IDE state
git reset HEAD .DS_Store ".kiro/" "cert page scrap.txt" 2>/dev/null || true

git add google-fde-generative-ai/README.md \
        google-fde-generative-ai/resume_google_fde.tex \
        google-fde-generative-ai/resume_google_fde.pdf

git commit -m "feat(fde): v3 synthesized from round-2 multi-agent review pass

Round 2 spun up the same 10 review agents (ATS, HM, technical, visual,
editorial, metrics, customer, bias, interview, differentiation) against v2
and fed their critiques back into the resume.

Factual / grammar fixes:
- TranslateGemma 4B -> Gemma 3 4B (Google never released TranslateGemma)
- ICD-CM-10 -> ICD-10-CM (correct medical coding ordering)
- cost-per-request '-3x' -> 'cut 3x' (negative-times is nonsense grammar)
- Unified Gemma 3 spelling across summary, thesis, skills
- DSPy InferRules-style -> 'custom DSPy module over BootstrapFewShot'
- GIST-style -> 'greedy diversity selection' (explained, not acronym-dropped)

Interview-risk hardening:
- AUROC 0.95 J&J bullet: added 'temporal holdout, leakage-audited'
  (neutralizes the top interview backfire risk flagged by Round 2)
- Dropped 'first LangGraph system to reach production in the org'
  (unverifiable local-bar claim)
- Named Claude migration task explicitly: media-description path
- Added baseline to -40% false positives (vs prior rules-only baseline)
- Qualified DeepEval metric: LLM-as-judge win-rate

Customer-narrative polish:
- Dropped self-narrating 'the field->product loop Google FDEs run'
- Tightened J&J discovery bullet (removed redundant em-dash phrasing)

ATS fixes:
- Skills: bolded 'Gemini (Vertex AI)' and 'Google Cloud' for top-third
  keyword density
- Summary: added 'Python, primary' and 'Gemini (Vertex AI), Google ADK'
  references so Python/Gemini/Vertex land in the first paragraph
- Publications: converted run-on bullet to discrete \\item entries
- Open Source: converted run-on bullet to discrete \\item entries

Cognitive-bias cleanup:
- Retired WBJEE 2016 #3450 and PNTSE undergrad-era anchors
- De-duplicated CTO recognition (kept as italic trailer on EmbeddingGemma
  bullet; removed from Achievements)
- Added (top ~1%) context to GATE ST AIR 410

Visual fixes:
- Education needspace 5 -> 11 baselines (fixes thesis bullets orphaning
  onto page 3 without heading)
- Added needspace{6\\baselineskip} wrap around J&J COE (fixes role split
  across page 1/2 break)
- Summary bold count reduced from 7 to 3 (LangGraph, 30%->40%, -50%)
  Bold is a scarce resource; only label + 1 metric per bullet

Added google-fde-generative-ai/README.md documenting the review methodology,
round-over-round scores across 10 dimensions, and tailoring decisions.

Page count: 3 (verified via mdls)."

git push origin main

echo "commit + push complete"
