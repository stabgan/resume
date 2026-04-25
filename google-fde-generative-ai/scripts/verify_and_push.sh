#!/usr/bin/env bash
# Quick AI-tell audit on v4, then commit & push.
set -euo pipefail

cd "$(dirname "$0")/../.."

echo "=== EM-DASH COUNT (--- in tex source) ==="
grep -c -- '---' google-fde-generative-ai/resume_google_fde.tex || echo 0

echo ""
echo "=== 'Bold Label:' PATTERN COUNT (should be low now) ==="
grep -o '\\textbf{[^}]*:}' google-fde-generative-ai/resume_google_fde.tex | wc -l | tr -d ' '

echo ""
echo "=== MARKETING-ECHO PHRASES (should be 0) ==="
for phrase in "white-glove" "connective tissue" "Customer-embedded AI engineer" "field.*product loop" "builder-doer" "L400-level"; do
  count=$(grep -c -i "$phrase" google-fde-generative-ai/resume_google_fde.tex || true)
  echo "  '$phrase': $count"
done

echo ""
echo "=== BOLD DENSITY CHECK (total \\textbf occurrences) ==="
grep -o '\\textbf' google-fde-generative-ai/resume_google_fde.tex | wc -l | tr -d ' '

echo ""
echo "=== PAGE COUNT ==="
mdls -name kMDItemNumberOfPages google-fde-generative-ai/resume_google_fde.pdf

echo ""
echo "=== WORDS IN SUMMARY (target: ~100-120) ==="
# Extract summary block between 'Professional Summary' and next '%-' comment
awk '/Professional Summary/,/%-----------/' google-fde-generative-ai/resume_google_fde.tex \
  | sed 's/\\[a-zA-Z]*//g; s/[{}]//g' \
  | wc -w | tr -d ' '

echo ""
echo "=== COMMIT + PUSH ==="
# Keep local-only files out
git reset HEAD .DS_Store ".kiro/" "cert page scrap.txt" 2>/dev/null || true

git add google-fde-generative-ai/resume_google_fde.tex \
        google-fde-generative-ai/resume_google_fde.pdf \
        google-fde-generative-ai/scripts/

git commit -m "style(fde): v4 humanization pass -- de-template prose, cut AI tells

The goal: read naturally to a human reviewer, not like it was AI-drafted.
Substance untouched (every metric, model, and technology is intact); this
is a voice-and-cadence rewrite.

What changed:
- Summary rewritten in natural prose, varied sentence lengths; 'I' appears
  where it naturally would for a senior engineer describing their own work
- Dropped the 'Bold Label: content' pattern from almost every experience
  bullet -- bolding now lands on the ONE anchor per bullet (tool, metric,
  or company), not on a redundant label colon
- Tagline trimmed to one positioning ('Production GenAI, Multi-Agent
  Systems & MCP'); the three-concept GCP stack read too calculated
- Em-dashes replaced with commas, semicolons, or sentence breaks in most
  spots; dash reserved for actual parenthetical/dramatic pause usage
- Varied bullet openers: some start with a verb ('Built', 'Owned',
  'Compiled', 'Took over'), some with context ('For synthetic data I run
  ...'), some with company/tool anchors
- Removed marketing-echo phrases flagged in the human-voice audit:
  'white-glove deployment', 'connective tissue', 'Customer-embedded AI
  engineer' (title/opener), 'field->product loop Google FDEs run'
- Softened JD-keyword density where it was audible: 'regulated
  medical-device business' appears once, not twice; 'Experienced with
  Gemini (Vertex AI), Google ADK, LangGraph, and CrewAI' line removed
  from summary (feels bolted-on; same items appear in Skills)
- Trimmed metric-stacking: each bullet now leads with 1-2 strong
  quantifiers, not 3-4 stacked
- Replaced informal '+' with 'and' ('LangGraph + Haiku' -> 'LangGraph
  work and the Haiku migration')
- mcp-icd10 blurb rewritten in first-person ('Built this after I kept
  wanting an MCP tool that worked inside regulated environments') --
  personality beats keyword density

Structure, sections, ordering, design system (navy accent, section
rules, typography), and page budget all unchanged. Still 3 pages."

git push origin main

echo ""
echo "done."
