#!/usr/bin/env bash
# In-place updates driven by recruiter PDF ground truth + 2026 product renames +
# real ADK API + official Google prep video transcripts. No new prep files.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

echo "== HEAD before: $(git log --oneline -1)"

UNIFIED="google-fde-generative-ai/interview-prep-unified"
SCRIPTS="google-fde-generative-ai/scripts"

# 13 modified prep files
git add "$UNIFIED/README.md"
git add "$UNIFIED/00_EXECUTION_PLAN.md"
git add "$UNIFIED/01_SOURCE_OF_TRUTH.md"
git add "$UNIFIED/02_RRK_MASTER_GUIDE.md"
git add "$UNIFIED/04_CODING_PROTOCOL.md"
git add "$UNIFIED/05_CODING_PROBLEM_SET.md"
git add "$UNIFIED/06_PYTHON_AND_OOP.md"
git add "$UNIFIED/07_SYSTEM_DESIGN.md"
git add "$UNIFIED/08_GCP_AND_FDE_VOCABULARY.md"
git add "$UNIFIED/10_INTERVIEW_DAY.md"
git add "$UNIFIED/11_BUILD_PLAN.md"
git add "$UNIFIED/12_RAPID_FIRE_QA.md"
git add "$UNIFIED/15_VIDEO_STUDY_PLAN.md"

# Transcripts (extracted from PDF-linked YouTube videos)
git add "$UNIFIED/_transcripts/systems_design.txt"
git add "$UNIFIED/_transcripts/coding_interview.txt"
git add "$UNIFIED/_transcripts/life_in_appengine_production.txt"

# Historical commit scripts (one-offs, kept for audit)
git add "$SCRIPTS/v9_cases_and_build_plan_push.sh"
git add "$SCRIPTS/v10_drill_materials_push.sh"
git add "$SCRIPTS/v11_review_fixes_push.sh"
git add "$SCRIPTS/v12_video_study_plan_push.sh"
git add "$SCRIPTS/v13_blind_metric_adversarial_push.sh"

# New helper scripts (PDF extraction + transcript tooling, reusable)
git add "$SCRIPTS/extract_recruiter_pdf.py"
git add "$SCRIPTS/fetch_yt_transcripts.sh"
git add "$SCRIPTS/clean_vtt.py"

echo ""
echo "== Staged:"
git diff --cached --name-status

if git diff --cached --name-only | grep -E '(\.DS_Store|\.kiro/|\.playwright-mcp/|cert page scrap\.txt)' ; then
  echo "!! FORBIDDEN FILE STAGED. Aborting."
  exit 1
fi

COMMIT_MSG="fix(fde): propagate recruiter-PDF ground truth + 2026 renames + real ADK API

No new prep files. 13 in-place edits driven by three verified sources:
  1) Recruiter PDF (extracted verbatim via pypdf; see scripts/extract_recruiter_pdf.py).
  2) 3 PDF-linked YouTube videos (transcripts captured to _transcripts/).
  3) Live cloud.google.com + github.com/google/adk-python (19.4k stars).

Coding environment conflict (flagged in 4 files):
  PDF says 'virtual interview platform that provides formatting/syntax
  highlighting, no execution.' Recruiter said plain Google Doc. Ambiguous.
  Updated README, 00_EXECUTION_PLAN, 04_CODING_PROTOCOL, 10_INTERVIEW_DAY
  to flag the conflict, recommend verifying with Priyanka in a confirmation
  email, and keep practice on the harder (plain Doc) surface. 01_SOURCE_OF_TRUTH
  Key Uncertainty section sharpened.

2026 product renames (08_GCP_AND_FDE_VOCABULARY, 02_RRK_MASTER_GUIDE,
12_RAPID_FIRE_QA):
  Vertex AI was officially renamed to 'Gemini Enterprise Agent Platform' at
  Google Cloud Next April 2026. Old name still in docs; interview-safe
  phrasing added: 'Vertex AI, which Google is renaming to Gemini Enterprise
  Agent Platform.' Gemini 3 Pro is the current headline; Gemini 2.5 family
  still supported and in production. Model Garden first-party list updated:
  Gemini, Imagen, Lyria, Chirp, Veo. Added Agent Studio / Agent Search /
  Gemini Enterprise / Gemini Code Assist / Agentic SOC. ASCII mental map
  refreshed.

Real ADK API (11_BUILD_PLAN Project 1):
  Replaced guessed API with verified 2026 API from github.com/google/adk-python
  README. pip install google-adk. from google.adk.agents import Agent.
  Agent(name, model, instruction, description, tools). Multi-agent via
  LlmAgent sub_agents=[...]. Deploy via vertexai.agent_engines.create.
  adk web and adk eval CLI mentioned. Tool Confirmation flagged as the
  built-in HITL surface.

PDF cloud-technology clause (02_RRK_MASTER_GUIDE + 08_GCP_AND_FDE_VOCABULARY):
  Verbatim quote added: 'Our interviews are not GCP specific... answer these
  questions in the cloud platform you are most familiar with.' Translation
  for candidate: frame answers in AWS when natural (J&J was AWS; Data Sentry
  was multi-cloud), name Google equivalents. Concrete bridge phrases added.

Official Google prep videos (15_VIDEO_STUDY_PLAN, 04_CODING_PROTOCOL,
07_SYSTEM_DESIGN):
  3 videos the recruiter PDF explicitly links are now Tier 0 in the video
  plan, above DLAI courses. Transcripts extracted to _transcripts/:
    - systems_design.txt (5 min, canonical framework)
    - coding_interview.txt (25 min, canonical coding demo)
    - life_in_appengine_production.txt (1h, troubleshooting reference)
  Direct quotes from each pulled into the relevant protocol files.

RateLimiter signature aligned across 04 / 05a / 06 / 14:
  limit / window_seconds: int / timestamp: int, with _events private attr.
  Prevents muscle-memory drift the review flagged.

Blind-verified comp in 01_SOURCE_OF_TRUTH:
  Replaced mid-2025 levels.fyi-only table with 2026 Blind-verified bands:
  L5 SWE base fixed at ~Rs 60.5L, variance in stock Rs 100-250K/4yr,
  ceiling Rs 1.1Cr for SWE. FDE markup ~20% above SWE per current Googler.
  L5 FDE floor Rs 1.0Cr, target Rs 1.2-1.3Cr, reach Rs 1.4Cr.

Problem set (05_CODING_PROBLEM_SET):
  Logger and FileSystem noted as pre-solved in 05a; removed 'do not touch
  until days 9-11' blanket rule.

New helper scripts (reusable):
  - scripts/extract_recruiter_pdf.py: pypdf-based PDF text + link extractor.
  - scripts/fetch_yt_transcripts.sh: yt-dlp auto-subtitle fetcher.
  - scripts/clean_vtt.py: VTT deduper and plain-text writer.

File count unchanged at 21. Zero new prep markdown files created."

git commit -m "$COMMIT_MSG"
echo ""
echo "== Commit: $(git log --oneline -1)"
git push origin main
echo "== Pushed. HEAD: $(git log --oneline -1)"
